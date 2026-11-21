---
name: music-video
description: Write a song with Cinely and make a music video for it. Use when the user asks for a song, lyrics set to music, a jingle, a birthday or wedding song, an instrumental, or a music video, lyric video or video for a song they have in Cinely.
---

# A song, then its music video

Cinely writes and records the song, then films a video that follows it.
The song is free; the video is priced like a film, per 8-second clip, and
nothing is charged until the user approves its preview.

These tools exist only where Cinely's connector offers them. If
`create_song` is not among your tools, say that songs and music videos are
made in the Cinely app or on cinelyai.com, and offer a short film instead.

## 1. The song

Ask only for what is missing: what the song is about, and how it should
sound (genre, mood, tempo, the kind of voice, the language). The user's own
lyrics are sung as written; without them Cinely writes the lyrics. Music
without singing is `instrumental: true`.

Call `create_song` with `about` in the user's words. Do not name a real
artist to imitate: describe the sound instead.

It returns either the takes (`state: song_ready`) or `song_generating` with
a `generation_id`. A song takes a minute or two. Where the Cinely card is
shown it waits and plays the takes itself: say the song is on its way and
do not poll. Without a card, call `list_songs` with the `generation_id`
when the user asks.

There are two takes of the same song. Let the user listen and choose one;
each has its own `song_id`. If neither is right, a new `create_song` with a
changed description makes two more, within the account's songs for the day.

A song already in the account (made earlier, or uploaded in the app) is
found with `list_songs`.

## 2. The video

Call `list_styles` once for the styles, the price per scene and the
balance, then ask:

- **How long**: 30 seconds (4 clips), 60 seconds (8 clips) or the whole
  song (one clip per 8 seconds of song). Say what each costs before the
  user chooses; the whole song of three minutes is over twenty clips.
- **What it shows**: a line or two is enough (`concept`). Without it the
  song's own lyrics decide.
- **Who is in it**: characters are optional. Each needs a name, a gender
  and a description of their looks, or the `image_url` of a saved character
  (`list_saved_characters`).
- **The look**: a style from `list_styles`, not one marked `locked`.

Call `create_music_video_preview` with the chosen `song_id`. The singing
character (`singing_character: true`, the character sings the chorus on
camera) is for Premium accounts and only when the user asks for it.

## 3. Preview, approval, delivery

From here it is a film: the preview shows a scene per clip, the cast, the
price and the balance. Scenes can be changed with `update_preview_scene`
when the user asks. `approve_film` charges the coins and renders the
video, with the song over the picture; pass the `price_coins` the user was
shown as `expected_coins`, and only after they said yes to that price.
`get_film` returns the finished video.

If the balance is short, say how many coins are missing and that coins are
added in the Cinely app or on cinelyai.com.
