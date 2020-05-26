###############################################################################
# Author:Valentina Bustamante
# Date:5/26/20
# Pledge:I pledge my honor that I have abided by the Stevens Honor System.
# Description:Creates a recycling bin
###############################################################################
#!/bin/bash

help_flag=0
list_flag=0
purge_flag=0
count_flags=0
script_name=`basename "$0"`

is_error=0

while getopts ":hlp" option; do
	case "$option" in 
		h) help_flag=1
			count_flags=$(( count_flags + 1 ))
			;;
		l) list_flag=1
			count_flags=$(( count_flags + 1 ))
			;;
		p) purge_flag=1
			count_flags=$(( count_flags + 1 ))
			;;
		?) printf "Error: Unknown option '%s'.\n" $OPTARG >&2
			is_error=1
			;;	
	esac
done

shift "$((OPTIND-1))"

if ( [ $count_flags -gt 1 ] || ( [ $# -gt 0 ] && [ $count_flags -gt 0 ] ) ) && [ $is_error -eq 0 ]; then
	printf "Error: Too many options enabled.\n" $OPTARG >&2
	is_error=1
fi

if [ $help_flag -eq 1 ] || [ $is_error -eq 1 ] || ( [ $# -eq 0 ] && [ $count_flags -eq 0 ] ); then
	(
	cat <<ENDOFTEXT
Usage: $script_name [-hlp] [list of files] 
   -h: Display help. 
   -l: List junked files. 
   -p: Purge all files. 
   [list of files] with no other arguments to junk those files.
ENDOFTEXT
	)
	if [ $# -eq 0 ] && [ $count_flags -eq 0 ]; then
		is_error=1
	fi
	exit $is_error
fi

#creates recycling bin if it does not exist
if [ ! -d $HOME/.junk ]; then
    mkdir -p $HOME/.junk
fi

#lists file in recycling bin
if [ $list_flag -eq 1 ]; then
	for f in $HOME/.junk; do
		file_listing=$(ls -lAF "$f" 2>/dev/null)
		echo "$file_listing"
	done
	exit 0
fi

#remove everything in recycling bin
if [ $purge_flag -eq 1 ]; then
	rm -r $HOME/.junk
	exit 0
fi

#$@ all of the things at the end of the line and go through them one at a time
#$f is each iteration
for f in $@; do

	#file_listing=$(ls -lAF "$f" 2>/dev/null)
	
	#checks if file exists
	if [ -f $HOME/junk/$f ]; then
		mv $f $HOME/.junk
	elif [ -d $HOME/junk/$f ]; then
		mv $f $HOME/.junk
	else
		echo "Warning: $f not found."
	fi
	#returns param
done


exit 0

