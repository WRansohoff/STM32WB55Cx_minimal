TARGET = main

# Define target chip.
MCU_FILES = STM32WB55CEU6
ST_MCU_DEF = STM32WB55xx
MCU_CLASS = WB
MCU_SPEC = cortex-m4

# Toolchain definitions (ARM bare metal GCC)
TOOLCHAIN = /usr
CC = $(TOOLCHAIN)/bin/arm-none-eabi-gcc
AS = $(TOOLCHAIN)/bin/arm-none-eabi-as
LD = $(TOOLCHAIN)/bin/arm-none-eabi-ld
OC = $(TOOLCHAIN)/bin/arm-none-eabi-objcopy
OD = $(TOOLCHAIN)/bin/arm-none-eabi-objdump
OS = $(TOOLCHAIN)/bin/arm-none-eabi-size

# Assembly directives.
ASFLAGS += -c
ASFLAGS += -O0
ASFLAGS += -mcpu=$(MCU_SPEC)
ASFLAGS += -mthumb
ASFLAGS += -Wall
# (Set error messages to appear on a single line.)
ASFLAGS += -fmessage-length=0
ASFLAGS += -DVVC_$(MCU_CLASS)

# C compilation directives
CFLAGS += -mcpu=$(MCU_SPEC)
CFLAGS += -mthumb
CFLAGS += -mhard-float
CFLAGS += -mfloat-abi=hard
CFLAGS += -mfpu=fpv4-sp-d16
CFLAGS += -Wall
CFLAGS += -Os
CFLAGS += -g
CFLAGS += -fmessage-length=0
CFLAGS += -ffunction-sections
CFLAGS += -fdata-sections
CFLAGS += --specs=nosys.specs
CFLAGS += -D$(ST_MCU_DEF)
CFLAGS += -D$(MCU_FILES)
CFLAGS += -DVVC_$(MCU_CLASS)

# Linker directives.
LSCRIPT = ./ld/$(MCU_FILES).ld
LFLAGS += -mcpu=$(MCU_SPEC)
LFLAGS += -mthumb
LFLAGS += -mhard-float
LFLAGS += -mfloat-abi=hard
LFLAGS += -mfpu=fpv4-sp-d16
LFLAGS += -Wall
LFLAGS += --specs=nosys.specs
#LFLAGS += -nostdlib
LFLAGS += -lgcc
LFLAGS += -Wl,--gc-sections
LFLAGS += -T$(LSCRIPT)

AS_SRC   =  ./vector_tables/$(MCU_FILES)_vt.S
C_SRC    =  ./src/main.c
C_SRC    += ./port/rcc.c
C_SRC    += ./port/usb.c

INCLUDE  =  -I./
INCLUDE  += -I./device_headers
INCLUDE  += -I./port
INCLUDE  += -I./src

OBJS  = $(AS_SRC:.S=.o)
OBJS += $(C_SRC:.c=.o)

.PHONY: all
all: $(TARGET).bin

%.o: %.S
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $(INCLUDE) $< -o $@

$(TARGET).elf: $(OBJS)
	$(CC) $^ $(LFLAGS) -o $@

$(TARGET).bin: $(TARGET).elf
	$(OC) -S -O binary $< $@
	$(OS) $<

.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf
	rm -f $(TARGET).bin
