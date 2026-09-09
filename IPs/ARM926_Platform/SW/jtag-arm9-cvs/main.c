#include <stdio.h>
#include <stdlib.h>

#include "jtag.h"
#include "parse.h"

char input_line[128];

int main(void)
{
	printf("Jtag-Arm9 - JTAG interface to the ARM9\n");
	printf("by Simon Wood. July 2001\n\n");

	if (jtag_init())
		return(-1);

	jtag_reset(0, 0);

	while (1) {
		printf("Jtag:>");
		fgets(input_line, sizeof(input_line), stdin);

		parse_main(input_line);
	}

	exit(0);
}
