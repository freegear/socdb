MEMORY
        {
        ram 	: ORIGIN = 0x00000000, LENGTH = 0x00200000
        }
 
SECTIONS
{
        .reset :
        {
        *(.reset)
	_src_beg = .;
        } > ram
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
