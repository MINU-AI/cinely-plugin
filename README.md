# Cinely for Claude

Make short AI films and series from a conversation. Describe a story, and
[Cinely](https://www.cinelyai.com) writes the script, prepares the
characters, shows you a preview, and renders the film when you approve it.

> **Status:** the connector at `mcp.cinelyai.com` is being rolled out and is
> not open to everyone yet. This note is removed at launch.

The plugin has two parts:

- the **Cinely connector**, a remote MCP server at
  `https://mcp.cinelyai.com/mcp` that you sign in to with your Cinely
  account;
- **skills** that teach Claude how to run a film from idea to finished
  video: `short-film` and `series-episode`.

## Install

**Claude (chat) and Cowork** — plugins need a paid Claude plan:

1. Go to **Customize → Plugins → Add → Add marketplace** and enter
   `MINU-AI/cinely-plugin`.
2. Install **Cinely**.
3. Open the plugin's **Connectors** tab, connect **Cinely**, and sign in.

**Claude Code:**

```
/plugin marketplace add MINU-AI/cinely-plugin
/plugin install cinely@cinely
/mcp
```

`/mcp` opens the sign-in for the Cinely connector.

**Free Claude plan, or any other MCP client:** add
`https://mcp.cinelyai.com/mcp` as a custom connector. You get the same
tools without the skills.

## Use it

Ask for a film in your own words:

- "Make a short film about a lighthouse keeper who finds a message in a
  bottle. Anime style, four scenes."
- "Here is my script. Film it as written, in landscape."
- "Add a second episode to my dragon series: they reach the storm."

Claude tells you the price in coins before anything is made, shows you the
script and the characters as a free preview, and starts the render only
after you say yes. Rendering takes a few minutes; the finished film stays
in your Cinely library, in the app and on the web.

## What it can do

| Tool | What it does |
| --- | --- |
| `list_styles` | Styles, genres, qualities and limits of your account |
| `get_account` | Your plan and coin balance |
| `estimate_cost` | The price of a film before it is made |
| `list_saved_characters` | Characters from your earlier films |
| `list_films`, `get_film` | Your films and the state of each one |
| `create_film_preview` | Writes the script and prepares the cast, free |
| `update_preview_scene`, `update_preview_character` | Edit a preview, free |
| `approve_film` | Charges the coins and renders the film |
| `discard_preview` | Deletes a preview you do not want |
| `create_share_link` | Makes a public page for a finished film |

## Coins

Films are paid for with the coins of your Cinely account, the same ones the
app and the website use. A preview is free. Coins are charged once, when you
approve a preview, and the amount is the one you were shown.

## Privacy Policy

Full policy: <https://www.cinelyai.com/privacy>

**What is collected.** To make a film, the connector sends Cinely the story
text, the character names, descriptions and picture links you give in the
conversation, and the choices you make (style, length, quality). It reads
from your Cinely account your plan, coin balance, films and saved
characters, to show them to you in the chat.

**How it is used and stored.** That data is used to write, preview and
render your films and is stored in your Cinely account like any film made
in the app. Character pictures given as links are copied to Cinely's
storage so the film can be rendered. The connector does not read the rest
of your conversation, your Claude memory or your files.

**Third parties.** Story text and character pictures are processed by the
AI providers Cinely uses to write and render films, as described in the
full policy.

**Retention.** Films and previews stay in your Cinely account until you
delete them; the full policy covers account deletion.

**Your controls.** You connect by signing in to Cinely and approving the
access; you can disconnect at any time from your Cinely settings or from
Claude, which ends the access immediately.

**Contact.** <support@cinelyai.com>

## Support

Questions about a film, coins or your account: <support@cinelyai.com>.
Problems with this plugin: open an issue in this repository.

## License

MIT — see [LICENSE](LICENSE). The license covers the files in this
repository; Cinely's service is governed by its
[terms](https://www.cinelyai.com/terms).
