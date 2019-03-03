#!/bin/bash

#const. var defines
block=512
mult=1
count=0

if [ $# -ne 1 ];
then
	echo "Usage: zeropad.sh filename"
	echo "example: ./zeropad.sh TingOS.flp"
	echo "Ensure that the biinary file is of multiples of 512 Bytes."
	echo "The script pads 2 bytes of 0x0000 to the file if there are"
	echo "holes present"
	exit 1
fi

#zero padding operation
bc=$(wc -c $1 | cut -d ' ' -f 1)

while [ $bc -gt $(($mult*$block))  ]
do
	mult=$(($mult+1))
done

echo "Target : $mult x 512 bytes."

while [ $bc -lt $(($mult*$block)) ]
do
	cat blocks/1block0000 >> $1
	bc=$(wc -c $1 | cut -d ' ' -f 1)
	count=$(($count+1))
done
echo "Padded $count words (1 word = 16 bits)"
echo "$1 size is $bc bytes."
echo 
echo "done."

exit 0
