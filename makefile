.PHONY: bin
bin:
	nasm -o bin/boot.img src/boot.s
	nasm -o bin/kernel.img src/kernel.s
	cat bin/boot.img bin/kernel.img > bin/main.img

vdi: bin
	qemu-img convert -p -f raw bin/main.img -O vdi bin/os.vdi
