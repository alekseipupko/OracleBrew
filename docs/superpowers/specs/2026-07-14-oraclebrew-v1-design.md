# OracleBrew — v1.0 Design Spec

**Date:** 2026-07-14
**Status:** draft — awaiting user review

## 1. What it is

Coffee-ground fortune-telling app. Two main flows:

- **Brew Reading** — pick a drink → pick a fortune teller → set intention → upload/pick a cup photo → get a reading result.
- **Oracle Chat** — after a reading (or directly), chat with the chosen fortune teller in character.

10 fortune-teller characters, each with a full profile. Onboarding collects a user profile. Everything is free in v1.0.

## 2. Project combo (fixed)

- **Architecture:** A1 — MVVM + Router.
- **Folders:** F20 — screen bundles. `App/`, `Screens/<Name>/{<Name>View, <Name>Model, components/}`, `Kit/` (design system), `Backbone/` (services + mock data), `Resources/`.
- **Navigation:** `TabView` (3 tabs), each tab its own `NavigationStack` driven by a `Pathfinder` router over `Waypoint` routes. Modals: `sheet`/`fullScreenCover` per design.
- **Role names:** Pigment (colors), Lettering (fonts), Cadence (metrics), Waypoint (route), Pathfinder (router), Vault (storage), Throb (haptics), Ignition (@main), Atrium (root container).
- **Invariants:** models are pure `struct`; UI on `MainActor`; dependencies behind protocols (mock now, real later).

## 3. Platform & constraints (from base regimen)

- iOS 17.0+, iPhone only (`TARGETED_DEVICE_FAMILY = 1`), portrait, light theme pinned.
- Source of truth = Figma design (file `fjyHm6er9GMWFaKxjMwN9M`, tab-1 start node `16-30`).
- Adaptive 375×667 (SE) — 440×956 (Pro Max); mandatory numeric re-verify on both diagonals.

## 4. Screen inventory

**Onboarding** (multi-screen, 1–2 fields/screen, "Later" skip):
Name · Gender (Female/Male/Prefer not to say) · Date of Birth (→ auto zodiac) · Relationship Status · Employment Status · Country · optional Children (Yes/No/Planning) · optional Topics of Interest (multiselect: Love/Career/Money/Family/Health/Travel/Study).

**Tabs (3)** — exact identities confirmed from Figma when building. Working assumption:
1. Home / Brew Reading entry
2. Reading History
3. Profile / Settings

**Brew Reading flow (5 screens):**
1. Drink Selection — pick a drink type; "random" option auto-picks drink + grounds photo; inside photo step can reshuffle.
2. Fortune Tellers — grid/list of 10; tap → profile card (illustration, name, bio, specializations, tags, rating, sessions, reviews) → chat or continue.
3. Intention — topic tags + optional free-text question + time horizon (Days/Month/Year).
4. Photo Upload — from gallery, or random, or replace random.
5. Reading Result — prediction, general answer, key symbols + meanings, teller's advice; share / save / go to chat.

**Oracle Chat:** teller-in-character replies (fixed stubs v1.0), header = teller illustration + name, horizontal quick-question chips, session-scoped history. Entry: from a reading (remembers drink/question/result, addresses user by name) or directly (generic quick questions).

**Reading History (tab):** archive of sessions. Card: cup thumbnail, teller icon, date, drink icon, topic tag, 2-line prediction preview, chat icon (if chatted). Tap → full result + resume chat.

**Share:** from result → Stories 9:16 card (background + key phrase + cup photo), always with "Oracle Brew" watermark.

**Settings:** Privacy Policy, Terms of Use, Support, Restore, Delete Account, Reading History, Pro Plan (mandatory items) + camera permission / consent management. Privacy & Terms open as in-app screens (not Safari). Profile fields editable here.

## 5. Mock / data layer (Backbone)

All data behind protocols; mock implementations now, real backend swaps later without touching UI.

- `FortuneTellerProvider` — 10 hardcoded tellers (profile + reviews).
- `ReadingEngine` — builds a `Reading` result from (drink, intention, photo) using templated symbol/advice pools per teller/topic.
- `ChatEngine` — **fixed canned replies** per teller/topic; addresses user by name, session-context-aware selection. Protocol boundary so a real LLM drops in later.
- `HistoryStore` (Vault) — persists sessions locally (`UserDefaults`/file/SwiftData — decide at build).
- `UserProfileStore` (Vault) — onboarding profile + `hasSeenOnboarding` flag; editable from Settings.
- `DrinkCatalog` + random grounds-photo pool (sample photos bundled from Figma exports).

No network states (loading/error/offline) in v1.0 — all local. Add per-screen only if a real API screen appears.

## 6. Registration

No login screen. Onboarding collects the profile (Name + structured fields). Zodiac computed from DOB. Editable in Settings → Profile. "Later" skips onboarding; user can fill it later in profile.

## 7. Localization & RTL

- String Catalog `Localizable.xcstrings`, EN base, hierarchical keys `screen.element[.state]`. No raw user-facing strings.
- Two locales: **EN** (dev/QA only) + **Arabic** (production). Prod ships Arabic only.
- Full RTL: layout mirrors; verify Arabic on SE + Pro Max. `InfoPlist.xcstrings` for display name / permissions.

## 8. House-kit primitives

Global loader (Backbone, separate `UIWindow`), alerts/toasts single point, haptics via `Throb` wrapper, in-app web browser (`SFSafariViewController`) — but Privacy/Terms are native screens per requirement. Splash (5.0–6.5s random) + ATT on splash. Wired via `setup-house-kit` / `_shared` modules.

## 9. Build order

1. Project setup: device family→1, iOS 17 target, rename `OracleBrewApp`/`ContentView` → `Ignition`/`Atrium`, bundle id.
2. Design system (Pigment/Lettering/Cadence) from Figma.
3. Tab 1 (Figma node 16-30) + TabView shell + routers.
4. Backbone mock layer (providers/engines/stores).
5. Brew Reading flow (5 screens) + Fortune Teller profiles + Oracle Chat.
6. Tabs 2 & 3 (History, Settings/Profile) + Share + Privacy/Terms screens.
7. Onboarding (last).
8. Localization EN + Arabic RTL, verify on both diagonals.

## 10. Deferred (NOT in v1.0)

Paywall / subscriptions, analytics, real backend, real AI chat, Pro Plan gating (item visible but no purchase), push, Privacy Manifest (assembled at finish).

## 11. Open questions (resolve at build)

- Exact identity/order of the 3 tabs (from Figma).
- Per-screen scroll vs fit (ask when ambiguous).
- History persistence mechanism (UserDefaults vs SwiftData).
- Whether Oracle Chat is a tab or only reachable from a reading/teller.
