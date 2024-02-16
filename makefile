GPPPARAMS = -m32 -fno-use-cxa-atexit -fleading-underscore  -fno-exceptions -fno-builtin -nostdlib -fno-rtti -fno-pie  //编译时需要取消g++自动添加的链接库
ASPARAMS = --32
LDPARAMS = -melf_i386 -no-pie

objects = loader.o kernel.o

%.o: %.cpp  #目标文件依赖的文件
	g++ $(GPPPARAMS) -o $@  -c  $<     #   $@这个符号表示目标文件名  $<这个符号表示依赖的文件   -c表示只编译不链接

%.o: %.s
	as $(ASPARAMS) -o $@  $<   

mykernel.bin: linker.ld $(objects)  #生成.bin二进制文件，用linker.ld脚本将object源文件连接起来
	ld ${LDPARAMS} -T $< -o $@ ${objects}  # -T指定链接脚本文件的位置， $<表示当前第一个要链接的文件  o $@表示目标文件

mykernel.iso: mykernel.bin   #Multiboot规范规定GRUB根据/boot/grub/grub.conf文件查找Kernel信息并加载Kernel程序，所以我们创建该文件
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp $< iso/boot/
	echo 'set timeout=0' > iso/boot/grub/grub.cfg    #conf文件中的内容，设置引导菜单的超时时间为0秒，这样引导加载器将立即引导到默认选项，而不会等待用户输入选择。
	echo 'set default=0' >> iso/boot/grub/grub.cfg   #：将默认引导项设置为第一个条目，即在菜单中指定的第一个操作系统或内核。
	echo 'menuentry "my os" {' >> iso/boot/grub/grub.cfg     #定义一个名为"my os"的菜单条目，这个条目将显示在引导菜单中。
	echo '    multiboot /boot/mykernel.bin' >> iso/boot/grub/grub.cfg   #指定要引导的内核文件路径为/boot/mykernel.bin，multiboot是GRUB加载Multiboot兼容内核的命令。
	echo '    boot' >> iso/boot/grub/grub.cfg   #boot启动
	echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=$@ iso
	rm -rf iso

clean:
	rm kernel.o loader.o mykernel.bin mykernel.iso   #清除产生的文件

install: mykernel.bin
	sudo cp $< /boot/mykernel.bin  #$<表示当前依赖的文件   cp是copy

//-m32                    # 指定编译为32位应用程序
//-fno-use-cxa-atexit     # 禁用C析构函数__cxa_atexit
//-fleading-underscore    # 编译时在C语言符号前加上下划线
//-fno-exceptions         # 禁用异常机制
//-fno-builtin            # 不使用C语言的内建函数
//-nostdlib               # 不链接系统标准启动文件和标准库文件
//-fno-rtti               # 禁用运行时类型信息
//-fno-pie                # 禁用PIE模式
