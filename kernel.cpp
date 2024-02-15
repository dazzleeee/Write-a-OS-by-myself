void printf(char* str) {
    unsigned short* VideoMemory = (unsigned short*)0xb8000; // (unsigned short*) make 0xb8000 to be a address,which is the first dress of video memory.
    for (int i = 0; str[i]; i++) {   //字符串的末尾是/0
        VideoMemory[i] = (VideoMemory[i] & 0xFF00) | str[i];     //VideoMemory[i] denote the data which number i ,from the start address of 0xb800.将显存地址与字符串进行或运算，保留字符及显示属性。
    }
}
typedef void(*constructor)(); #定义一个指向函数的指针
extern "C" constructor start_ctors; #声明一个函数指针
extern "C" constructor end_ctors;#声明一个函数指针

extern "C" void callConstructors(){     //在c++中，init（）fini（）分别会在main函数之前和之后执行，其中init（）对全局对象进行构造，执行构造函数，初始化相关内容。
    for(constructor* i = &start_ctors; i != &end_ctors;i++) //全局构造函数的指针被存储在 start_ctors 和 end_ctors 之间的数组中。这里是在遍历该数组，调用该初始化构造函数。
        (*i)();
}

extern "C" void kernelMain(void* multiboot_structure, unsigned int magic_number) { //multiboot_structure包含关于硬件、内存等信息；接收magicnumber验证是否是合法的BootLoader。
    printf((char*)"hello world!");
    while (1);
}
