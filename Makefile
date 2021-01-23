INC_DIR   := include
SRC_DIR   := src
BIN_DIR   := bin
BUILD_DIR := build
TOOLS_DIR := tools

OS_TARGET     := $(BIN_DIR)/dokkan.img
BOOT_TARGET   := $(BIN_DIR)/boot.bin
KERNEL_TARGET := $(BIN_DIR)/kernel.bin

TOOLCHAIN := $(TOOLS_DIR)/cross/bin/i686-elf

AS  := $(TOOLCHAIN)-as
CPP := $(TOOLCHAIN)-cpp
CC  := $(TOOLCHAIN)-gcc
CXX := $(TOOLCHAIN)-g++
LD  := $(CXX)
OD  := $(TOOLCHAIN)-objdump
VM  := qemu-system-i386

ASFLAGS  :=
CXXFLAGS := -g -ffreestanding -fno-exceptions -fno-rtti -Wall -Wextra -std=c++17
LDFLAGS  := -nostdlib -Wl,--oformat=binary
LDLIBS   := -lgcc
VMFLAGS  := -no-reboot -drive
ODFLAGS  := -D -m i386

SRCS := $(shell find $(SRC_DIR) -type f -name *.cpp)
OBJS := $(SRCS:src/%.cpp=build/%.o)
INCS := $(shell dir $(INC_DIR))
INCS := $(INCS:%=-I$(INC_DIR)/%)

CRTI_OBJ     := $(BUILD_DIR)/libc/crti.o
CRTBEGIN_OBJ := $(shell $(CXX) $(CXXFLAGS) -print-file-name=crtbegin.o)
CRTEND_OBJ   := $(shell $(CXX) $(CXXFLAGS) -print-file-name=crtend.o)
CRTN_OBJ     := $(BUILD_DIR)/libc/crtn.o
LINK_OBJS    := $(OBJS)

$(OS_TARGET): $(BOOT_TARGET) $(KERNEL_TARGET)
	cat $^ > $@

$(BOOT_TARGET): $(BUILD_DIR)/boot/boot.o
	mkdir -p $(@D)
	$(LD) $(LDFLAGS) -Ttext=0x7C00 -e boot_entry $< -o $@

$(KERNEL_TARGET): $(BUILD_DIR)/boot/kernel_entry.o $(LINK_OBJS)
	mkdir -p $(@D)
	$(LD) $(LDFLAGS) -Ttext=0x7E00 -e kernel_entry $^ $(LDLIBS) -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s
	mkdir -p $(@D)
	$(AS) $(ASFLAGS) -I$(<D) $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(INCS) -I$(<D) -c $< -o $@

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

.PHONY:
	clean run disas format cross
