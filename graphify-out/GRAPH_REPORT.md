# Graph Report - OracleBrew  (2026-07-23)

## Corpus Check
- 109 files · ~45,604 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1088 nodes · 1937 edges · 63 communities (52 shown, 11 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 133 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a6ec6d23`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Chat & Catalog DTOs
- History & Navigation
- Country Catalog & API Config
- Reading Service & JSON
- Chat Wire Models
- Flow Layout & Bubble Shapes
- Onboarding Conversation Flow
- App Root & Catalog Store
- Cup Camera Capture
- Profile Dropdown Controls
- Oracle Entity API Contract
- Daily Fortune Catalog
- Project Design Notes
- Oracle & Review DTOs
- Intention: Topic & Horizon
- Settings Row Components
- User Profile Enums
- Chat Session Store
- Emissary Request Building
- Typography & Nav Chrome
- Catalog Repository
- Reading Result Screen
- Splash Video Player
- Remote Image Cache
- Network Send & Retry
- Onboarding Chrome
- Zodiac Signs
- Brew Reading Flow Steps
- Session Gate & Bootstrap
- Interests & Profile Chips
- PhotoCaptor
- Network Failure Types
- Profile Field Keys
- Profile DTO Mapping
- ReadingStep
- Lettering Fonts
- Oracle Chat Screen
- Flow Buttons & Header
- Topic & Teller Chips
- Chats List Screen
- LegalTextView
- Palette & Brew Cards
- Profile Repository & Store
- Intention Screen
- Emissary Core
- Encodable Request Bodies
- Community 46
- Community 47
- Community 48
- Community 49
- Community 51
- LayoutDirection
- SegmentedSelector
- Community 55
- Community 56
- Community 58
- Community 60
- CGFloat
- ScrollViewProxy
- Community 63
- Void
- Community 68
- Community 70

## God Nodes (most connected - your core abstractions)
1. `View` - 95 edges
2. `SwiftUI` - 71 edges
3. `Color` - 26 edges
4. `FortuneTeller` - 25 edges
5. `UserProfile` - 25 edges
6. `Foundation` - 24 edges
7. `EmissaryRequest` - 24 edges
8. `CodingKeys` - 22 edges
9. `CodingKeys` - 22 edges
10. `EmissaryFailure` - 22 edges

## Surprising Connections (you probably didn't know these)
- `Pigment` --calls--> `Color`  [INFERRED]
  OracleBrew/OracleBrew/Kit/StarRating.swift → OracleBrew/OracleBrew/Kit/Pigment.swift
- `OracleChatView` --calls--> `ChatRepository`  [INFERRED]
  OracleBrew/OracleBrew/Screens/OracleChat/OracleChatView.swift → OracleBrew/OracleBrew/Backbone/Network/ChatRepository.swift
- `SparklePair` --references--> `View`  [EXTRACTED]
  OracleBrew/OracleBrew/Kit/Sparkle.swift → OracleBrew/OracleBrew/App/WaypointDestinations.swift
- `OnboardingLoadingView` --references--> `View`  [EXTRACTED]
  OracleBrew/OracleBrew/Screens/Onboarding/OnboardingView.swift → OracleBrew/OracleBrew/App/WaypointDestinations.swift
- `ChatBackground` --references--> `View`  [EXTRACTED]
  OracleBrew/OracleBrew/Screens/OracleChat/components/ChatBackground.swift → OracleBrew/OracleBrew/App/WaypointDestinations.swift

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **** — docs_superpowers_specs_2026_07_14_oraclebrew_v1_design_brew_reading_flow, docs_superpowers_specs_2026_07_14_oraclebrew_v1_design_drink_catalog, docs_superpowers_specs_2026_07_14_oraclebrew_v1_design_reading_engine, docs_superpowers_specs_2026_07_14_oraclebrew_v1_design_reading_result, docs_superpowers_specs_2026_07_14_oraclebrew_v1_design_fortune_teller_provider [INFERRED 0.80]
- **** — docs_superpowers_specs_2026_07_14_oraclebrew_v1_design_mvvm_router, docs_superpowers_specs_2026_07_14_oraclebrew_v1_design_pathfinder, docs_superpowers_specs_2026_07_14_oraclebrew_v1_design_waypoint, docs_superpowers_specs_2026_07_14_oraclebrew_v1_design_atrium [INFERRED 0.80]
- **Open content gaps blocking the shipped oracle content** — docs_oracle_entity_gap_reviews_count_missing, docs_oracle_entity_gap_short_description_empty, docs_oracle_entity_gap_per_review_rating, docs_oracle_entity_gap_sessions_count [EXTRACTED 1.00]
- **Oracle id round-trip between client and server** — docs_oracle_entity_get_api_oracles, docs_oracle_entity_oracle_id, docs_oracle_entity_post_api_chats, docs_oracle_entity_post_api_readings, docs_oracle_entity_oracles_content_json [EXTRACTED 1.00]
- **Localization of oracle and reading texts** — docs_oracle_entity_accept_language, docs_oracle_entity_reading_language_in_analyze_body, docs_oracle_entity_post_api_readings_analyze, docs_oracle_entity_bio, docs_oracle_entity_short_description [INFERRED 0.85]

## Communities (63 total, 11 thin omitted)

### Community 0 - "Chat & Catalog DTOs"
Cohesion: 0.06
Nodes (43): AIJobDTO, ChatMessage, Emissary, Encodable, Int, ChatDetailDTO, ChatJobDTO, ChatJobResultDTO (+35 more)

### Community 1 - "History & Navigation"
Cohesion: 0.06
Nodes (22): HistoryRepository, Pathfinder, HistoryItem, ReadingHistoryStore, Bool, Date, Hasher, Int (+14 more)

### Community 2 - "Country Catalog & API Config"
Cohesion: 0.06
Nodes (31): EmissaryFailure, decoding, encoding, notFound, notSubscribed, offline, rateLimited, server (+23 more)

### Community 3 - "Reading Service & JSON"
Cohesion: 0.09
Nodes (20): Entry, Bool, String, SymbolCatalog, Cadence, Screen, CGFloat, CameraPicker (+12 more)

### Community 4 - "Chat Wire Models"
Cohesion: 0.10
Nodes (20): CodingKeys, authorName, bio, createdAt, description, id, illustration, image (+12 more)

### Community 5 - "Flow Layout & Bubble Shapes"
Cohesion: 0.06
Nodes (30): CGSize, Error, Layout, BubbleTail, Bool, CGRect, Path, FlowLayout (+22 more)

### Community 6 - "Onboarding Conversation Flow"
Cohesion: 0.10
Nodes (26): Duration, Equatable, Identifiable, Line, OnboardingFlow, Stage, asking, ready (+18 more)

### Community 7 - "App Root & Catalog Store"
Cohesion: 0.10
Nodes (15): Calendar, FortuneCatalog, Date, Int, String, OnboardingLeavePopup, OnboardingLoadingView, OnboardingReadyView (+7 more)

### Community 8 - "Cup Camera Capture"
Cohesion: 0.13
Nodes (14): AVCaptureSession, AVCaptureVideoPreviewLayer, AVPlayer, AVPlayerLayer, CameraPreview, PreviewView, AnyClass, Context (+6 more)

### Community 9 - "Profile Dropdown Controls"
Cohesion: 0.10
Nodes (26): Label, DropdownChevron, DropdownOverlay, DropdownRow, ProfileFieldBox, Bool, CGFloat, Content (+18 more)

### Community 10 - "Oracle Entity API Contract"
Cohesion: 0.10
Nodes (29): Accept-Language header, bio, Bundled art matched to assigned ids, Gap: per-review rating has no source, Gap: reviews_count missing from API, Gap: sessions_count has no source, Gap: short_description empty on live oracles, GET /api/oracles/ (list) (+21 more)

### Community 11 - "Daily Fortune Catalog"
Cohesion: 0.19
Nodes (13): OnboardingBirthPicker, OnboardingContinue, OnboardingInterests, OnboardingOptions, OnboardingTextEntry, OnboardingWheel, Bool, Int (+5 more)

### Community 12 - "Project Design Notes"
Cohesion: 0.10
Nodes (26): Backbone (Services + Mock Data), Brew Reading Flow, ChatEngine, Deferred Scope (Not in v1.0), DrinkCatalog, Fortune Teller Characters, FortuneTellerProvider, HistoryStore (+18 more)

### Community 13 - "Oracle & Review DTOs"
Cohesion: 0.10
Nodes (20): CodingKeys, adviceHeadline, aiJobId, baseDescription, cupImage, hasChat, icon, id (+12 more)

### Community 14 - "Intention: Topic & Horizon"
Cohesion: 0.14
Nodes (13): Bool, Hasher, Int, LocalizedStringKey, TimeHorizon, days, month, year (+5 more)

### Community 15 - "Settings Row Components"
Cohesion: 0.15
Nodes (17): SettingsArrow, SettingsCard, SettingsDivider, SettingsIcon, SettingsRow, SettingsSectionLabel, SettingsToggleRow, Bool (+9 more)

### Community 16 - "User Profile Enums"
Cohesion: 0.15
Nodes (16): CaseIterable, Codable, ChildrenStatus, have, none, planning, Employment, both (+8 more)

### Community 17 - "Chat Session Store"
Cohesion: 0.09
Nodes (27): ChatMessage, ChatSessionStore, ChatSummary, ChatThread, Bool, Date, Hasher, Int (+19 more)

### Community 18 - "Emissary Request Building"
Cohesion: 0.06
Nodes (35): HTTPURLResponse, JSONDecoder, APIConfig, String, AnyEncodable, Data, Emissary, HTTPMethod (+27 more)

### Community 19 - "Typography & Nav Chrome"
Cohesion: 0.09
Nodes (12): AVFoundation, CoreText, StepDots, Int, ChatBackground, ChatBubble, Bool, ReviewCard (+4 more)

### Community 20 - "Catalog Repository"
Cohesion: 0.08
Nodes (22): CatalogStore, Int, String, Drink, DrinkCatalog, Bool, LocalizedStringKey, String (+14 more)

### Community 21 - "Reading Result Screen"
Cohesion: 0.07
Nodes (31): App, Ignition, Reading, ReadingEngine, ReadingSymbol, SeededGenerator, String, Lettering (+23 more)

### Community 23 - "Remote Image Cache"
Cohesion: 0.22
Nodes (11): ContentMode, NSCache, NSString, DecodedImages, RemoteImage, ShimmerFill, Bool, CGFloat (+3 more)

### Community 24 - "Network Send & Retry"
Cohesion: 0.12
Nodes (10): Foundation, Paginated, Bool, Int, Item, String, Features, RelativeTime (+2 more)

### Community 25 - "Onboarding Chrome"
Cohesion: 0.13
Nodes (14): Kind, failure, offline, ScreenStateView, LocalizedStringKey, String, Void, RootTab (+6 more)

### Community 26 - "Zodiac Signs"
Cohesion: 0.15
Nodes (14): View, SettingsButton, HistoryCard, String, Void, OnboardingBackground, OnboardingBubble, OnboardingHeader (+6 more)

### Community 27 - "Brew Reading Flow Steps"
Cohesion: 0.15
Nodes (13): CodingKeys, adviceHeadline, createdAt, cupImage, drink, hasChat, id, oracle (+5 more)

### Community 28 - "Session Gate & Bootstrap"
Cohesion: 0.14
Nodes (14): Int, Zodiac, aquarius, aries, cancer, capricorn, gemini, leo (+6 more)

### Community 30 - "PhotoCaptor"
Cohesion: 0.42
Nodes (12): Decodable, DrinkDTO, OracleDTO, RandomCupDTO, ReviewDTO, SpecializationDTO, Double, Int (+4 more)

### Community 31 - "Network Failure Types"
Cohesion: 0.26
Nodes (5): ProfileRepository, Bool, Set, UserProfile, UserProfileStore

### Community 32 - "Profile Field Keys"
Cohesion: 0.17
Nodes (12): CodingKeys, children, country, dataConsent, dateOfBirth, employmentStatus, gender, name (+4 more)

### Community 33 - "Profile DTO Mapping"
Cohesion: 0.19
Nodes (10): Interest, InterestCatalog, String, InterestChip, ProfileChip, ProfileSectionLabel, Bool, LocalizedStringKey (+2 more)

### Community 34 - "ReadingStep"
Cohesion: 0.32
Nodes (6): ProfileDTO, ProfileMapper, Bool, Int, String, T

### Community 35 - "Lettering Fonts"
Cohesion: 0.18
Nodes (7): FortuneTellersView, Int, LocalizedStringKey, Void, RandomCupView, Int, Void

### Community 36 - "Oracle Chat Screen"
Cohesion: 0.07
Nodes (29): Bool, CGFloat, ChatThread, Drink, FortuneTeller, Hashable, Atrium, Country (+21 more)

### Community 37 - "Flow Buttons & Header"
Cohesion: 0.31
Nodes (8): FlowHeader, PrimaryButton, SecondaryButton, Bool, Int, LocalizedStringKey, String, Void

### Community 38 - "Topic & Teller Chips"
Cohesion: 0.20
Nodes (7): Bool, String, TopicChip, Bool, Int, Void, TellerCard

### Community 39 - "Chats List Screen"
Cohesion: 0.14
Nodes (10): LegalCopy, LegalTextView, LocalizedStringKey, String, Void, SettingsDestination, privacy, terms (+2 more)

### Community 40 - "LegalTextView"
Cohesion: 0.50
Nodes (8): AIJobDTO, ReadingDTO, ReadingResultDTO, ReadingSymbolDTO, Bool, Int, String, SymbolDTO

### Community 41 - "Palette & Brew Cards"
Cohesion: 0.22
Nodes (7): LinearGradient, Pigment, FlowCard, CGFloat, LocalizedStringKey, String, Void

### Community 42 - "Profile Repository & Store"
Cohesion: 0.33
Nodes (6): CodingKey, AuthResponse, CodingKeys, shareCode, token, String

### Community 43 - "Intention Screen"
Cohesion: 0.33
Nodes (6): RelationshipStatus, complicated, divorced, inRelationship, married, single

### Community 44 - "Emissary Core"
Cohesion: 0.40
Nodes (4): EmptyState, LocalizedStringKey, String, Void

### Community 48 - "Community 48"
Cohesion: 0.33
Nodes (6): Pigment, RatingLabel, StarRow, CGFloat, Double, Int

### Community 49 - "Community 49"
Cohesion: 0.29
Nodes (5): BrewModel, LocalizedStringKey, BrewView, CGFloat, LocalizedStringKey

### Community 51 - "Community 51"
Cohesion: 0.33
Nodes (6): Cadence (Metrics), Design System (Kit), Figma Source of Truth, Lettering (Fonts), Pigment (Colors), Platform Constraints (iOS 17, iPhone, Portrait, Light)

### Community 52 - "LayoutDirection"
Cohesion: 0.50
Nodes (3): LayoutDirection, CGFloat, UnitPoint

### Community 53 - "SegmentedSelector"
Cohesion: 0.50
Nodes (3): SegmentedSelector, Item, LocalizedStringKey

### Community 55 - "Community 55"
Cohesion: 0.40
Nodes (4): ReadingLoadingView, CGFloat, Double, Void

### Community 56 - "Community 56"
Cohesion: 0.09
Nodes (20): AVCapturePhoto, AVCapturePhotoCaptureDelegate, AVCapturePhotoOutput, NSObject, CupCamera, Phase, denied, idle (+12 more)

### Community 58 - "Community 58"
Cohesion: 0.33
Nodes (5): Image, LocalizedStringKey, String, Text, ThumbCard

### Community 68 - "Community 68"
Cohesion: 1.00
Nodes (3): Atrium (Root Container), Build Order, Ignition (@main App Entry)

## Knowledge Gaps
- **193 isolated node(s):** `id`, `role`, `text`, `createdAt`, `oracle` (+188 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **11 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SwiftUI` connect `Typography & Nav Chrome` to `History & Navigation`, `Country Catalog & API Config`, `Reading Service & JSON`, `Flow Layout & Bubble Shapes`, `Onboarding Conversation Flow`, `App Root & Catalog Store`, `Profile Dropdown Controls`, `Daily Fortune Catalog`, `Intention: Topic & Horizon`, `Settings Row Components`, `Chat Session Store`, `Catalog Repository`, `Reading Result Screen`, `Remote Image Cache`, `Onboarding Chrome`, `Zodiac Signs`, `Profile DTO Mapping`, `Lettering Fonts`, `Oracle Chat Screen`, `Flow Buttons & Header`, `Topic & Teller Chips`, `Chats List Screen`, `Palette & Brew Cards`, `Emissary Core`, `Community 48`, `Community 49`, `LayoutDirection`, `SegmentedSelector`, `Community 55`, `Community 56`, `Community 58`?**
  _High betweenness centrality (0.291) - this node is a cross-community bridge._
- **Why does `View` connect `Zodiac Signs` to `History & Navigation`, `Country Catalog & API Config`, `Reading Service & JSON`, `Flow Layout & Bubble Shapes`, `App Root & Catalog Store`, `Profile Dropdown Controls`, `Daily Fortune Catalog`, `Intention: Topic & Horizon`, `Settings Row Components`, `Typography & Nav Chrome`, `Catalog Repository`, `Reading Result Screen`, `Remote Image Cache`, `Onboarding Chrome`, `Profile DTO Mapping`, `Lettering Fonts`, `Oracle Chat Screen`, `Flow Buttons & Header`, `Topic & Teller Chips`, `Chats List Screen`, `Palette & Brew Cards`, `Emissary Core`, `Community 48`, `Community 49`, `SegmentedSelector`, `Community 55`, `Community 56`, `Community 58`?**
  _High betweenness centrality (0.209) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Network Send & Retry` to `Chat & Catalog DTOs`, `History & Navigation`, `Country Catalog & API Config`, `Oracle Chat Screen`, `Onboarding Conversation Flow`, `App Root & Catalog Store`, `LegalTextView`, `Profile Repository & Store`, `User Profile Enums`, `Chat Session Store`, `Emissary Request Building`, `Reading Result Screen`, `Brew Reading Flow Steps`, `PhotoCaptor`, `Network Failure Types`?**
  _High betweenness centrality (0.177) - this node is a cross-community bridge._
- **Are the 12 inferred relationships involving `Color` (e.g. with `.drink()` and `SegmentedSelector`) actually correct?**
  _`Color` has 12 INFERRED edges - model-reasoned connections that need verification._
- **What connects `id`, `role`, `text` to the rest of the system?**
  _193 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Chat & Catalog DTOs` be split into smaller, more focused modules?**
  _Cohesion score 0.06103896103896104 - nodes in this community are weakly interconnected._
- **Should `History & Navigation` be split into smaller, more focused modules?**
  _Cohesion score 0.06201550387596899 - nodes in this community are weakly interconnected._