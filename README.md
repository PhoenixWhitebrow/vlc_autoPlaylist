# vlc_autoPlaylist
This is a script to automatically add all files in the parent directory of the opened file to a VLC playlist

This script is intended for use on macOS and is implemented as an Automator-made application so that it can be set as the default application for desired file types with '⌘command + i' ⇨ 'Open with:' ⇨ 'Change All…'. 

An Automator application is composed of two sequential actions: executing a Bash script, then executing an AppleScript. The absolute location of the file being opened is used as an argument to the Bash script. 
<img width="1680" alt="Automator" src="https://github.com/PhoenixWhitebrow/vlc_autoPlaylist/assets/85649316/80a2e0c4-b218-4cda-83af-7b63735c697a">

The Bash script gets a list of files in the parent directory of the file being opened, creates a temporary hidden file in it and writes a list of file names to it. The script then adds the contents of the temporary file to the array line by line, each line becoming an element of the array.
Next, the cycle of adding array elements corresponding to file names to the VLC playlist starts. After adding the first file to the playlist, there is a pause so that VLC has time to start and subsequent additions of files to the playlist lead to the correct order of the files in the playlist.
After this, the index of the array element corresponding to the name of the file being opened is searched. 1 is subtracted from the index, and the resulting value is copied to the clipboard.
The last action of the Bash script is to delete the temporary hidden file. 

AppleScript is used to highlight in the playlist the file that was opened using the Automator-made application. For this feature to work, the application must be granted access to the Accessibility features in the System Preferences ⇨ Security & Privacy ⇨ Privacy tab.
<img width="669" alt="Accessibility" src="https://github.com/PhoenixWhitebrow/vlc_autoPlaylist/assets/85649316/dd72b74a-f9c9-4424-8099-9aabe0e4243b">

After executing the Bash script, the VLC playlist window remains in focus on the screen, with the cursor in the search field. AppleScript emulates pressing the tab key to move the cursor to the first list item of files in a playlist.
Next, the script declares the variable 'i', which will be used further in the loop as the number of repetitions, and sets its value to the contents of the clipboard, which at that moment contains the index of the file being opened in the playlist minus 1.
Next, a cycle of emulation of pressing the down arrow key occurs, leading to the cursor moving to the playlist element corresponding to the initially opened file.
Finally, the script emulates pressing the return and space keys in rapid succession.

Expected result: VLC is open, the playlist contains all files from the parent directory of the initially opened file, the initially opened file is started and paused.

Plans for improvement:
1. Add a filter by file type to prevent non-media files from getting into the playlist;
2. Work on a solution for Linux.
3. Deal with a specific bug when used with the Remote Mouse app from http://remotemouse.net/ (the application starts twice when double-tapping, which leads to the script not working correctly).
