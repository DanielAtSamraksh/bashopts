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


# Do arguments 
# http://stackoverflow.com/questions/17016007/bash-getopts-optional-arguments

function Usage()
{
cat <<-ENDOFMESSAGE
$0 [OPTION] test-name

options:
    -h --help        Display this message.
    -s --silent      Run silently.

    -i --int         Sample argument taking a value.

ENDOFMESSAGE
}

function GetOpts() {
    # while there still are arguments do this:
    while [ $# -gt 0 ]
    do
	# save the first argument in $@ and then shift $@
	# example before: $@ = arg1 arg2 arg3
	#         after: $opt = arg1, $@ = arg2 arg3
	opt=$1
        shift
        case ${opt} in
	    
	    # general options
            -h|--help)
                Usage
		;;
	    -s|--silent|-q|--quiet)
		# set variable to be processed later
		silent="1"
		;;
	    -i|--int)
		if [ $# -eq 0 -o "${1:0:1}" = "-" ]; then
                    Die "The ${opt} option requires an argument."
                fi
		int="$1"
		shift
		;;

	    ## unknown arguments or arguments in a special form follow

	    # unset long
	    *=)
		# Trailing = means missing argument
		Die "Unset argument ${opt1}"
		;;

	    # -- typically means end of arguments
	    --) 
		# echo "ignoring --"
		break
		;;

	    # long argument set with an equal sign
	    --*=*)
		# echo "set an argument to a value with =, separate arg from val, push both back on $@, and go through the loop again."
		opt1=`echo "${opt}" | perl -pe 's/(.+)=.+/$1/'`
		opt2=`echo "${opt}" | perl -pe 's/.+=(.+)/$1/'`
		set -- "${opt1}" "${opt2}" "$@"
                ;;

	    # unknown long argument
	    --*) 
		# We've already parsed all the valid long arguments
		Die "Invalid long argument ${opt}"
		;;

	    #  multiple arguments
	    -??*)
		# We've already checked for --*, so these are multiple
		# arguments Split them in two, push them on $@ and go
		# through the loop again. 
		echo "SPLIT SPLIT SPLIT"
		opt1=`echo "${opt}" | perl -pe 's/-(.).+/-$1/'`
		opt2=`echo "${opt}" | perl -pe 's/-.(.+)/-$1/'`
		set -- "${opt1}" "${opt2}" "$@"
		# echo "@ = $@"
		;;

	    # unknown argument
            *)
		echo "positional argument $opt"
		;;
        esac
    done 
}

GetOpts $*

# show results
echo
echo "silent = $silent"
echo "int = $int"
echo "positional arguments = $@"

