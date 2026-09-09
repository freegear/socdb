/*
  Translation Page Table


*/

extern _TPT;

void set_tpt(void)
{
	unsigned int *tp; // table pointer
	unsigned int  fg; // control flags
	int     i;

	// Initialize First Level Table
	tp = _TPT;
	tp &= (~0x3fff);
	
	for(i=0;i<4096;i++) {
		if(i<0x800) {
			fg = 0xc1e; // all accesable, write-back
		} // if
		else {
			fg = 0; // fault
		}

		*(tp + i<<2) = (i<<20) + fg; // 1:1 mapping
	} // for
	
	// Initialize Second Level Table
	for(i=0;i<1024;i++)
		*(tp + 4096 + i) = 0; // clear

} // set_tpt




void set_mmu(void)
{
	unsigned int domain;


	// set domain register
	domain = 0xffffffff;
	asm("mcr p15, 0, %0, c3, c0, 0"
		:
		: "r" (domain)
		: "memory");

	//



} // set_mmu
