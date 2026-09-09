/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*-----------------------------------------------------------------------
    Function name   : PWMTEST()
    Prototype           : void PWMTEST(void)
    Return              : void
    Argument        :
    Comments        : PWM TEST FUNCTION
-----------------------------------------------------------------------*/
void PWMLINETEST(void)// for uart and i2c 
{
    
    SMT_WRITE(PPRE0_0,0x01);
    SMT_WRITE(PPRE0_1,0x01);
    SMT_WRITE(PPRE0_2,0x02);
    SMT_WRITE(PPRE0_3,0x02);
    SMT_WRITE(PPRE0_4,0x03);
    SMT_WRITE(PPRE0_5,0x03);
    SMT_WRITE(PPRE0_6,0x04);
    SMT_WRITE(PPRE0_7,0x04);
    SMT_WRITE(PPRE1_0,0x05);
    SMT_WRITE(PPRE1_1,0x05);
    SMT_WRITE(PPRE1_2,0x06);
    SMT_WRITE(PPRE1_3,0x06);
    SMT_WRITE(PPRE1_4,0x07);
    SMT_WRITE(PPRE1_5,0x07);
    SMT_WRITE(PPRE1_6,0x08);
    SMT_WRITE(PPRE1_7,0x08);
    SMT_WRITE(PPRE2_0,0x09);
    SMT_WRITE(PPRE2_1,0x09);
    SMT_WRITE(PPRE2_2,0x0A);
    SMT_WRITE(PPRE2_3,0x0A);
    SMT_WRITE(PPRE2_4,0x0B);
    SMT_WRITE(PPRE2_5,0x0B);
    SMT_WRITE(PPRE2_6,0x0C);
    SMT_WRITE(PPRE2_7,0x0C);
    SMT_WRITE(PPRE3_0,0x0D);
    SMT_WRITE(PPRE3_1,0x0D);
    SMT_WRITE(PPRE3_2,0x0E);
    SMT_WRITE(PPRE3_3,0x0E);
    SMT_WRITE(PPRE3_4,0x0F);
    SMT_WRITE(PPRE3_5,0x0F);
    SMT_WRITE(PPRE3_6,0x10);
    SMT_WRITE(PPRE3_7,0x10);
    
    SMT_WRITE(PDAT0_0,0xf);
    SMT_WRITE(PDAT0_1,0xf);
    SMT_WRITE(PDAT0_2,0xf);
    SMT_WRITE(PDAT0_3,0xf);
    SMT_WRITE(PDAT0_4,0xf);
    SMT_WRITE(PDAT0_5,0xf);
    SMT_WRITE(PDAT0_6,0xf);
    SMT_WRITE(PDAT0_7,0xf);
    SMT_WRITE(PDAT1_0,0xf);
    SMT_WRITE(PDAT1_1,0xf);
    SMT_WRITE(PDAT1_2,0xf);
    SMT_WRITE(PDAT1_3,0xf);
    SMT_WRITE(PDAT1_4,0xf);
    SMT_WRITE(PDAT1_5,0xf);
    SMT_WRITE(PDAT1_6,0xf);
    SMT_WRITE(PDAT1_7,0xf);
    SMT_WRITE(PDAT2_0,0xf);
    SMT_WRITE(PDAT2_1,0xf);
    SMT_WRITE(PDAT2_2,0xf);
    SMT_WRITE(PDAT2_3,0xf);
    SMT_WRITE(PDAT2_4,0xf);
    SMT_WRITE(PDAT2_5,0xf);
    SMT_WRITE(PDAT2_6,0xf);
    SMT_WRITE(PDAT2_7,0xf);
    SMT_WRITE(PDAT3_0,0xf);
    SMT_WRITE(PDAT3_1,0xf);
    SMT_WRITE(PDAT3_2,0xf);
    SMT_WRITE(PDAT3_3,0xf);
    SMT_WRITE(PDAT3_4,0xf);
    SMT_WRITE(PDAT3_5,0xf);
    SMT_WRITE(PDAT3_6,0xf);
    SMT_WRITE(PDAT3_7,0xf);

    SMT_WRITE(PCON0_0,0x00090);
    SMT_WRITE(PCON0_1,0x00092);
    SMT_WRITE(PCON0_2,0x00090);
    SMT_WRITE(PCON0_3,0x00092);
    SMT_WRITE(PCON0_4,0x00090);
    SMT_WRITE(PCON0_5,0x00092);
    SMT_WRITE(PCON0_6,0x00090);
    SMT_WRITE(PCON0_7,0x00092);
    SMT_WRITE(PCON1_0,0x00090);
    SMT_WRITE(PCON1_1,0x00092);
    SMT_WRITE(PCON1_2,0x00090);
    SMT_WRITE(PCON1_3,0x00092);
    SMT_WRITE(PCON1_4,0x00090);
    SMT_WRITE(PCON1_5,0x00092);
    SMT_WRITE(PCON1_6,0x00090);
    SMT_WRITE(PCON1_7,0x00092);
    SMT_WRITE(PCON2_0,0x00090);
    SMT_WRITE(PCON2_1,0x00092);
    SMT_WRITE(PCON2_2,0x00090);
    SMT_WRITE(PCON2_3,0x00092);
    SMT_WRITE(PCON2_4,0x00090);
    SMT_WRITE(PCON2_5,0x00092);
    SMT_WRITE(PCON2_6,0x00090);
    SMT_WRITE(PCON2_7,0x00092);
    SMT_WRITE(PCON3_0,0x00090);
    SMT_WRITE(PCON3_1,0x00092);
    SMT_WRITE(PCON3_2,0x00090);
    SMT_WRITE(PCON3_3,0x00092);
    SMT_WRITE(PCON3_4,0x00090);
    SMT_WRITE(PCON3_5,0x00092);
    SMT_WRITE(PCON3_6,0x00090);
    SMT_WRITE(PCON3_7,0x00092);


    SMT_WRITE(GPIO_CON0, 
                         (0x3<<SHIFT_DN_FROM_MASK(GPIO_0)   
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_1)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_2)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_3)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_4)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_5)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_6)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_7)));
                        
    //GPIO2 setting (Timer output  2'b01) 
    //GPIO2 setting (PWM output    2'b00) 
    //GPIO2 setting (push-pull output    2'b11) 
    SMT_WRITE(GPIO_CON2, 
                         (0x0<<SHIFT_DN_FROM_MASK(GPIO_0)   
                        | 0x0<<SHIFT_DN_FROM_MASK(GPIO_1)
                        | 0x0<<SHIFT_DN_FROM_MASK(GPIO_2)
                        | 0x0<<SHIFT_DN_FROM_MASK(GPIO_3)
                        | 0x0<<SHIFT_DN_FROM_MASK(GPIO_4)
                        | 0x0<<SHIFT_DN_FROM_MASK(GPIO_5)
                        | 0x0<<SHIFT_DN_FROM_MASK(GPIO_6)
                        | 0x0<<SHIFT_DN_FROM_MASK(GPIO_7)));
    UART_printf(" Press Any key : end pwm test \n\r");
    UART_getch();
    
    SMT_WRITE(PWMCON,0x0001); //To address and data line PWM
    UART_printf(" Press Any key : end pwm test \n\r");
    UART_getch();
    SMT_WRITE(PWMCON,0x0000); //To address and data line PWM
    
}
