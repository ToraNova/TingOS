#!/bin/bash

#compile script for tingOS v1

if [ $# -ne 0 ];
then
	exit 1
fi

#rawnames
bootsectName="boot_sector"
kernel="kernel"

#input file declares
bootsectAsm="boot/$bootsectName"
kernelSrc="kernel/$kernel"

#output file declares
os_imgName="tingOS"
boots_binf="bin/$boot_sector"
kerne_binf="bin/$kernel"

kernelOffset="0x1000"

echo "Compiling sources..."

nasm $bootsectAsm.asm -f bin -o $boots_binf.bin -l $boots_binf.lst
gcc -ffreestanding -c $kernelSrc.c -o $kerne_binf.o
ld -o $kerne_binf.bin -Ttext $kernelOffset --oformat binary $kerne_binf.o
cat $boots_binf.bin $kerne_binf.bin > $os_imgName.flp

#zero padding
bc=$(wc -c $os_imgName.flp | cut -d ' ' -f 1)
block=512
mult=1
count=0

while [ $bc -gt $(($mult*$block))  ]
do
	mult=$(($mult+1))
done

echo "Target : $mult x 512 bytes."

while [ $bc -lt $(($mult*$block)) ]
do
	cat blocks/1block0000 >> $os_imgName.flp
	bc=$(wc -c $os_imgName.flp | cut -d ' ' -f 1)
	count=$(($count+1))
done
echo "Padded $count words (1 word = 16 bits)"
echo "$os_imgName size is $bc bytes."
echo 
echo "done."

exit 0
