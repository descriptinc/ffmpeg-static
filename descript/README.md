
# ffmpeg-ffprobe-static
Descript Fork of [ffmpeg-static](https://github.com/eugeneware/ffmpeg-static) that includes `ffprobe`.

## Author / Contact:
  - [Charles Van Winkle](https://github.com/cvanwinkle)
  - [Steve Rubin](https://github.com/srubin)
  - [Marcello Bastéa-Forte](https://github.com/marcello3d)
## Note
- The upstream `Readme.md` applies, but anywhere you see `ffmpeg-static` it should be `ffmpeg-ffprobe-static`
  - Also, anywhere you see `ffmpeg` (the executable, i.e. `ffmpeg.exe`) assume it also means `ffprobe` (the executable) as well.

## Modifications to `ffprobe-static`:
- `.github/workflows/release-binaries.yml` is modified to
  - .
- `build/index.sh` is modified to
  - be runnable on macOS (for local testing)
    - required modifications to `tar` arguments
  - download `ffprobe` in addition to `ffmpeg`
- `install.js`
  - download both `ffmpeg` and `ffprobe`
  - allow for an environment-based override of the download URL
    - this is used on our Linux server
  - Don't call `exit()` if the `LICENSE` or `README` file is not downloaded

## Patches
- We patch `node_modules/@derhuerst/http-basic/` to recursively make directories

## Testing
- `node install`
- Run `build/index.sh`
  - Prerequisites on macOS:
    - you'll need the following utilities for certain downloads
      - `brew install p7zip` for `7zr`
      - `brew install jq` for `jq`

## To make a release
- Push a tag which starts with `b` (e.g. `b4.4.0-rc.17`) which triggers `release-binaries.yml`

