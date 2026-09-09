/*-----------------------------------------------------------------------
    Function name   : POWERMANAGE_TEST(void)
    Prototype       : void POWERMANAGE_TEST(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void POWERMANAGE_TEST(void)
{
    
    char testnumber;
 //        RequestIRQ(,GPIOIN_HANDLER);
 
    int syscon_store;
    RequestIRQ(IRQ_EINT0, EINT0_HANDLER );// EINT[0] Interrupt handler set
    TIMER_INTERRUPT_TEST();
    testnumber=UART_getch();
    while(testnumber!=0x33)
    {
        UART_printf("-POWERMANGEMENT TEST-\n\r");
        UART_printf("-1. STOP MODE-\n\r");
        UART_printf("-2. SLOW MODE-\n\r");
        UART_printf("-3. END POWERMANGEMENT TEST-\n\r");
    
        testnumber= UART_getch();

        switch(testnumber)
        {
            case 0x31:
                SMT_WRITE(SYSCON, (SMT_READ(SYSCON)|0x0001)); //stop mode
                UART_getch();
                UART_printf("normal mode\n\r");
                break;
            case 0x32:
                syscon_store = SMT_READ(SYSCON);
                SMT_WRITE(SYSCON,0x1054);// 46 54 62
                UART_printf("This mode is SLOW mode!!\n\r");
                UART_printf("press any key : normal mode\n\r");
                UART_getch();
                UART_printf("This mode is NORMAL mode!!\n\r");
                SMT_WRITE(SYSCON,syscon_store);// 46 54 62
                ReleaseIRQ(IRQ_EINT0);
                break;
                
        }
    }
    
}

