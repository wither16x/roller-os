BUILD := build
TARGET := $(BUILD)/bin/bootloader
BOOTSECT := eltorito.asm

all: $(TARGET)

$(TARGET): $(BOOTSECT)
	@mkdir -p $(dir $@)
	@echo "[BOOTLOADER] Generating NASM binary: $@"
	@nasm -f bin -o $(TARGET) $(BOOTSECT)

clean:
	@echo "[BOOTLOADER] Cleaning"
	@rm -rf $(BUILD)

.PHONY: all clean