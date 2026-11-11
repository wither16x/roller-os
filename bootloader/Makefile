BOOTSECTOR := bootsector
STAGE2 := stage2
BUILD := build
BIN := $(BUILD)/bin

BOOTSECTOR_BIN := $(BOOTSECTOR)/build/bin/bootsector.bin
STAGE2_BIN := $(STAGE2)/build/bin/stage2.bin
TARGET := $(BIN)/bootloader.bin

all: $(TARGET)

$(TARGET): build
	@mkdir -p $(dir $@)
	@echo "[Bootloader] Generating binary: $@"
	@cat $(BOOTSECTOR_BIN) $(STAGE2_BIN) > $@

build:
	@echo "[Bootloader] Building boot sector"
	@$(MAKE) -C $(BOOTSECTOR)
	@echo "[Bootloader] Building stage 2"
	@$(MAKE) -C $(STAGE2)

clean:
	@echo "[Bootloader] Cleaning"
	@$(MAKE) -C $(BOOTSECTOR) clean
	@$(MAKE) -C $(STAGE2) clean
	rm -rf $(BUILD)

.PHONY: all clean