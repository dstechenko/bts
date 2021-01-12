AS = as
LD = ld

BUILD_DIR = build

${BUILD_DIR}/boot.bin: ${BUILD_DIR}/boot.o
	${LD} -m elf_i386 --oformat=binary -Ttext=0x7C00 -nostartfiles -nostdlib -e boot_main $< -o $@

${BUILD_DIR}/boot.o: boot/boot.s
	mkdir -p ${dir $@}
	${AS} --32 $< -o $@

clean:
	rm -rf ${BUILD_DIR}

start: ${BUILD_DIR}/boot.bin
	qemu-system-i386 -no-reboot -drive file=$<,index=0,media=disk,format=raw

debug: ${BUILD_DIR}/boot.bin ${BUILD_DIR}/boot.o
	objdump -D -m i386 -b binary -d ${BUILD_DIR}/boot.bin > ${BUILD_DIR}/boot_bin.txt
	objdump -D -m i386 -d ${BUILD_DIR}/boot.o > ${BUILD_DIR}/boot_o.txt


.PHONY: clean start debug
