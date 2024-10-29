#!/bin/bash
set -x
tar_exec=$(command -v gtar)
if [ $? -ne 0 ]; then
	tar_exec=$(command -v tar)
fi

tar_options="--wildcards --ignore-case"
if [ "$(uname)" == "Darwin" ]; then
  tar_options=""
fi

set -e
echo using tar executable: $tar_exec $tar_options

cd $(dirname $0)

mkdir -p ../bin

download () {
  if [ -e $2 ]; then
    echo "  already downloaded: $2"
  else
    echo "  downloading $1"
    curl --connect-timeout 60 --retry 5 --retry-max-time 90 --retry-all-errors \
       --silent -L -# --compressed -A 'https://github.com/descriptinc/ffmpeg-ffprobe-static' -o $2 $1
  fi
}

##Special case download from archive.org for one-time download
echo 'windows x64'
echo '  downloading from gyan.dev'
download 'https://github.com/BtbN/FFmpeg-Builds/releases/download/autobuild-2024-10-23-13-03/ffmpeg-n6.1.2-9-g4571c80b40-win64-gpl-6.1.zip' win32-x64.zip
echo '  extracting'
tmpdir=$(mktemp -d)
unzip -o -d $tmpdir -j win32-x64.zip '*/bin/ffmpeg.exe' '*/bin/ffprobe.exe'
ls -lr ../bin
mv "$tmpdir/ffmpeg.exe" ../bin/ffmpeg-win32-x64
mv "$tmpdir/ffprobe.exe" ../bin/ffprobe-win32-x64
curl -fsSL 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/n6.1:/LICENSE.md'  -o ../bin/win32-x64.LICENSE
curl -fsSL 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/n6.1:/README.md'  -o ../bin/win32-x64.README

echo 'windows ia32'
echo '  downloading from github.com'
download 'https://github.com/sudo-nautilus/FFmpeg-Builds-Win32/releases/download/latest/ffmpeg-n6.0-latest-win32-gpl-6.0.zip' win32-ia32.zip
echo '  extracting'
unzip -o -d ../bin -j win32-ia32.zip '*/bin/ffmpeg.exe' '*/bin/ffprobe.exe'
mv ../bin/ffmpeg.exe ../bin/ffmpeg-win32-ia32
mv ../bin/ffprobe.exe ../bin/ffprobe-win32-ia32

echo 'linux x64'
download 'https://github.com/BtbN/FFmpeg-Builds/releases/download/autobuild-2024-10-23-13-03/ffmpeg-n6.1.2-9-g4571c80b40-linux64-gpl-6.1.tar.xz' linux-x64.tar.xz
echo '  extracting'
xzcat linux-x64.tar.xz | $tar_exec -x -C ../bin --strip-components 2 --wildcards '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-x64
mv ../bin/ffprobe ../bin/ffprobe-linux-x64
xzcat linux-x64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/LICENSE.txt' >../bin/linux-x64.LICENSE
curl -s -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/HEAD:/README.md'  -o ../bin/linux-x64.README

echo 'linux arm64'
download 'https://github.com/BtbN/FFmpeg-Builds/releases/download/autobuild-2024-10-23-13-03/ffmpeg-n6.1.2-9-g4571c80b40-linuxarm64-gpl-6.1.tar.xz' linux-arm64.tar.xz
echo '  extracting'
xzcat linux-arm64.tar.xz | $tar_exec -x -C ../bin --strip-components 2 --wildcards '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-arm64
mv ../bin/ffprobe ../bin/ffprobe-linux-arm64
xzcat linux-arm64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/LICENSE.txt' >../bin/linux-arm64.LICENSE
curl -s -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/HEAD:/README.md'  -o ../bin/linux-arm64.README

echo 'darwin x64'
download 'https://www.osxexperts.net/ffmpeg71intel.zip' ffmpeg-darwin-x64.zip
echo '  extracting'
unzip -o -d ../bin -j ffmpeg-darwin-x64.zip ffmpeg
mv ../bin/ffmpeg ../bin/ffmpeg-darwin-x64

download 'https://www.osxexperts.net/ffprobe71intel.zip' ffprobe-darwin-x64.zip
echo '  extracting'
unzip -o -d ../bin -j ffprobe-darwin-x64.zip ffprobe
mv ../bin/ffprobe ../bin/ffprobe-darwin-x64
curl -s -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/HEAD:/README.md'  -o ../bin/darwin-x64.README
curl -s -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/HEAD:/LICENSE.md'  -o ../bin/darwin-x64.LICENSE

echo 'darwin arm64'
echo '  downloading from osxexperts.net'
download 'https://www.osxexperts.net/ffmpeg611arm.zip' ffmpeg-darwin-arm64.zip
download 'https://www.osxexperts.net/ffprobe611arm.zip' ffprobe-darwin-arm64.zip
echo '  extracting'
unzip -o -d ../bin -j ffmpeg-darwin-arm64.zip ffmpeg
unzip -o -d ../bin -j ffprobe-darwin-arm64.zip ffprobe
mv ../bin/ffmpeg ../bin/ffmpeg-darwin-arm64
mv ../bin/ffprobe ../bin/ffprobe-darwin-arm64
chmod +x ../bin/ffmpeg-darwin-arm64 ../bin/ffprobe-darwin-arm64
curl -fsSL 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/n6.1:/LICENSE.md'  -o ../bin/darwin-arm64.LICENSE
curl -fsSL 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/n6.1:/README.md'  -o ../bin/darwin-arm64.README


echo 'freebsd x64'
echo '  downloading from github.com/Thefrank/ffmpeg-static-freebsd'
download 'https://github.com/Thefrank/ffmpeg-static-freebsd/releases/download/v6.1.0/ffmpeg' ../bin/freebsd-x64
chmod +x ../bin/freebsd-x64
