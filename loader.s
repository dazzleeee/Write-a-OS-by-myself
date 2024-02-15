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
    push %eax   #eax存储这BootLoader的起始地址
    push %ebx   #ebx存储的是magicnumber
    call _kernelMain

_stop:
    cli #关掉中断
    hlt #CPU停机
    jmp _stop #保持程序运行

.section .bss # .bss存储未初始化的全局变量和静态变量，会被清零。
.space 2 * 1024 * 1024
kernel_stack:
