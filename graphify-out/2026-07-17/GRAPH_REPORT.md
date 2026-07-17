# Graph Report - OracleBrew  (2026-07-17)

## Corpus Check
- 86 files · ~28,594 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 489 nodes · 744 edges · 49 communities (20 shown, 29 thin omitted)
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 41 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `66d8c954`
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
- NavigationPath
- LocalizedStringKey

## God Nodes (most connected - your core abstractions)
1. `SwiftUI` - 43 edges
2. `Zodiac` - 19 edges
3. `ReadingDraft` - 18 edges
4. `UserProfile` - 17 edges
5. `FortuneTeller` - 17 edges
6. `ProfileView` - 15 edges
7. `ReadingResultView` - 13 edges
8. `Employment` - 12 edges
9. `Drink` - 12 edges
10. `CameraPicker` - 12 edges

## Surprising Connections (you probably didn't know these)
- `BrewReadingFlow` --calls--> `ReadingDraft`  [INFERRED]
  OracleBrew/OracleBrew/Screens/BrewReading/BrewReadingFlow.swift → OracleBrew/OracleBrew/Backbone/ReadingDraft.swift
- `OracleChatEntryFlow` --calls--> `ReadingDraft`  [INFERRED]
  OracleBrew/OracleBrew/Screens/OracleChat/OracleChatEntryFlow.swift → OracleBrew/OracleBrew/Backbone/ReadingDraft.swift
- `Atrium` --calls--> `UserProfileStore`  [INFERRED]
  OracleBrew/OracleBrew/App/Atrium.swift → OracleBrew/OracleBrew/Backbone/UserProfile.swift
- `ProfileView` --calls--> `UserProfile`  [INFERRED]
  OracleBrew/OracleBrew/Screens/Profile/ProfileView.swift → OracleBrew/OracleBrew/Backbone/UserProfile.swift
- `Pigment` --calls--> `Color`  [INFERRED]
  OracleBrew/OracleBrew/Kit/StarRating.swift → OracleBrew/OracleBrew/Kit/Pigment.swift

## Import Cycles
- None detected.

## Communities (49 total, 29 thin omitted)

### Community 0 - "ReadingDraft"
Cohesion: 0.10
Nodes (21): Equatable, Foundation, Hasher, Identifiable, ChatEngine, ChatMessage, Bool, FortuneTeller (+13 more)

### Community 1 - "View"
Cohesion: 0.07
Nodes (32): Binding, Content, Image, Atrium, LocalizedStringKey, TabPlaceholder, BrewReadingFlow, FlowStub (+24 more)

### Community 2 - "Drink"
Cohesion: 0.10
Nodes (18): Double, Drink, DrinkCatalog, Bool, LocalizedStringKey, String, Color, Pigment (+10 more)

### Community 3 - "SwiftUI"
Cohesion: 0.05
Nodes (29): LinearGradient, StepDots, Int, Bool, String, TopicChip, BrewModel, LocalizedStringKey (+21 more)

### Community 4 - "ReadingSession"
Cohesion: 0.12
Nodes (13): Hashable, Country, CountryCatalog, String, Pathfinder, Waypoint, brewReading, profile (+5 more)

### Community 5 - "Backbone (Services + Mock Data)"
Cohesion: 0.10
Nodes (26): Backbone (Services + Mock Data), Brew Reading Flow, ChatEngine, Deferred Scope (Not in v1.0), DrinkCatalog, Fortune Teller Characters, FortuneTellerProvider, HistoryStore (+18 more)

### Community 6 - "FortuneTeller"
Cohesion: 0.15
Nodes (11): Color, Item, Bool, Hasher, Topic, TopicCatalog, SegmentedSelector, LocalizedStringKey (+3 more)

### Community 7 - "CameraPicker"
Cohesion: 0.07
Nodes (28): Any, AnyClass, AVCaptureVideoPreviewLayer, AVFoundation, Context, NSObject, Cadence, Screen (+20 more)

### Community 9 - "Lettering"
Cohesion: 0.19
Nodes (7): App, CGFloat, CoreText, Font, Ignition, Lettering, Scene

### Community 11 - "Reading"
Cohesion: 0.28
Nodes (8): Reading, ReadingEngine, ReadingSymbol, SeededGenerator, String, SymbolChip, RandomNumberGenerator, UInt64

### Community 12 - "FlowLayout"
Cohesion: 0.27
Nodes (7): CGRect, CGSize, Layout, FlowLayout, CGFloat, ProposedViewSize, Subviews

### Community 13 - "FlowHeader"
Cohesion: 0.31
Nodes (8): FlowHeader, PrimaryButton, SecondaryButton, Bool, Int, LocalizedStringKey, String, Void

### Community 14 - "Design System (Kit)"
Cohesion: 0.33
Nodes (6): Cadence (Metrics), Design System (Kit), Figma Source of Truth, Lettering (Fonts), Pigment (Colors), Platform Constraints (iOS 17, iPhone, Portrait, Light)

### Community 15 - "OracleChatEntryFlow"
Cohesion: 0.06
Nodes (46): CaseIterable, Codable, LocalizedStringKey, TimeHorizon, days, month, year, ChildrenStatus (+38 more)

### Community 16 - "Atrium (Root Container)"
Cohesion: 1.00
Nodes (3): Atrium (Root Container), Build Order, Ignition (@main App Entry)

### Community 19 - "Drink"
Cohesion: 0.09
Nodes (20): Drink, FortuneTeller, Int, ReadingDraft, Reading, String, HistoryCard, HistoryItem (+12 more)

### Community 22 - "LocalizedStringKey"
Cohesion: 0.12
Nodes (15): AVCapturePhoto, AVCapturePhotoCaptureDelegate, AVCapturePhotoOutput, AVCaptureSession, Bool, Error, LocalizedStringKey, CupCamera (+7 more)

### Community 26 - "RootTab"
Cohesion: 0.09
Nodes (27): Label, DropdownChevron, DropdownOverlay, DropdownRow, ProfileFieldBox, Bool, CGFloat, Int (+19 more)

### Community 31 - "Interest"
Cohesion: 0.19
Nodes (10): Interest, InterestCatalog, String, InterestChip, ProfileChip, ProfileSectionLabel, Bool, LocalizedStringKey (+2 more)

### Community 32 - "RootTab"
Cohesion: 0.29
Nodes (7): RootTab, brew, chats, history, LocalizedStringKey, String, TabBar

## Knowledge Gaps
- **68 isolated node(s):** `AVFoundation`, `idle`, `denied`, `unavailable`, `running` (+63 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **29 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SwiftUI` connect `SwiftUI` to `RootTab`, `View`, `Drink`, `ReadingDraft`, `ReadingSession`, `FortuneTeller`, `CameraPicker`, `Lettering`, `Reading`, `FlowLayout`, `FlowHeader`, `Drink`, `LocalizedStringKey`, `RootTab`, `Interest`?**
  _High betweenness centrality (0.271) - this node is a cross-community bridge._
- **Why does `ProfileView` connect `RootTab` to `View`, `Interest`, `OracleChatEntryFlow`?**
  _High betweenness centrality (0.079) - this node is a cross-community bridge._
- **Why does `UserProfile` connect `OracleChatEntryFlow` to `ReadingDraft`, `RootTab`?**
  _High betweenness centrality (0.069) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `ReadingDraft` (e.g. with `BrewReadingFlow` and `OracleChatEntryFlow`) actually correct?**
  _`ReadingDraft` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `AVFoundation`, `idle`, `denied` to the rest of the system?**
  _68 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ReadingDraft` be split into smaller, more focused modules?**
  _Cohesion score 0.10344827586206896 - nodes in this community are weakly interconnected._
- **Should `View` be split into smaller, more focused modules?**
  _Cohesion score 0.06826241134751773 - nodes in this community are weakly interconnected._