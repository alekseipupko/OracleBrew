import AVFoundation
import SwiftUI
import UIKit

@MainActor
@Observable
final class CupCamera {
    enum Phase {
        case idle
        case denied
        /// No camera hardware — the simulator, mostly.
        case unavailable
        case running
    }

    private(set) var phase: Phase = .idle

    /// One session for this object's lifetime, handed to the preview layer once
    /// and never swapped. Giving the layer a *different* session while it still
    /// holds a connection from the old one trips AVFoundation's "connection
    /// references an input unknown to this session" assertion — so stopping
    /// only stops it running; it never throws the session away.
    @ObservationIgnored let session = AVCaptureSession()

    @ObservationIgnored private let output = AVCapturePhotoOutput()
    /// Configuring and starting a session blocks, so it stays off the main
    /// thread, as AVFoundation asks.
    @ObservationIgnored private let queue = DispatchQueue(label: "cup-camera")
    @ObservationIgnored private var captor: PhotoCaptor?
    @ObservationIgnored private var isConfigured = false

    /// Asks for access (first call shows the system prompt) and starts the
    /// session. Safe to call again — a running session is left alone, and the
    /// inputs are only ever added once.
    func prepare() async {
        guard phase != .running else { return }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            guard await AVCaptureDevice.requestAccess(for: .video) else {
                phase = .denied
                return
            }
        default:
            phase = .denied
            return
        }

        if !isConfigured {
            guard await configure() else {
                phase = .unavailable
                return
            }
            isConfigured = true
        }

        phase = .running
        queue.async { [session] in
            if !session.isRunning { session.startRunning() }
        }
    }

    /// Wires the camera into the session. Runs once; after that the session is
    /// only started and stopped.
    private func configure() async -> Bool {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return false
        }
        return await withCheckedContinuation { continuation in
            queue.async { [session, output] in
                session.beginConfiguration()
                session.sessionPreset = .photo
                guard session.canAddInput(input), session.canAddOutput(output) else {
                    session.commitConfiguration()
                    continuation.resume(returning: false)
                    return
                }
                session.addInput(input)
                session.addOutput(output)
                session.commitConfiguration()
                continuation.resume(returning: true)
            }
        }
    }

    func stop() {
        guard phase == .running else { return }
        phase = .idle
        queue.async { [session] in
            if session.isRunning { session.stopRunning() }
        }
    }

    /// Takes a still. Returns nil if the session isn't running or capture failed.
    func capture() async -> UIImage? {
        guard phase == .running else { return nil }
        let settings = AVCapturePhotoSettings()
        return await withCheckedContinuation { continuation in
            let captor = PhotoCaptor { image in
                continuation.resume(returning: image)
                Task { @MainActor in self.captor = nil }
            }
            // The output only holds the delegate weakly — keep it alive here.
            self.captor = captor
            output.capturePhoto(with: settings, delegate: captor)
        }
    }
}

/// One-shot AVCapturePhotoOutput delegate.
private final class PhotoCaptor: NSObject, AVCapturePhotoCaptureDelegate {
    private let onFinish: (UIImage?) -> Void
    private var finished = false

    init(onFinish: @escaping (UIImage?) -> Void) {
        self.onFinish = onFinish
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard !finished else { return }
        finished = true
        onFinish(photo.fileDataRepresentation().flatMap(UIImage.init(data:)))
    }
}

/// Hosts the session's preview layer. Sized by the SwiftUI parent.
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.backgroundColor = .black
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    /// Deliberately empty: the session never changes, and reassigning it is
    /// exactly what trips the connection assertion.
    func updateUIView(_ view: PreviewView, context: Context) {}

    final class PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }

        override func layoutSubviews() {
            super.layoutSubviews()
            // The flow is portrait-locked; pin the feed so it never lands sideways.
            guard let connection = previewLayer.connection,
                  connection.isVideoRotationAngleSupported(90) else { return }
            connection.videoRotationAngle = 90
        }
    }
}
