# getting the path to the directory of the file being opened
DIR=`dirname "$@"`
# getting the name of the file being opened
FILE=`basename "$@"`
# alias for VLC executable
VLC=/Applications/VLC.app/Contents/MacOS/VLC
# setting the file directory as the working directory
cd "$DIR"
# supported file types
TYPE_3GP="3gp|3gpp"
TYPE_ASF="asf|wma|wmv"
TYPE_AVI="avi"
TYPE_DVRMS="dvr-ms"
TYPE_FLV="flv|fla|f4v|f4a|f4b|f4p"
TYPE_MKV="mkv|mk3d|mka|mks"
TYPE_MIDI="midi|mid"
TYPE_QICKTIME="mov|movie|qt"
TYPE_MP4="mp4|m4a|m4p|m4b|m4r|m4v"
TYPE_OGG="ogg|ogv|oga|ogx|ogm|spx|opus"
TYPE_WAV="wav|wave"
TYPE_MPEG2_ES="m2v|mp2|mp3|bit|mpe|mp4v|xvid|aac|mp1|mpg2|m1v|m1a|m2a|mpa|mpv"
TYPE_MPEG2_PS="mpg|mpeg|m2p|ps"
TYPE_MPEG2_TS="ts|tsv|tsa|m2t"
TYPE_PVA="pva"
TYPE_RAW_AUDIO="raw|pcm|sam"
TYPE_RAW_DV="dv|dif"
TYPE_MXF="mxf"
TYPE_AIFF="aiff|aif|aifc"
TYPE_VOB="vob|ifo|bup"
TYPE_RM="rm|rma|rmi|rmv|rmvb|rmhd|rmm|ra|ram"
TYPE_BLURAY="m2ts|mts|cpi|clpi|mpl|mpls|bdm|bdmv|bdav"
TYPE_VCD="dat"
TYPE_CDDA="cda"
TYPE_HEIF="heif|heifs|heic|heics|avci|avcs|hif"
TYPE_AVIF="avif|avifs"
TYPE_AC3="ac3"
TYPE_ALAC="caf"
TYPE_AMR="amr|3ga"
TYPE_XM="xm"
TYPE_FLAC="flac"
TYPE_IT="it"
TYPE_MOD="mod"
TYPE_MONKEY="ape"
TYPE_OPUS="opus"
TYPE_PLS="pls"
TYPE_QCP="qcp"
TYPE_SPEEX="spx"
TYPE_S3M="s3m"
TYPE_TTA="tta"
TYPE_WAVPACK="wv"
TYPES="$TYPE_3GP|$TYPE_ASF|$TYPE_AVI|$TYPE_DVRMS|$TYPE_FLV|$TYPE_MKV|$TYPE_MIDI|$TYPE_QICKTIME|$TYPE_MP4|$TYPE_OGG|$TYPE_WAV|$TYPE_MPEG2_ES|$TYPE_MPEG2_TS|$TYPE_PVA|$TYPE_AIFF|$TYPE_RAW_AUDIO|$TYPE_RAW_DV|$TYPE_MXF|$TYPE_VOB|$TYPE_RM|$TYPE_BLURAY|$TYPE_VCD|$TYPE_CDDA|$TYPE_HEIF|$TYPE_AVIF|$TYPE_AC3|$TYPE_ALAC|$TYPE_XM|$TYPE_FLAC|$TYPE_IT|$TYPE_MOD|$TYPE_MONKEY|$TYPE_OPUS|$TYPE_PLS|$TYPE_QCP|$TYPE_SPEEX|$TYPE_S3M|$TYPE_TTA|$TYPE_WAVPACK"
# getting a list of supported files in a directory (exclude subdirectories and hidden files), sort by name
FILES=`find -E "$DIR" -maxdepth 1 -type f -not -name '.*' -regex ".*.($TYPES)$" | sort -V`
# writing a list of files to a temporary text file
echo $FILES > .temp
# creating an array from the contents of a temporary file, delimited by strings
IFS=$'\n' ARR=($(<./.temp))
# cycle for 1 repetition – timeout after adding the first file for the application to load correctly
for (( i=1; i <= 1; i++ ))
do
	# adding files to a VLC playlist
	open -a $VLC $ARR[$i]
	# a short timeout to maintain the order of files in the playlist
	sleep 1
done
# loop through the remaining number of array elements - adding files without timeout
for (( i=2; i <= ${#ARR[*]}; i++ ))
do
	# adding files to a VLC playlist
	open -a $VLC $ARR[$i]
done
# search by the index line number of an array element that matches the name of the file being opened, result minus 1
INDEX=$((-1 + 10#0$(IFS=$'\n' echo "${ARR[*]}" | grep --line-number --fixed-strings -- "$FILE" | cut -f1 -d:)))
# passing the index to the clipboard (without line breaks)
echo -n $INDEX| pbcopy
# deleting a temporary text file
rm .temp