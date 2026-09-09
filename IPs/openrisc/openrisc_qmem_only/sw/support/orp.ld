MEMORY
        {
        reset    : ORIGIN = 0x00000000, LENGTH = 0x00000200
        qmem     : ORIGIN = 0x00000200, LENGTH = 0x00001D00
        }
 
SECTIONS
{
      .reset :
        {
        *(.reset)
        } > reset

      .vectors :
        {
        _vec_start = .;
        *(.vectors)
        _vec_end = .;
        } > qmem

        .text ALIGN(0x04):
        {
        *(.text)
        } > qmem

      .rodata :
        {
        *(.rodata)
	*(.rodata.*)
        } > qmem
 
      .dummy ALIGN(0x04):
        {
        _src_beg = .;
        } > qmem
 
     .data :
        {
        _dst_beg = .;
        *(.data)
        _dst_end = .;
        } > qmem
 
      .bss :
        {
        *(.bss)
        } > qmem
 
      .stack (NOLOAD) :
        {
        _stack_saddr = .;
        *(.stack)
        _src_addr = .;
        } > qmem
}
PROVIDE(_ram_end = 0x00001ffc);	/* for stack */
