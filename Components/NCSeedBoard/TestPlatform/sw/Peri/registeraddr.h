/*-------------------------------------------------------------------
File name   : registeraddr.h

Description : middle level routines
----------------------------------------------------------------------*/
#ifndef __REGISTER_H__
#define __REGISTER_H__

/*/////////////////////////////////////////////////////////
        REGISTER ADDRESS DEFINITION
///////////////////////////////////////////////////////// */

/* Internal flash */
#define REG_FMKEY 			0x01FF8000
#define REG_FMADDR			0x01FF8004
#define REG_FMDATA			0x01FF8008
#define REG_FMUCON			0x01FF800C
#define REG_FSO   			0x01FF8010
#define REG_FPO   			0x01FF8014

#define REG_FMTNV   		0x01FF8020
#define REG_FMTPG       	0x01FF8024
#define REG_FMTRCV      	0x01FF8028
#define REG_FMTPROG     	0x01FF802C
#define REG_FMTERASE    	0x01FF8030
#define REG_FMTME       	0x01FF8034

/* External sram */
#define REG_ESMC_B0_CON		0x01FF8100
#define REG_ESMC_B1_CON		0x01FF8104
#define REG_ESMC_B2_CON		0x01FF8108
#define REG_ESMC_B3_CON		0x01FF810C

/* UART */
 #define REG_UARTDR   		0x01FF8200
 #define REG_UARTSR   		0x01FF8204      
                      		
 #define REG_UARTFR   		0x01FF8218
                      		
 #define REG_UARTILPR 		0x01FF8220     
 #define REG_UARTIBRD 		0x01FF8224    
 #define REG_UARTFBRD 		0x01FF8228     
 #define REG_UARTLCR_H		0x01FF822C    
 #define REG_UARTCR   		0x01FF8230       
 #define REG_UARTIFLS 		0x01FF8234     
 #define REG_UARTIMSC 		0x01FF8238     
 #define REG_UARTRIS  		0x01FF823C      
 #define REG_UARTMIS  		0x01FF8240      
 #define REG_UARTICR  		0x01FF8244
                      		
 #define REG_UARTDMACR		0x01FF8248    

/* I2C */
#define REG_ICCR0_0			0x01FF8300
#define REG_ICSR0  			0x01FF8304    
#define REG_IAR0   			0x01FF8308    
#define REG_IDSR0  			0x01FF830C   
#define REG_ICCR0_1			0x01FF8310
                   			
#define REG_ICCR1_0			0x01FF8380
#define REG_ICSR1  			0x01FF8384      
#define REG_IAR1   			0x01FF8388      
#define REG_IDSR1  			0x01FF838C  
#define REG_ICCR1_1			0x01FF8390

/* Timer & PWM */
#define REG_TDAT0 			0x01FF8400
#define REG_TPRE0 			0x01FF8404
#define REG_TCON0 			0x01FF8408
#define REG_TCNT0 			0x01FF840C
#define REG_TPWM0 			0x01FF8410 
                  			
#define REG_TDAT1 			0x01FF8420
#define REG_TPRE1 			0x01FF8424
#define REG_TCON1 			0x01FF8428
#define REG_TCNT1 			0x01FF842C
#define REG_TPWM1 			0x01FF8430 
                  			
#define REG_TDAT2			0x01FF8440																											
#define REG_TPRE2			0x01FF8444																											
#define REG_TCON2			0x01FF8448																											
#define REG_TCNT2			0x01FF844C																											
#define REG_TPWM2			0x01FF8450																											 
                  			
#define REG_TDAT3 			0x01FF8460
#define REG_TPRE3 			0x01FF8464
#define REG_TCON3 			0x01FF8468
#define REG_TCNT3 			0x01FF846C 
#define REG_TPWM3 			0x01FF8470 

#define REG_TDAT4			0x01FF8480
#define REG_TPRE4			0x01FF8484
#define REG_TCON4			0x01FF8488
#define REG_TCNT4			0x01FF848C
#define REG_TPWM4			0x01FF8490
                 			
#define REG_TDAT5			0x01FF84A0
#define REG_TPRE5			0x01FF84A4
#define REG_TCON5			0x01FF84A8
#define REG_TCNT5			0x01FF84AC
#define REG_TPWM5			0x01FF84B0
                 			
#define REG_TDAT6			0x01FF84C0
#define REG_TPRE6			0x01FF84C4
#define REG_TCON6			0x01FF84C8
#define REG_TCNT6			0x01FF84CC 
#define REG_TPWM6			0x01FF84D0 
                 			
#define REG_TDAT7			0x01FF84E0
#define REG_TPRE7			0x01FF84E4
#define REG_TCON7			0x01FF84E8
#define REG_TCNT7			0x01FF84EC
#define REG_TPWM7			0x01FF84F0

/* PWM */
#define REG_PDAT0_0			0x01FF8500
#define REG_PPRE0_0			0x01FF8504
#define REG_PCON0_0			0x01FF8508
#define REG_PCNT0_0			0x01FF850C
#define REG_PPWM0_0			0x01FF8510
                   			
#define REG_PDAT0_1			0x01FF8520
#define REG_PPRE0_1			0x01FF8524
#define REG_PCON0_1			0x01FF8528
#define REG_PCNT0_1			0x01FF852C
#define REG_PPWM0_1			0x01FF8530
                   			
#define REG_PDAT0_2			0x01FF8540
#define REG_PPRE0_2			0x01FF8544
#define REG_PCON0_2			0x01FF8548
#define REG_PCNT0_2			0x01FF854C
#define REG_PPWM0_2			0x01FF8550
                   			
#define REG_PDAT0_3			0x01FF8560
#define REG_PPRE0_3			0x01FF8564
#define REG_PCON0_3			0x01FF8568
#define REG_PCNT0_3			0x01FF856C
#define REG_PPWM0_3			0x01FF8570 
                   			
#define REG_PDAT0_4			0x01FF8580
#define REG_PPRE0_4			0x01FF8584
#define REG_PCON0_4			0x01FF8588
#define REG_PCNT0_4			0x01FF858C
#define REG_PPWM0_4			0x01FF8590
                   			
#define REG_PDAT0_5			0x01FF85A0
#define REG_PPRE0_5			0x01FF85A4
#define REG_PCON0_5			0x01FF85A8 
#define REG_PCNT0_5			0x01FF85AC
#define REG_PPWM0_5			0x01FF85B0 
                   			
#define REG_PDAT0_6			0x01FF85C0
#define REG_PPRE0_6			0x01FF85C4
#define REG_PCON0_6			0x01FF85C8
#define REG_PCNT0_6			0x01FF85CC
#define REG_PPWM0_6			0x01FF85D0
                   			
#define REG_PDAT0_7			0x01FF85E0
#define REG_PPRE0_7			0x01FF85E4
#define REG_PCON0_7			0x01FF85E8
#define REG_PCNT0_7			0x01FF85EC
#define REG_PPWM0_7			0x01FF85F0

#define REG_PDAT1_0			0x01FF8600
#define REG_PPRE1_0			0x01FF8604
#define REG_PCON1_0			0x01FF8608
#define REG_PCNT1_0			0x01FF860C
#define REG_PPWM1_0			0x01FF8610
                   			
#define REG_PDAT1_1			0x01FF8620
#define REG_PPRE1_1			0x01FF8624
#define REG_PCON1_1			0x01FF8628
#define REG_PCNT1_1			0x01FF862C
#define REG_PPWM1_1			0x01FF8630
                   			
#define REG_PDAT1_2			0x01FF8640
#define REG_PPRE1_2			0x01FF8644
#define REG_PCON1_2			0x01FF8648
#define REG_PCNT1_2			0x01FF864C
#define REG_PPWM1_2			0x01FF8650
                   			
#define REG_PDAT1_3			0x01FF8660
#define REG_PPRE1_3			0x01FF8664
#define REG_PCON1_3			0x01FF8668
#define REG_PCNT1_3			0x01FF866C
#define REG_PPWM1_3			0x01FF8670
                   			
#define REG_PDAT1_4			0x01FF8680
#define REG_PPRE1_4			0x01FF8684
#define REG_PCON1_4			0x01FF8688
#define REG_PCNT1_4			0x01FF868C 
#define REG_PPWM1_4			0x01FF8690
                   			
#define REG_PDAT1_5			0x01FF86A0
#define REG_PPRE1_5			0x01FF86A4
#define REG_PCON1_5			0x01FF86A8
#define REG_PCNT1_5			0x01FF86AC 
#define REG_PPWM1_5			0x01FF86B0
                   			
#define REG_PDAT1_6			0x01FF86C0
#define REG_PPRE1_6			0x01FF86C4
#define REG_PCON1_6			0x01FF86C8
#define REG_PCNT1_6			0x01FF86CC 
#define REG_PPWM1_6			0x01FF86D0

#define REG_PDAT1_7			0x01FF86E0
#define REG_PPRE1_7			0x01FF86E4
#define REG_PCON1_7			0x01FF86E8
#define REG_PCNT1_7			0x01FF86EC 
#define REG_PPWM1_7			0x01FF86F0
                   			
#define REG_PDAT2_0			0x01FF8700
#define REG_PPRE2_0			0x01FF8704
#define REG_PCON2_0			0x01FF8708
#define REG_PCNT2_0			0x01FF870C 
#define REG_PPWM2_0			0x01FF8710
                   			
#define REG_PDAT2_1			0x01FF8720 
#define REG_PPRE2_1			0x01FF8724 
#define REG_PCON2_1			0x01FF8728 
#define REG_PCNT2_1			0x01FF872C  
#define REG_PPWM2_1			0x01FF8730 
                   			
#define REG_PDAT2_2			0x01FF8740
#define REG_PPRE2_2			0x01FF8744
#define REG_PCON2_2			0x01FF8748
#define REG_PCNT2_2			0x01FF874C
#define REG_PPWM2_2			0x01FF8750
                   			
#define REG_PDAT2_3			0x01FF8760
#define REG_PPRE2_3			0x01FF8764
#define REG_PCON2_3			0x01FF8768
#define REG_PCNT2_3			0x01FF876C
#define REG_PPWM2_3			0x01FF8770
                   			
#define REG_PDAT2_4			0x01FF8780
#define REG_PPRE2_4			0x01FF8784
#define REG_PCON2_4			0x01FF8788
#define REG_PCNT2_4			0x01FF878C
#define REG_PPWM2_4			0x01FF8790
                   			
#define REG_PDAT2_5			0x01FF87A0
#define REG_PPRE2_5			0x01FF87A4
#define REG_PCON2_5			0x01FF87A8
#define REG_PCNT2_5			0x01FF87AC         
#define REG_PPWM2_5			0x01FF87B0

#define REG_PDAT2_6			0x01FF87C0 
#define REG_PPRE2_6			0x01FF87C4 
#define REG_PCON2_6			0x01FF87C8  
#define REG_PCNT2_6			0x01FF87CC  
#define REG_PPWM2_6			0x01FF87D0  
                   			
#define REG_PDAT2_7			0x01FF87E0 
#define REG_PPRE2_7			0x01FF87E4
#define REG_PCON2_7			0x01FF87E8 
#define REG_PCNT2_7			0x01FF87EC
#define REG_PPWM2_7			0x01FF87F0 
                   			
#define REG_PDAT3_0			0x01FF8800
#define REG_PPRE3_0			0x01FF8804
#define REG_PCON3_0			0x01FF8808
#define REG_PCNT3_0			0x01FF880C 
#define REG_PPWM3_0			0x01FF8810
                   			
#define REG_PDAT3_1			0x01FF8820
#define REG_PPRE3_1			0x01FF8824
#define REG_PCON3_1			0x01FF8828
#define REG_PCNT3_1			0x01FF882C
#define REG_PPWM3_1			0x01FF8830
                   			
#define REG_PDAT3_2			0x01FF8840
#define REG_PPRE3_2			0x01FF8844
#define REG_PCON3_2			0x01FF8848
#define REG_PCNT3_2			0x01FF884C
#define REG_PPWM3_2			0x01FF8850
                   			
#define REG_PDAT3_3			0x01FF8860
#define REG_PPRE3_3			0x01FF8864
#define REG_PCON3_3			0x01FF8868
#define REG_PCNT3_3			0x01FF886C
#define REG_PPWM3_3			0x01FF8870
                   			
#define REG_PDAT3_4			0x01FF8880
#define REG_PPRE3_4			0x01FF8884
#define REG_PCON3_4			0x01FF8888
#define REG_PCNT3_4			0x01FF888C 
#define REG_PPWM3_4			0x01FF8890

#define REG_PDAT3_5			0x01FF88A0
#define REG_PPRE3_5			0x01FF88A4
#define REG_PCON3_5			0x01FF88A8
#define REG_PCNT3_5			0x01FF88AC
#define REG_PPWM3_5			0x01FF88B0
                   			
#define REG_PDAT3_6			0x01FF88C0
#define REG_PPRE3_6			0x01FF88C4
#define REG_PCON3_6			0x01FF88C8
#define REG_PCNT3_6			0x01FF88CC
#define REG_PPWM3_6			0x01FF88D0
                   			
#define REG_PDAT3_7			0x01FF88E0
#define REG_PPRE3_7			0x01FF88E4
#define REG_PCON3_7			0x01FF88E8
#define REG_PCNT3_7			0x01FF88EC
#define REG_PPWM3_7			0x01FF88F0
                   			
/* WDT */          			
#define REG_WDTCR  			0x01FF8900
#define REG_WDTPSR 			0x01FF8904
#define REG_WDTTLDR			0x01FF8908
#define REG_WDTVLR 			0x01FF890C
#define REG_WDTISR 			0x01FF8910

/* GPIO */
#define REG_GPIO_DAT0		0x01FF8A00 
#define REG_GPIO_DAT1		0x01FF8A04 
#define REG_GPIO_DAT2		0x01FF8A08 
#define REG_GPIO_DAT3		0x01FF8A0C 
#define REG_GPIO_CON0		0x01FF8A10 
#define REG_GPIO_CON1		0x01FF8A14 
#define REG_GPIO_CON2		0x01FF8A18 
#define REG_GPIO_CON3		0x01FF8A1C 

/* VIC */
#define REG_INTCON   		0x01FF8B00
#define REG_INTPND   		0x01FF8B04
#define REG_INTMOD   		0x01FF8B08
#define REG_INTMSK   		0x01FF8B0C
#define REG_LEVEL			0x01FF8B10 
#define REG_I_PSLV0  		0x01FF8B14
#define REG_I_PSLV1  		0x01FF8B18
#define REG_I_PSLV2  		0x01FF8B1C
#define REG_I_PSLV3  		0x01FF8B20
#define REG_I_PMST   		0x01FF8B24
#define REG_ICSLV0			0x01FF8B28
#define REG_ICSLV1			0x01FF8B2C
#define REG_ICSLV2			0x01FF8B30
#define REG_ICSLV3			0x01FF8B34
#define REG_I_CMST			0x01FF8B38
#define REG_I_ISPR			0x01FF8B3C
#define REG_I_ISPC			0x01FF8B40
#define REG_F_PSLV0  		0x01FF8B44
#define REG_F_PSLV1  		0x01FF8B48
#define REG_F_PSLV2  		0x01FF8B4C
#define REG_F_PSLV3  		0x01FF8B50
#define REG_F_PMST   		0x01FF8B54
#define REG_F_CSLV0  		0x01FF8B58
#define REG_F_CSLV1  		0x01FF8B5C
#define REG_F_CSLV2  		0x01FF8B60
#define REG_F_CSLV3  		0x01FF8B64
#define REG_F_CMST   		0x01FF8B68
#define REG_F_ISPR			0x01FF8B6C
#define REG_F_ISPC			0x01FF8B70
#define REG_POLARITY 		0x01FF8B74  
#define REG_I_VECADDR		0x01FF8B78 
#define REG_F_VECADDR		0x01FF8B7C 

/* ADC */
#define REG_ADCCON			0x01FF8C00
#define REG_ADCDAT			0x01FF8C04
                  			
/* Power */       			
#define REG_SYSCON			0x01FF8D00 
#define REG_PWMCON			0x01FF8D04 
                  			
#define REG_DEVID 			0x01FF8D08  

/*/////////////////////////////////////////////////////////
        STRUCTURE DEFINITION
///////////////////////////////////////////////////////// */
typedef enum {
    READ_ONLY,
    WRITE_ONLY,
    READ_WRITE
} ACCESS_TYPE;

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

smtBoolean RegisterFMC(void);
smtBoolean RegisterESMC(void);
smtBoolean RegisterUART(void);
smtBoolean RegisterI2C(void);
smtBoolean RegisterTimer(void);
smtBoolean RegisterPWM(void);
smtBoolean RegisterWDT(void);
smtBoolean RegisterGPIO(void);
smtBoolean RegisterVIC(void);
smtBoolean RegisterADC(void);
smtBoolean RegisterPower(void);

smtBoolean RegisterRangeCheck(smtUint32 pRegList[][3], smtUint32 data);
smtBoolean RegisterCheck(smtUint32 registerNum, smtUint32 data, smtUint32 bitmask);

#endif /* __REGISTER_H__ */
