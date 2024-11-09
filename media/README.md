Refresh the gif with:

```bash
brew install ffmpeg

ffmpeg -i input.mov -filter_complex "[0:v]setpts=PTS/4,fps=1,scale=480:-1,split[s1][s2];[s1]palettegen[p];[s2][p]paletteuse" -t 40 output.gif
```