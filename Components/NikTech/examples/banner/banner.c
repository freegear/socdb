/*------------------------------------------------------------------------------------*/
#include <stdio.h>
#include "banner.h"

#define WINDOW_SIZE 81
#define LINES 15
#define ASCENT 13
static char screen[LINES][WINDOW_SIZE];

static int indx(char c)
{
	return c >= '0' && c <= '9' ? (int)c - '0'
		: isupper((int)c) ? (int)10 + c - 'A'
		: islower((int)c) ? (int)11 + 'Z' - 'A' + c - 'a'
		: -1;
}

static void banner(char *s, char *police[][62], int nl)
{
	int i, j, k, l, m;
	char *line;

	/* rince off :
	   the buffer is filled with nul characteres. */
	for (j = 0; j < nl; j++)
		for (i = 0; i < WINDOW_SIZE; i++)
			screen[j][i] = '\0';
	/* first :
	   filling the buffer with direct table output. */
	while (*s) {
		for (i = 0; i < nl; i++) {
			if ((j = indx(*s)) == -1) {
				fprintf(stderr,
					"Error: Character out of [0-9A-Za-z] range\n");
				exit(1);
			}
			line = police[j][i];
			if (strlen(line) + strlen(screen[i]) >= WINDOW_SIZE) {
				fprintf(stderr,
					"Error: Resulting size bigger than %d columns not allowed\n",
					WINDOW_SIZE - 1);
				exit(1);
			}
			strcat(screen[i], line);
			if (*(s + 1) != '\0')
				strcat(screen[i], " ");
		}
		s++;
	}
	for (m = l = -1, j = 0; j < nl; j++)
		for (i = 0; i < WINDOW_SIZE; i++)
			if (screen[j][i] == '@') {
				if (m == -1)
					m = j;
				l = j;
				break;
			}
	k = strlen(screen[0]);
	/* banner :
	   output on stdout. */
	putc('\n', stdout);
	for (j = m; j <= l; j++) {
		for (i = 0; i < (WINDOW_SIZE - k) / 2; i++)
			putc(' ', stdout);
		for (i = 0; i < k; i++)
			putc(screen[j][i], stdout);
		putc('\n', stdout);
	}
}

main()
{
	banner("MANIK",Unknown_Bold_Normal_14,15);
	banner("Demo",Unknown_Bold_Normal_14,15);
	banner("NikTech",Unknown_Bold_Normal_14,15);
}

