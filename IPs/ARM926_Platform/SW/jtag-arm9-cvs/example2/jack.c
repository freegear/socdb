unsigned char * serial;

char * message = "All work and no play makes jack a dull boy.\r\n";

void SerialInit()
{
	unsigned long * gpio_config;

	gpio_config = (unsigned long *) 0x30440050;
	*gpio_config = 0xc000;

	serial = (unsigned char *) 0x305d0000;

	serial[0x0c] = 0x81;	/* enable bit rate regsisters */
	serial[0x00] = 0x5e;	/* 9600 baud */
	serial[0x04] = 0x01;
	serial[0x0c] = 0x01;	/* disable bit rate registers */
}

void SerialOut(char character)
{
#if 1
	while (serial[0x28] != 0x00)
		;
#endif
	serial[0x00] = character;
}

main()
{	
	int temp;
	char * current_character;

	SerialInit();

	while (1) {
		current_character = message;
		
		while (*current_character != 0) {
			SerialOut(*current_character);
			current_character ++;
		}
#if 1
		/* sleep for a bit */
		for (temp = 0; temp < 1000000; temp++)
			;
#endif
	}
	
}

