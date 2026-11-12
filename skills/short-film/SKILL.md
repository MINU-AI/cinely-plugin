---
name: short-film
description: Make a short AI film with Cinely from an idea, a synopsis or a finished script. Use when the user asks for a short film, movie, video story, animated story or cinematic clip with characters and a plot, or asks to turn a story into a video.
---

# Make a short film with Cinely

Cinely writes the script, prepares the characters, and renders the film. The
user pays with the coins of their own Cinely account, and only when they
approve a preview. Your part is to gather what the film needs, show the
preview faithfully, and never spend coins the user has not agreed to.

## 1. Find out what the film is

Ask only for what is missing, in one message:

- **The story**: an idea is enough. Keep the user's own words; do not expand
  a one-line idea into a plot of your own before sending it. If they give a
  finished script, it is filmed as written (see `keep_script` below).
- **The characters**: a name and gender for each, and how each one looks.
  A picture works better than a description when the user has one: a public
  image link, or a character from an earlier film (`list_saved_characters`).
  Do not describe the looks of a character the user gave a picture for.
- **The look**: call `list_styles` once and offer a few styles that suit the
  story, not the whole list. Entries marked `locked` are outside the
  account's plan; do not offer them.
- **The length**: scenes are 8 seconds each. Four scenes is a good first
  film. `list_styles` gives the largest film the account can make.

`list_styles` is the only call you need before the preview: it also gives
the price per scene of each quality and the user's coin balance. The user
is asked to allow every tool call, so do not make calls whose answer you
already have.

Leave quality, aspect ratio, genre and language at their defaults unless the
user asks. Portrait suits phones and social apps; landscape suits YouTube.

## 2. Say what it will cost before making the preview

The price is the number of scenes times `coins_per_scene` of the quality
(from `list_styles`; the account's default quality is `pro` on a premium
plan and `standard` on a free one). Tell the user the price in coins and
their balance (`coins`) in one sentence. If the balance is short, say how
many scenes it covers and offer that film instead. The preview itself is
free; the price is what approving it will charge.

## 3. Make the preview

Call `create_film_preview`. For a finished script set `keep_script: true`
and set `scenes` to the number of scenes in the script.

The call takes up to a minute and normally answers with the finished
preview (`state: preview_ready`). Only when it answers `preview_generating`
do you need `get_film`: tell the user the preview is still being prepared
and call it once, about half a minute later — not again and again.

## 4. Show the preview

From the preview (`state: preview_ready`), show:

- each scene in a sentence or two of your own summary, numbered — the full
  scene text is long, so quote it only when the user asks to read or edit a
  scene;
- each character with its picture (`image_url`) when there is one;
- the price (`price_coins`) and the balance.

Ask whether to make the film or change something first.

Changes are free: `update_preview_scene` rewrites one scene (send the whole
new text of the scene, keeping its SETTING / SHOT layout),
`update_preview_character` renames a character, gives it another picture or
redraws its portrait. To change the story, the style or the number of
scenes, `discard_preview` and make a new preview.

If portraits are still being drawn, the film cannot be approved yet; check
again shortly.

## 5. Approve only on a clear yes

`approve_film` spends the user's coins and cannot be undone. Call it only
after the user has seen the price and said yes to making the film, and pass
that price as `expected_coins`. If it answers `PRICE_CHANGED`, tell the user
the new price and ask again.

If it answers `INSUFFICIENT_COINS`, pass on what it says: how many coins are
missing and how long a film the balance covers. Do not suggest ways of
getting coins other than the ones the answer itself names.

## 6. Deliver the film

Rendering takes several minutes. Say so once, and call `get_film` when the
user asks or comes back — not in a loop.

- `finished`: give the `video_url`, and show the poster. Offer
  `create_share_link` if they want a page to send to other people; say that
  anyone with that link can watch the film.
- `failed`: say what `get_film` gives as the meaning and the advice, in
  plain words. Do not guess at other causes.
- some scenes left out (`scenes_left_out`): say how many; they can be remade
  in the Cinely app.

## What not to do

- Do not approve a film to "save the user a step".
- Do not invent prices, limits or plan features; they come from
  `list_styles` and from the preview itself.
- If a tool answers `PROMPT_BLOCKED_…`, the story as written cannot be
  filmed. Say which kind of content was the problem and help the user
  rewrite it; do not try to get the same content through in other words.
