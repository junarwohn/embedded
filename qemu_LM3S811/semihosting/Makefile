CROSS_COMPILE ?=arm-none-eabi-
CC :=$(CROSS_COMPILE)gcc
CFLAGS = -fno-common -O0 -std=gnu99 \
		-mcpu=cortex-m3 -mthumb \
		-T semi.ld -nostartfiles \

TARGET = semi.bin
all:$(TARGET)

$(TARGET):semi.c startup.c
	$(CC) $(CFLAGS) $^ -o semi.elf
	$(CROSS_COMPILE)objcopy -Obinary semi.elf semi.bin
	$(CROSS_COMPILE)objdump -S semi.elf > semi.list

qemu:$(TARGET)
	@qemu-system-arm -M ? | grep lm3s811evb > /dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	@echo
	qemu-system-arm -M lm3s811evb -semihosting -nographic -kernel semi.bin

clean:
	rm -f *.o *.bin *.elf *.list