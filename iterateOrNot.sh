#!/bin/bash 
# set -u
set -e
# set -x

usage() {
    cat <<EOF
$0 program arguments

Execute pragram for every argument combination. Combinations are given as single arguments contianing separating spaces. If no iteration happens, exit with an error (1). 

Examples:
 
$ $0 echo -i 'one two three' # runs: 
echo -i one 
echo -i two
echo -i three

$ $0 echo -i '1 2' -j '3 4' '5 6' # runs: 
echo -i 1 -j 3 5
echo -i 1 -j 3 6
echo -i 1 -j 4 5
echo -i 1 -j 4 6
echo -i 2 -j 3 5
echo -i 2 -j 3 6
echo -i 2 -j 4 5
echo -i 2 -j 4 6

$ $0 echo -i 1 || echo "error" $ echos error.

Calling $0 with no arguments generates this help message.
EOF
}

if [ $# -lt 1 ]; then usage; exit 0; fi
# code borrowed from http://stackoverflow.com/questions/17016007/bash-getopts-optional-arguments
function Die()
{
    echo "$*"
    exit 1
}

export recursed=

function recurse() {
    local prefix=$1
    shift
    # while there still are arguments do this:
    while [ $# -gt 0 ]
    do
	# save the first argument in $@ and then shift $@
	# example before: $@ = arg1 arg2 arg3
	#         after: $opt = arg1, $@ = arg2 arg3
	opt=$1
        shift
	# echo
	# echo "opt = $opt"
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
		    export recursed=1
		    #echo "> $prefix $v $@"
		    recurse "$prefix $v" "$@"
		done
		return 0
		;;

            *)
		prefix="$prefix $opt"
		#echo "prefix is now $prefix"
		;;

        esac
    done

    if [ ! $recursed ]; then return 1; fi

    echo $prefix

}

# call like this:

recurse "$@"

# example
# > recurse myprogram -i "one two" --letter="a b c d" "last argument"
# returns: 
# myprogram -i one --letter a last
# myprogram -i one --letter a argument
# myprogram -i one --letter b last
# myprogram -i one --letter b argument
# myprogram -i one --letter c last
# myprogram -i one --letter c argument
# myprogram -i one --letter d last
# myprogram -i one --letter d argument
# myprogram -i two --letter a last
# myprogram -i two --letter a argument
# myprogram -i two --letter b last
# myprogram -i two --letter b argument
# myprogram -i two --letter c last
# myprogram -i two --letter c argument
# myprogram -i two --letter d last
# myprogram -i two --letter d argument

