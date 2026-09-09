void WDT_FPGATEST(void);
static void WDT_TEST_ISR(smtUint32 IRQ);
void WDT_TEST_disable(void);
/*-----------------------------------------------------------------------
    Function name   : WDT_FPGATEST(void)
    Prototype       : void WDT_FPGATEST(void)
    Return          :
    Argument        :
    Comments        : FOR FPGA TEST
-----------------------------------------------------------------------*/
void WDT_FPGATEST(void)
{
    // WDT test
    SMT_WRITE(WDTPSR,  0x4);
    SMT_WRITE(WDTTLDR, 0x10);
    RequestIRQ(IRQ_WDT, WDT_TEST_ISR);

    UART_printf("Press test button !\n\r");
    UART_printf("1. WDT Interrupt test\n\r");
    UART_printf("2. WDT Reset test\n\r");
    UART_printf("?. WDT test pass\n\r");

    // WDT interrupt enable & WDT enable
    switch(UART_getch())
    {
        case 0x31:  SMT_WRITE(WDTCR, WDT_INTEN | WDT_EN);
            break;
        case 0x32:  SMT_WRITE(WDTCR, WDT_RSTEN |WDT_INTEN | WDT_EN);
            break;
    }
}
/*-----------------------------------------------------------------------
    Function name   : WDT_TEST_ISR(smtUint32 IRQ)
    Prototype       : static void WDT_TEST_ISR(smtUint32 IRQ)
    Return          :
    Argument        :
    Comments        : FPGA TEST WDT INTERRUPT FUNCTION 
-----------------------------------------------------------------------*/
static void WDT_TEST_ISR(smtUint32 IRQ)
{
    UART_printf("WDT interrupt generated!!!\n\r");
    UART_printf("WDT TEST OK! \n\r");
    
    SMT_WRITE(WDTISR, 1<<WDTISR_FLAG);   // WDT interrupt status clear.
    WDT_TEST_disable();
}
/*-----------------------------------------------------------------------
    Function name   : WDT_TEST_disable(void)
    Prototype       : void WDT_TEST_disable(void)
    Return          :
    Argument        :
    Comments        : FPGA TEST WDT INTERRUPT DISABLE FUNCTION 
-----------------------------------------------------------------------*/
void WDT_TEST_disable(void)
{
    SMT_WRITE(WDTCR, (~(signed)WDT_INTEN&WDT_INTEN)|(~WDT_EN&WDT_EN));
    ReleaseIRQ(IRQ_WDT);
}
