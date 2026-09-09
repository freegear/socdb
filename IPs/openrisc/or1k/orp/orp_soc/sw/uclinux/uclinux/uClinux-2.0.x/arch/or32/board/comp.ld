MEMORY
        {
        ram     : ORIGIN = 0x01000000, LENGTH = 0x00010000
        flash   : ORIGIN = 0x04000000, LENGTH = 0x00200000
        }
 
SECTIONS
{
        .reset :
        {
        *(.reset)
        } > flash

        .text :
        {
        *(.text)
        } > flash

        .linux ALIGN(0x4):
        {
        _linux_start = .;
        *(.linux)
        _linux_end = .;
        _src_beg = .;
        } > flash

        .data :
        AT ( ADDR (.text) + SIZEOF (.text) + SIZEOF (.linux))
        {
        _dst_beg = .;
        *(.rodata)
        *(.data)
        _dst_end = .;
        } > ram

        .bss :
        {
        *(.bss)
        } > ram

        .stack  ALIGN(0x10) (NOLOAD):
        {
        *(.stack)
        } > ram
}          
