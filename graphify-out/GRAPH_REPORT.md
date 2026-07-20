# Graph Report - OracleBrew  (2026-07-20)

## Corpus Check
- 87 files · ~27,526 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 665 nodes · 1064 edges · 80 communities (49 shown, 31 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 49 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `ec905111`
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
- .section
- NavigationPath
- LocalizedStringKey
- RemoteImage
- DecodedImages
- IntentionView
- FlowCard
- HistoryItem
- String
- Pathfinder
- ChatsView
- FortuneTellersView
- Country
- RandomCupView
- Ignition
- DrinkSelectionView
- Pathfinder
- EmptyState
- .short
- TopicChip
- BrewModel
- BrewView
- ChatBubble
- .init
- Hasher
- ChatMessage
- ChatSummary
- ChatThread
- HistoryItem
- ReadingDraft
- ReadingDraft
- Topic

## God Nodes (most connected - your core abstractions)
1. `SwiftUI` - 52 edges
2. `ReadingDraft` - 22 edges
3. `Zodiac` - 19 edges
4. `UserProfile` - 17 edges
5. `ChatThread` - 16 edges
6. `ProfileView` - 15 edges
7. `ChatSummary` - 14 edges
8. `Color` - 14 edges
9. `OracleChatView` - 14 edges
10. `ReadingResultView` - 14 edges

## Surprising Connections (you probably didn't know these)
- `Pigment` --calls--> `Color`  [INFERRED]
  OracleBrew/OracleBrew/Kit/StarRating.swift → OracleBrew/OracleBrew/Kit/Pigment.swift
- `BrewReadingFlow` --calls--> `ReadingDraft`  [INFERRED]
  OracleBrew/OracleBrew/Screens/BrewReading/BrewReadingFlow.swift → OracleBrew/OracleBrew/Backbone/ReadingDraft.swift
- `TellerCard` --calls--> `Color`  [INFERRED]
  OracleBrew/OracleBrew/Screens/FortuneTellers/components/TellerCard.swift → OracleBrew/OracleBrew/Kit/Pigment.swift
- `ChatBubble` --calls--> `Color`  [INFERRED]
  OracleBrew/OracleBrew/Screens/OracleChat/components/ChatBubble.swift → OracleBrew/OracleBrew/Kit/Pigment.swift
- `PhotoUploadView` --calls--> `Color`  [INFERRED]
  OracleBrew/OracleBrew/Screens/PhotoUpload/PhotoUploadView.swift → OracleBrew/OracleBrew/Kit/Pigment.swift

## Import Cycles
- None detected.

## Communities (80 total, 31 thin omitted)

### Community 0 - "ReadingDraft"
Cohesion: 0.19
Nodes (10): Interest, InterestCatalog, String, InterestChip, ProfileChip, ProfileSectionLabel, Bool, LocalizedStringKey (+2 more)

### Community 1 - "View"
Cohesion: 0.28
Nodes (9): Image, Color, Pigment, ReadingResultView, LocalizedStringKey, Reading, String, Void (+1 more)

### Community 2 - "Drink"
Cohesion: 0.24
Nodes (8): Drink, DrinkCatalog, Bool, LocalizedStringKey, String, DrinkCard, Bool, Void

### Community 3 - "SwiftUI"
Cohesion: 0.08
Nodes (30): Bool, EmissaryFailure, Encodable, Encoder, HTTPURLResponse, JSONDecoder, AnyEncodable, Data (+22 more)

### Community 4 - "ReadingSession"
Cohesion: 0.20
Nodes (6): Foundation, Waypoint, brewReading, profile, settings, Features

### Community 5 - "Backbone (Services + Mock Data)"
Cohesion: 0.10
Nodes (26): Backbone (Services + Mock Data), Brew Reading Flow, ChatEngine, Deferred Scope (Not in v1.0), DrinkCatalog, Fortune Teller Characters, FortuneTellerProvider, HistoryStore (+18 more)

### Community 6 - "FortuneTeller"
Cohesion: 0.18
Nodes (7): AVFoundation, SettingsDestination, privacy, terms, SettingsView, UserNotifications, Void

### Community 7 - "CameraPicker"
Cohesion: 0.08
Nodes (23): Any, AnyClass, AVCaptureSession, AVCaptureVideoPreviewLayer, Context, NSObject, Cadence, Screen (+15 more)

### Community 8 - "RootTab"
Cohesion: 0.10
Nodes (19): AIJobDTO, CatalogRepository, Emissary, CatalogStore, Drink, FortuneTeller, Int, String (+11 more)

### Community 9 - "Lettering"
Cohesion: 0.33
Nodes (4): CGFloat, CoreText, Font, Lettering

### Community 10 - "ReadingStep"
Cohesion: 0.27
Nodes (10): Label, DropdownChevron, DropdownOverlay, DropdownRow, ProfileFieldBox, Bool, CGFloat, Int (+2 more)

### Community 11 - "Reading"
Cohesion: 0.28
Nodes (8): Reading, ReadingEngine, ReadingSymbol, SeededGenerator, String, SymbolChip, RandomNumberGenerator, UInt64

### Community 12 - "FlowLayout"
Cohesion: 0.15
Nodes (11): CGRect, CGSize, Layout, BubbleTail, Bool, FlowLayout, CGFloat, Path (+3 more)

### Community 13 - "Drink"
Cohesion: 0.18
Nodes (10): ReadingDraft, Drink, FortuneTeller, Int, Reading, String, Topic, UIImage (+2 more)

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
Cohesion: 0.29
Nodes (9): Identifiable, FortuneTeller, FortuneTellerRoster, Review, Bool, Double, Int, String (+1 more)

### Community 20 - "FortuneTeller"
Cohesion: 0.33
Nodes (6): Equatable, ChatEngine, ChatMessage, Bool, FortuneTeller, String

### Community 21 - "Int"
Cohesion: 0.24
Nodes (7): Bool, Hasher, Topic, TopicCatalog, Bool, Void, TopicButton

### Community 22 - "LocalizedStringKey"
Cohesion: 0.09
Nodes (19): AVCapturePhoto, AVCapturePhotoCaptureDelegate, AVCapturePhotoOutput, Error, CupCamera, Phase, denied, idle (+11 more)

### Community 24 - "ReadingDraft"
Cohesion: 0.15
Nodes (12): BrewReadingFlow, FlowStub, ReadingStep, chat, intention, loading, photo, result (+4 more)

### Community 26 - "RootTab"
Cohesion: 0.10
Nodes (21): Atrium, LocalizedStringKey, TabPlaceholder, IntBox, OpenField, country, day, month (+13 more)

### Community 31 - "Interest"
Cohesion: 0.15
Nodes (11): HistoryCard, HistoryItem, String, Void, HistoryReplayView, HistoryView, CGFloat, HistoryItem (+3 more)

### Community 32 - "RootTab"
Cohesion: 0.29
Nodes (7): RootTab, brew, chats, history, LocalizedStringKey, String, TabBar

### Community 35 - "Bool"
Cohesion: 0.24
Nodes (11): Hashable, ChatSummary, ChatThread, Bool, ChatMessage, Date, FortuneTeller, Int (+3 more)

### Community 36 - "FortuneTeller"
Cohesion: 0.31
Nodes (4): ChatListItemDTO, ChatRepository, ChatSessionStore, ScreenPhase

### Community 44 - "CGFloat"
Cohesion: 0.20
Nodes (6): StepDots, Int, ChatBackground, OracleChatEntryFlow, Void, SwiftUI

### Community 47 - "FlowHeader"
Cohesion: 0.31
Nodes (8): FlowHeader, PrimaryButton, SecondaryButton, Bool, Int, LocalizedStringKey, String, Void

### Community 48 - ".section"
Cohesion: 0.22
Nodes (6): Content, LocalizedStringKey, FortuneTeller, LocalizedStringKey, Void, TellerProfileView

### Community 50 - "LocalizedStringKey"
Cohesion: 0.22
Nodes (7): Bool, FortuneTeller, Int, Void, TellerCard, LocalizedStringKey, View

### Community 51 - "RemoteImage"
Cohesion: 0.25
Nodes (7): Color, ContentMode, Item, RemoteImage, ShimmerFill, SegmentedSelector, LocalizedStringKey

### Community 52 - "DecodedImages"
Cohesion: 0.39
Nodes (4): NSCache, NSString, DecodedImages, UIImage

### Community 53 - "IntentionView"
Cohesion: 0.29
Nodes (5): Binding, IntentionView, Bool, String, Void

### Community 54 - "FlowCard"
Cohesion: 0.29
Nodes (6): LinearGradient, FlowCard, CGFloat, LocalizedStringKey, String, Void

### Community 55 - "HistoryItem"
Cohesion: 0.33
Nodes (6): Pigment, RatingLabel, StarRow, CGFloat, Double, Int

### Community 56 - "String"
Cohesion: 0.17
Nodes (9): OracleChatView, Bool, FortuneTeller, Reading, String, Void, TellerPeek, TypingBubble (+1 more)

### Community 58 - "ChatsView"
Cohesion: 0.29
Nodes (4): ChatsView, CGFloat, Pathfinder, ChatThreadRow

### Community 59 - "FortuneTellersView"
Cohesion: 0.33
Nodes (5): FortuneTeller, Int, LocalizedStringKey, FortuneTellersView, Void

### Community 60 - "Country"
Cohesion: 0.67
Nodes (3): Country, CountryCatalog, String

### Community 61 - "RandomCupView"
Cohesion: 0.40
Nodes (3): RandomCupView, Int, Void

### Community 62 - "Ignition"
Cohesion: 0.40
Nodes (3): App, Ignition, Scene

### Community 63 - "DrinkSelectionView"
Cohesion: 0.40
Nodes (3): Drink, DrinkSelectionView, Void

### Community 65 - "EmptyState"
Cohesion: 0.40
Nodes (4): EmptyState, LocalizedStringKey, String, Void

### Community 66 - ".short"
Cohesion: 0.40
Nodes (3): RelativeTime, Date, String

### Community 67 - "TopicChip"
Cohesion: 0.50
Nodes (3): Bool, String, TopicChip

### Community 68 - "BrewModel"
Cohesion: 0.50
Nodes (3): BrewModel, LocalizedStringKey, String

### Community 69 - "BrewView"
Cohesion: 0.50
Nodes (3): BrewView, CGFloat, LocalizedStringKey

### Community 70 - "ChatBubble"
Cohesion: 0.50
Nodes (3): ChatBubble, Bool, ChatMessage

## Knowledge Gaps
- **81 isolated node(s):** `int`, `string`, `idle`, `denied`, `unavailable` (+76 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **31 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SwiftUI` connect `CGFloat` to `ReadingDraft`, `View`, `Drink`, `FortuneTeller`, `CameraPicker`, `RootTab`, `Lettering`, `ReadingStep`, `Reading`, `FlowLayout`, `Drink`, `Drink`, `Int`, `LocalizedStringKey`, `ReadingDraft`, `RootTab`, `Interest`, `RootTab`, `FlowHeader`, `.section`, `LocalizedStringKey`, `RemoteImage`, `DecodedImages`, `IntentionView`, `FlowCard`, `HistoryItem`, `String`, `ChatsView`, `FortuneTellersView`, `RandomCupView`, `Ignition`, `DrinkSelectionView`, `Pathfinder`, `EmptyState`, `TopicChip`, `BrewModel`, `BrewView`, `ChatBubble`?**
  _High betweenness centrality (0.258) - this node is a cross-community bridge._
- **Why does `ReadingDraft` connect `Drink` to `Bool`, `RootTab`, `Reading`, `FortuneTeller`, `ReadingDraft`, `String`, `Interest`?**
  _High betweenness centrality (0.088) - this node is a cross-community bridge._
- **Why does `RemoteImage` connect `RemoteImage` to `View`, `SwiftUI`, `Lettering`, `LocalizedStringKey`, `DecodedImages`?**
  _High betweenness centrality (0.068) - this node is a cross-community bridge._
- **What connects `int`, `string`, `idle` to the rest of the system?**
  _81 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.08081632653061224 - nodes in this community are weakly interconnected._
- **Should `Backbone (Services + Mock Data)` be split into smaller, more focused modules?**
  _Cohesion score 0.10153846153846154 - nodes in this community are weakly interconnected._
- **Should `CameraPicker` be split into smaller, more focused modules?**
  _Cohesion score 0.08021390374331551 - nodes in this community are weakly interconnected._