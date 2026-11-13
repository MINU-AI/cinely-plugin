# Cinely — ChatGPT plugin submission

Everything the OpenAI plugin portal asks for besides the archive. Build the
archive with `scripts/build-chatgpt-zip.sh`; upload it at
<https://platform.openai.com/plugins> → **Create plugin** → **With MCP**.

Reviewer sign-in details are entered in the portal only. They are not in
this repository.

## Connection

| Field | Value |
| --- | --- |
| MCP server URL | `https://mcp.cinelyai.com/mcp` |
| Transport | Streamable HTTP |
| Authentication | OAuth 2.1, authorization code with PKCE (S256) |
| Client registration | Client ID Metadata Document (DCR also supported) |
| Scopes | `films:read`, `films:write` |
| Domain verification | The portal's token is served at `https://mcp.cinelyai.com/.well-known/openai-apps-challenge` once it is set as `OPENAI_APPS_CHALLENGE` on the server |
| UI | One MCP App, the film card. It loads images and video only from `https://dwkzuecysz523.cloudfront.net` (Cinely's own storage). No external frames |

## Reviewer access

Sign-in is by email and password on `https://www.cinelyai.com/oauth/authorize`
(the page ChatGPT opens when connecting). No MFA, no email or SMS code. The
test account already holds finished films and enough coins to render several
more.

## Tool annotations and why

| Tool | readOnly | destructive | openWorld | Justification |
| --- | --- | --- | --- | --- |
| `list_styles` | true | false | false | Reads Cinely's catalog and the signed-in account's plan, balance and limits. Changes nothing. |
| `get_account` | true | false | false | Reads the signed-in account's plan, balance and limits. |
| `list_saved_characters` | true | false | false | Reads characters from the user's own earlier films. |
| `list_films` | true | false | false | Reads the user's own films. |
| `get_film` | true | false | false | Reads one of the user's own films: preview, render state or finished video. |
| `create_film_preview` | false | false | false | Creates a free draft in the user's Cinely account. Nothing is charged; the draft can be discarded. It takes text, and pictures only from the user's own Cinely account; a link to anywhere else is refused (`IMAGE_URL_NOT_IN_ACCOUNT`). |
| `update_preview_scene` | false | true | false | Overwrites the text of one scene of an unapproved draft; the earlier text is not kept. Free. |
| `update_preview_character` | false | true | true | Renames a character of an unapproved draft or replaces its picture. A picture given as a link is downloaded from that public address and copied into the user's account. Free. |
| `create_share_link` | false | false | true | Makes a public watch page for a finished film; anyone with the link can view it. The user can revoke the link in Cinely. |
| `approve_film` | false | true | false | Spends the user's Cinely coins and starts a render that cannot be cancelled. Safeguards: the call must carry the exact price the user was shown and is refused if it differs; nothing is charged when the balance is short. |
| `discard_preview` | false | true | false | Permanently deletes an unapproved draft. No coins are involved. |

All tools act only inside the signed-in user's Cinely account. Two reach
the public internet on the user's behalf: `create_share_link`, which
publishes a page, and `update_preview_character`, which downloads a picture
from a link the user gives.

## Positive test cases

Run each in a new conversation with Cinely selected.

**1. Plan and preview a film**

- Prompt: `Make a 2-scene short film in an animated style about an orange cat named Miu who sees snow for the first time. Miu is a fluffy orange cat with blue eyes.`
- Expected tools: `list_styles`, `create_film_preview`
- Expected result: A film card titled by Cinely appears. Within about a minute it shows two scenes, the character Miu with a drawn portrait, the price in coins and the account balance, and an approve button. The assistant says nothing has been charged.

**2. Edit the preview**

- Prompt (after case 1): `Change scene 2 so Miu jumps back in surprise when a snowflake lands on her nose.`
- Expected tools: `update_preview_scene`
- Expected result: ChatGPT may ask for confirmation first (the tool overwrites the scene). The assistant confirms scene 2 was rewritten and that the preview is still free. Asking to see the film again shows the new scene 2.

**3. Approve and render**

- Prompt (after case 1 or 2): `Looks good. Approve it and render the film.`
- Expected tools: `approve_film`
- Expected result: ChatGPT asks for confirmation before the call; the request shows the film and the coin amount. After confirming, the card reports the coins charged and that the film is rendering. A few minutes later the card plays the finished video. (The approve button on the card does the same.)

**4. Find earlier films**

- Prompt: `Show me my Cinely films and play the most recent finished one.`
- Expected tools: `list_films`, `get_film`
- Expected result: A short list of the account's films with their states, then a card that plays the latest finished film.

**5. Check the account**

- Prompt: `How many Cinely coins do I have, and how long a film can I make?`
- Expected tools: `get_account`
- Expected result: The balance in coins, the plan, and the largest number of scenes the account can make. No prices of coin packs, no purchase link.

## Negative test cases

Cinely should not be called for any of these.

**1. A request that has nothing to do with making a film**

- Prompt: `What's the weather in Singapore this weekend?`

**2. Editing a video the user already has**

- Prompt: `Trim the first 10 seconds off the MP4 I attached and add English subtitles.`
- Cinely makes new films; it does not edit a file.

**3. A general question about filmmaking**

- Prompt: `Explain the three-act structure used in screenwriting.`

The test cases, the release notes and the commerce declaration that the
portal reads are in `plugin.json` (`extensions.com.openai.review` and
`.publication`); this file is their commentary. The demo recording's link
goes there too, as `review.demo_recording_url`.

## Release notes — 0.1.0

First release. Make a short film from a story idea: a free preview with the
script, the characters and the price; approval that spends Cinely coins; the
finished video in the conversation. Continue a film as a series. See earlier
films, saved characters and the coin balance.

## Demo recording — shot list

About two minutes, screen recording of ChatGPT on desktop, no cuts inside a
step.

1. Plugins page → Cinely → Connect; the Cinely consent page; **Allow**.
2. New chat with Cinely: positive test case 1. Let the card reach the preview.
3. Open one scene on the card to show the full text; point at price and balance.
4. Positive test case 2 (edit a scene).
5. Approve from the card (two taps); ChatGPT's confirmation if it appears.
6. Cut the wait; show the card playing the finished film.
7. Positive test case 4 (list films).
8. Settings → Cinely → Disconnect, and the same connection listed under
   Cinely → Settings → Connected apps.

## Before submitting

- [ ] Server changes deployed; `OPENAI_APPS_CHALLENGE` set and the container restarted.
- [ ] Developer identity in the portal matches the publisher named on
      cinelyai.com (the site names **MINU PTE. LTD.**).
- [ ] All five positive and three negative cases rerun against production.
- [ ] Demo recording uploaded somewhere reviewers can open without signing in.
- [ ] Reviewer account checked: signs in with email and password only.
