
.PHONY: setup
setup:
	# install rustc
	rustup show
	# install probe-rs
	curl --proto '=https' --tlsv1.2 -LsSf https://github.com/probe-rs/probe-rs/releases/latest/download/probe-rs-tools-installer.sh | sh
	# probe setup
	wget https://probe.rs/files/69-probe-rs.rules \
		&& sudo mv 69-probe-rs.rules /etc/udev/rules.d/ \
		&& sudo udevadm control --reload \
		&& sudo udevadm trigger

BIN := target/thumbv7em-none-eabihf/debug/microbit-v2
SRC_FILES := $(shell find src -type f)

# Rebuild bin and flash into the chip when srouce files change.
target/.flash-stamp: $(SRC_FILES) memory.x
	cargo flash
	@touch $@

.PHONY: flash
flash: target/.flash-stamp

.PHONY: gdb-server
gdb-server: $(BIN) flash
	probe-rs gdb --reset-halt

.PHONY: gdb-client
gdb-client: $(BIN)
	RUST_GDB=gdb-multiarch rust-gdb $(BIN) -ex "target remote :1337"
