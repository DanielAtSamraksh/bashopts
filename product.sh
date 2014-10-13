#!/bin/bash 
# set -u
set -e
# set -x

# code borrowed from http://stackoverflow.com/questions/17016007/bash-getopts-optional-arguments
function Die()
{
    echo "$*"
    exit 1
}


function recurse() {
    local prefix=$1
    local recursed=
    shift
    # while there still are arguments do this:
    while [ $# -gt 0 ]
    do
	# save the first argument in $@ and then shift $@
	# example before: $@ = arg1 arg2 arg3
	#         after: $opt = arg1, $@ = arg2 arg3
	opt=$1
        shift
	#echo
	#echo "opt = $opt"
        case ${opt} in

	    --*=*)
		opt1=`echo "${opt}" | perl -pe 's/(.+)=.+/$1/'`
		opt2=`echo "${opt}" | perl -pe 's/.+=(.+)/$1/'`
		set -- "${opt1}" "${opt2}" "$@"
		;;

	    --*)
		prefix="$prefix $opt"
		;;
	    
	    -??*)
		# We've already checked for --*, so these are multiple
		# arguments Split them in two, push them on $@ and go
		# through the loop again. 
		opt1=`echo "${opt}" | perl -pe 's/-(.).+/-$1/'`
		opt2=`echo "${opt}" | perl -pe 's/-.(.+)/-$1/'`
		set -- "${opt1}" "${opt2}" "$@"
		# echo "@ = $@"
		;;

	    *\ *)
		#echo "blank in $opt"
		for v in $opt; do
		    #echo "> $prefix $v $@"
		    recurse "$prefix $v" "$@"
		done
		recursed=1
		break
		;;

            *)
		prefix="$prefix $opt"
		#echo "prefix is now $prefix"
		;;

        esac
    done
    if [ $recursed ]; then
	echo recursed > /dev/null
    else
	echo $prefix
    fi
}

recurse $0 "$@"

