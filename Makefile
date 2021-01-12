build/boot.bin:
	mkdir -p build
	as --32 -o build/boot.o boot/boot.s
	ld -m elf_i386 --oformat=binary -Ttext=0x7C00 -nostartfiles -nostdlib -e boot_main -o build/boot.bin build/boot.o

build/kernel.bin:
	mkdir -p build
	g++ -m32 -ffreestanding -fno-pie -o build/kernel.o -c kernel/kernel.cpp
	ld -m elf_i386 --oformat=binary -Ttext=0x1000 -nostartfiles -nostdlib -e kernel_main -o build/kernel.bin build/kernel.o

build/os.img: build/boot.bin build/kernel.bin
	cat build/boot.bin build/kernel.bin > build/os.img

clean:
	rm -rf build

run: build/os.img
	qemu-system-i386 -no-reboot -drive file=build/os.img,index=0,media=disk,format=raw

debug: build/boot.bin
	objdump -D -m i386 -b binary -d build/boot.bin > build/boot_bin.txt
	objdump -D -m i386 -d           build/boot.o   > build/boot_o.txt

.PHONY: clean run debug
