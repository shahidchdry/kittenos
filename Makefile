C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c libc/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h cpu/*.c libc/*.c)
OBJ = ${C_SOURCES:.c=.o cpu/interrupt.o}

# Use i686 cross-compiler
CC = i686-linux-gnu-gcc
LD = i686-linux-gnu-ld
GDB = gdb

# Crucial flags for bare-metal kernel development
CFLAGS = -g -ffreestanding -Wall -Wextra -nostdlib -fno-pic -fno-pie -m32
LDFLAGS = -nostdlib -static -m elf_i386

# First rule is run by default
# Create a 1.44MB floppy disk image and copy our code onto it
os-image.bin: boot/bootsect.bin kernel.bin
	# Create a blank 1.44MB image file
	dd if=/dev/zero of=os-image.bin bs=512 count=288
	# Copy the boot sector to the beginning of the image (Sector 1)
	dd if=boot/bootsect.bin of=os-image.bin bs=512 count=1 conv=notrunc
	# Copy the kernel right after the boot sector (Starting at Sector 2)
	dd if=kernel.bin of=os-image.bin bs=512 seek=1 conv=notrunc

kernel.bin: boot/kernel_entry.o ${OBJ}
	${LD} ${LDFLAGS} -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.elf: boot/kernel_entry.o ${OBJ}
	${LD} ${LDFLAGS} -o $@ -Ttext 0x1000 $^

run2: os-image.bin
	qemu-system-i386 -fda os-image.bin -display curses
	
# Fixed run command with explicit format and console display
run: os-image.bin
	qemu-system-x86_64 -boot order=a -drive format=raw,file=os-image.bin,if=floppy -display curses

# Alternative run command with VNC (usually works better)
run-vnc: os-image.bin
	qemu-system-x86_64 -boot order=a -drive format=raw,file=os-image.bin,if=floppy -vga std -display vnc=:0

# Simple console-only version (most reliable)
run-console: os-image.bin
	qemu-system-x86_64 -boot order=a -drive format=raw,file=os-image.bin,if=floppy -nographic -serial mon:stdio

debug: os-image.bin kernel.elf
	qemu-system-x86_64 -s -S -drive format=raw,file=os-image.bin -display curses &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -c $< -o $@

%.o: %.asm
	nasm $< -f elf32 -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o cpu/*.o libc/*.o

.PHONY: run run-vnc run-console debug clean
