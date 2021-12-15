#!/bin/bash
set -e
cd $(dirname $0)

set +e
tar_exec=$(command -v gtar)
if [ $? -ne 0 ]; then
	tar_exec=$(command -v tar)
fi

tar_options="--wildcards --ignore-case"
if [ "$(uname)" == "Darwin" ]; then
  tar_options=""
fi

set -e
echo using tar executable at $tar_exec $tar_options

mkdir -p ../bin

download () {
	curl -L -# --compressed -A 'https://github.com/eugeneware/ffmpeg-static build script' -o $2 $1
}

echo 'windows x64'
echo '  downloading from gyan.dev'
download 'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.7z' win32-x64.7z
echo '  extracting'
tmpdir=$(mktemp -d)
7zr e -y -bd -o"$tmpdir" win32-x64.7z >/dev/null
mv "$tmpdir/ffmpeg.exe" ../bin/ffmpeg-win32-x64
mv "$tmpdir/ffprobe.exe" ../bin/ffprobe-win32-x64
mv "$tmpdir/LICENSE" ../bin/win32-x64.LICENSE
mv "$tmpdir/README.txt" ../bin/win32-x64.README

echo 'windows ia32'
echo '  downloading from github.com'
download 'https://github.com/sudo-nautilus/FFmpeg-Builds-Win32/releases/download/autobuild-2021-12-14-12-30/ffmpeg-n4.4.1-2-gcc33e73618-win32-gpl-4.4.zip' win32-ia32.zip
echo '  extracting'
unzip -o -d ../bin -j win32-ia32.zip '*/bin/ffmpeg.exe'
mv ../bin/ffmpeg.exe ../bin/ffmpeg-win32-ia32
unzip -o -d ../bin -j win32-ia32.zip '*/bin/ffprobe.exe'
mv ../bin/ffprobe.exe ../bin/ffprobe-win32-ia32
curl -s -L 'https://raw.githubusercontent.com/sudo-nautilus/FFmpeg-Builds-Win32/master/LICENSE' -o ../bin/win32-ia32.LICENSE

echo 'linux x64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz' linux-x64.tar.xz
echo '  extracting'
xzcat linux-x64.tar.xz | $tar_exec -x -C ../bin --strip-components 1 $tar_options '*/ffmpeg'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-x64
xzcat linux-x64.tar.xz | $tar_exec -x -C ../bin --strip-components 1 $tar_options '*/ffprobe'
mv ../bin/ffprobe ../bin/ffprobe-linux-x64
xzcat linux-x64.tar.xz | $tar_exec -x $tar_options -O '**/GPLv3.txt' >../bin/linux-x64.LICENSE
xzcat linux-x64.tar.xz | $tar_exec -x $tar_options -O '**/readme.txt' >../bin/linux-x64.README

echo 'linux ia32'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-i686-static.tar.xz' linux-ia32.tar.xz
echo '  extracting'
xzcat linux-ia32.tar.xz | $tar_exec -x -C ../bin --strip-components 1 $tar_options '*/ffmpeg'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-ia32
xzcat linux-ia32.tar.xz | $tar_exec -x -C ../bin --strip-components 1 $tar_options '*/ffprobe'
mv ../bin/ffprobe ../bin/ffprobe-linux-ia32
xzcat linux-ia32.tar.xz | $tar_exec -x $tar_options -O '**/GPLv3.txt' >../bin/linux-ia32.LICENSE
xzcat linux-ia32.tar.xz | $tar_exec -x $tar_options -O '**/readme.txt' >../bin/linux-ia32.README

echo 'linux arm'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-static.tar.xz' linux-arm.tar.xz
echo '  extracting'
xzcat linux-arm.tar.xz | $tar_exec -x -C ../bin --strip-components 1 $tar_options '*/ffmpeg'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-arm
xzcat linux-arm.tar.xz | $tar_exec -x -C ../bin --strip-components 1 $tar_options '*/ffprobe'
mv ../bin/ffprobe ../bin/ffprobe-linux-arm
xzcat linux-arm.tar.xz | $tar_exec -x $tar_options -O '**/GPLv3.txt' >../bin/linux-arm.LICENSE
xzcat linux-arm.tar.xz | $tar_exec -x $tar_options -O '**/readme.txt' >../bin/linux-arm.README

echo 'linux arm64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz' linux-arm64.tar.xz
echo '  extracting'
xzcat linux-arm64.tar.xz | $tar_exec -x -C ../bin --strip-components 1 $tar_options '*/ffmpeg'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-arm64
xzcat linux-arm64.tar.xz | $tar_exec -x -C ../bin --strip-components 1 $tar_options '*/ffprobe'
mv ../bin/ffprobe ../bin/ffprobe-linux-arm64
xzcat linux-arm64.tar.xz | $tar_exec -x $tar_options -O '**/GPLv3.txt' >../bin/linux-arm64.LICENSE
xzcat linux-arm64.tar.xz | $tar_exec -x $tar_options -O '**/readme.txt' >../bin/linux-arm64.README

echo 'darwin x64'
echo '  downloading from evermeet.cx'
download 'https://evermeet.cx/ffmpeg/getrelease/ffmpeg/zip' darwin-x64.zip
echo '  extracting'
unzip -o -d ../bin -j darwin-x64.zip ffmpeg
mv ../bin/ffmpeg ../bin/ffmpeg-darwin-x64
download 'https://evermeet.cx/ffmpeg/getrelease/ffprobe/zip' darwin-x64-ffprobe.zip
unzip -o -d ../bin -j darwin-x64-ffprobe.zip ffprobe
mv ../bin/ffprobe ../bin/ffprobe-darwin-x64
curl -s -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/HEAD:/LICENSE.md'  -o ../bin/darwin-x64.LICENSE
curl -s -L 'https://evermeet.cx/ffmpeg/info/ffmpeg/release' | jq --tab '.' >../bin/darwin-x64.README

echo 'darwin arm64'
echo '  downloading from osxexperts.net'
download 'https://www.osxexperts.net/ffmpeg44arm.zip' darwin-arm64.zip
echo '  extracting'
unzip -o -d ../bin -j darwin-arm64.zip ffmpeg
mv ../bin/ffmpeg ../bin/ffmpeg-darwin-arm64
# ffprobe doesn't exist at osxexperts.net
#download 'https://www.osxexperts.net/ffmpeg44arm.zip' darwin-arm64-ffprobe.zip
#unzip -o -d ../bin -j darwin-arm64-ffprobe.zip ffprobe
#mv ../bin/ffprobe ../bin/ffprobe-darwin-arm64
curl -s -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/HEAD:/LICENSE.md'  -o ../bin/darwin-arm64.LICENSE
curl -s -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/HEAD:/README.md'  -o ../bin/darwin-arm64.README

echo 'freebsd x64'
echo '  downloading from github.com/Thefrank/ffmpeg-static-freebsd'
download 'https://github.com/Thefrank/ffmpeg-static-freebsd/releases/download/v4.4/ffmpeg' ../bin/ffmpeg-freebsd-x64
chmod +x ../bin/ffmpeg-freebsd-x64
download 'https://github.com/Thefrank/ffmpeg-static-freebsd/releases/download/v4.4/ffprobe' ../bin/ffprobe-freebsd-x64
chmod +x ../bin/ffprobe-freebsd-x64
