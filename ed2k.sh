#!/bin/bash

ED2K_FILE=/net/aMule/.aMule/ED2KLinks
TMP=/tmp/$$.tmp
TMP2=/tmp/$$.tmp2

if [ "${EDITOR}" = "" ]; then
    EDITOR=/usr/bin/vim
fi

# accept input data from editor
${EDITOR} "$TMP"

if [ -f $TMP ]; then
    while read line
    do
        # php -r "echo urldecode('${line}'.\"\n\");" >> "${TMP2}"
        php -r 'echo urldecode($argv[1]) . "\n";' -- "$line" >> "${TMP2}"
        # echo ${line}
    done < "${TMP}"
    cat ${TMP2} >> ${ED2K_FILE}

    # remove temp file
    rm -rf ${TMP}
    rm -rf ${TMP2}
fi

# php -r "echo urldecode('$@'.\"\n\");" >> ${F_NAME}
# rm -rf /tmp/tempfile.$$
exit 0

