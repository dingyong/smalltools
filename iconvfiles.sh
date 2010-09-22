#!/bin/bash
CMDNAME=`basename $0`

# Function for print usage 
function print_usage()
{
    echo "Usage: $CMDNAME [-p] [-f encoding] [-t encoding] filelist" 1>&2
    echo "       -p : not output to new file , only print the preview" 1>&2
    echo "       -f : Convert characters from encoding.[default is GBK]" 1>&2
    echo "       -t : Convert characters to encoding.[default is UTF-8]" 1>&2
}

# Check the count of the parameter
if [ $# -lt 1 ]; then
    print_usage
    exit 1
fi

# Option parameters
while getopts pf:t: OPT
do
    case $OPT in
        "p" ) FLG_P="TRUE" ;;
        "f" ) FLG_F="TRUE" ; VALUE_FROM="$OPTARG" ;;
        "t" ) FLG_T="TRUE" ; VALUE_TO="$OPTARG" ;;
        *   ) print_usage ; 
            exit 1 ;;
    esac
done

# Check the source encoding
if [ ! "$FLG_F" = "TRUE" ]; then
    VALUE_FROM="GBK"
fi

# Check the to encoding
if [ ! "$FLG_T" = "TRUE" ]; then
    VALUE_TO="UTF-8"
fi

# Remove the option parameters
shift `expr $OPTIND - 1`

# Check the count of the parameters
if [ $# -lt 1 ]; then
    print_usage
    exit 1
fi

# Convert the file in the file list
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

echo "== Convert file from ${VALUE_FROM} to ${VALUE_TO} ==" 1>&2
SUCCESSED=0
FAILED=0
for arg in $@
do
    if [ -r "${arg}" ]; then # Check readable
        if [ "$FLG_P" = "TRUE" ]; then
            echo "Preview the file '${arg}'" 1>&2
            iconv -c -f ${VALUE_FROM} -t ${VALUE_TO} "${arg}"
        else
            echo "Process the file '${arg}' " 1>&2
            echo "    ==> ${arg%.*}.${VALUE_TO}.${arg##*.}" 1>&2
            iconv -c -f ${VALUE_FROM} -t ${VALUE_TO} "$arg" > "${arg%.*}.${VALUE_TO}.${arg##*.}"
        fi
        declare -i SUCCESSED=$SUCCESSED+1
    else
        declare -i FAILED=$FAILED+1
        echo "Can not read the source file '${arg}'" 1>&2
    fi
done

# restore $IFS
IFS=$SAVEIFS

echo "==============================================" 1>&2
echo "Successed : ${SUCCESSED} files" 1>&2
echo "Failed : ${FAILED} files" 1>&2

exit 0
