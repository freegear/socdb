#define MAX_COUNT	800
#define	RED_LED		0x08000000;
#define GREEN_LED	0x00100000;

main()
{
	int count, threshold;
	unsigned long * drive_on;
	unsigned long * drive_off;
	
	drive_on = (unsigned long *) 0x30470008;
	drive_off = (unsigned long *) 0x30470010;

	*drive_off = GREEN_LED;

	/* loop for ever */
	while (1) {

		for (threshold = 0; threshold < MAX_COUNT; threshold ++) {
			*drive_off = RED_LED;

			for (count = 0; count < MAX_COUNT; count ++) {
				if (count == threshold)
					*drive_on = RED_LED;
			}
		}
			
		for (threshold = 0; threshold < MAX_COUNT; threshold ++) {
			*drive_on = RED_LED;

			for (count = 0; count < MAX_COUNT; count ++) {
				if (count == threshold)
					*drive_off = RED_LED;
			}
		}

	}
}
