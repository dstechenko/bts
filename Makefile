SRC_DIR   := src
BIN_DIR   := bin
BUILD_DIR := build
TOOLS_DIR := tools

OS_TARGET     := $(BIN_DIR)/dokkan.img
BOOT_TARGET   := $(BIN_DIR)/boot.bin
KERNEL_TARGET := $(BIN_DIR)/kernel.bin

TOOLCHAIN := $(TOOLS_DIR)/cross/bin/i686-elf

AS  := $(TOOLCHAIN)-as
CC  := $(TOOLCHAIN)-gcc
CXX := $(TOOLCHAIN)-g++
CPP := $(TOOLCHAIN)-cpp
LD  := $(TOOLCHAIN)-ld
OD  := $(TOOLCHAIN)-objdump

VM  := qemu-system-i386

# ASFLAGS   := --32
# CXXFLAGS  := -m32 -ffreestanding -fno-exceptions -fno-rtti -fno-pie -Wall -Wextra
# LDFLAGS   := -m elf_i386 --oformat=binary -nostartfiles -nostdlib
# VMFLAGS   := -no-reboot -drive
# ODFLAGS   := -D -m i386

ASFLAGS  :=
CXXFLAGS := -ffreestanding -fno-exceptions -fno-rtti -Wall -Wextra
LDFLAGS  := -nostdlib -lgcc
VMFLAGS  := -no-reboot -drive
ODFLAGS  := -D

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
	$(CXX) $(CXXFLAGS) -Iinclude -I$(<D) -c $< -o $@

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

cross:
	$(TOOLS_DIR)/cross.sh

.PHONY: clean run disas format cross
