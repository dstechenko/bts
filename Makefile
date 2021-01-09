AS = as
LD = ld

BUILD_DIR = build

${BUILD_DIR}/boot.bin: ${BUILD_DIR}/boot.o
	${LD} --oformat=binary -Ttext=0x7C00 -nostartfiles -nostdlib -e boot_main $< -o $@

${BUILD_DIR}/boot.o: boot/boot.s
	mkdir -p ${dir $@}
	${AS} $< -o $@

clean:
	rm -rf ${BUILD_DIR}

start: ${BUILD_DIR}/boot.bin
	qemu-system-i386 -nographic -no-reboot -drive file=$<,index=0,media=disk,format=raw


.PHONY: clean start
