GPPPARAMS = -m32 -fno-use-cxa-atexit -fleading-underscore  -fno-exceptions -fno-builtin -nostdlib -fno-rtti -fno-pie  //编译时需要取消g++自动添加的链接库
ASPARAMS = --32
LDPARAMS = -melf_i386 -no-pie

objects = loader.o kernel.o

%.o: %.cpp  #目标文件依赖的文件
	g++ $(GPPPARAMS) $< -c -o $@     #   $@这个符号表示目标文件名  $<这个符号表示依赖的文件   -c表示只编译不链接

%.o: %.s
	as $(ASPARAMS) $< -o $@   

mykernel.bin: linker.ld $(objects)  #生成.bin二进制文件，用linker.ld脚本将object源文件连接起来
	ld $(LDPARAMS) -T $< $(objects) -o $@  # -T指定链接脚本文件的位置， $<表示当前第一个要链接的文件  o $@表示目标文件

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
