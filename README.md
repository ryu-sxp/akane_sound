akane_sound
===============
A simple GUI audio player for GNU/Linux operation systems. Keyboard controls only.

Features
--------
- customization (background, font, colors)
- playlists

Requirements
------------
- Ruby (Tested against Ruby 5.1)
- SDL2
- [Ruby/SDL2](https://github.com/ohai/ruby-sdl2)

Installation
------------
Just run `gem install akane_sound` then do execute `akane_sound` for a first startup that sets up the config file in `/home/user/.local/share/ruby_app/akane_sound/`. Open the config file and edit as you wish, it's recommended to specify the root directory according to your music directory.

Keybindings
-----------
| Key | Function |
| --- | --- |
| enter | play a song, load a playlist, change directory |
| j | move cursor down |
| k | move cursor up |
| page up | move page up |
| page down | move page down |
| space | toggle pause |
| > | volume up |
| < | volume down |
| a | append selected song to playlist, appends contents if directory is selected |
| A | same as above, but recursive |
| tab | switch between directory and playlist |
| C | clear playlist |
| w | write playlist to root_dir/akane_playlists |
| s | stops track if playing |
| r | refreshes the current directory and updates the cache |
| n | skip to next song |
| p | skip back to previous song |
| R | toggle repeat |
| S | toggle shuffle |
| N | toggle auto-next |
| g | go to beginning of list |
| G | go to end of list |
| ESC | quit |





License
-------
GPL3
