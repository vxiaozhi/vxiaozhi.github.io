# x86 汇编语言

这里提供了各种十六进制机器操作码

[X86 Opcode and Instruction Reference Home](http://ref.x86asm.net/coder64.html#xCB)

这里提供了在线工具进行汇编或者反汇编

[Online x86 / x64 Assembler and Disassembler](https://defuse.ca/online-x86-assembler.htm)


## 常用机器码指令

- 0xffe0   jmp rax

  
## 反汇编

objdump反汇编常用参数

- objdump -d <file(s)>: 将代码段反汇编；
- objdump -S <file(s)>: 将代码段反汇编的同时，将反汇编代码与源代码交替显示，编译时需要使用-g参数，即需要调试信息，不需要再包含-d；
- objdump -C <file(s)>: 将C++符号名逆向解析
- objdump -l <file(s)>: 反汇编代码中插入文件名和行号
- objdump -j section -S <file(s)>: 仅反汇编指定的section

## 参考

