# Generate list of sources
c_sources=$(wildcard kernel/*.c drivers/*.c)
headers=$(wildcard kernel/*.h drivers/*.h)
objs=$(c_sources:.c=.o)

IDIR=drivers
OS_IMGFILE=TingOS.flp
CC=gcc
CFLAGS?=-ffreestanding -I$(IDIR)

#clean and rebuild, run again
run: clean os-image
	./ostart.sh
	

# Default build target
all: os-image

#concatenate the bootsector file and the kernel file
os-image: boot_sect.bin kernel.bin
	cat $^ > $(OS_IMGFILE)
	./zeropad.sh $(OS_IMGFILE)

#creates kernel.bin by linking the obj files
kernel.bin: ${objs}
	ld -o $@ -Ttext 0x1000 --oformat binary $^

#create obj files from c sources
#%.o : %.c ${headers}
#	gcc -ffreestanding -c $< -o $@

#create obj files from kernel/sources
%.o : kernel/%.c
	$(CC) $(CFLAGS)-c $< -o $@ 

#create obj files from driver/sources
%.o : drivers/%.c
	$(CC) $(CFLAGS)-c $< -o $@ 

#create the boot sector binary
boot_sect.bin :
	nasm boot/boot_sector.asm -f bin -o $@ -l boot.lst

clean:
	rm -rf *.bin kernel/*.o drivers/*.o
	rm -rf boot.lst
	rm -rf $(OS_IMGFILE)


