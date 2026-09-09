/*--------------------------------------------------------------------*/
/* Target side implementation of "manikremote" protocol. For the host */
/* side implementation see file remote-manikremote.c in gdb           */
/*--------------------------------------------------------------------*/

#include <manik_system.h>
#include <ser.h>

/* local stack */
int lstack[32] = {1}; /* prevents getting into bss */
/*
  Registered function pointers
*/
void (*extrn_fptr[6])(int *) = {0,0,0,0,0,0};
void (*timer_fptr)(int *) = 0;

/* forward declaration for functions */
void handle_sw_int(int *registers);

/* startup code */
/* all interrupts go to the swiint vector */
/* the ibase register should be changed to handle */
/* interrupts that user wants to handle */
asm (""
     "	.org 0\n"
     "	.global _start\n"
     "_start:\n"
     "	j	reset_vect\n"
     "	j	swint_vect\n"
     "	j	timer_vect\n"
     "	j	extrn_vect\n"
     "  j	buserr_vect\n"
     "reset_vect:\n"
     "	ldrpc	r0,lstack+32*4\n"
     "  movi	r1,0\n"
     "	mtsfr	psw,r1\n"
     "  swint	0x0f\n"
     );

/* bus error vector */
asm ("buserr_vect:\n"
     "	sj	swint_vect\n"
     );

/* save gprs 0-14 */
asm ("save_gpr0_14:\n"
     "	mfsfr	r15,ipc\n"
     "	str	r15,4(r0)\n"
     "	mfsfr	r15,ipc\n"
     "	str	r15,16(r0)\n"
     "	mfsfr	r15,timer\n"
     "	str	r15,20(r0)\n"
     "  mfsfr   r15,hwdbg\n"
     "	str	r15,24(r0)\n"
     "  mfsfr   r15,bp0\n"
     "	str	r15,28(r0)\n"
     "  mfsfr   r15,bp1\n"
     "	str	r15,32(r0)\n"
     "  mfsfr   r15,wp0\n"
     "	str	r15,36(r0)\n"
     "  mfsfr   r15,wp1\n"
     "	str	r15,40(r0)\n"
     "	ldr     r15,0(r0)\n"
     "	addi	r0,-60\n"
     "	str	r0,0(r0)\n"
     "	str	r1,4(r0)\n"
     "	str	r2,8(r0)\n"
     "	str	r3,12(r0)\n"
     "	str	r4,16(r0)\n"
     "	str	r5,20(r0)\n"
     "	str	r6,24(r0)\n"
     "	str	r7,28(r0)\n"
     "	str	r8,32(r0)\n"
     "	str	r9,36(r0)\n"
     "	str	r10,40(r0)\n"
     "	str	r11,44(r0)\n"
     "	str	r12,48(r0)\n"
     "	str	r13,52(r0)\n"
     "	str	r14,56(r0)\n"
     "	jsfr	ra\n"
     );
/* timer interrupt */
asm ("timer_vect:\n"
     "	addi	r0,-44\n"       
     "	str	r15,0(r0)\n"
     "	mfsfr	r15,psw\n"
     "	str	r15,8(r0)\n"
     "	mfsfr	r15,ra\n"
     "	str	r15,12(r0)\n"
     "	jl	save_gpr0_14\n"
     "	mov	r1,r0\n"
     "	jl	handle_timer_int\n"
     "	sj	crestore\n");

/* external interrupt */
asm ("extrn_vect:\n"
     "	addi	r0,-44\n"       
     "	str	r15,0(r0)\n"
     "	mfsfr	r15,psw\n"
     "	str	r15,8(r0)\n"
     "	mfsfr	r15,ra\n"
     "	str	r15,12(r0)\n"
     "	jl	save_gpr0_14\n"
     "	mov	r1,r0\n"
     "	jl	handle_extrn_int\n"
     "	sj	crestore\n");

/* software interrupt */
asm ("swint_vect:\n"
     "	addi	r0,-44\n"       
     "	str	r15,0(r0)\n"
     "	mfsfr	r15,psw\n"
     "	str	r15,8(r0)\n"
     "	mfsfr	r15,ra\n"
     "	str	r15,12(r0)\n"
     "	jl	save_gpr0_14\n"
     "  xor	r1,r1\n"
     "  mtsfr	hwdbg,r1\n"
     "	mov	r1,r0\n"
     "	jl	handle_sw_int\n"
     "	sj	crestore\n" );

/* Common restore */
asm ("crestore:\n"
     "	ldr	r1,4(r0)\n"
     "	ldr	r2,8(r0)\n"
     "	ldr	r3,12(r0)\n"
     "	ldr	r4,16(r0)\n"
     "	ldr	r5,20(r0)\n"
     "	ldr	r6,24(r0)\n"
     "	ldr	r7,28(r0)\n"
     "	ldr	r8,32(r0)\n"
     "	ldr	r9,36(r0)\n"
     "	ldr	r10,40(r0)\n"
     "	ldr	r11,44(r0)\n"
     "	ldr	r12,48(r0)\n"
     "	ldr	r13,52(r0)\n"
     "	ldr	r14,56(r0)\n"
     "	addi	r0,60\n"
     "	ldr	r15,40(r0)\n"
     "  mtsfr   wp1,r15\n"
     "	ldr	r15,36(r0)\n"
     "  mtsfr   wp0,r15\n"
     "	ldr	r15,32(r0)\n"
     "  mtsfr   bp1,r15\n"
     "	ldr	r15,28(r0)\n"
     "  mtsfr   bp0,r15\n"
     "	ldr	r15,24(r0)\n"
     "  mtsfr   hwdbg,r15\n"
     "	ldr	r15,16(r0)\n"
     "	mtsfr	ipc,r15\n"
     "	ldr	r15,12(r0)\n"
     "	mtsfr	ra,r15\n"
     "	ldr	r15,8(r0)\n"
     "	mtsfr	psw,r15\n"
     "	ldr	r15,4(r0)\n"
     "	mtsfr	ipc,r15\n"
     "	ldr	r15,0(r0)\n"
     "	addi	r0,44\n"
     "	jsfr	ipc\n"
     );

void handle_timer_int(int *registers)
{
	if (timer_fptr) timer_fptr(registers);
}

void handle_extrn_int(int *registers)
{
	int i ;
	unsigned int stat = EI0_STAT;

	for (i = 0 ; i < 6 ; i++, stat <<= 1) {
		if (registers[PSW]  & stat) {
			if (UART_IRQ == i) {
				handle_sw_int(registers);
				break;
			} else if (extrn_fptr[i]) {
				extrn_fptr[i](registers);
				break;
			}
		}
	}
}

/* get a character from the host */
static inline char get_char()
{
	return (char) ser_get();
}

/* get_short : get half word from host */
/* 2 bytes : highest order first */
static inline unsigned short get_short()
{
	unsigned short r0 = get_char(), r1;
	r1 = get_char();
	return (r0 << 8) | r1;
}

/* get_int : get word from host */
/* 4 bytes : highest order first */
static inline unsigned int get_int()
{
	unsigned int r = get_char();
	r <<= 8;
	r |= get_char();
	r <<= 8;
	r |= get_char();
	r <<= 8;
	r |= get_char();
	return r;
}

/* put_char : send a character to host */
static inline void put_char(char c)
{
	ser_put(c);
}

/* put_int : send an integer to host
   sent highest order byte first */
static void put_int(unsigned int val)
{
	put_char((val >> 24) & 0xff);
	put_char((val >> 16) & 0xff);
	put_char((val >> 8) & 0xff);
	put_char(val & 0xff);
}

/* mem_read : read memory & send it back to the host */
static void mem_read( int len, char *addr)
{
	while(len--) {
		SET_PSWBIT(BD_FLAG);
		put_char(*addr++);
		CLR_PSWBIT(BD_FLAG);
	}
}

/* mem_write : get from host & update memory */
static void mem_write( int len, char *addr)
{
	put_char('M');
	while (len--) {
		char c = get_char();
		SET_PSWBIT(II_FLAG);
		*addr++ = c;
		CLR_PSWBIT(II_FLAG);		
	}
		
}

void handle_sw_int(int *registers)
{
	unsigned short len;	
	unsigned int   addr;
	char rno;
	int done = 0;
	unsigned int psw = registers[PSW];

	/* set serial port in polled mode */
	ser_set_polled(1);

	/* software interrupt */
	if (psw & SW_FLAG) {
		/* if register interrupt service routine */
		if (((psw >> 16) & 0x0f) == 1) {
			if (registers[R1] == TIMER_IRQ) {
				registers[R1] = (unsigned int) timer_fptr;
				timer_fptr = (void *) registers[R2];
			} else if (registers[R1] == EXTRN_IRQ) {
				int xirq = registers[R3];
				registers[R1] = (unsigned int) extrn_fptr[xirq];
				extrn_fptr[xirq] = (void *) registers[R2];
			}
			goto ret_handler;
		}		
	}
	/* tell the host that we have stopped */
	put_char('X'); /* eXception happened */

	/* get commands from host and execute them */
	while(!done) {
		char cmd = get_char();
		switch (cmd) {
		case 'm': /* read memory */
		case 'M': /* write memory */
			len  = get_short();
			addr = get_int();
			if (cmd == 'm')
				mem_read(len,(char *)addr);
			else
				mem_write(len,(char *)addr);
			break;
		case 'r': /* read register */
		case 'R': /* write register */
			rno = get_char();
			if (cmd == 'r') 				
				mem_read(4,(char *)&registers[rno]);
			else
				mem_write(4,(char *)&registers[rno]);
			break;
		case 'c': /* continue */
			done = 1;
			break;
		}		
		put_char('k');
	}
 ret_handler:
	/* enable serial port interrupt so we can catch the break */
	registers[PSW] |= (IE_FLAG| (EI0_ENB << UART_IRQ));
	ser_set_polled(0);
}
