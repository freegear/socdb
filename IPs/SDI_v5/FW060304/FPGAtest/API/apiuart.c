/*----------------------------------------------------------
	File Name   : apiuart.c 
	Description : Timer & PWM test routine
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

//#define DIVSET_UARTIBRD      0x138 
#define DIVSET_UARTIBRD      20 
#define DIVSET_UARTFBRD      53 

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

void UART_putch(char ch);
void UART_printf(char * str);
char UART_getch(void);
void UART_Initial(void);
void UART_putchhex(char ch);
void UART_putchhex16(int ch);
/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */



/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : UART_Initial(void)
    Prototype       : void UART_Initial(void)
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void UART_Initial(void)
{
    SMT_WRITE(UARTIBRD, DIVSET_UARTIBRD); // 14400 BPS setting
    SMT_WRITE(UARTFBRD, DIVSET_UARTFBRD);
    SMT_WRITE(GPIO_CON3, 0xFFFF);
    SMT_WRITE(UARTLCR_H, 
                    (0x0<<SHIFT_DN_FROM_MASK(STICK_PAR_SEL) |
                     0x3<<SHIFT_DN_FROM_MASK(WORD_LENGTH) |
                     0x1<<SHIFT_DN_FROM_MASK(EN_FIFO) |
                     0x0<<SHIFT_DN_FROM_MASK(T_STOP_BIT_SEL) |
                     0x0<<SHIFT_DN_FROM_MASK(EVEN_PARITY_SEL) |
                     0x0<<SHIFT_DN_FROM_MASK(SEND_BREAK) ));

    SMT_WRITE(UARTIFLS,
                    (0x0<<SHIFT_DN_FROM_MASK(RX_INTERRUPT_LEVEL) |
                     0x0<<SHIFT_DN_FROM_MASK(TX_INTERRUPT_LEVEL) 
                ));


    SMT_WRITE(UARTIMSC,
                    (0x1<<SHIFT_DN_FROM_MASK(OVERRUN_ERR_MASK) |
                     0x1<<SHIFT_DN_FROM_MASK(BREAK_ERR_MASK) | 
                     0x1<<SHIFT_DN_FROM_MASK(PARITY_ERR_MASK) | 
                     0x1<<SHIFT_DN_FROM_MASK(FRAMING_ERR_MASK) | 
                     0x1<<SHIFT_DN_FROM_MASK(RX_TIMEOUT) | 
                     0x1<<SHIFT_DN_FROM_MASK(TX_INTERRUPT_MASK) | 
                     0x0<<SHIFT_DN_FROM_MASK(RX_INTERRUPT_MASK) | 
                     0x1<<SHIFT_DN_FROM_MASK(DSR_INTERRUPT_MASK) | 
                     0x1<<SHIFT_DN_FROM_MASK(DCD_INTERRUPT_MASK) | 
                     0x1<<SHIFT_DN_FROM_MASK(CTS_INTERRUPT_MASK) | 
                     0x1<<SHIFT_DN_FROM_MASK(RI_INTERRUPT_MASK)  
                ));


    SMT_WRITE(UARTCR,
                    (0x0<<SHIFT_DN_FROM_MASK(CTS_HW_FLOW) |
                     0x0<<SHIFT_DN_FROM_MASK(RTS_HW_FLOW) |
                     0x0<<SHIFT_DN_FROM_MASK(OUT2) |
                     0x0<<SHIFT_DN_FROM_MASK(OUT1) |
                     0x0<<SHIFT_DN_FROM_MASK(REQ_TO_SEND) |
                     0x0<<SHIFT_DN_FROM_MASK(DATA_TX_READY) |
                     0x1<<SHIFT_DN_FROM_MASK(RX_EN) |
                     0x1<<SHIFT_DN_FROM_MASK(TX_EN) |
                     0x0<<SHIFT_DN_FROM_MASK(LOOP_BACK_EN) |
                     0x1<<SHIFT_DN_FROM_MASK(UART_EN) 
                ));
}




/*-----------------------------------------------------------------------
    Function name   : UART_putch(char ch)
    Prototype       : void UART_putch(char ch)
    Return          : char
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void UART_putch(char ch)
{
  
  long rx_ch ;
  long test = 0 ;

  while (1) {
    if((SMT_READ(UARTFR) & 0x00000020 )  != 0x00000020) // FIFO no full
    {
      SMT_WRITE(UARTDR, (long)(ch & 0xff));
      return ;
    }
  }
}
/*-----------------------------------------------------------------------
    Function name   : UART_putch_hex(char ch)
    Prototype       : void UART_putch_hex(char ch)
    Return          : char
    Argument        :
    Comments        : UART to char -> ASCII hex
-----------------------------------------------------------------------*/
void UART_putchhex(char ch)
{
    UART_printf("0x");
    
    if (((ch>>4)&0x0f)<=9)
    UART_putch(((ch>>4)&0x0f)+0x30);
    else
    UART_putch(((ch>>4)&0x0f)+0x37);
    
    if ((ch&0x0f)<=9)
    UART_putch((ch&0x0f)+0x30);
    else
    UART_putch((ch&0x0f)+0x37);
    
}
/*-----------------------------------------------------------------------
    Function name   : UART_putch_hex16(int ch)
    Prototype       : void UART_putch_hex16(int ch)
    Return          : char
    Argument        :
    Comments        : UART to char -> ASCII 16bit hex
-----------------------------------------------------------------------*/
void UART_putchhex16(int ch)
{
    UART_printf("0x");
    
    if (((ch>>12)&0x0f)<=9)
    UART_putch(((ch>>12)&0x0f)+0x30);
    else
    UART_putch(((ch>>12)&0x0f)+0x37);
    
    if (((ch>>8)&0x0f)<=9)
    UART_putch(((ch>>8)&0x0f)+0x30);
    else
    UART_putch(((ch>>8)&0x0f)+0x37);
    
    
    
    
    
    
    if (((ch>>4)&0x0f)<=9)
    UART_putch(((ch>>4)&0x0f)+0x30);
    else
    UART_putch(((ch>>4)&0x0f)+0x37);
    
    if ((ch&0x0f)<=9)
    UART_putch((ch&0x0f)+0x30);
    else
    UART_putch((ch&0x0f)+0x37);
    
}
/*-----------------------------------------------------------------------
    Function name   : UART_printf(char *)
    Prototype       : void UART_printf(char *)
    Return          : char *
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void UART_printf(char * str)
{
	
 int index = 0 ;
  while( str[index] != '\000')  
    {      	
      UART_putch( (char) str[index] ) ;      
      index++;            
    } 
}

/*-----------------------------------------------------------------------
    Function name   : UART_getch()
    Prototype       : long UART_getch()
    Return          : 
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

char UART_getch()
{
    while((SMT_READ(UARTFR) & 0x00000010 )  == 0x00000010); // FIFO no full
        return (SMT_READ(UARTDR)& 0xff);  
}

