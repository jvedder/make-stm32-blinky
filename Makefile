# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2021 John Vedder

# TARGET is the name of the output files (project.bin, project.elf, project.hex, etc.)
TARGET  := blinky

# BUILD_DIR is the buid output directory. Should start with ./
BUILD_DIR := Build

# SRC_DIRS is a list of source code directories. Must be a relative path.
#SRC_DIRS  += .
SRC_DIRS  += Core/Src
SRC_DIRS  += Core/Startup
SRC_DIRS  += Drivers/STM32F0xx_HAL_Driver/Src
SRC_DIRS  += Drivers/CMSIS/Device/ST/STM32F0xx/Source

# Create list of Include directories
INC_DIRS  += Core/Inc
INC_DIRS  += Drivers/STM32F0xx_HAL_Driver/Inc
INC_DIRS  += Drivers/STM32F0xx_HAL_Driver/Inc/Legacy
INC_DIRS  += Drivers/CMSIS/Device/ST/STM32F0xx/Include
INC_DIRS  += Drivers/CMSIS/Include

# Linker script for this MCU
LDSCRIPT = STM32F030R8TX_FLASH.ld

# Compiler defines
DEFS  += DEBUG
DEFS  += USE_HAL_DRIVER
DEFS  += STM32F030x8

# Target-specific compile flags
ARCH_FLAGS  := -mthumb -mcpu=cortex-m4 -mfloat-abi=soft

# C Compiler Flasgs
CFLAGS += $(ARCH_FLAGS)
CFLAGS += -std=gnu11
CFLAGS += -g3
CFLAGS += -O0
CFLAGS += -ffunction-sections 	
CFLAGS += -fdata-sections 
CFLAGS += -fstack-usage 
CFLAGS += -Wall 
CFLAGS += -MMD 
CFLAGS += -MP
CFLAGS += $(addprefix -I,$(INC_DIRS))

# C Pre-Processor Flags
CPPFLAGS := $(addprefix -D,$(DEFS))

# Assembler Flags
ASFLAGS += $(ARCH_FLAGS)
ASFLAGS += $(CPPFLAGS)
ASFLAGS += -g3
ASFLAGS += -MMD
ASFLAGS += -MP

# Linker Flags
LDFLAGS += $(ARCH_FLAGS)
LDFLAGS += 


#
# Generally do not edit below here
#

# Create list of all source code files in the SRC_DIRS  (*.c, *.cpp , and *.s)
SRC_FILES  += $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
#SRC_FILES  += $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.cpp))
SRC_FILES  += $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.s))

# Create list of object files in the build dir -- one for each soure file.
# For example, main.c maps to build/main.c.o
OBJ_FILES := $(SRC_FILES:%=$(BUILD_DIR)/%.o)
#OBJ_FILES := $(addprefix $(BUILD_DIR)/,$(SRC_FILES:.c=.o))

# Clear the implicit built in rules
.SUFFIXES:

BIN_DIR := C:/ST/STM32CubeIDE_1.6.0/STM32CubeIDE/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.9-2020-q2-update.win32_2.0.0.202105311346/tools/bin
CC := $(BIN_DIR)/arm-none-eabi-gcc.exe

# Default action depends on target file
all: $(BUILD_DIR)/$(TARGET)
	@echo "SRC:" $(SRC_FILES)
	@echo "OBJ:" $(OBJ_FILES)
	@echo 'Build all..'

# Build target from object files
$(BUILD_DIR)/$(TARGET):$(OBJ_FILES)
	#mkdir -p $(dir $@)
	#touch $@
	#$(CC) $(OBJ_FILES) -o $@ $(LDFLAGS)
	@echo "Linker goes here:" $@

# Compile all .c into .o
$(BUILD_DIR)/%.c.o: %.c
	@echo "Compile .c into .o"
	@echo "    " $<
	@echo "    " $@
	mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

# Compile all .s into .o
$(BUILD_DIR)/%.s.o: %.s
	@echo "Compile .s into .o"
	@echo "    " $<
	@echo "    " $@
	mkdir -p $(dir $@)
	$(CC) $(LDFLAGS) $< -o $@ $(LOADLIBES) $(LDLIBS)


clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean

