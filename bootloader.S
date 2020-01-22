	;; assemble using : as -o bootloader.o bootloader.S
	;; link using : ld -o bootloader.bin --oformat binary -e start bootloader.o
	;; 			-Ttext 0x7c00 (start with text segment at 0x7c00)
	;; emulate using: qemu-system-i368 -fda bootloader.bin
	.code16			; gas use 16 bit real mode
	.global start
start:
	movb $0x0e, %ah		; interrupt 0x0e print char
	mov $msg, %bx		; mov *msg to bh
	mov $0, %cx		; counter
print_init:
	movb (%bx), %al		; al = *msg
	inc %cx			
	cmp $20, %cx
	je loop
	int $0x10		; print char in al
	add $1, %bx
	jmp print_init
loop:
	jmp loop
msg:	 .asciz "Hello, abootloader!"
	
	.fill 510-(.-start), 1, 0 ; fill remaining 510 bytes with zeros
	.word 0xaa55		  ; mbr signature
