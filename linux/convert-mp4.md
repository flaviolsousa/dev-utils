# Convert all \*.mp4 in directory

```sh
for i in *.mp4; do ffmpeg -n -loglevel error -i "$i" -vcodec h264 -acodec mp3 -vf scale=640:-1 "cc/${i}"; done
```
