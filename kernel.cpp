void printf(char* str) {
    unsigned short* VideoMemory = (unsigned short*)0xb8000; // (unsigned short*) make 0xb8000 to be a address,which is the first dress of video memory.
    for (int i = 0; str[i]; i++) {   //字符串的末尾是/0
        VideoMemory[i] = (VideoMemory[i] & 0xFF00) | str[i];     //VideoMemory[i] denote the data which number i ,from the start address of 0xb800.将显存地址与字符串进行或运算，保留字符及显示属性。
    }                                                            //将要打印的字符写入地址的低16位
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


//符号表（Symbol Table）是一个记录了程序中函数、变量和其他符号名称以及其对应地址或其他信息的表格。
//在编译后的可执行文件中，符号表可以帮助调试器和链接器定位和处理各种符号。 编译后可以发现kernelmain被编译器作了些许修改。

//用这个printf函数可以实现对整块屏幕的控制:

void printf(const char *str)
{
    // screen address
    static uint16_t *VideoMemory = (uint16_t*)0xb8000;   #强制转换为16位
    static uint8_t x = 0, y = 0;   #x和y代表光标位置，屏幕是宽80字节*高25行

    for (int i = 0; str[i]; i++)
    {
        switch (str[i])
        {
            case '\n':   #换行
                y++;
                x = 0;
                break;
            default:
                VideoMemory[80 * y + x] = (VideoMemory[80 * y + x] & 0xFF00) | str[i];     #VideoMemory[80 * y + x]来访问第y行第x位
                x++;
        }

        if (x >= 80) #换行，因为超过了屏幕最大宽度
        {
            x = 0;
            y++;
        }
        if (y >= 25)  #如果超出了该屏幕所在的页面，
        {
            for (y = 0; y < 25; y++)
            {
                for (x = 0; x < 80; x++)
                    VideoMemory[i] = (VideoMemory[i] & 0xFF00) | ' ';   #将字符设置为空
            }
            x = 0;   #光标回到左上角
            y = 0;
        }
    }
}
