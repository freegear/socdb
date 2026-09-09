MEMORY
        {
        reset 	: ORIGIN = 0x00000100, LENGTH = 0x00001f00
        ram  	: ORIGIN = 0x80000000, LENGTH = 0x00200000
        }
 
SECTIONS
{
        .reset :
        {
        *(.reset)
	_src_beg = .;
        } > reset
        .text :
	AT ( ADDR (.reset) + SIZEOF (.reset) )
        {
	_dst_beg = .;
        *(.text)
        } > ram
        .data :
	AT ( ADDR (.reset) + SIZEOF (.reset) + SIZEOF (.text))
        {
        *(.data)
	_dst_end = .;
        } > ram
        .bss :
        {
        *(.bss)
        } > ram
} 
