#!/bin/bash
set -ue

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. <3

usage() {
    name=${i:-'download.sh'}
    echo "Usage: $name path/playlist.m3u path/outputdir" >&2
    exit 1
}

if [ -z "${1:+x}" ]; then
    echo "No playlist file provided." >&2
    usage
fi

if [ -z "${2+x}" ]; then
    echo "Output directory not set." >&2
    usage
fi

playlist=$1
playlistdir=$(dirname "$playlist")
outputdir=${2%/}

if [ ! -d $outputdir ]; then
	echo -e "Making folder $outputdir.\n"
	mkdir -p $outputdir
fi

outputdir=$(realpath $outputdir)

declare -i lines=$(wc -l < "$playlist")
declare -i songs=($lines-1)/2

for ((song = 1; song <= $songs; song++)); do
	songtitle="$(awk "NR==$song*2 {print}" "$playlist" | cut -d',' -f2-)"
	songtitle=${songtitle//\//-}
	#echo -e "$song/$songs\tDownloading $songtitle"
	
	songlink="$(awk "NR==$song*2+1 {print}" "$playlist")"
	if [ -f "$songlink" ]; then
        echo "$songlink exists."
    else 
        songlink="$playlistdir/$songlink"
        echo "new link $songlink"
    fi	
    cp "$songlink" "$outputdir"
done

echo -e "\nAll songs downloaded."
