# Graph Report - /Users/macbookpro/Projects/OracleBrew  (2026-07-14)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 365 nodes · 582 edges · 30 communities (17 shown, 13 thin omitted)
- Extraction: 92% EXTRACTED · 8% INFERRED · 0% AMBIGUOUS · INFERRED: 45 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e8a69796`
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

## God Nodes (most connected - your core abstractions)
1. `SwiftUI` - 41 edges
2. `ReadingSession` - 21 edges
3. `ReadingDraft` - 18 edges
4. `FortuneTeller` - 17 edges
5. `ChatThread` - 16 edges
6. `Topic` - 15 edges
7. `ReadingResultView` - 13 edges
8. `Drink` - 12 edges
9. `TimeHorizon` - 12 edges
10. `Reading` - 12 edges

## Surprising Connections (you probably didn't know these)
- `Pigment` --calls--> `Color`  [INFERRED]
  OracleBrew/OracleBrew/Kit/StarRating.swift → OracleBrew/OracleBrew/Kit/Pigment.swift
- `TellerCard` --calls--> `Color`  [INFERRED]
  OracleBrew/OracleBrew/Screens/FortuneTellers/components/TellerCard.swift → OracleBrew/OracleBrew/Kit/Pigment.swift
- `Atrium` --calls--> `ChatSessionStore`  [INFERRED]
  OracleBrew/OracleBrew/App/Atrium.swift → OracleBrew/OracleBrew/Backbone/ChatSessionStore.swift
- `Atrium` --calls--> `ReadingHistoryStore`  [INFERRED]
  OracleBrew/OracleBrew/App/Atrium.swift → OracleBrew/OracleBrew/Backbone/ReadingHistory.swift
- `BrewReadingFlow` --calls--> `ReadingDraft`  [INFERRED]
  OracleBrew/OracleBrew/Screens/BrewReading/BrewReadingFlow.swift → OracleBrew/OracleBrew/Backbone/ReadingDraft.swift

## Import Cycles
- None detected.

## Communities (30 total, 13 thin omitted)

### Community 0 - "ReadingDraft"
Cohesion: 0.07
Nodes (29): Equatable, Foundation, ChatEngine, ChatMessage, Bool, FortuneTeller, String, ChatSessionStore (+21 more)

### Community 1 - "View"
Cohesion: 0.10
Nodes (26): Binding, Color, Item, SegmentedSelector, LocalizedStringKey, IntentionView, Bool, LocalizedStringKey (+18 more)

### Community 2 - "Drink"
Cohesion: 0.08
Nodes (24): LinearGradient, Drink, DrinkCatalog, Bool, LocalizedStringKey, String, Color, Pigment (+16 more)

### Community 3 - "SwiftUI"
Cohesion: 0.06
Nodes (20): StepDots, Int, BrewModel, LocalizedStringKey, String, BrewView, CGFloat, ChatsView (+12 more)

### Community 4 - "ReadingSession"
Cohesion: 0.14
Nodes (20): Date, Hashable, Bool, Hasher, LocalizedStringKey, TimeHorizon, days, month (+12 more)

### Community 5 - "Backbone (Services + Mock Data)"
Cohesion: 0.10
Nodes (26): Backbone (Services + Mock Data), Brew Reading Flow, ChatEngine, Deferred Scope (Not in v1.0), DrinkCatalog, Fortune Teller Characters, FortuneTellerProvider, HistoryStore (+18 more)

### Community 6 - "FortuneTeller"
Cohesion: 0.10
Nodes (19): Hasher, Identifiable, FortuneTeller, FortuneTellerRoster, Review, Bool, Double, Int (+11 more)

### Community 7 - "CameraPicker"
Cohesion: 0.12
Nodes (16): Any, Context, NSObject, Cadence, Screen, CGFloat, CameraPicker, Coordinator (+8 more)

### Community 8 - "RootTab"
Cohesion: 0.09
Nodes (16): CaseIterable, Atrium, Bool, LocalizedStringKey, TabPlaceholder, Pathfinder, Waypoint, brewReading (+8 more)

### Community 9 - "Lettering"
Cohesion: 0.12
Nodes (11): App, Content, CoreText, Font, Ignition, Lettering, CGFloat, LocalizedStringKey (+3 more)

### Community 10 - "ReadingStep"
Cohesion: 0.18
Nodes (10): BrewReadingFlow, FlowStub, ReadingStep, chat, intention, photo, result, tellers (+2 more)

### Community 11 - "Reading"
Cohesion: 0.36
Nodes (7): Reading, ReadingEngine, ReadingSymbol, SeededGenerator, String, RandomNumberGenerator, UInt64

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
Cohesion: 0.40
Nodes (4): ChatEntryStep, chat, OracleChatEntryFlow, Void

### Community 16 - "Atrium (Root Container)"
Cohesion: 1.00
Nodes (3): Atrium (Root Container), Build Order, Ignition (@main App Entry)

## Knowledge Gaps
- **29 isolated node(s):** `figma-dev-mode`, `CoreText`, `Screen Bundles Folder Structure (F20)`, `Waypoint (Route)`, `Pigment (Colors)` (+24 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SwiftUI` connect `SwiftUI` to `ReadingDraft`, `View`, `Drink`, `ReadingSession`, `FortuneTeller`, `CameraPicker`, `RootTab`, `Lettering`, `ReadingStep`, `FlowLayout`, `FlowHeader`, `OracleChatEntryFlow`?**
  _High betweenness centrality (0.295) - this node is a cross-community bridge._
- **Why does `ReadingDraft` connect `ReadingDraft` to `ReadingStep`, `Reading`, `ReadingSession`, `OracleChatEntryFlow`?**
  _High betweenness centrality (0.076) - this node is a cross-community bridge._
- **Why does `ReadingSession` connect `ReadingSession` to `SwiftUI`, `ReadingDraft`, `Reading`, `FortuneTeller`?**
  _High betweenness centrality (0.051) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `ReadingDraft` (e.g. with `BrewReadingFlow` and `OracleChatEntryFlow`) actually correct?**
  _`ReadingDraft` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `figma-dev-mode`, `CoreText`, `Screen Bundles Folder Structure (F20)` to the rest of the system?**
  _29 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ReadingDraft` be split into smaller, more focused modules?**
  _Cohesion score 0.06565656565656566 - nodes in this community are weakly interconnected._
- **Should `View` be split into smaller, more focused modules?**
  _Cohesion score 0.09615384615384616 - nodes in this community are weakly interconnected._