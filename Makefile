MAKEFLAGS += --no-print-directory

BUILD := build
BOOTLOADER := bootloader

BOOTLOADER_BIN := $(BOOTLOADER)/build/bin/bootloader.bin
ISO := $(BUILD)/images/roller-os.iso

XORRISO := xorriso -as mkisofs
QEMU := qemu-system-x86_64

all: $(ISO)

$(ISO): $(BOOTLOADER)
	@echo "[Global] Generating ISO image: $(ISO)"
	@mkdir -p $(BUILD)/iso_root/boot $(dir $@)
	@cp $(BOOTLOADER_BIN) $(BUILD)/iso_root/boot/bootloader
	@$(XORRISO) -R \
		-J \
		-o $@ \
		-c boot/bootcat \
		-b boot/bootloader \
		-no-emul-boot \
		-boot-load-size 4 \
		-boot-info-table \
		--protective-msdos-label \
		$(BUILD)/iso_root

$(BOOTLOADER):
	@echo "[Global] Building bootloader"
	@$(MAKE) -C $(BOOTLOADER)

clean:
	@echo "[Global] Cleaning"
	@$(MAKE) -C $(BOOTLOADER) clean
	@rm -rf $(BUILD)

run:
	$(QEMU) -cdrom $(ISO) -m 2G

run-debug:
	$(QEMU) -cdrom $(ISO) -m 2G -d int -no-reboot

.PHONY: all clean $(BOOTLOADER) run run-debug