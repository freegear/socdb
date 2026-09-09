/**************************************************************
 * 파일명 : rtc-app.c
 * 작성자 : 김충헌
 * 년월일 : 2005년 1월 14일
 *
 * 내  용 : 이 프로그램은 real time clock device driver을 open하여
 *			드라이버를 사용하기 위한 어플리케이션이다.
 *			
 *			이 소스가 있는 디렉토리의 Makefile을 참조하여
 *			컴파일 시키면 된다.
 *
 *			컴파일 하면 rtc-app 라는 실행 파일이 생긴다.
 *			커널 부팅 후 이 실행 파일을 보드상에서 실행시킨다.
 *
 *			실행 시키기 전에 MBA2410보드의 /dev/밑에 장치 파일
 *			을 만들어 주어야 한다.
 *			> mknod /dev/rtc c 10 135
 *
 *			장치 파일을 만든 후에 파일을 실행 시킨다.
 *			> ./rtc-app
 *
 **************************************************************/


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <error.h>
#include <errno.h>
#include <string.h>

/*************************************************************************
 * 매크로 정의
 *************************************************************************/
// Direction bits.
#define _IOC_NONE   0U
#define _IOC_WRITE  1U
#define _IOC_READ   2U

#define _IOC(dir,type,nr,size) (((dir)  << _IOC_DIRSHIFT) | ((type) << _IOC_TYPESHIFT) | ((nr)   << _IOC_NRSHIFT) | ((size) << _IOC_SIZESHIFT))

// used to create numbers
#define _IO(type,nr)        _IOC(_IOC_NONE,(type),(nr),0)
#define _IOR(type,nr,size)  _IOC(_IOC_READ,(type),(nr),sizeof(size))
#define _IOW(type,nr,size)  _IOC(_IOC_WRITE,(type),(nr),sizeof(size))


// ioctl command
#define RTC_AIE_ON  	_IO('p', 0x01)  /* Alarm int. enable on     */
#define RTC_AIE_OFF 	_IO('p', 0x02)  /* ... off          */
#define RTC_UIE_ON  	_IO('p', 0x03)  /* Update int. enable on    */
#define RTC_UIE_OFF 	_IO('p', 0x04)  /* ... off          */
#define RTC_PIE_ON  	_IO('p', 0x05)  /* Periodic int. enable on  */
#define RTC_PIE_OFF 	_IO('p', 0x06)  /* ... off          */
#define RTC_WIE_ON  	_IO('p', 0x0f)  /* Watchdog int. enable on  */
#define RTC_WIE_OFF 	_IO('p', 0x10)  /* ... off          */

#define RTC_ALM_SET 	_IOW('p', 0x07, struct rtc_time) /* Set alarm time  */
#define RTC_ALM_READ    _IOR('p', 0x08, struct rtc_time) /* Read alarm time */
#define RTC_RD_TIME 	_IOR('p', 0x09, struct rtc_time) /* Read RTC time   */
#define RTC_SET_TIME    _IOW('p', 0x0a, struct rtc_time) /* Set RTC time    */
#define RTC_IRQP_READ   _IOR('p', 0x0b, unsigned long)   /* Read IRQ rate   */
#define RTC_IRQP_SET    _IOW('p', 0x0c, unsigned long)   /* Set IRQ rate    */
#define RTC_EPOCH_READ  _IOR('p', 0x0d, unsigned long)   /* Read epoch      */
#define RTC_EPOCH_SET   _IOW('p', 0x0e, unsigned long)   /* Set epoch       */

#define RTC_WKALM_SET   _IOW('p', 0x0f, struct rtc_wkalrm)/* Set wakeup alarm*/
#define RTC_WKALM_RD    _IOR('p', 0x10, struct rtc_wkalrm)/* Get wakeup alarm*/


/*************************************************************************
 * 구조체 정의
 *************************************************************************/
typedef struct rtc_time {
    int tm_sec;
    int tm_min;
    int tm_hour;
    int tm_mday;
    int tm_mon;
    int tm_year;
    int tm_wday;
    int tm_yday;
    int tm_isdst;
} RTC_packet;


/*************************************************************************
 * 전역 변수 정의
 *************************************************************************/
int 		dd_fd;//디바이스 드라이버 파일 디스크립터


/*************************************************************************
 * 함수 정의
 *************************************************************************/
void Display_current_time(void);
void set_time(void);


int main(int argc, char **argv)
{

	if( (dd_fd = open("/dev/rtc", O_RDWR)) < 3) {
		fprintf(stderr, "Cannot open /dev/rtc!! %s\n", strerror(errno));
		return 0;
	}

	if(argc == 1){
		printf("program start\n");
		printf("\n\n");
		Display_current_time();
		printf("\n\n");
		set_time();
		printf("\n\n");
		Display_current_time();
		printf("\n\n");
		printf("program exit\n");
		close(dd_fd);
	}else{
		if(strcmp(argv[1], "display") == 0)	Display_current_time();
	}

	return 0;
}


void Display_current_time(void)
{
	RTC_packet	tm_c;
	 
	ioctl(dd_fd, RTC_RD_TIME, &tm_c);
	
	printf("%d년 ", tm_c.tm_year + 1900); 
	printf("%d월 ", tm_c.tm_mon); 
	printf("%d일 ", tm_c.tm_mday); 
	printf("%d시 ", tm_c.tm_hour);
	printf("%d분 ", tm_c.tm_min);
	printf("%d초 \n", tm_c.tm_sec);
}



void set_time(void)
{

	int y,M,d,h,m,s, ret;
	RTC_packet	tm_s;
	
	printf("Set time you want..\n");
	
	printf("enter year : ");
	scanf("%d", &y);	printf("\n");
	
	printf("enter month : ");
	scanf("%d", &M);	printf("\n");
	
	printf("enter day : ");
	scanf("%d", &d);	printf("\n");
	
	printf("enter hour : ");
	scanf("%d", &h);	printf("\n");
	
	printf("enter minute: ");
	scanf("%d", &m);	printf("\n");
	
	printf("enter second : ");
	scanf("%d", &s);	printf("\n");
	
	printf("%d, %d, %d, %d, %d, %d\n",
		y, M, d, h, m, s);

	y = y - 1900;
	
	tm_s.tm_year = y;
	tm_s.tm_mon = M;
	tm_s.tm_mday = d;
	tm_s.tm_hour = h;
	tm_s.tm_min = m;
	tm_s.tm_sec = s;

	ioctl(dd_fd, RTC_SET_TIME, &tm_s);
	
}

