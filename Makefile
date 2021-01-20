BUILD_DIR := build
SRC_DIR		:= src
BIN_DIR		:= bin

OS_TARGET     := $(BIN_DIR)/dokkan.img
BOOT_TARGET   := $(BIN_DIR)/boot.bin
KERNEL_TARGET := $(BIN_DIR)/kernel.bin

AS := as
CC := gcc
LD := ld
VM := qemu-system-i386
OD := objdump

ASFLAGS := --32
CFLAGS  := -m32 -ffreestanding -fno-pie -Wall -Wextra
LDFLAGS := -m elf_i386 --oformat=binary -nostartfiles -nostdlib
VMFLAGS := -no-reboot -drive
ODFLAGS := -D -m i386

SRCS := $(shell find $(SRC_DIR) -type f -name *.cpp)
OBJS := $(SRCS:src/%.cpp=build/%.o)

$(OS_TARGET): $(BOOT_TARGET) $(KERNEL_TARGET)
	echo $(SRCS)
	echo $(OBJS)
	cat $^ > $@

$(BOOT_TARGET): $(BUILD_DIR)/boot/boot.o
	mkdir -p $(@D)
	$(LD) $(LDFLAGS) -Ttext=0x7C00 -e boot_entry $< -o $@

$(KERNEL_TARGET): $(BUILD_DIR)/boot/kernel_entry.o $(BUILD_DIR)/kernel/kernel.o $(OBJS)
	mkdir -p $(@D)
	$(LD) $(LDFLAGS) -Ttext=0x7E00 -e kernel_entry $^ -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s
	mkdir -p $(@D)
	$(AS) $(ASFLAGS) -I$(<D) $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -Iinclude -I$(<D) -c $< -o $@

clean:
	rm -rf $(BIN_DIR)
	rm -rf $(BUILD_DIR)

run: $(OS_TARGET)
	$(VM) $(VMFLAGS) file=$<,index=0,media=disk,format=raw

disas: $(BOOT_TARGET) $(KERNEL_TARGET) $(OS_TARGET)
	$(OD) $(ODFLAGS) -b binary $(BOOT_TARGET) > $(BOOT_TARGET).disas
	$(OD) $(ODFLAGS) -b binary $(KERNEL_TARGET) > $(KERNEL_TARGET).disas
	$(OD) $(ODFLAGS) -b binary $(OS_TARGET) > $(OS_TARGET).disas

format:
	find . -name *.cpp -or -name *.hpp | xargs clang-format -i --style=Google

.PHONY: clean run disas format
