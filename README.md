# DJ's Small Machine ME

This is a dual-MP3 player (able to play / fix / fade two `.mp3` files in the same time) with extended playlist management and integrated screensaver mode, which allows you to set your bunch of `.mp3` files in a nice row, start the music, put some cool info about current and following songs and go party.

For Delphi developer this piece of source code may be useful to test things mentioned above. Dual-MP3 playing using DirectX and XAudio library plus an example of full-screen, screen-saver-like window / program.

This program uses _passage point_ or _marker_ -- a point in time (in seconds, counting from each song's end) upon reaching which current song will be slowly silenced and next song will start playing with fade-in sound effect. This should produce a cool no-pause, no-interruption music effect. You can define _passage point_ independently for each song or as fixed value for all songs. For this purpose, program supports saving your list of songs as simple playlist (`.sml`), where _passage points_ are **not** saved or as a project (`.smp`), where _passage points_ are saved. However, looking at the source code tells me, that second function is not fully implemented, so use it with care or consider finishing it yourself.

**This project ABANDONED! There is no wiki, issues and no support. There will be no future updates. Unfortunately, you're on your own.**

### Status

Last time `.dpr` file saved in Delphi: **6 January 2013**. Last time `.exe` file built: **6 January 2013**.

**You're only getting project's source code and nothing else! You need to find all missing Delphi components by yourself.**

I don't have access to either most of my components used in this or any other of my Delphi projects, nor to Delphi itself. Even translation of this project to English was done by text-editing all `.dfm` and `.pas` files and therefore it may be cracked. It was made in hope to be useful to anyone and for the same reason I'm releasing its source code, but you're using this project or source code at your own responsibility.

For sure, you'll need _[Roger Color Combo Box v.1.0](http://www.torry.net/pages.php?id=135)_ component (`TRogerColorComboBox`) or some equivalent.

Keep in mind, that both comments and names (variables, object) are in Polish. I didn't find enough time and determination to translated them as well. I only translated strings.

**This project ABANDONED! There is no wiki, issues and no support. There will be no future updates. Unfortunately, you're on your own.**