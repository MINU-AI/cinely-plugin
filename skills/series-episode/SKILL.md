---
name: series-episode
description: Add the next episode to a Cinely series, or turn a finished Cinely film into a series. Use when the user asks for a sequel, a part two, the next episode, or to continue a film they already made with Cinely.
---

# Continue a Cinely series

A new episode belongs to the series of the film it continues: it keeps that
series' visual style, genre and cast, so the characters look the same from
one episode to the next.

## 1. Find the series

Call `list_films`. Match what the user said to a title; if two could be
meant, ask which. Use the `series_id` of that entry. A single film becomes a
series the moment a second episode is added to it.

If the user does not remember what happened, `get_film` on the latest
episode gives its title and state; summarise from what the user tells you,
not from memory of your own.

## 2. Agree on what happens next

Ask for the idea of the new episode in the user's own words. One or two
sentences are enough: Cinely's writer knows the earlier episodes and picks
up where they ended.

Keep the cast unless the user wants a change. To keep it, leave `characters`
out of the call. To add or replace someone, send the whole cast you want in
this episode: the returning characters with the `image_url` they already
have (from `list_saved_characters`), and the new one with a picture or a
description.

## 3. Price, preview, approval, delivery

From here it is the same as any Cinely film — follow the **short-film**
skill from its step 2:

- `estimate_cost` and tell the user the price;
- `create_film_preview` with `series_id` set, and without `style_id` or
  `genre` (the series decides them);
- `get_film` to show the preview;
- `approve_film` only after a clear yes to the price;
- `get_film` again for the finished video.
