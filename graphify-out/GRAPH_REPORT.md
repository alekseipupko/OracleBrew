# Graph Report - OracleBrew  (2026-07-17)

## Corpus Check
- 86 files · ~28,594 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 518 nodes · 776 edges · 58 communities (28 shown, 30 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 36 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f9ebe1ae`
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
- FlowHeader
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
- Void
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
- FlowCard
- StarRating.swift
- NavigationPath
- LocalizedStringKey
- Color
- HistoryCard
- BrewView
- DrinkSelectionView
- HistoryItem
- String
- Pathfinder

## God Nodes (most connected - your core abstractions)
1. `SwiftUI` - 45 edges
2. `Zodiac` - 19 edges
3. `UserProfile` - 17 edges
4. `FortuneTeller` - 16 edges
5. `ProfileView` - 15 edges
6. `OracleChatView` - 13 edges
7. `ReadingDraft` - 13 edges
8. `ReadingResultView` - 12 edges
9. `Employment` - 12 edges
10. `Drink` - 12 edges

## Surprising Connections (you probably didn't know these)
- `Pigment` --calls--> `Color`  [INFERRED]
  OracleBrew/OracleBrew/Kit/StarRating.swift → OracleBrew/OracleBrew/Kit/Pigment.swift
- `Atrium` --calls--> `UserProfileStore`  [INFERRED]
  OracleBrew/OracleBrew/App/Atrium.swift → OracleBrew/OracleBrew/Backbone/UserProfile.swift
- `ProfileView` --calls--> `UserProfile`  [INFERRED]
  OracleBrew/OracleBrew/Screens/Profile/ProfileView.swift → OracleBrew/OracleBrew/Backbone/UserProfile.swift
- `TellerCard` --calls--> `Color`  [INFERRED]
  OracleBrew/OracleBrew/Screens/FortuneTellers/components/TellerCard.swift → OracleBrew/OracleBrew/Kit/Pigment.swift
- `PhotoUploadView` --calls--> `CupCamera`  [INFERRED]
  OracleBrew/OracleBrew/Screens/PhotoUpload/PhotoUploadView.swift → OracleBrew/OracleBrew/Kit/CupCamera.swift

## Import Cycles
- None detected.

## Communities (58 total, 30 thin omitted)

### Community 0 - "ReadingDraft"
Cohesion: 0.13
Nodes (16): Foundation, Hasher, Identifiable, Country, CountryCatalog, String, FortuneTeller, FortuneTellerRoster (+8 more)

### Community 1 - "View"
Cohesion: 0.07
Nodes (30): Binding, ChatSummary, Content, Image, ChatsView, CGFloat, Pathfinder, IntentionView (+22 more)

### Community 2 - "Drink"
Cohesion: 0.24
Nodes (8): Drink, DrinkCatalog, Bool, LocalizedStringKey, String, DrinkCard, Bool, Void

### Community 3 - "SwiftUI"
Cohesion: 0.20
Nodes (7): Bool, String, TopicChip, Bool, Int, Void, TellerCard

### Community 4 - "ReadingSession"
Cohesion: 0.13
Nodes (9): Atrium, LocalizedStringKey, TabPlaceholder, Pathfinder, Waypoint, brewReading, profile, settings (+1 more)

### Community 5 - "Backbone (Services + Mock Data)"
Cohesion: 0.10
Nodes (26): Backbone (Services + Mock Data), Brew Reading Flow, ChatEngine, Deferred Scope (Not in v1.0), DrinkCatalog, Fortune Teller Characters, FortuneTellerProvider, HistoryStore (+18 more)

### Community 6 - "FortuneTeller"
Cohesion: 0.12
Nodes (14): Color, Item, Bool, Hasher, Topic, TopicCatalog, Interest, InterestCatalog (+6 more)

### Community 7 - "CameraPicker"
Cohesion: 0.07
Nodes (27): Any, AnyClass, AVCaptureVideoPreviewLayer, AVFoundation, Context, Cadence, Screen, CGFloat (+19 more)

### Community 9 - "Lettering"
Cohesion: 0.19
Nodes (7): App, CGFloat, CoreText, Font, Ignition, Lettering, Scene

### Community 11 - "Reading"
Cohesion: 0.28
Nodes (8): Reading, ReadingEngine, ReadingSymbol, SeededGenerator, String, SymbolChip, RandomNumberGenerator, UInt64

### Community 12 - "FlowLayout"
Cohesion: 0.15
Nodes (12): CGRect, CGSize, Layout, FlowLayout, CGFloat, BubbleTail, ChatBubble, Bool (+4 more)

### Community 13 - "FlowHeader"
Cohesion: 0.31
Nodes (8): FlowHeader, PrimaryButton, SecondaryButton, Bool, Int, LocalizedStringKey, String, Void

### Community 14 - "Design System (Kit)"
Cohesion: 0.33
Nodes (6): Cadence (Metrics), Design System (Kit), Figma Source of Truth, Lettering (Fonts), Pigment (Colors), Platform Constraints (iOS 17, iPhone, Portrait, Light)

### Community 15 - "OracleChatEntryFlow"
Cohesion: 0.06
Nodes (47): CaseIterable, ChatMessage, Codable, LocalizedStringKey, TimeHorizon, days, month, year (+39 more)

### Community 16 - "Atrium (Root Container)"
Cohesion: 1.00
Nodes (3): Atrium (Root Container), Build Order, Ignition (@main App Entry)

### Community 19 - "Drink"
Cohesion: 0.14
Nodes (15): Drink, Equatable, FortuneTeller, Int, ChatEngine, ChatMessage, Bool, FortuneTeller (+7 more)

### Community 22 - "LocalizedStringKey"
Cohesion: 0.12
Nodes (16): AVCapturePhoto, AVCapturePhotoCaptureDelegate, AVCapturePhotoOutput, AVCaptureSession, Bool, Error, LocalizedStringKey, NSObject (+8 more)

### Community 24 - "ReadingDraft"
Cohesion: 0.07
Nodes (28): ChatThread, EmissaryFailure, Hashable, BrewReadingFlow, FlowStub, ReadingStep, chat, intention (+20 more)

### Community 26 - "RootTab"
Cohesion: 0.09
Nodes (27): Label, DropdownChevron, DropdownOverlay, DropdownRow, ProfileFieldBox, Bool, CGFloat, Int (+19 more)

### Community 31 - "Interest"
Cohesion: 0.23
Nodes (8): HistoryItem, HistoryReplayView, HistoryView, CGFloat, Pathfinder, Reading, ReadingDraft, Void

### Community 32 - "RootTab"
Cohesion: 0.29
Nodes (7): RootTab, brew, chats, history, LocalizedStringKey, String, TabBar

### Community 44 - "CGFloat"
Cohesion: 0.18
Nodes (7): StepDots, Int, BrewModel, LocalizedStringKey, String, ChatBackground, SwiftUI

### Community 47 - "FlowCard"
Cohesion: 0.29
Nodes (6): LinearGradient, FlowCard, CGFloat, LocalizedStringKey, String, Void

### Community 48 - "StarRating.swift"
Cohesion: 0.33
Nodes (6): Pigment, RatingLabel, StarRow, CGFloat, Double, Int

### Community 51 - "Color"
Cohesion: 0.40
Nodes (4): Double, Color, Pigment, UInt32

### Community 52 - "HistoryCard"
Cohesion: 0.40
Nodes (4): HistoryCard, HistoryItem, String, Void

### Community 53 - "BrewView"
Cohesion: 0.50
Nodes (3): BrewView, CGFloat, LocalizedStringKey

### Community 54 - "DrinkSelectionView"
Cohesion: 0.50
Nodes (3): DrinkSelectionView, String, Void

## Knowledge Gaps
- **69 isolated node(s):** `tellers`, `intention`, `photo`, `loading`, `result` (+64 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **30 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SwiftUI` connect `CGFloat` to `ReadingDraft`, `View`, `Drink`, `SwiftUI`, `ReadingSession`, `FortuneTeller`, `CameraPicker`, `Lettering`, `Reading`, `FlowLayout`, `FlowHeader`, `Drink`, `LocalizedStringKey`, `ReadingDraft`, `RootTab`, `Interest`, `RootTab`, `FlowCard`, `StarRating.swift`, `Color`, `HistoryCard`, `BrewView`, `DrinkSelectionView`?**
  _High betweenness centrality (0.295) - this node is a cross-community bridge._
- **Why does `ProfileView` connect `RootTab` to `View`, `ReadingSession`, `OracleChatEntryFlow`?**
  _High betweenness centrality (0.061) - this node is a cross-community bridge._
- **Why does `OracleChatView` connect `ReadingDraft` to `View`, `OracleChatEntryFlow`?**
  _High betweenness centrality (0.053) - this node is a cross-community bridge._
- **What connects `tellers`, `intention`, `photo` to the rest of the system?**
  _69 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ReadingDraft` be split into smaller, more focused modules?**
  _Cohesion score 0.13438735177865613 - nodes in this community are weakly interconnected._
- **Should `View` be split into smaller, more focused modules?**
  _Cohesion score 0.07171717171717172 - nodes in this community are weakly interconnected._
- **Should `ReadingSession` be split into smaller, more focused modules?**
  _Cohesion score 0.13333333333333333 - nodes in this community are weakly interconnected._