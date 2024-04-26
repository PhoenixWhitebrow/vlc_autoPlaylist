# getting the path to the directory of the file being opened
dir=`dirname $@`
# getting the name of the file being opened
file=`basename $@`
# alias for VLC executable
vlc=/Applications/VLC.app/Contents/MacOS/VLC
# setting the file directory as the working directory
cd $dir
# getting a list of files in a directory
files=`find "$dir" -maxdepth 1 -type f -not -name '.*' | sort -h`
# writing a list of files to a temporary text file
echo $files > .temp
# creating an array from the contents of a temporary file, delimited by strings
IFS=$'\n' arr=($(<./.temp))
# cycle for 1 repetition – timeout after adding the first file for the application to load correctly
for (( i=1; i <= 1; i++ ))
do
	# adding files to a VLC playlist
	open -a $vlc $arr[$i]
	# a short timeout to maintain the order of files in the playlist
	sleep 1
done
# loop through the remaining number of array elements - adding files without timeout
for (( i=2; i <= ${#arr[*]}; i++ ))
do
	# adding files to a VLC playlist
	open -a $vlc $arr[$i]
done
# search by the index line number of an array element that matches the name of the file being opened, result minus 1
index=$((-1 + 10#0$(IFS=$'\n' echo "${arr[*]}" | grep --line-number --fixed-strings -- "$file" | cut -f1 -d:)))
# passing the index to the clipboard (without line breaks)
echo -n $index| pbcopy
# deleting a temporary text file
rm .temp