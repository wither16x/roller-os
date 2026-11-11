BUILD := build
BIN_DIR := $(BUILD)/bin
TARGET := $(BUILD)/bin/stage2.bin
LIB := ../lib/asm/real

SRC := $(shell find . -name '*.asm')
BIN := $(patsubst ./%.asm,$(BIN_DIR)/%.bin,$(SRC))

all: $(TARGET)

$(TARGET): $(BIN)
	@mkdir -p $(dir $@)
	@echo "[Bootloader.Stage2] Generating binary: $@"
	@cat $< > $@

$(BIN_DIR)/%.bin: ./%.asm
	@mkdir -p $(dir $@)
	@echo "[Bootloader.Stage2] Generating NASM binary: $@"
	@nasm -f bin -I$(LIB) -o $@ $<

clean:
	@echo "[Bootloader] Cleaning"
	@rm -rf $(BUILD)

.PHONY: all clean