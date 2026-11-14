BUILD := build
TARGET := $(BUILD)/bin/bootsector.bin
BOOTSECT := eltorito.asm
LIB := ../lib/asm/real

all: $(TARGET)

$(TARGET): $(BOOTSECT)
	@mkdir -p $(dir $@)
	@echo "[Bootloader.BootSector] Generating NASM binary: $@"
	@nasm -f bin -I$(LIB) -o $(TARGET) $(BOOTSECT)

clean:
	@echo "[Bootloader.BootSector] Cleaning"
	@rm -rf $(BUILD)

.PHONY: all clean