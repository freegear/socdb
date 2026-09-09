/*
 *  linux/arch/m68knommu/kernel/setup.c
 *
 *  Copyright (C) 1998,1999  D. Jeff Dionne <jeff@rt-control.com>
 *  Copyright (C) 1998       Kenneth Albanowski <kjahds@kjahds.com>
 *  Copyright (C) 1995       Hamish Macdonald
 */

/*
 * This file handles the architecture-dependent parts of system setup
 */

#include <linux/config.h>
#include <linux/kernel.h>
#include <linux/sched.h>
#include <linux/delay.h>
#include <linux/interrupt.h>
#include <linux/fs.h>
#include <linux/fb.h>
#include <linux/console.h>
#include <linux/genhd.h>
#include <linux/errno.h>
#include <linux/string.h>
#include <linux/major.h>

#include <asm/shglports.h>

#include <asm/setup.h>
#include <asm/irq.h>
#include <asm/machdep.h>

#ifdef CONFIG_BLK_DEV_INITRD
#include <linux/blk.h>
#include <asm/pgtable.h>
#endif

extern void register_console(void (*proc)(const char *));
/*  conswitchp               = &fb_con;*/
#ifdef CONFIG_CONSOLE
extern struct consw *conswitchp;
#ifdef CONFIG_FRAMEBUFFER
extern struct consw fb_con;
#endif
#endif
  
#ifdef CONFIG_SHGLCORE
int comm_status_led;
int comm_error_led;
int alarm_led;
struct semaphore porte_interlock = MUTEX;
#endif

unsigned long rom_length;
unsigned long memory_start;
unsigned long memory_end;
char command_line[512];
char saved_command_line[512];

/* setup some dummy routines */
static void dummy_waitbut(void)
{
}

void (*mach_sched_init) (void (*handler)(int, void *, struct pt_regs *));
/* machine dependent keyboard functions */
int (*mach_keyb_init) (void);
int (*mach_kbdrate) (struct kbd_repeat *) = NULL;
void (*mach_kbd_leds) (unsigned int) = NULL;
/* machine dependent irq functions */
void (*mach_init_IRQ) (void);
void (*(*mach_default_handler)[]) (int, void *, struct pt_regs *) = NULL;
int (*mach_request_irq) (unsigned int, void (*)(int, void *, struct pt_regs *),
                         unsigned long, const char *, void *);
int (*mach_free_irq) (unsigned int, void *);
void (*mach_enable_irq) (unsigned int) = NULL;
void (*mach_disable_irq) (unsigned int) = NULL;
int (*mach_get_irq_list) (char *) = NULL;
void (*mach_process_int) (int, struct pt_regs *) = NULL;
/* machine dependent timer functions */
unsigned long (*mach_gettimeoffset) (void);
void (*mach_gettod) (int*, int*, int*, int*, int*, int*);
int (*mach_hwclk) (int, struct hwclk_time*) = NULL;
int (*mach_set_clock_mmss) (unsigned long) = NULL;
void (*mach_mksound)( unsigned int count, unsigned int ticks );
void (*mach_reset)( void );
void (*waitbut)(void) = dummy_waitbut;
void (*mach_debug_init)(void);

extern void register_console(void (*proc)(const char *));

#define MASK_256K 0xfffc0000

#ifdef CONFIG_M68000
	#define CPU "68000"
#endif
#ifdef CONFIG_M68328
#ifdef CONFIG_UCSIMM
	#define CPU "68EZ328 DragonBallEZ"
#else
	#define CPU "68328 DragonBall"
#endif
#endif
#ifdef CONFIG_M68332
	#define CPU "68332"
#endif
#ifdef CONFIG_M68360
	#define CPU "68360"
#endif


#ifdef CONFIG_SHGLCORE

static int RAM_present(unsigned long address)
{
	unsigned int i, j;
	register int result;

	i = *((volatile unsigned char *)address);
	(*((volatile unsigned char *)address))++;
	j = *((volatile unsigned char *)address);
	result = (((i+1)&0xff) == j);
	*((volatile unsigned char *)address) = i;

	i = *((volatile unsigned char *)address);
	(*((volatile unsigned char *)address))++;
	j = *((volatile unsigned char *)address);
	result = result && (((i+1)&0xff) == j);
	*((volatile unsigned char *)address) = i;

	return result;
}


static unsigned char FLASH_MID[5];
static unsigned char FLASH_DID[5];

static void FLASH_identify_sub(void)
{
	volatile unsigned short int * address;
	volatile unsigned char * caddress;
	unsigned short int mid, did;
	
	address = (unsigned short int*)(0x005555 << 1);
	*address = 0xAAAA;
	address = (unsigned short int*)(0x002AAA << 1);
	*address = 0x5555;
	address = (unsigned short int*)(0x005555 << 1);
	*address = 0x9090;
	
	address = (unsigned short int*)(0x000000 << 1);
	mid = *address;
	if (*address != mid)
		mid = 0;
	address = (unsigned short int*)(0x000001 << 1);
	did = *address;
	if (*address != did)
		did = 0;

	*address = 0xF0F0;
	
	FLASH_MID[0] = mid & 0xff;
	FLASH_MID[1] = mid >> 8;
	FLASH_DID[0] = did & 0xff;
	FLASH_DID[1] = did >> 8;
	
	address = (unsigned short int*)(0x085555 << 1);
	*address = 0xAAAA;
	address = (unsigned short int*)(0x082AAA << 1);
	*address = 0x5555;
	address = (unsigned short int*)(0x085555 << 1);
	*address = 0x9090;
	
	address = (unsigned short int*)(0x080000 << 1);
	mid = *address;
	if (*address != mid)
		mid = 0;
	address = (unsigned short int*)(0x080001 << 1);
	did = *address;
	if (*address != did)
		did = 0;

	*address = 0xF0F0;
	
	FLASH_MID[2] = mid & 0xff;
	FLASH_MID[3] = mid >> 8;
	FLASH_DID[2] = did & 0xff;
	FLASH_DID[3] = did >> 8;

	caddress = (unsigned char*)(0x405555);
	*caddress = 0xAA;
	caddress = (unsigned char*)(0x402AAA);
	*caddress = 0x55;
	caddress = (unsigned char*)(0x405555);
	*caddress = 0x90;
	
	caddress = (unsigned char*)(0x400000);
	mid = *caddress;
	if (*caddress != mid)
		mid = 0;
	caddress = (unsigned char*)(0x400001);
	did = *caddress;
	if (*caddress != did)
		did = 0;

	*caddress = 0xF0;
	
	FLASH_MID[4] = mid & 0xff;
	FLASH_DID[4] = did & 0xff;

}

/* Identify FLASH using built-in identify ops, with for run-from-RAM idiom */
static void FLASH_identify(unsigned long memory_start)
{
	int len;

	void (*code)(void);
      
	len = (char*)&FLASH_identify-(char*)&FLASH_identify_sub;
	code = (void*)memory_start;
	memcpy(code, &FLASH_identify_sub, len);
	
	code();
}

/* Conjure up name for a specific flash part */
static void FLASH_part(int mid, int did)
{
	if (mid == 0x20) {
		/* SGS-Thompson */
		if (did == 0xE2)
			printk("ST M29F040");
		else
			printk("ST D0x%02x", did);
	} else if (mid == 0x01) {
		/* AMD */
		if (did == 0xA4)
			printk("AMD 29F040B");
		else
			printk("AMD D0x%02x", did);
	} else if ((mid == 0x00) && (did == 0x00))
		printk("Not present");
	else
		printk("M0x%02x D0x%02x", mid, did);
}

#endif /* CONFIG_SHGLCORE */

void setup_arch(char **cmdline_p,
		unsigned long * memory_start_p, unsigned long * memory_end_p)
{
	extern int _etext, _edata, _end, _ramend, _romvec, _flashend;
	

#ifdef CONFIG_68328_SERIAL
       extern void console_print_68328(const char * b);
	register_console(console_print_68328);
#endif

#ifdef CONFIG_68332_SERIAL
       extern void console_print_68332(const char * b);
	register_console(console_print_68332);
#endif

#ifdef CONFIG_SHGLCORE


	PQSPAR |= 0x70; /* Configure PCS1,2,3 as PQS4,5,6 = SBOUT, SBCLK, SBIN  */

	PORTQS = 0;
	DDRQS  |= 0x30; /* Make PQS4,5 outputs. */
	DDRQS  &= (~0x40); /* and PQS6 input.  */

	PEPAR &= (~0x4b); /* PE0,1,3,6 as outputs for all the usuall /SB chip selects. */
	DDRE  |= 0x4b;
  
	PQSPAR = 0x70;
	DDRQS = 0x30;

	PORT_QS->sbclk=0;
	PORT_E->sbirigb = 1;
	PORT_E->sbsrom = 0;

        SET_COMM_STATUS_LED(1);
        SET_COMM_ERROR_LED(1);
        SET_ALARM_LED(1);
#endif

#ifdef CONFIG_PILOT

#if 0
	*(volatile char *)0xfffff41C = 0x00; /* Port D edge-detect polarity (0=trigger on rise)*/
	*(volatile char *)0xfffff41D = 0xff; /* Port D interrupt generator */
	*(volatile char *)0xfffff41F = 0x00; /* Port D trigger (0=level, 1=edge) */
	*(volatile unsigned long *)0xfffff304 &= ~0x0000ff00; /* Unmask Port D interrupts */
#endif

#endif



	printk("\x0F\r\n\nuClinux/MC" CPU "\n");
	printk("Flat model support (C) 1998,1999 Kenneth Albanowski, D. Jeff Dionne\n");
#ifdef CONFIG_PILOT
	printk("TRG SuperPilot FLASH card support <info@trgnet.com>\n");
#endif

	memory_start = &_end;

#ifdef CONFIG_SHGLCORE

	printk("\n");
	printk("	Bank 0		Bank 1		Bank 2		Bank 3\n");
	printk("RAM	");
	
	printk( RAM_present(0x200000) ? "Present\t\t" : "Not present\t");
	printk( RAM_present(0x280001) ? "Present\t\t" : "Not present\t");
	printk( RAM_present(0x300000) ? "Present\t\t" : "Not present\t");
	printk( RAM_present(0x380001) ? "Present\n" : "Not present\n");
	
	FLASH_identify(memory_start);
	
	printk("ROM	");
	
	FLASH_part(FLASH_MID[0], FLASH_DID[0]); printk("\t");
	FLASH_part(FLASH_MID[1], FLASH_DID[1]);	printk("\t");
	FLASH_part(FLASH_MID[2], FLASH_DID[2]); printk("\t");
	FLASH_part(FLASH_MID[3], FLASH_DID[3]);	printk("\n");

	printk("FLASH	");
	
	FLASH_part(FLASH_MID[4], FLASH_DID[4]);	printk("\n");
	
	printk("\n");

#endif /* CONFIG_SHGLCORE */

	

	init_task.mm->start_code = 0;
	init_task.mm->end_code = (unsigned long) &_etext;
	init_task.mm->end_data = (unsigned long) &_edata;
	init_task.mm->brk = (unsigned long) &_end;

	ROOT_DEV = MKDEV(BLKMEM_MAJOR,0);

	command_line[512-1] = '\0';
	
	if (memcmp(command_line, "Arg!", 4))
		command_line[4] = '\0';
	
	memset(command_line, 0, 4);

	strcpy(saved_command_line, command_line+4);
	*cmdline_p = command_line+4;
	
	
#ifdef DEBUG
	if (strlen(*cmdline_p)) 
		printk("Command line: '%s'\n", *cmdline_p);
#endif

#ifdef CONFIG_PILOT_MEMORY_DISPLAY
	{
		unsigned long * mem = (memory_start + 16) & ~15;
		memcpy(mem, *(volatile unsigned long*)0xFFFFFA00, 160*160/8);
		*(volatile unsigned long*)0xFFFFFA00 = mem;
		memory_start += 4096;
	}
#endif                                
                                
	*memory_start_p = memory_start;
	*memory_end_p = memory_end = (unsigned long)&_ramend - 0x10000;
	rom_length = (unsigned long)&_flashend - (unsigned long)&_romvec;

#ifdef CONFIG_CONSOLE
#ifdef CONFIG_FRAMEBUFFER
	conswitchp = &fb_con;
#else
	conswitchp = 0;
#endif
#endif
}

int get_cpuinfo(char * buffer)
{
    char *cpu, *mmu, *fpu;
    u_long clockfreq, clockfactor;

    cpu = CPU;
    mmu = "none";
    fpu = "none";
    clockfactor = 16;

    clockfreq = loops_per_sec*clockfactor;

    return(sprintf(buffer, "CPU:\t\t%s\n"
		   "MMU:\t\t%s\n"
		   "FPU:\t\t%s\n"
		   "Clocking:\t%lu.%1luMHz\n"
		   "BogoMips:\t%lu.%02lu\n"
		   "Calibration:\t%lu loops\n",
		   cpu, mmu, fpu,
		   clockfreq/1000000,(clockfreq/100000)%10,
		   loops_per_sec/500000,(loops_per_sec/5000)%100,
		   loops_per_sec));

}

#if 0
int get_hardware_list(char *buffer)
{
    int len = 0;
    char model[80];
    u_long mem;
    int i;

    strcpy(model, "Unknown m68k");

    len += sprintf(buffer+len, "Model:\t\t%s\n", model);
    len += get_cpuinfo(buffer+len);
    len += sprintf(buffer+len, "System Memory:\t%ldK\n", mem>>10);

    return(len);
}

unsigned long arch_kbd_init(void)
{
	if (mach_keyb_init)
		return mach_keyb_init();
	else
		return 0;
}
#endif

void arch_gettod(int *year, int *mon, int *day, int *hour,
		 int *min, int *sec)
{
	*year = *mon = *day = *hour = *min = *sec = 0;
}
