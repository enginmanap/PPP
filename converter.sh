#!/bin/sh

if [ $# -eq 0  ]
then
    echo "Error in $0 - Invalid Argument Count"
    echo "Syntax: $0 input_file"
    echo "or"
    echo "Syntax: $0 input_file output_file"
    exit
fi

if [ $# -eq 1 ]
then
    ./ppp < $1 > output.pas
else
    ./ppp < $1 > $2
fi

echo "Conversation successful"
