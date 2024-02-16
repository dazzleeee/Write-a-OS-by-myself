ENTRY(loader)  # 程序的入口是loader标记
OUTPUT_FORMAT(elf32-i386) #输出格式为32 位 x86 架构的可执行文件
OUTPUT_ARCH(i386:i386) #x86架构

SECTIONS {
    . = 0x0100000;  # .表示当前位置，设置为0x0100000

    .text : 
    {
        *(.multiboot) #输入的.multiboot放这里
        *(.text*)  #输入的.text都会放到这个.text处
        *(.rodata)  #输入的.rodata放这里
    }

    .data :            #函数表会存储函数的地址、名称等信息。
    {
        _start_ctors = .;         #函数表的起始地址为当前地址
        KEEP(*(.init_array));        #全局对象的构造函数会被放置在.init_array 节中，程序加载内存开始执行后， 系统遍历.init_array节中的函数指针，调用全局变量的初始化函数。*表示所有文件
        KEEP(*(SORT_BY_INIT_PRIORITY(.init_array.*)));  #keep保持内容不被丢弃；SORT_BY_INIT_PRIORITY是链接器的选项，根据目标文件中的全局对象的初始化优先级确定在内存中的顺序，
        _end_ctors = .;   #函数表的终止地址为当前地址

        *(.data)
    }

    .bss :
    {
        *(.bss)
    }

    /DISCARD/ :   #这是要被抛弃的输入段
    {
        *(.fini array*)
        *(.comment)
    }
}
