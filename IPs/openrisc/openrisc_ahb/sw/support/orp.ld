MEMORY
        {
        reset   : ORIGIN = 0x00000000, LENGTH = 0x00000200
        ram     : ORIGIN = 0x00000200, LENGTH = 0x001ffe00
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
        } > ram

        .text ALIGN(0x04):
        {
        *(.text)
        } > ram

      .rodata :
        {
        *(.rodata)
	*(.rodata.*)
        } > ram

      .rodata ALIGN(0x04) :
		{
		_src_beg = .;
		} > ram
 
     .data ALIGN(0x04) :
        {
        _dst_beg = .;
        *(.data)
        _dst_end = .;
        } > ram
 
      .bss :
        {
        *(.bss)
        } > ram
 
      .stack (NOLOAD) :
        {
        *(.stack)
        _src_addr = .;
        } > ram

}
