# OnsetFM
Add a radio to your cars! OnsetFM let's you add streams and tracks ingame to play in cars as a radio. Each stream is it's own channel, tracks are collected in a separate channel.

# Installation
1. For streams: add the urls to the */tracks/streams.txt* file, each on their own line.
1. For tracks: add the audio file to the */tracks/* folder and make sure the name starts with "x-", where x is the duration of the song in seconds (*127-trackname.mp3*).
1. Add the tracks to the *package.json*.
1. You can change keybindings and options in *configurations.lua*.

# Usage
- Turn the radio on and off (default "R").
- Change the channels (default "[" and "]").
- Change the volume (default "Page Up" and "Page Down").

# Planned
- 3D sounds - Currently not possible due to broken *SetSound3DLocation()*.
- Easy track installation (no filename changing) - Currently not possible due to broken *OnSoundFinished*.
- Broadcast to other clients.

# Bugs & Issues
No bugs have been reported at this time. The package has not been tested on Linux yet, if there are any problems please let me know.