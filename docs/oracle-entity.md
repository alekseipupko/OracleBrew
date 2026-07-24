# Oracle — what the iOS client expects

The client never invents an oracle. It renders whatever `GET /api/oracles/`
returns and sends the `id` back on `POST /api/chats/` and `POST /api/readings/`,
so the oracle has to exist server-side before the app can talk to it or read a
cup with it.

## Fields

`GET /api/oracles/` — list. Everything here is what the cards and the list need.

| Field | Type | Required | Where it shows | Notes |
|---|---|---|---|---|
| `id` | int | yes | — | Sent back as `oracle_id`. The client treats it as opaque. |
| `slug` | string | yes | — | Stable text key. Handy for content ops; the client doesn't route on it. |
| `name` | string | yes | Card + chat header | "Serena" |
| `profession` | string | yes | Line under the name | "Moon Seer" |
| `short_description` | string | yes | Card subtitle | One sentence. **Currently empty on all three live oracles** — see gaps. |
| `illustration` | URL | yes | Card + chat avatar | The client has no bundled art for new oracles; without this the card is blank. |
| `rating` | decimal | yes | Card, "4.9" | One decimal. |
| `reviews_count` | int | yes | Card, "18.7k reviews" | **Does not exist yet** — see gaps. |
| `sessions_count` | int | no | Card, "52 sessions" | Hidden when absent. |
| `specializations` | array | yes | Topic chips | `{id, slug, title}`. Existing endpoint already returns these. |
| `sort_order` | int | no | List order | |

`GET /api/oracles/{id}/` — detail. Adds:

| Field | Type | Required | Where it shows | Notes |
|---|---|---|---|---|
| `bio` | string | yes | Profile "About" | The long paragraph. |
| `reviews` | array | yes | Profile review cards | `{id, author_name, rating, text, created_at}` |
| `quick_prompts` | array of string | no | Chat suggestion chips | Falls back to the chat's own `quick_questions`. |

## Gaps against the content we are shipping

1. **`reviews_count` is missing.** The API only returns the `reviews` array,
   and that is a handful of showcased ones — counting it would print "4
   reviews". The content ships `reviews_count` per oracle and the client reads
   its own value, so this is not blocking; still, add the integer server-side so
   the two agree once the API is the source of truth.

2. **`short_description` comes back empty** on all three live oracles. It is the
   card subtitle — the one-liner in the content doc. The client falls back to
   `bio`, which is a whole paragraph and overflows the card.

3. **Per-review `rating` has no source.** The content gives an overall rating and
   review text, but no stars per review. The field is a required int today —
   either make it optional or default it to 5.

4. **`sessions_count`** now ships in the content (`sessions_count` per oracle),
   and the client reads its own value. Store it server-side too so they agree;
   the client hides the chip only when both are absent.

## Language

The client sends `Accept-Language` on every request. Once these texts are
translatable server-side, `name` / `profession` / `short_description` / `bio` /
review text should come back in the requested language.

### Reading language — resolved

`language` rides in the body of `POST /api/readings/{id}/analyze/` — the call
that spawns the AI job — not on `POST /api/readings/`, which only drafts the
reading. Same shape as chat, where the language goes with each message.
Verified against production: `{"language": "ar"}` on analyze returns
`what_i_see`, `advice_headline` and the symbol texts in Arabic. The client
sends it on every analyze.

## Content

`oracles-content.json` next to this file holds all 15 profiles in this shape,
ready to load. `id` is left out on purpose — it is yours to assign. Send the
assigned ids back and the client will match its bundled art to them.
