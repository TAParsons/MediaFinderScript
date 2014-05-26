#!/bin/bash
# play.sh git version

function play {
	echo "FILE: $playlist"
	if [ "$playlist" == "" ]; then 
		echo No files compatible!
		let fail=$fail+1
		return
	elif [ `ls -l "$playlist" | grep -c total` -eq 0 ]; then #$isfile -gt 0 
		#echo found the song!
		mpv --fs -loop=inf --no-joystick "$playlist"
	else
		cd "$playlist"
		if [ $isgif -eq 1 ]; then 
			isfile=`ls | grep -e "\.gif" -e "\.Gif" -e "\.gIf" -e "\.giF" -e "\.GIf" -e "\.GiF" -e "\.gIF" -e "\.GIF"`
		elif [ $isgif -eq -1 ]; then
			isfile=`ls | grep -e "\.gif" -e "\.Gif" -e "\.gIf" -e "\.giF" -e "\.GIf" -e "\.GiF" -e "\.gIF" -e "\.GIF" -e "\.m4a" -e "\.M4A" -e "\.mp3" -e "\.MP3" -e "\.mp4" -e "\.MP4" -e "\.ogg" -e "\.OGG" -e "\.wav" -e "\.WAV" -e "\.wma" -e "\.WMA"`
		else
			isfile=`ls | grep -e "\.m4a" -e "\.M4A" -e "\.mp3" -e "\.MP3" -e "\.mp4" -e "\.MP4" -e "\.ogg" -e "\.OGG" -e "\.wav" -e "\.WAV" -e "\.wma" -e "\.WMA"`
		fi
		if [ `echo "$isfile" | grep -c .` -gt 0 ]; then
			mpv --no-joystick *
		else
			echo No files in album compatible!
			let fail=$fail+1
		fi
	fi
}

let isgif=0
if [[ "$1" == "gif" ]]; then # || [ "$1" -eq "Gif" ] || [ "$1" -eq "gIf" ] || [ "$1" -eq "giF" ] || [ "$1" -eq "GIf" ] || [ "$1" -eq "GiF" ] || [ "$1" -eq "gIF" ] || [ "$1" == "GIF" ] ]]; then
	let isgif=1
	shift
	playlist=`locate -ieLA "$@" | grep -v ".secret" | grep -m 1 -e ~/Pictures -e ~/Videos`
elif [[ "$1" == "secretcode" ]]; then
	let isgif=-1
	shift
	playlist=`locate -ieLA "$@" | grep -e ".secret" | grep -m 1 ~/not_as_secret`
else
	playlist=`locate -ieLA "$@" | grep -v ".secret" | grep -m 1 ~/Music`
fi
let fail=0
clear
play
if [[ "$fail" -gt 0 && "$isgif" -ge 0 ]]; then
	echo Widening search to all local files...
	playlist=`locate -ieLA "$@" | grep -v ".secret" | grep -m 1 ~/`
	play
	if [[ "$fail" -gt 1 ]]; then
		echo Widening search to all files...
		playlist=`locate -ieLA "$@" | grep -v ".secret" | grep -m 1 /`
		play
		if [[ "$fail" -gt 2 ]]; then
			echo Possible matches for \"$@\":
			locate -ieLA "$@" | grep -v ".secret"
		fi
	fi
elif [[ "$fail" -gt 0 && "$isgif" -eq -1 ]]; then
	echo Possible matches for \"$@\":
	locate -ieLA "$@" | grep "not_as_secret"
fi
