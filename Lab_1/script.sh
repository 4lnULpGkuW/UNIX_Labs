#!/bin/sh -e

if [ $# -ne 1 ]; then
    echo "Error: argument not found / too many arguments."
    exit 1
fi

SRC_FILE="$1"

if [ ! -f "$SRC_FILE" ]; then
    echo "Error: file '$SRC_FILE' not found."
    exit 2
fi

OUTPUT_FILE=$(awk -F': ' '/&Output:/ {print $2}' "$SRC_FILE")
OUTPUT_FILE=$(echo "$OUTPUT_FILE" | tr -d '\r')

if [ -z "$OUTPUT_FILE" ]; then
    echo "Error: &Output: <file_name> line not found."
    exit 3
fi

TMP_DIR=$(mktemp -d) || 
{ 
    echo "Error: can't create temporary directory."
    exit 4;
}

exit_handler()
{
    local rc=$?
    trap - EXIT
    rm -f -- /tmp/socket
    exit $rc
}

trap exit_handler EXIT HUP INT QUIT PIPE TERM

case "$SRC_FILE" in
    *.c)
        gcc -o \"$TMP_DIR/$OUTPUT_FILE\" \"$SRC_FILE\"
        ;;
    *.cpp)
        g++ -o \"$TMP_DIR/$OUTPUT_FILE\" \"$SRC_FILE\"
        ;;
    *.tex)
        cd \"$TMP_DIR\"
        pdflatex \"$SRC_FILE\"
        mv document.pdf $OUTPUT_FILE
        ;;
    *)
        echo "Error: file type unknown."
        exit 5
        ;;
esac

COMPILE_STATUS=$?
if [ $COMPILE_STATUS -ne 0 ]; then
    echo -e "Error: build failed.\nError code: $COMPILE_STATUS"
    exit 6
fi

if [ -f "$TMP_DIR/$OUTPUT_FILE" ]; then
    mv "$TMP_DIR/$OUTPUT_FILE" "$(dirname "$SRC_FILE")"
    echo "File '$OUTPUT_FILE' created."
else
    echo "Error: output file not found."
    exit 7
fi
