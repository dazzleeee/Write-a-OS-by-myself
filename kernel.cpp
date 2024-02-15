void printf(char* str) {
    unsigned short* VideoMemory = (unsigned short*)0xb8000; // (unsigned short*) make 0xb8000 to be a address,which is the first dress of video memory.
    for (int i = 0; str[i]; i++) {
        VideoMemory[i] = (VideoMemory[i] & 0xFF00) | str[i];//VideoMemory[i] denote the data which number i ,from the start address of 0xb800.
    }
}
typedef void(*constructor)();
extern "C" constructor start_ctors;
extern "C" constructor end_ctors;

extern "C" void callConstructors(){
    for(constructor* i = &start_ctors; i != &end_ctors;i++)
        (*i)();
}

extern "C" void kernelMain(void* multiboot_structure, unsigned int magic_number) {
    printf((char*)"hello world!");
    while (1);
}
