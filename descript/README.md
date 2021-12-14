
# ffmpeg-ffprobe-static
Descript Fork of [ffmpeg-static](https://github.com/eugeneware/ffmpeg-static) that includes `ffprobe`.

## Author / Contact:
  - [Charles Van Winkle](https://github.com/cvanwinkle)
  - [Steve Rubin](https://github.com/srubin)

## Note
- The upstream `Readme.md` applies, but anywhere you see `ffmpeg-static` it should be `ffmpeg-ffprobe-static`
  - Also, anywhere you see `ffmpeg` (the executable, i.e. `ffmpeg.exe`) assume it also means `ffprobe` (the executable) as well.

## Patches
- We patch `node_modules/@derhuerst/http-basic/` to recursively make directories

## Prerequisites
- `brew install p7zip` for `7zr`