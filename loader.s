# multiboot header
.set MAGIC, 0x1badb002 #This is multiboot configuration,a magic number,it is a setted number.
.set FLAGS, (1 << 0 | 1 << 1)#it means 3,use the way of bit expression can precess easily.
.set CHECKSUM, -(MAGIC + FLAGS)# it is a check number,the three of about must plus to zero.

.section .multiboot #define a sector of multiboot,set the long datatype of the three number 
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .text
.extern _kernelMain #extern means this variable is just reference here,not define it
.extern _callConstructors
.global loader# loader is a global sign

loader:
    mov $kernel_stack, %esp #kernel stack is kernel's start stack address,move esp(stack top) to it
    call _callConstructors
    push %eax
    push %ebx
    call _kernelMain

_stop:
    cli
    hlt
    jmp _stop

.section .bss
.space 2 * 1024 * 1024
kernel_stack:
