/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define MAKE_GPIO_CON(x)	\
			(((x) << SHIFT_DN_FROM_MASK(GPIO_0))	\
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_1)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_2)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_3)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_4)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_5)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_6)) \
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_7)))
#define GPIO0_GPIO_OUTPUT_MODE	MAKE_GPIO_CON(2)
#define GPIO1_GPIO_OUTPUT_MODE	MAKE_GPIO_CON(1)
#define GPIO2_GPIO_OUTPUT_MODE	MAKE_GPIO_CON(3)
#define GPIO3_GPIO_OUTPUT_MODE	MAKE_GPIO_CON(1)

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */


void GPIO_EXINT(void);
void GPIOTIMERSET(void);
void GPIOOUTTEST(void);
void GPIOOUTTEST2(void);
void GPIOINTEST(void);
void TIMER_INTERRUPT_TEST(void);
void GPIOOUT_HANDLER(smtUint32 IRQ);
void GPIOOUT2_HANDLER(smtUint32 IRQ);

void GPIOIN_HANDLER(smtUint32 IRQ);
void TCLKTEST(void);
void TCAPTEST(void);
void TIMER0_HANDLER(smtUint32 IRQ);
void TIMER1_HANDLER(smtUint32 IRQ);
void TIMER2_HANDLER(smtUint32 IRQ);
void TIMER3_HANDLER(smtUint32 IRQ);
void TIMER4_HANDLER(smtUint32 IRQ);
void TIMER5_HANDLER(smtUint32 IRQ);
void TIMER6_HANDLER(smtUint32 IRQ);
void TIMER7_HANDLER(smtUint32 IRQ);
void EINT0_HANDLER(smtUint32 IRQ);
void EINT1_HANDLER(smtUint32 IRQ);
void EINT2_HANDLER(smtUint32 IRQ);
void EINT3_HANDLER(smtUint32 IRQ);
void EINT4_HANDLER(smtUint32 IRQ);
void EINT5_HANDLER(smtUint32 IRQ);
void EINT6_HANDLER(smtUint32 IRQ);
void EINT7_HANDLER(smtUint32 IRQ);
void TCLKTEST0_HANDLER(smtUint32 IRQ);
void TCLKTEST1_HANDLER(smtUint32 IRQ);
void TCLKTEST2_HANDLER(smtUint32 IRQ);
void TCLKTEST3_HANDLER(smtUint32 IRQ);
void TCLKTEST4_HANDLER(smtUint32 IRQ);
void TCAPTEST0_HANDLER(smtUint32 IRQ);
void TCAPTEST1_HANDLER(smtUint32 IRQ);
void TCAPTEST2_HANDLER(smtUint32 IRQ);
void TCAPTEST3_HANDLER(smtUint32 IRQ);
void TCAPTEST4_HANDLER(smtUint32 IRQ);
void TCAPTEST5_HANDLER(smtUint32 IRQ);
void TCAPTEST6_HANDLER(smtUint32 IRQ);
void TCAPTEST7_HANDLER(smtUint32 IRQ);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
volatile int TIMECNT; // FND TEST GLOBAL VALIABLE
/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*-----------------------------------------------------------------------
    Function name   : GPIO_EXINT()
    Prototype           : void GPIO_EXINT(void)
    Return              : void
    Argument        :
    Comments        :GPIO External interrupt test function
-----------------------------------------------------------------------*/
void GPIO_EXINT(void) //GPIO0 EINT MODE TEST
{
    
    smtDelay100us(100);// gpio interrupt interval time
    RequestIRQ(IRQ_EINT0, EINT0_HANDLER );// EINT[0] Interrupt handler set
    RequestIRQ(IRQ_EINT1, EINT1_HANDLER );// EINT[1] Interrupt handler set
    RequestIRQ(IRQ_EINT2, EINT2_HANDLER );// EINT[2] Interrupt handler set
    RequestIRQ(IRQ_EINT3, EINT3_HANDLER );// EINT[3] Interrupt handler set
    RequestIRQ(IRQ_EINT4, EINT4_HANDLER );// EINT[4] Interrupt handler set
    RequestIRQ(IRQ_EINT5, EINT5_HANDLER );// EINT[5] Interrupt handler set
    RequestIRQ(IRQ_EINT6, EINT6_HANDLER );// EINT[6] Interrupt handler set
    RequestIRQ(IRQ_EINT7, EINT7_HANDLER );// EINT[7] Interrupt handler set
    
    SMT_WRITE(GPIO_CON0,0x0000);// EINT MODE 
    UART_printf("Press Any Key : END EINT TEST \n\r");
    UART_getch();
    
    ReleaseIRQ(IRQ_EINT0);
    ReleaseIRQ(IRQ_EINT1);
    ReleaseIRQ(IRQ_EINT2);
    ReleaseIRQ(IRQ_EINT3);
    ReleaseIRQ(IRQ_EINT4);
    ReleaseIRQ(IRQ_EINT5);
    ReleaseIRQ(IRQ_EINT6);
    ReleaseIRQ(IRQ_EINT7);
}
/*-----------------------------------------------------------------------
    Function name   : GPIOOUTTEST2()
    Prototype           : void GPIOOUTTEST2(void)
    Return              : void
    Argument        :
    Comments        :GPIO OUTPUT TEST MODE2 (ALL HIGH -> ALL LOW -> SHIFT)
-----------------------------------------------------------------------*/
void GPIOOUTTEST2(void)
{
    SMT_WRITE(GPIO_CON0,GPIO0_GPIO_OUTPUT_MODE);
    SMT_WRITE(GPIO_CON1,GPIO1_GPIO_OUTPUT_MODE);
    SMT_WRITE(GPIO_CON2,GPIO2_GPIO_OUTPUT_MODE);
    SMT_WRITE(GPIO_CON3,GPIO3_GPIO_OUTPUT_MODE|0xf000); // all gpio output
    
    SMT_WRITE(GPIO_DAT0,0xff);
    SMT_WRITE(GPIO_DAT1,0xff);
    SMT_WRITE(GPIO_DAT2,0xff);
    SMT_WRITE(GPIO_DAT3,0xff);
    
    UART_printf("All GPIO HIGH\n\r ");
    UART_printf("Press Any key : next STEP\n\r ");
    UART_getch();
    
    SMT_WRITE(GPIO_DAT0,0x00);
    SMT_WRITE(GPIO_DAT1,0x00);
    SMT_WRITE(GPIO_DAT2,0x00);
    SMT_WRITE(GPIO_DAT3,0x00);
    
    UART_printf("All GPIO LOW\n\r ");
    UART_printf("Press Any key : next STEP\n\r");
    UART_getch();
    
    // shift function
    TIMECNT=0x00000001;
    RequestIRQ(IRQ_TIMER0_TMC, GPIOOUT2_HANDLER);
    GPIOTIMERSET();
    UART_printf("Press Any key : END GPIOOUT TEST\n\r ");
    UART_getch();
    ReleaseIRQ(IRQ_TIMER0_TMC);
    

}

/*-----------------------------------------------------------------------
    Function name   : GPIOOUTTEST()
    Prototype           : void GPIOOUTTEST(void)
    Return              : void
    Argument        :
    Comments        :GPIO OUTPUT TEST for 7-segment
-----------------------------------------------------------------------*/
void GPIOOUTTEST(void)
{
    SMT_WRITE(GPIO_CON0,GPIO0_GPIO_OUTPUT_MODE);
    SMT_WRITE(GPIO_CON1,GPIO1_GPIO_OUTPUT_MODE);
    SMT_WRITE(GPIO_CON2,GPIO2_GPIO_OUTPUT_MODE);
    SMT_WRITE(GPIO_CON3,GPIO3_GPIO_OUTPUT_MODE); // all gpio output
    
    TIMECNT=0;
    
    SMT_WRITE(GPIO_DAT0,(TIMECNT&0xFF));
    SMT_WRITE(GPIO_DAT1,((TIMECNT&0xFF00)>>8));
    SMT_WRITE(GPIO_DAT2,((TIMECNT&0xFF0000)>>16));
    SMT_WRITE(GPIO_DAT3,((TIMECNT&0xFF000000)>>24)); 
    
    RequestIRQ(IRQ_TIMER0_TMC, GPIOOUT_HANDLER);
    GPIOTIMERSET();

}
/*-----------------------------------------------------------------------
    Function name   : GPIOINTEST()
    Prototype           : void GPIOINTEST(void)
    Return              : void
    Argument        :
    Comments        :GPIO INPUT TEST (input data -> uart)
-----------------------------------------------------------------------*/
void GPIOINTEST(void)
{
    SMT_WRITE(GPIO_CON0,GPIO0_GPIO_INPUT_MODE);
    SMT_WRITE(GPIO_CON1,GPIO1_GPIO_INPUT_MODE);
    SMT_WRITE(GPIO_CON2,GPIO2_GPIO_INPUT_MODE);
    SMT_WRITE(GPIO_CON3,GPIO3_GPIO_INPUT_MODE|0xf000); // for uart
    RequestIRQ(IRQ_TIMER0_TMC, GPIOIN_HANDLER);
    GPIOTIMERSET();
    UART_printf(" Test END? (Press any key)");
    UART_getch();
    ReleaseIRQ(IRQ_TIMER0_TMC);
    
}
/*-----------------------------------------------------------------------
    Function name   : GPIOTIMERSET()
    Prototype           : void GPIOTIMERSET(void)
    Return              : void
    Argument        :
    Comments        : TIMER setting for GPIO TEST
-----------------------------------------------------------------------*/
void GPIOTIMERSET(void) 
{
    SMT_WRITE(TPRE0, 0xff);   // Prescaler selection
    SMT_WRITE(TDAT0, 0x6000);
    //internal clock used
    SMT_WRITE(TCON0, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
}
/*-----------------------------------------------------------------------
    Function name   : TCLKTEST()
    Prototype           : void TCLKTEST(void)
    Return              : void
    Argument        :
    Comments        :GPIO INPUT TCLK MODE TEST
-----------------------------------------------------------------------*/

void TCLKTEST(void)
{
    SMT_WRITE(TCON0, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN)); // timer disable
    SMT_WRITE(TCON1, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON2, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON3, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON4, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON5, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON6, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON7, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));

    
    
    SMT_WRITE(GPIO_CON3,GPIO3_TCLK_INPUT_MODE|0xf000); // for uart
    RequestIRQ(IRQ_TIMER0_TMC, TCLKTEST0_HANDLER);
    RequestIRQ(IRQ_TIMER1_TMC, TCLKTEST1_HANDLER);
    RequestIRQ(IRQ_TIMER2_TMC, TCLKTEST2_HANDLER);
    RequestIRQ(IRQ_TIMER3_TMC, TCLKTEST3_HANDLER);
    RequestIRQ(IRQ_TIMER4_TMC, TCLKTEST4_HANDLER);
    SMT_WRITE(TPRE0, 0xf0);   // Prescaler selection
    SMT_WRITE(TPRE1, 0xf0);   // Prescaler selection
    SMT_WRITE(TPRE2, 0xf0);   // Prescaler selection
    SMT_WRITE(TPRE3, 0xf0);   // Prescaler selection
    SMT_WRITE(TPRE4, 0xf0);   // Prescaler selection
    SMT_WRITE(TDAT0, 0x0100);
    SMT_WRITE(TDAT1, 0x0100);
    SMT_WRITE(TDAT2, 0x0500);
    SMT_WRITE(TDAT3, 0x0010);
    SMT_WRITE(TDAT4, 0x0002);
    
    //INTERRUPT를 EXTERNAL CLOCK으로 하고 INTERRUPT 걸리는지 확인,GPIO MODE 세팅
    SMT_WRITE(TCON0, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
    SMT_WRITE(TCON1, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
    SMT_WRITE(TCON2, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
    SMT_WRITE(TCON3, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
    SMT_WRITE(TCON4, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
    
    UART_getch();
    
    ReleaseIRQ(IRQ_TIMER0_TMC);
    ReleaseIRQ(IRQ_TIMER1_TMC);
    ReleaseIRQ(IRQ_TIMER2_TMC);
    ReleaseIRQ(IRQ_TIMER3_TMC);
    ReleaseIRQ(IRQ_TIMER4_TMC);
    
}
/*-----------------------------------------------------------------------
    Function name   : TCAPTEST()
    Prototype           : void TCAPTEST(void)
    Return              : void
    Argument        :
    Comments        :GPIO TCAP MODE TEST
-----------------------------------------------------------------------*/
void TCAPTEST(void)
{
    SMT_WRITE(TCON0, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN)); // timer disable
    SMT_WRITE(TCON1, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON2, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON3, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON4, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON5, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON6, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON7, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
   
    SMT_WRITE(GPIO_CON1,GPIO1_TCAP_INPUT_MODE); 
    RequestIRQ(IRQ_TIMER0_TOF, TCAPTEST0_HANDLER);
    RequestIRQ(IRQ_TIMER1_TOF, TCAPTEST1_HANDLER);
    RequestIRQ(IRQ_TIMER2_TOF, TCAPTEST2_HANDLER);
    RequestIRQ(IRQ_TIMER3_TOF, TCAPTEST3_HANDLER);
    RequestIRQ(IRQ_TIMER4_TOF, TCAPTEST4_HANDLER);
    RequestIRQ(IRQ_TIMER5_TOF, TCAPTEST5_HANDLER);
    RequestIRQ(IRQ_TIMER6_TOF, TCAPTEST6_HANDLER);
    RequestIRQ(IRQ_TIMER7_TOF, TCAPTEST7_HANDLER);
    //RequestIRQ(IRQ_TIMER5_TMC, TCLKTEST4_HANDLER);
    SMT_WRITE(TPRE0, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE1, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE2, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE3, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE4, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE5, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE6, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE7, 0xff);   // Prescaler selection
    SMT_WRITE(TDAT0, 0xf000);
    SMT_WRITE(TDAT1, 0xe000);
    SMT_WRITE(TDAT2, 0xf000);
    SMT_WRITE(TDAT3, 0xe000);
    SMT_WRITE(TDAT4, 0xf000);
    SMT_WRITE(TDAT5, 0xe000);
    SMT_WRITE(TDAT6, 0xf000);
    SMT_WRITE(TDAT7, 0xe000);
    //INTERRUPT를 EXTERNAL CLOCK으로 하고 INTERRUPT 걸리는지 확인,GPIO MODE 세팅
    SMT_WRITE(TCON0, 0x4<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //external clock 
                   );
    SMT_WRITE(TCON1, 0x5<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //external clock 
                   );
    SMT_WRITE(TCON2, 0x6<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //external clock 
                   );
    SMT_WRITE(TCON3, 0x4<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //external clock 
                   );
    SMT_WRITE(TCON4, 0x5<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //external clock 
                   );
    SMT_WRITE(TCON5, 0x5<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //external clock 
                   );
    SMT_WRITE(TCON6, 0x5<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //external clock 
                   );
    SMT_WRITE(TCON7, 0x5<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //external clock 
                   );
    
    UART_getch();
    ReleaseIRQ(IRQ_TIMER0_TOF);
    ReleaseIRQ(IRQ_TIMER1_TOF);
    ReleaseIRQ(IRQ_TIMER2_TOF);
    ReleaseIRQ(IRQ_TIMER3_TOF);
    ReleaseIRQ(IRQ_TIMER4_TOF);
    ReleaseIRQ(IRQ_TIMER5_TOF);
    ReleaseIRQ(IRQ_TIMER6_TOF);
    ReleaseIRQ(IRQ_TIMER7_TOF);
}   
    
/*-----------------------------------------------------------------------
    Function name   : GPIOOUT_HANDLER()
    Prototype           : void GPIOOUT_HANDLER(smtUint32 IRQ)
    Return              : void
    Argument        :
    Comments        : interrupt handler for GPIO OUTPUT TEST
-----------------------------------------------------------------------*/
void GPIOOUT_HANDLER(smtUint32 IRQ)
{
    SMT_WRITE(GPIO_DAT0,(TIMECNT&0xFF));
    SMT_WRITE(GPIO_DAT1,((TIMECNT&0xFF00)>>8));
    SMT_WRITE(GPIO_DAT2,((TIMECNT&0xFF0000)>>16));
    SMT_WRITE(GPIO_DAT3,((TIMECNT&0xFF000000)>>24)); 
    TIMECNT++;
}
/*-----------------------------------------------------------------------
    Function name   : GPIOOUT2_HANDLER()
    Prototype           : void GPIOOUT2_HANDLER(smtUint32 IRQ)
    Return              : void
    Argument        :
    Comments        : interrupt handler for GPIO OUTPUT2 TEST
-----------------------------------------------------------------------*/
void GPIOOUT2_HANDLER(smtUint32 IRQ)
{
    SMT_WRITE(GPIO_DAT0,(TIMECNT&0xFF));
    SMT_WRITE(GPIO_DAT1,((TIMECNT&0xFF00)>>8));
    SMT_WRITE(GPIO_DAT2,((TIMECNT&0xFF0000)>>16));
    SMT_WRITE(GPIO_DAT3,((TIMECNT&0xFF000000)>>24)); 
    TIMECNT=TIMECNT<<1;
}
/*-----------------------------------------------------------------------
    Function name   : GPIOIN_HANDLER()
    Prototype           : void GPIOIN_HANDLER(smtUint32 IRQ)
    Return              : void
    Argument        :
    Comments        : interrupt handler for GPIO INPUT TEST
-----------------------------------------------------------------------*/
void GPIOIN_HANDLER(smtUint32 IRQ)
{
    UART_printf(" -GPIO0 : ");
    UART_putchhex(GPIO_DAT0);
    UART_printf("  -GPIO1 : ");
    UART_putchhex(GPIO_DAT1);
    UART_printf("  -GPIO2 : ");
    UART_putchhex(GPIO_DAT2);
    UART_printf("  -GPIO3 : ");
    UART_putchhex(GPIO_DAT3);
    UART_printf("\n\r");
}

/*-----------------------------------------------------------------------
    Function name   : TIMER_INTERRUPT_TEST()
    Prototype           : void TIMER_INTERRUPT_TEST(void)
    Return              : void
    Argument        :
    Comments        : TIMER INTERRUPT TEST FUNCTION
-----------------------------------------------------------------------*/

void TIMER_INTERRUPT_TEST(void) 
{
    SMT_WRITE(TCON0, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN)); // timer disable
    SMT_WRITE(TCON1, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON2, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON3, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON4, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON5, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON6, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));
    SMT_WRITE(TCON7, 0x0<<SHIFT_DN_FROM_MASK(TIMER_EN));

    
    RequestIRQ(IRQ_TIMER0_TMC, TIMER0_HANDLER);
    RequestIRQ(IRQ_TIMER1_TMC, TIMER1_HANDLER);
    RequestIRQ(IRQ_TIMER2_TMC, TIMER2_HANDLER);
    RequestIRQ(IRQ_TIMER3_TMC, TIMER3_HANDLER);
    RequestIRQ(IRQ_TIMER4_TMC, TIMER4_HANDLER);
    RequestIRQ(IRQ_TIMER5_TMC, TIMER5_HANDLER);
    RequestIRQ(IRQ_TIMER6_TMC, TIMER6_HANDLER);
    RequestIRQ(IRQ_TIMER7_TMC, TIMER7_HANDLER);
    
    SMT_WRITE(TPRE0, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE1, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE2, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE3, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE4, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE5, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE6, 0xff);   // Prescaler selection
    SMT_WRITE(TPRE7, 0xff);   // Prescaler selection
    SMT_WRITE(TDAT0, 0xf000);
    SMT_WRITE(TDAT1, 0xe000);
    SMT_WRITE(TDAT2, 0xf000);
    SMT_WRITE(TDAT3, 0xe000);
    SMT_WRITE(TDAT4, 0xf000);
    SMT_WRITE(TDAT5, 0xe000);
    SMT_WRITE(TDAT6, 0xf000);
    SMT_WRITE(TDAT7, 0xe000);
    //internal clock used
    SMT_WRITE(TCON0, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
    SMT_WRITE(TCON1, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
    SMT_WRITE(TCON2, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
    SMT_WRITE(TCON3, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
    SMT_WRITE(TCON4, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
    SMT_WRITE(TCON5, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
    SMT_WRITE(TCON6, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
    SMT_WRITE(TCON7, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock 
                   );
                   
}





void TIMER0_HANDLER(smtUint32 IRQ)
{
    UART_printf(" Timer0 interrupt \n\r ");
}
void TIMER1_HANDLER(smtUint32 IRQ)
{
    UART_printf(" Timer1 interrupt \n\r ");
}
void TIMER2_HANDLER(smtUint32 IRQ)
{
    UART_printf(" Timer2 interrupt \n\r ");    
}
void TIMER3_HANDLER(smtUint32 IRQ)
{
    UART_printf(" Timer3 interrupt \n\r ");
}
void TIMER4_HANDLER(smtUint32 IRQ)
{
    UART_printf(" Timer4 interrupt \n\r ");
}
void TIMER5_HANDLER(smtUint32 IRQ)
{
    UART_printf(" Timer5 interrupt \n\r ");
}
void TIMER6_HANDLER(smtUint32 IRQ)
{
    UART_printf(" Timer6 interrupt \n\r ");
}
void TIMER7_HANDLER(smtUint32 IRQ)
{
    UART_printf(" Timer7 interrupt \n\r ");
}
void EINT0_HANDLER(smtUint32 IRQ)
{
    UART_printf(" EINT0 interrupt \n\r ");
} 
void EINT1_HANDLER(smtUint32 IRQ) 
{
    UART_printf(" EINT1 interrupt \n\r ");
}
void EINT2_HANDLER(smtUint32 IRQ) 
{
    UART_printf(" EINT2 interrupt \n\r ");
}
void EINT3_HANDLER(smtUint32 IRQ) 
{
    UART_printf(" EINT3 interrupt \n\r ");
}
void EINT4_HANDLER(smtUint32 IRQ) 
{
    UART_printf(" EINT4 interrupt \n\r ");
}
void EINT5_HANDLER(smtUint32 IRQ) 
{
    UART_printf(" EINT5 interrupt \n\r ");
}
void EINT6_HANDLER(smtUint32 IRQ) 
{
    UART_printf(" EINT6 interrupt \n\r ");
}
void EINT7_HANDLER(smtUint32 IRQ) 
{
    UART_printf(" EINT7 interrupt \n\r ");
}

void TCLKTEST0_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCLK0 interrupt \n\r ");
}

void TCLKTEST1_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCLK1 interrupt \n\r ");
}
void TCLKTEST2_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCLK2 interrupt \n\r ");
}
void TCLKTEST3_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCLK3 interrupt \n\r ");
}
void TCLKTEST4_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCLK4 interrupt \n\r ");
}
void TCAPTEST0_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCAP0 interrupt : ");
    UART_putchhex16(SMT_READ(TCNT0));
    UART_printf(" \n\r");
}
void TCAPTEST1_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCAP1 interrupt : ");
    UART_putchhex16(SMT_READ(TCNT1));
    UART_printf(" \n\r");
}
void TCAPTEST2_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCAP2 interrupt : ");
    UART_putchhex16(SMT_READ(TCNT2));
    UART_printf(" \n\r");
}
void TCAPTEST3_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCAP3 interrupt : ");
    UART_putchhex16(SMT_READ(TCNT3));
    UART_printf(" \n\r");
}
void TCAPTEST4_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCAP4 interrupt : ");
    UART_putchhex16(SMT_READ(TCNT4));
    UART_printf(" \n\r");
}
void TCAPTEST5_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCAP5 interrupt : ");
    UART_putchhex16(SMT_READ(TCNT5));
    UART_printf(" \n\r");
}
void TCAPTEST6_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCAP6 interrupt : ");
    UART_putchhex16(SMT_READ(TCNT6));
    UART_printf(" \n\r");
}
void TCAPTEST7_HANDLER(smtUint32 IRQ)
{
    UART_printf(" TCAP7 interrupt : ");
    UART_putchhex16(SMT_READ(TCNT7));
    UART_printf(" \n\r");
}

