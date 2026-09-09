/*************************************************************
   C Initialize Unit
   Data Section
   BSS Section
**************************************************************/


extern unsigned char ___shadow_data[];
extern unsigned char ___data_reload[];
extern const int     ___data_size[];

extern unsigned char _edata[];
extern unsigned char _end[];

void __main()
{
	
	static int initialized;
	unsigned char * srcptr ;
	unsigned char * destptr ;
	int count ;

	/* copy shadow data to data section */
	srcptr = (char *)&___shadow_data ;
	destptr = (char *)&___data_reload ;
	count = (int)&___data_size ;
	
	
	while(count--){
		*destptr++ = *srcptr++ ;
	}
	
	/* Clear BSS */
	count = (int)_end - (int)_edata;
	if ( count != 0 ) 
	{
		do{
					_edata[count] = 0 ;		
	 }while(count--);
	}
	
}

