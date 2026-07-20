# Graph Report - OracleBrew  (2026-07-20)

## Corpus Check
- 92 files · ~30,996 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 588 nodes · 927 edges · 53 communities (23 shown, 30 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 36 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `c1e09b62`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ReadingDraft
- View
- Drink
- SwiftUI
- ReadingSession
- Backbone (Services + Mock Data)
- FortuneTeller
- CameraPicker
- RootTab
- Lettering
- ReadingStep
- Reading
- FlowLayout
- Drink
- Design System (Kit)
- OracleChatEntryFlow
- Atrium (Root Container)
- .mcp.json
- CGFloat
- Drink
- FortuneTeller
- Int
- LocalizedStringKey
- ReadingDraft
- ReadingDraft
- ReadingDraft
- RootTab
- TimeHorizon
- Topic
- Topic
- Double
- Interest
- RootTab
- Date
- Bool
- Bool
- FortuneTeller
- Hasher
- Bool
- Drink
- FortuneTeller
- Hasher
- UIImage
- UUID
- CGFloat
- NavigationPath
- String
- FlowHeader
- NavigationPath
- LocalizedStringKey
- HistoryItem
- String
- Pathfinder

## God Nodes (most connected - your core abstractions)
1. `SwiftUI` - 47 edges
2. `Zodiac` - 19 edges
3. `UserProfile` - 17 edges
4. `ProfileView` - 15 edges
5. `FortuneTeller` - 15 edges
6. `OracleChatView` - 13 edges
7. `ReadingDraft` - 13 edges
8. `Emissary` - 12 edges
9. `Data` - 12 edges
10. `ReadingResultView` - 12 edges

## Surprising Connections (you probably didn't know these)
- `Atrium` --calls--> `UserProfileStore`  [INFERRED]
  OracleBrew/OracleBrew/App/Atrium.swift → OracleBrew/OracleBrew/Backbone/UserProfile.swift
- `ProfileView` --calls--> `UserProfile`  [INFERRED]
  OracleBrew/OracleBrew/Screens/Profile/ProfileView.swift → OracleBrew/OracleBrew/Backbone/UserProfile.swift
- `Pigment` --calls--> `Color`  [INFERRED]
  OracleBrew/OracleBrew/Kit/StarRating.swift → OracleBrew/OracleBrew/Kit/Pigment.swift
- `TellerCard` --calls--> `Color`  [INFERRED]
  OracleBrew/OracleBrew/Screens/FortuneTellers/components/TellerCard.swift → OracleBrew/OracleBrew/Kit/Pigment.swift
- `PhotoUploadView` --calls--> `CupCamera`  [INFERRED]
  OracleBrew/OracleBrew/Screens/PhotoUpload/PhotoUploadView.swift → OracleBrew/OracleBrew/Kit/CupCamera.swift

## Import Cycles
- None detected.

## Communities (53 total, 30 thin omitted)

### Community 0 - "ReadingDraft"
Cohesion: 0.19
Nodes (10): Interest, InterestCatalog, String, InterestChip, ProfileChip, ProfileSectionLabel, Bool, LocalizedStringKey (+2 more)

### Community 1 - "View"
Cohesion: 0.06
Nodes (40): Binding, ChatSummary, Color, Content, ContentMode, Image, Item, Label (+32 more)

### Community 2 - "Drink"
Cohesion: 0.10
Nodes (18): Double, Drink, DrinkCatalog, Bool, LocalizedStringKey, String, Color, Pigment (+10 more)

### Community 3 - "SwiftUI"
Cohesion: 0.08
Nodes (30): Bool, EmissaryFailure, Encodable, Encoder, HTTPURLResponse, JSONDecoder, AnyEncodable, Data (+22 more)

### Community 4 - "ReadingSession"
Cohesion: 0.13
Nodes (9): Atrium, LocalizedStringKey, TabPlaceholder, Pathfinder, Waypoint, brewReading, profile, settings (+1 more)

### Community 5 - "Backbone (Services + Mock Data)"
Cohesion: 0.10
Nodes (26): Backbone (Services + Mock Data), Brew Reading Flow, ChatEngine, Deferred Scope (Not in v1.0), DrinkCatalog, Fortune Teller Characters, FortuneTellerProvider, HistoryStore (+18 more)

### Community 6 - "FortuneTeller"
Cohesion: 0.08
Nodes (19): AVFoundation, Hashable, Bool, Hasher, Topic, TopicCatalog, Bool, Void (+11 more)

### Community 7 - "CameraPicker"
Cohesion: 0.11
Nodes (17): Any, AnyClass, AVCaptureVideoPreviewLayer, Context, CameraPicker, Coordinator, Bool, UIImage (+9 more)

### Community 9 - "Lettering"
Cohesion: 0.33
Nodes (4): CGFloat, CoreText, Font, Lettering

### Community 11 - "Reading"
Cohesion: 0.28
Nodes (8): Reading, ReadingEngine, ReadingSymbol, SeededGenerator, String, SymbolChip, RandomNumberGenerator, UInt64

### Community 12 - "FlowLayout"
Cohesion: 0.13
Nodes (13): CGRect, CGSize, ChatMessage, Layout, FlowLayout, CGFloat, BubbleTail, ChatBubble (+5 more)

### Community 13 - "Drink"
Cohesion: 0.11
Nodes (14): Drink, FortuneTeller, Int, LocalizedStringKey, ReadingDraft, Reading, String, DrinkSelectionView (+6 more)

### Community 14 - "Design System (Kit)"
Cohesion: 0.33
Nodes (6): Cadence (Metrics), Design System (Kit), Figma Source of Truth, Lettering (Fonts), Pigment (Colors), Platform Constraints (iOS 17, iPhone, Portrait, Light)

### Community 15 - "OracleChatEntryFlow"
Cohesion: 0.06
Nodes (45): CaseIterable, Codable, LocalizedStringKey, TimeHorizon, days, month, year, ChildrenStatus (+37 more)

### Community 16 - "Atrium (Root Container)"
Cohesion: 1.00
Nodes (3): Atrium (Root Container), Build Order, Ignition (@main App Entry)

### Community 19 - "Drink"
Cohesion: 0.07
Nodes (28): Equatable, Foundation, Hasher, Identifiable, ChatEngine, ChatMessage, Bool, FortuneTeller (+20 more)

### Community 22 - "LocalizedStringKey"
Cohesion: 0.09
Nodes (22): AVCapturePhoto, AVCapturePhotoCaptureDelegate, AVCapturePhotoOutput, AVCaptureSession, Error, NSCache, NSObject, NSString (+14 more)

### Community 24 - "ReadingDraft"
Cohesion: 0.08
Nodes (22): ChatThread, BrewReadingFlow, FlowStub, ReadingStep, chat, intention, loading, photo (+14 more)

### Community 26 - "RootTab"
Cohesion: 0.13
Nodes (17): IntBox, OpenField, country, day, month, relationship, year, ProfileView (+9 more)

### Community 31 - "Interest"
Cohesion: 0.23
Nodes (8): HistoryItem, HistoryReplayView, HistoryView, CGFloat, Pathfinder, Reading, ReadingDraft, Void

### Community 32 - "RootTab"
Cohesion: 0.29
Nodes (7): RootTab, brew, chats, history, LocalizedStringKey, String, TabBar

### Community 44 - "CGFloat"
Cohesion: 0.06
Nodes (27): App, LinearGradient, Ignition, Cadence, Screen, CGFloat, StepDots, Int (+19 more)

### Community 47 - "FlowHeader"
Cohesion: 0.31
Nodes (8): FlowHeader, PrimaryButton, SecondaryButton, Bool, Int, LocalizedStringKey, String, Void

## Knowledge Gaps
- **79 isolated node(s):** `get`, `post`, `patch`, `delete`, `none` (+74 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **30 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SwiftUI` connect `CGFloat` to `ReadingDraft`, `View`, `Drink`, `RootTab`, `ReadingSession`, `FortuneTeller`, `Lettering`, `Reading`, `FlowLayout`, `Drink`, `FlowHeader`, `Drink`, `LocalizedStringKey`, `ReadingDraft`, `RootTab`, `Interest`?**
  _High betweenness centrality (0.235) - this node is a cross-community bridge._
- **Why does `RemoteImage` connect `View` to `Lettering`, `SwiftUI`, `LocalizedStringKey`?**
  _High betweenness centrality (0.054) - this node is a cross-community bridge._
- **Why does `PhotoUploadView` connect `LocalizedStringKey` to `View`, `SwiftUI`, `Drink`?**
  _High betweenness centrality (0.050) - this node is a cross-community bridge._
- **What connects `get`, `post`, `patch` to the rest of the system?**
  _79 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `View` be split into smaller, more focused modules?**
  _Cohesion score 0.05974025974025974 - nodes in this community are weakly interconnected._
- **Should `Drink` be split into smaller, more focused modules?**
  _Cohesion score 0.10144927536231885 - nodes in this community are weakly interconnected._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.08081632653061224 - nodes in this community are weakly interconnected._