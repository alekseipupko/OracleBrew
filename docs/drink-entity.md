# Random cup — now client-side

Decision: the **Random Cup** photos are bundled in the app, three per drink, the
same way the oracle portraits are. When the user taps "Random Cup" the client
picks a random drink and a random one of its bundled photos, shows it, and — on
"Start Reading" — **uploads that photo** as the reading's cup image, exactly like
a shot the user took themselves.

So there is nothing for the backend to build here. This replaces the earlier
plan where the backend generated cups and served them.

## What changed on the client

- Each drink carries three bundled cup photos (`CupEspresso1..3`, etc.).
- The Random path selects drink + photo locally and stores the image as the
  reading's `photo`.
- Creating a reading is now **one path**: multipart with `cup_image`. The random
  case and the user-upload case are identical to the backend.

## What the backend no longer needs

- **`GET /api/drinks/random/`** — dropped. The client doesn't call it.
- **`random_cup_id` on `POST /api/readings/`** — dropped. Every reading, random
  or not, arrives as multipart with a `cup_image` file.
- No cup generation, no cup pool, no per-drink cup coverage.

`POST /api/readings/` should accept the multipart form it already does for the
upload path:

| Field | Type | Notes |
|---|---|---|
| `cup_image` | file | The cup photo (a bundled one for the random case). |
| `drink_id` | int | The drink the cup depicts. |
| `oracle_id` | int | |
| `time_horizon` | string | |
| `topic_id` | int | optional |
| `question` | string | optional |

## Drinks list — unchanged

`GET /api/drinks/` is still needed for the drink catalog, matched by slug to the
bundled art/name/blurb. The seven slugs the client keys on:

`turkish_coffee`, `espresso`, `herbal_tea`, `tea_leaves`, `matcha`,
`hot_chocolate`, `wine_sediment`

`image` on a drink can stay null — the client ships the card art.

## Assets still to add (client-side, not backend)

21 cup photos — three per drink — dropped into `Assets.xcassets` under these
names. Until they land the path falls back to the shared `SampleCup`, so it
works now and gains variety when the art arrives.

| Drink | Assets |
|---|---|
| Turkish Coffee | `CupTurkish1`, `CupTurkish2`, `CupTurkish3` |
| Espresso | `CupEspresso1`, `CupEspresso2`, `CupEspresso3` |
| Herbal Brew | `CupHerbal1`, `CupHerbal2`, `CupHerbal3` |
| Tea Leaves | `CupTea1`, `CupTea2`, `CupTea3` |
| Matcha | `CupMatcha1`, `CupMatcha2`, `CupMatcha3` |
| Hot Chocolate | `CupChocolate1`, `CupChocolate2`, `CupChocolate3` |
| Wine Sediment | `CupWine1`, `CupWine2`, `CupWine3` |
