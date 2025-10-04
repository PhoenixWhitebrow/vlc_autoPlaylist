# getting the path to the directory of the file being opened
DIR=`realpath "$@" | sed -E "s/(.*\/).*/\1/"`
# getting the name of the file being opened
FILE=`basename "$@"`
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

# getting a list of supported files in a directory (exclude subdirectories and hidden files), sort by name, put the result to an array
mapfile -t ARR < <( find "$DIR" -maxdepth 1 -type f -not -name '.*' -regextype posix-egrep -regex ".*\.($TYPES)" | sort -V ) 

# open the files (Checkboxes 'Use only one instance when started from file manager' 
# and 'Enqueue items into playlist in one instance mode' should be turned ON 
# in the VLC → Tools → Preferences → All (Advanced Preferences) → Playlist)

# get the first file's full path by cutting the ending of a string that contains item's position in the array
F=`echo ${ARR[0]} | sed -E "s/(.*\/.*)\[.*/\1/"`
# open file
gtk-launch vlc "$F"
# a little timeout for player to load properly
sleep 0.5
# and now adding the rest of the files
for (( i=1; i < ${#ARR[@]}; i++ ))
do
  F=`echo ${ARR[i]} | sed -E "s/(.*\/.*)\[.*/\1/"`
  gtk-launch vlc "$F"
done

# get the VLC main window id
WID=`xdotool search --pid $(ps aux | grep '[/]usr/bin/vlc' | awk '{print $2}') | sort -V | head -1`
# activate and focus on the VLC window
xdotool windowactivate $WID
xdotool windowfocus $WID

# stop the playback
# xdotool key "KP_Space"

# get the line number of opened file, cut the rest of the grep output
INDEX=`printf -- '%s\n' "${ARR[@]}" | grep -n "$FILE" | cut -d : -f 1`
# press the N (Next) hotkey to reach the opened file
for (( i = 1; i < $INDEX; i++ ))
do
  xdotool key "n"
  sleep 0.25
done

# stop the playback again if the index is grater that one
#if [ $((INDEX)) -gt 0 ]; then 
#  xdotool key "KP_Space"
#fi