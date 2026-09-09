/*-----------------------------------------------------------------------*/
/* ttest.c - timer test. test the timer. Requires debug module support   */
/*	     to register interrupt routine handler 			 */
/*-----------------------------------------------------------------------*/
#include <manik_system.h>
#include <sys/time.h>
#include <signal.h>

static struct itimerval tval;
static int total;
void sig_handler(int sig)
{
	printf("in sig_handler()\n");
	signal(SIGALRM, sig_handler);
}

main()
{
	signal(SIGALRM, sig_handler);
	tval.it_interval.tv_sec = 5;
	setitimer(ITIMER_REAL,&tval,NULL);

	while (1) {
		power_down();
		total += 5;
		printf("5 more seconds elapsed. Total %d\n",total);
	}
}
