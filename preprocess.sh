#!/bin/sh

if [ $# -eq 0 -o  $# -eq 1  ]
then
    echo "Error in $0 - Invalid Argument Count"
    echo "Syntax: $0 name_to_define input_file"
    echo "or"
    echo "Syntax: $0 name_to_define input_file output_file"
    exit
fi

if [ $# -eq 2 ]
then
    ./ppp $1 < $2 > output.pas
else
    ./ppp $1 < $2 > $3
fi

echo "Processing finished."
