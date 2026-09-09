/*----------------------------------------------------------
    File Name   : sysreg.h
    Description : Special function register definition using ARM7TDMI core
-----------------------------------------------------------*/

#ifndef __SDI_V5_H__
#define __SDI_V5_H__

#ifdef __cplusplus
extern "C" {
#endif

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "syscfg.h"

/*/////////////////////////////////////////////////////////
        REGISTER DEFINITION
///////////////////////////////////////////////////////// */

/* Internal flash */
#define FMKEY               (*(volatile unsigned *)0x01FF8000)
#define FMADDR              (*(volatile unsigned *)0x01FF8004)
#define FMDATA              (*(volatile unsigned *)0x01FF8008)
#define FMUCON              (*(volatile unsigned *)0x01FF800C)
#define FSO                 (*(volatile unsigned *)0x01FF8010)
#define FPO                 (*(volatile unsigned *)0x01FF8014)

#define FMTNV               (*(volatile unsigned *)0x01FF8020)
#define FMTPG               (*(volatile unsigned *)0x01FF8024)
#define FMTRCV              (*(volatile unsigned *)0x01FF8028)
#define FMTPROG             (*(volatile unsigned *)0x01FF802C)
#define FMTERASE            (*(volatile unsigned *)0x01FF8030)
#define FMTME               (*(volatile unsigned *)0x01FF8034)

/* External sram */
#define ESMC_B0_CON     	(*(volatile unsigned *)0x01FF8100)
#define ESMC_B1_CON     	(*(volatile unsigned *)0x01FF8104)
#define ESMC_B2_CON     	(*(volatile unsigned *)0x01FF8108)
#define ESMC_B3_CON     	(*(volatile unsigned *)0x01FF810C)

/* UART */
#define UARTDR              (*(volatile unsigned *)0x01FF8200)
#define UARTSR              (*(volatile unsigned *)0x01FF8204)
#define UARTFR              (*(volatile unsigned *)0x01FF8218)
#define UARTILPR            (*(volatile unsigned *)0x01FF8220)
#define UARTIBRD            (*(volatile unsigned *)0x01FF8224)
#define UARTFBRD            (*(volatile unsigned *)0x01FF8228)
#define UARTLCR_H           (*(volatile unsigned *)0x01FF822C)
#define UARTCR              (*(volatile unsigned *)0x01FF8230)
#define UARTIFLS            (*(volatile unsigned *)0x01FF8234)
#define UARTIMSC            (*(volatile unsigned *)0x01FF8238)
#define UARTRIS             (*(volatile unsigned *)0x01FF823C)
#define UARTMIS             (*(volatile unsigned *)0x01FF8240)
#define UARTICR             (*(volatile unsigned *)0x01FF8244)
#define UARTDMACR       	(*(volatile unsigned *)0x01FF8248)

/* IIC0 */
#define ICCR0_0             (*(volatile unsigned *)0x01FF8300)
#define ICSR0               (*(volatile unsigned *)0x01FF8304)
#define IAR0                (*(volatile unsigned *)0x01FF8308)
#define IDSR0               (*(volatile unsigned *)0x01FF830C)
#define ICCR0_1             (*(volatile unsigned *)0x01FF8310)
#define I2C0_SRST        	(*(volatile unsigned *)0x01FF8314)

/* IIC1 */
#define ICCR1_0             (*(volatile unsigned *)0x01FF8380)
#define ICSR1               (*(volatile unsigned *)0x01FF8384)
#define IAR1                (*(volatile unsigned *)0x01FF8388)
#define IDSR1               (*(volatile unsigned *)0x01FF838C)
#define ICCR1_1             (*(volatile unsigned *)0x01FF8390)
#define I2C1_SRST        	(*(volatile unsigned *)0x01FF8394)

/* Timer0 */
#define TDAT0               (*(volatile unsigned *)0x01FF8400)
#define TPRE0               (*(volatile unsigned *)0x01FF8404)
#define TCON0               (*(volatile unsigned *)0x01FF8408)
#define TCNT0               (*(volatile unsigned *)0x01FF840C)
#define TPWM0               (*(volatile unsigned *)0x01FF8410)

/* Timer1 */
#define TDAT1               (*(volatile unsigned *)0x01FF8420)
#define TPRE1               (*(volatile unsigned *)0x01FF8424)
#define TCON1               (*(volatile unsigned *)0x01FF8428)
#define TCNT1               (*(volatile unsigned *)0x01FF842C)
#define TPWM1               (*(volatile unsigned *)0x01FF8430)

/* Timer2 */
#define TDAT2               (*(volatile unsigned *)0x01FF8440)
#define TPRE2               (*(volatile unsigned *)0x01FF8444)
#define TCON2               (*(volatile unsigned *)0x01FF8448)
#define TCNT2               (*(volatile unsigned *)0x01FF844C)
#define TPWM2               (*(volatile unsigned *)0x01FF8450)

/* Timer3 */
#define TDAT3               (*(volatile unsigned *)0x01FF8460)
#define TPRE3               (*(volatile unsigned *)0x01FF8464)
#define TCON3               (*(volatile unsigned *)0x01FF8468)
#define TCNT3               (*(volatile unsigned *)0x01FF846C)
#define TPWM3               (*(volatile unsigned *)0x01FF8470)

/* Timer4 */
#define TDAT4               (*(volatile unsigned *)0x01FF8480)
#define TPRE4               (*(volatile unsigned *)0x01FF8484)
#define TCON4               (*(volatile unsigned *)0x01FF8488)
#define TCNT4               (*(volatile unsigned *)0x01FF848C)
#define TPWM4               (*(volatile unsigned *)0x01FF8490)

/* Timer5 */
#define TDAT5               (*(volatile unsigned *)0x01FF84A0)
#define TPRE5               (*(volatile unsigned *)0x01FF84A4)
#define TCON5               (*(volatile unsigned *)0x01FF84A8)
#define TCNT5               (*(volatile unsigned *)0x01FF84AC)
#define TPWM5               (*(volatile unsigned *)0x01FF84B0)

/* Timer6 */
#define TDAT6               (*(volatile unsigned *)0x01FF84C0)
#define TPRE6               (*(volatile unsigned *)0x01FF84C4)
#define TCON6               (*(volatile unsigned *)0x01FF84C8)
#define TCNT6               (*(volatile unsigned *)0x01FF84CC)
#define TPWM6               (*(volatile unsigned *)0x01FF84D0)

/* Timer7 */
#define TDAT7               (*(volatile unsigned *)0x01FF84E0)
#define TPRE7               (*(volatile unsigned *)0x01FF84E4)
#define TCON7               (*(volatile unsigned *)0x01FF84E8)
#define TCNT7               (*(volatile unsigned *)0x01FF84EC)
#define TPWM7               (*(volatile unsigned *)0x01FF84F0)

/* PWM 0-0 */
#define PDAT0_0         	(*(volatile unsigned *)0x01FF8500)
#define PPRE0_0         	(*(volatile unsigned *)0x01FF8504)
#define PCON0_0         	(*(volatile unsigned *)0x01FF8508)
#define PCNT0_0         	(*(volatile unsigned *)0x01FF850C)
#define PPWM0_0         	(*(volatile unsigned *)0x01FF8510)
                        	
/* PWM 0-1 */           	
#define PDAT0_1         	(*(volatile unsigned *)0x01FF8520)
#define PPRE0_1         	(*(volatile unsigned *)0x01FF8524)
#define PCON0_1         	(*(volatile unsigned *)0x01FF8528)
#define PCNT0_1         	(*(volatile unsigned *)0x01FF852C)
#define PPWM0_1         	(*(volatile unsigned *)0x01FF8530)
                        	
/* PWM 0-2 */           	
#define PDAT0_2         	(*(volatile unsigned *)0x01FF8540)
#define PPRE0_2         	(*(volatile unsigned *)0x01FF8544)
#define PCON0_2         	(*(volatile unsigned *)0x01FF8548)
#define PCNT0_2         	(*(volatile unsigned *)0x01FF854C)
#define PPWM0_2         	(*(volatile unsigned *)0x01FF8550)
                        	
/* PWM 0-3 */           	
#define PDAT0_3         	(*(volatile unsigned *)0x01FF8560)
#define PPRE0_3         	(*(volatile unsigned *)0x01FF8564)
#define PCON0_3         	(*(volatile unsigned *)0x01FF8568)
#define PCNT0_3         	(*(volatile unsigned *)0x01FF856C)
#define PPWM0_3         	(*(volatile unsigned *)0x01FF8570)

/* PWM 0-4 */
#define PDAT0_4         	(*(volatile unsigned *)0x01FF8580)
#define PPRE0_4         	(*(volatile unsigned *)0x01FF8584)
#define PCON0_4         	(*(volatile unsigned *)0x01FF8588)
#define PCNT0_4         	(*(volatile unsigned *)0x01FF858C)
#define PPWM0_4         	(*(volatile unsigned *)0x01FF8590)
                        	
/* PWM 0-5 */           	
#define PDAT0_5         	(*(volatile unsigned *)0x01FF85A0)
#define PPRE0_5         	(*(volatile unsigned *)0x01FF85A4)
#define PCON0_5         	(*(volatile unsigned *)0x01FF85A8)
#define PCNT0_5         	(*(volatile unsigned *)0x01FF85AC)
#define PPWM0_5         	(*(volatile unsigned *)0x01FF85B0)
                        	
/* PWM 0-6 */           	
#define PDAT0_6         	(*(volatile unsigned *)0x01FF85C0)
#define PPRE0_6         	(*(volatile unsigned *)0x01FF85C4)
#define PCON0_6         	(*(volatile unsigned *)0x01FF85C8)
#define PCNT0_6         	(*(volatile unsigned *)0x01FF85CC)
#define PPWM0_6         	(*(volatile unsigned *)0x01FF85D0)
                        	
/* PWM 0-7 */           	
#define PDAT0_7         	(*(volatile unsigned *)0x01FF85E0)
#define PPRE0_7         	(*(volatile unsigned *)0x01FF85E4)
#define PCON0_7         	(*(volatile unsigned *)0x01FF85E8)
#define PCNT0_7         	(*(volatile unsigned *)0x01FF85EC)
#define PPWM0_7         	(*(volatile unsigned *)0x01FF85F0)
                        	
/* PWM 1-0 */           	
#define PDAT1_0         	(*(volatile unsigned *)0x01FF8600)
#define PPRE1_0         	(*(volatile unsigned *)0x01FF8604)
#define PCON1_0         	(*(volatile unsigned *)0x01FF8608)
#define PCNT1_0         	(*(volatile unsigned *)0x01FF860C)
#define PPWM1_0         	(*(volatile unsigned *)0x01FF8610)

/* PWM 1-1 */
#define PDAT1_1         	(*(volatile unsigned *)0x01FF8620)
#define PPRE1_1         	(*(volatile unsigned *)0x01FF8624)
#define PCON1_1         	(*(volatile unsigned *)0x01FF8628)
#define PCNT1_1         	(*(volatile unsigned *)0x01FF862C)
#define PPWM1_1         	(*(volatile unsigned *)0x01FF8630)
                        	
/* PWM 1-2 */           	
#define PDAT1_2         	(*(volatile unsigned *)0x01FF8640)
#define PPRE1_2         	(*(volatile unsigned *)0x01FF8644)
#define PCON1_2         	(*(volatile unsigned *)0x01FF8648)
#define PCNT1_2         	(*(volatile unsigned *)0x01FF864C)
#define PPWM1_2         	(*(volatile unsigned *)0x01FF8650)
                        	
/* PWM 1-3 */           	
#define PDAT1_3         	(*(volatile unsigned *)0x01FF8660)
#define PPRE1_3         	(*(volatile unsigned *)0x01FF8664)
#define PCON1_3         	(*(volatile unsigned *)0x01FF8668)
#define PCNT1_3         	(*(volatile unsigned *)0x01FF866C)
#define PPWM1_3         	(*(volatile unsigned *)0x01FF8670)
                        	
/* PWM 1-4 */           	
#define PDAT1_4         	(*(volatile unsigned *)0x01FF8680)
#define PPRE1_4         	(*(volatile unsigned *)0x01FF8684)
#define PCON1_4         	(*(volatile unsigned *)0x01FF8688)
#define PCNT1_4         	(*(volatile unsigned *)0x01FF868C)
#define PPWM1_4         	(*(volatile unsigned *)0x01FF8690)
                        	
/* PWM 1-5 */           	
#define PDAT1_5         	(*(volatile unsigned *)0x01FF86A0)
#define PPRE1_5         	(*(volatile unsigned *)0x01FF86A4)
#define PCON1_5         	(*(volatile unsigned *)0x01FF86A8)
#define PCNT1_5         	(*(volatile unsigned *)0x01FF86AC)
#define PPWM1_5         	(*(volatile unsigned *)0x01FF86B0)
                        	
/* PWM 1-6 */           	
#define PDAT1_6         	(*(volatile unsigned *)0x01FF86C0)
#define PPRE1_6         	(*(volatile unsigned *)0x01FF86C4)
#define PCON1_6         	(*(volatile unsigned *)0x01FF86C8)
#define PCNT1_6         	(*(volatile unsigned *)0x01FF86CC)
#define PPWM1_6         	(*(volatile unsigned *)0x01FF86D0)

/* PWM 1-7 */
#define PDAT1_7         	(*(volatile unsigned *)0x01FF86E0)
#define PPRE1_7         	(*(volatile unsigned *)0x01FF86E4)
#define PCON1_7         	(*(volatile unsigned *)0x01FF86E8)
#define PCNT1_7         	(*(volatile unsigned *)0x01FF86EC)
#define PPWM1_7         	(*(volatile unsigned *)0x01FF86F0)
                        	
/* PWM 2-0 */           	
#define PDAT2_0         	(*(volatile unsigned *)0x01FF8700)
#define PPRE2_0         	(*(volatile unsigned *)0x01FF8704)
#define PCON2_0         	(*(volatile unsigned *)0x01FF8708)
#define PCNT2_0         	(*(volatile unsigned *)0x01FF870C)
#define PPWM2_0         	(*(volatile unsigned *)0x01FF8710)
                        	
/* PWM 2-1 */           	
#define PDAT2_1         	(*(volatile unsigned *)0x01FF8720)
#define PPRE2_1         	(*(volatile unsigned *)0x01FF8724)
#define PCON2_1         	(*(volatile unsigned *)0x01FF8728)
#define PCNT2_1         	(*(volatile unsigned *)0x01FF872C)
#define PPWM2_1         	(*(volatile unsigned *)0x01FF8730)
                        	
/* PWM 2-2 */           	
#define PDAT2_2         	(*(volatile unsigned *)0x01FF8740)
#define PPRE2_2         	(*(volatile unsigned *)0x01FF8744)
#define PCON2_2         	(*(volatile unsigned *)0x01FF8748)
#define PCNT2_2         	(*(volatile unsigned *)0x01FF874C)
#define PPWM2_2         	(*(volatile unsigned *)0x01FF8750)
                        	
/* PWM 2-3 */           	
#define PDAT2_3         	(*(volatile unsigned *)0x01FF8760)
#define PPRE2_3         	(*(volatile unsigned *)0x01FF8764)
#define PCON2_3         	(*(volatile unsigned *)0x01FF8768)
#define PCNT2_3         	(*(volatile unsigned *)0x01FF876C)
#define PPWM2_3         	(*(volatile unsigned *)0x01FF8770)

/* PWM 2-4 */
#define PDAT2_4         	(*(volatile unsigned *)0x01FF8780)
#define PPRE2_4         	(*(volatile unsigned *)0x01FF8784)
#define PCON2_4         	(*(volatile unsigned *)0x01FF8788)
#define PCNT2_4         	(*(volatile unsigned *)0x01FF878C)
#define PPWM2_4         	(*(volatile unsigned *)0x01FF8790)
                        	
/* PWM 2-5 */           	
#define PDAT2_5         	(*(volatile unsigned *)0x01FF87A0)
#define PPRE2_5         	(*(volatile unsigned *)0x01FF87A4)
#define PCON2_5         	(*(volatile unsigned *)0x01FF87A8)
#define PCNT2_5         	(*(volatile unsigned *)0x01FF87AC)
#define PPWM2_5         	(*(volatile unsigned *)0x01FF87B0)
                        	
/* PWM 2-6 */           	
#define PDAT2_6         	(*(volatile unsigned *)0x01FF87C0)
#define PPRE2_6         	(*(volatile unsigned *)0x01FF87C4)
#define PCON2_6         	(*(volatile unsigned *)0x01FF87C8)
#define PCNT2_6         	(*(volatile unsigned *)0x01FF87CC)
#define PPWM2_6         	(*(volatile unsigned *)0x01FF87D0)
                        	
/* PWM 2-7 */           	
#define PDAT2_7         	(*(volatile unsigned *)0x01FF87E0)
#define PPRE2_7         	(*(volatile unsigned *)0x01FF87E4)
#define PCON2_7         	(*(volatile unsigned *)0x01FF87E8)
#define PCNT2_7         	(*(volatile unsigned *)0x01FF87EC)
#define PPWM2_7         	(*(volatile unsigned *)0x01FF87F0)
                        	
/* PWM 3-0 */           	
#define PDAT3_0         	(*(volatile unsigned *)0x01FF8800)
#define PPRE3_0         	(*(volatile unsigned *)0x01FF8804)
#define PCON3_0         	(*(volatile unsigned *)0x01FF8808)
#define PCNT3_0         	(*(volatile unsigned *)0x01FF880C)
#define PPWM3_0         	(*(volatile unsigned *)0x01FF8810)

/* PWM 3-1 */
#define PDAT3_1         	(*(volatile unsigned *)0x01FF8820)
#define PPRE3_1         	(*(volatile unsigned *)0x01FF8824)
#define PCON3_1         	(*(volatile unsigned *)0x01FF8828)
#define PCNT3_1         	(*(volatile unsigned *)0x01FF882C)
#define PPWM3_1         	(*(volatile unsigned *)0x01FF8830)
                        	
/* PWM 3-2 */           	
#define PDAT3_2         	(*(volatile unsigned *)0x01FF8840)
#define PPRE3_2         	(*(volatile unsigned *)0x01FF8844)
#define PCON3_2         	(*(volatile unsigned *)0x01FF8848)
#define PCNT3_2         	(*(volatile unsigned *)0x01FF884C)
#define PPWM3_2         	(*(volatile unsigned *)0x01FF8850)
                        	
/* PWM 3-3 */           	
#define PDAT3_3         	(*(volatile unsigned *)0x01FF8860)
#define PPRE3_3         	(*(volatile unsigned *)0x01FF8864)
#define PCON3_3         	(*(volatile unsigned *)0x01FF8868)
#define PCNT3_3         	(*(volatile unsigned *)0x01FF886C)
#define PPWM3_3         	(*(volatile unsigned *)0x01FF8870)
                        	
/* PWM 3-4 */           	
#define PDAT3_4         	(*(volatile unsigned *)0x01FF8880)
#define PPRE3_4         	(*(volatile unsigned *)0x01FF8884)
#define PCON3_4         	(*(volatile unsigned *)0x01FF8888)
#define PCNT3_4         	(*(volatile unsigned *)0x01FF888C)
#define PPWM3_4         	(*(volatile unsigned *)0x01FF8890)
                        	
/* PWM 3-5 */           	
#define PDAT3_5         	(*(volatile unsigned *)0x01FF88A0)
#define PPRE3_5         	(*(volatile unsigned *)0x01FF88A4)
#define PCON3_5         	(*(volatile unsigned *)0x01FF88A8)
#define PCNT3_5         	(*(volatile unsigned *)0x01FF88AC)
#define PPWM3_5         	(*(volatile unsigned *)0x01FF88B0)

/* PWM 3-6 */
#define PDAT3_6         	(*(volatile unsigned *)0x01FF88C0)
#define PPRE3_6         	(*(volatile unsigned *)0x01FF88C4)
#define PCON3_6         	(*(volatile unsigned *)0x01FF88C8)
#define PCNT3_6         	(*(volatile unsigned *)0x01FF88CC)
#define PPWM3_6         	(*(volatile unsigned *)0x01FF88D0)
                        	
/* PWM 3-7 */           	
#define PDAT3_7         	(*(volatile unsigned *)0x01FF88E0)
#define PPRE3_7         	(*(volatile unsigned *)0x01FF88E4)
#define PCON3_7         	(*(volatile unsigned *)0x01FF88E8)
#define PCNT3_7         	(*(volatile unsigned *)0x01FF88EC)
#define PPWM3_7         	(*(volatile unsigned *)0x01FF88F0)
                        	
/* WDT */               	
#define WDTCR           	(*(volatile unsigned *)0x01FF8900)
#define WDTPSR          	(*(volatile unsigned *)0x01FF8904)
#define WDTTLDR         	(*(volatile unsigned *)0x01FF8908)
#define WDTVLR          	(*(volatile unsigned *)0x01FF890C)
#define WDTISR          	(*(volatile unsigned *)0x01FF8910)
                        	
/* GPIO */              	
#define GPIO_DAT0       	(*(volatile unsigned *)0x01FF8A00)
#define GPIO_DAT1       	(*(volatile unsigned *)0x01FF8A04)
#define GPIO_DAT2       	(*(volatile unsigned *)0x01FF8A08)
#define GPIO_DAT3       	(*(volatile unsigned *)0x01FF8A0C)
#define GPIO_CON0       	(*(volatile unsigned *)0x01FF8A10)
#define GPIO_CON1       	(*(volatile unsigned *)0x01FF8A14)
#define GPIO_CON2       	(*(volatile unsigned *)0x01FF8A18)
#define GPIO_CON3       	(*(volatile unsigned *)0x01FF8A1C)

/* Interrupt */
#define INTCON              (*(volatile unsigned *)0x01FF8B00)
#define INTPND              (*(volatile unsigned *)0x01FF8B04)
#define INTMOD              (*(volatile unsigned *)0x01FF8B08)
#define INTMSK              (*(volatile unsigned *)0x01FF8B0C)
#define LEVEL               (*(volatile unsigned *)0x01FF8B10)
#define I_PSLV0             (*(volatile unsigned *)0x01FF8B14)
#define I_PSLV1             (*(volatile unsigned *)0x01FF8B18)
#define I_PSLV2             (*(volatile unsigned *)0x01FF8B1C)
#define I_PSLV3             (*(volatile unsigned *)0x01FF8B20)
#define F_PSLV0             (*(volatile unsigned *)0x01FF8B44)  
#define F_PSLV1             (*(volatile unsigned *)0x01FF8B48)
#define F_PSLV2             (*(volatile unsigned *)0x01FF8B4C)
#define F_PSLV3             (*(volatile unsigned *)0x01FF8B50)
#define I_PMST              (*(volatile unsigned *)0x01FF8B24)
#define F_PMST              (*(volatile unsigned *)0x01FF8B54)
#define ICSLV0              (*(volatile unsigned *)0x01FF8B28)
#define ICSLV1              (*(volatile unsigned *)0x01FF8B2C)
#define ICSLV2              (*(volatile unsigned *)0x01FF8B30)
#define ICSLV3              (*(volatile unsigned *)0x01FF8B34)
#define F_CSLV0             (*(volatile unsigned *)0x01FF8B58)
#define F_CSLV1             (*(volatile unsigned *)0x01FF8B5C)
#define F_CSLV2             (*(volatile unsigned *)0x01FF8B60)
#define F_CSLV3             (*(volatile unsigned *)0x01FF8B64)
#define I_CMST              (*(volatile unsigned *)0x01FF8B38)
#define F_CMST              (*(volatile unsigned *)0x01FF8B68)
#define I_ISPR              (*(volatile unsigned *)0x01FF8B3C)
#define F_ISPR              (*(volatile unsigned *)0x01FF8B6C)
#define I_ISPC              (*(volatile unsigned *)0x01FF8B40)
#define F_ISPC              (*(volatile unsigned *)0x01FF8B70)
#define POLARITY            (*(volatile unsigned *)0x01FF8B74)
#define I_VECADDR       	(*(volatile unsigned *)0x01FF8B78)
#define F_VECADDR       	(*(volatile unsigned *)0x01FF8B7C)

/* ADC */
#define ADCCON          	(*(volatile unsigned *)0x01FF8C00)
#define ADCDAT          	(*(volatile unsigned *)0x01FF8C04)

/* Power */
#define SYSCON          	(*(volatile unsigned *)0x01FF8D00)
#define PWMCON          	(*(volatile unsigned *)0x01FF8D04)

#define DEVID               (*(volatile unsigned *)0x01FF8D08)



/*  Further work - Endian ordering  (2006/02/27)
// UART
#ifdef __BIG_ENDIAN
	#define rUTXH0		(*(volatile unsigned char *)0x1D00023)

#else //Little Endian
	#define rUTXH0		(*(volatile unsigned char *)0x1D00020)
#endif

// IIS
#ifdef __BIG_ENDIAN
#define rIISFIF		((volatile unsigned short *)0x1D18012)
#else //Little Endian
#define rIISFIF		((volatile unsigned short *)0x1D18010)
#endif

// RTC
#ifdef __BIG_ENDIAN
	#define rRTCCON		(*(volatile unsigned char *)0x1d70043)
 #else
	#define rRTCCON     (*(volatile unsigned char *)0x1d70040)
 #endif
*/

/*/////////////////////////////////////////////////////////
        REGISTER MASK DEFINITION
///////////////////////////////////////////////////////// */

/* Internal flash*/
// FMUCON register
#define UCERSR_EN          	(0x1UL)<<0
#define USERSR_EN          	(0x1UL)<<1
#define UPGMR_EN           	(0x1UL)<<2
#define UCPUH_EN           	(0x1UL)<<3
#define UOPGMR_EN          	(0x1UL)<<5
#define USTRSTPT           	(0x1UL)<<6
#define UOSCEN_EN          	(0x1UL)<<7
#define WAIT_REG           	(0x3UL)<<8

#define FSO_MASK            (0xffffUL)<<0
#define FPO_MASK            (0xffffUL)<<0

#define FM_KEYVALUE     	(0x5a5a5a5a)<<0

#define FM_PROTECT_HW   	(0x1)<<17
#define FM_PROTECT_RD   	(0x1)<<27
#define PROTECTION_OPT  	0x0e3c
#define SMART_OPT           0x0e38


/* External sram */
// SMC_Bx_CON register
#define TACSR_MASK          (0x3UL)<<26
#define TCOSR_MASK          (0x3UL)<<24
#define TACCR_MASK          (0xfUL)<<20
#define TCOHR_MASK          (0x3UL)<<18

#define TACSW_MASK          (0x3UL)<<10
#define TCOSW_MASK          (0x3UL)<<8
#define TACCW_MASK          (0xfUL)<<4
#define TCOHW_MASK          (0x3UL)<<2

#define SHIFT_MASK          (0x1UL)<<1
#define WIDTH_MASK          (0x1UL)<<0


/* UART */
// UART_DR register
#define DR_OVERRUN_ERR  	(0x1UL)<<11
#define DR_BREAK_ERR    	(0x1UL)<<10
#define DR_PARITY_ERR   	(0x1UL)<<9
#define DR_FRAMING_ERR  	(0x1UL)<<8
#define DR_DATA             (0xffUL)<<0

// UARTRSR register
#define RSR_OVERUN_ERR  	(0x1UL)<<3
#define RSR_BREAK_ERR  		(0x1UL)<<2
#define RSR_PARITY_ERR  	(0x1UL)<<1
#define RSR_FRAMING_ERR  	(0x1UL)<<0

// UARTFR register
#define RING_INDICATOR  	(0x1UL)<<8
#define TXFIFO_EMPTY    	(0x1UL)<<7
#define RXFIFO_FULL     	(0x1UL)<<6
#define TXFIFO_FULL     	(0x1UL)<<5
#define RXFIFO_EMPTY    	(0x1UL)<<4
#define UART_BUSY       	(0x1UL)<<3
#define CARRIER_DETECT  	(0x1UL)<<2
#define SET_RETRY       	(0x1UL)<<1
#define CLEAR_TO_SEND  		(0x1UL)<<0

// UARTLCR_H register
#define STICK_PAR_SEL   	(0x1UL)<<7
#define WORD_LENGTH     	(0x3UL)<<5
#define EN_FIFO         	(0x1UL)<<4
#define T_STOP_BIT_SEL  	(0x1UL)<<3
#define EVEN_PARITY_SEL 	(0x1UL)<<2
#define PARITY_EN       	(0x1UL)<<1
#define SEND_BREAK      	(0x1UL)<<0

// UARTCR register
#define CTS_HW_FLOW 		(0x1UL)<<15
#define RTS_HW_FLOW 		(0x1UL)<<14
#define OUT2                (0x1UL)<<13
#define OUT1                (0x1UL)<<12
#define REQ_TO_SEND 		(0x1UL)<<11
#define DATA_TX_READY   	(0x1UL)<<10
#define RX_EN               (0x1UL)<<9
#define TX_EN               (0x1UL)<<8
#define LOOP_BACK_EN    	(0x1UL)<<7
#define UART_EN         	(0x1UL)<<0

// UARTFLS register
#define RX_INTERRUPT_LEVEL  (0x7UL)<<3
#define TX_INTERRUPT_LEVEL  (0x7UL)<<0

// UARTMSC & RIS & MIS & ICR register
#define OVERRUN_ERR_MASK 	(0x1UL)<<10
#define BREAK_ERR_MASK   	(0x1UL)<<9
#define PARITY_ERR_MASK  	(0x1UL)<<8
#define FRAMING_ERR_MASK 	(0x1UL)<<7
#define RX_TIMEOUT          (0x1UL)<<6
#define TX_INTERRUPT_MASK   (0x1UL)<<5
#define RX_INTERRUPT_MASK   (0x1UL)<<4
#define DSR_INTERRUPT_MASK  (0x1UL)<<3
#define DCD_INTERRUPT_MASK  (0x1UL)<<2
#define CTS_INTERRUPT_MASK  (0x1UL)<<1
#define RI_INTERRUPT_MASK   (0x1UL)<<0


/* I2C */
// ICCR0 register
#define ACK_EN          	(0x1UL)<<7
#define TX_CLK_SEL      	(0x1UL)<<6
#define INTERRUPT_EN    	(0x1UL)<<5
#define INTR_PENDING_FLAG   (0x1UL)<<4
#define TX_CLK_VALUE        (0xfUL)<<0

// ICCR1 register
#define HIGH_SPEED_CYCLE    (0x3fUL)<<0

// ICSR register
#define I2C_MODE_SEL        (0x3UL)<<6
#define TXRX_EN             (0x1UL)<<6
#define I2C_START           (0x1UL)<<5
//#define TXRX_EN             (0x1UL)<<4
//#define ARBITOR_FLAG        (0x1UL)<<3
//#define START_BIT           (0x1UL)<<2
//#define ZERO_ADDR_FLAG  	(0x1UL)<<1
//#define LAST_RX_BIT_FLAG    (0x1UL)<<0

// IAR register
#define SLAVE_ADDR_MASK 	(0x7fUL)<<1
// IDSR register        	        
#define DATA_SHIFT_MASK 	(0xffUL)<<0
                                
                                
/* Timer & PWM */               
// Control register             
#define TIMER_PHASE_INVERT_SEL  (0x1UL)<<1
#define TIMER_IN_CLK_SEL        (0x1UL)<<2
#define TIMER_OP_MODE_SEL       (0x7UL)<<3
#define TIMER_CNT_CLR           (0x1UL)<<6
#define TIMER_EN                (0x1UL)<<7

#define TDAT_START       	(0x01FF8400)
#define TPRE_START       	(0x01FF8404)
#define TCON_START       	(0x01FF8408)
#define TCNT_START       	(0x01FF840C)
#define TPWM_START       	(0x01FF8410)


/* WDT */
// WDTCR register
#define WDT_DIV_SEL 		(0x3UL)<<4
#define WDT_CLKSEL  		(0x1UL)<<3
#define WDT_INTEN   		(0x1UL)<<2
#define WDT_RSTEN   		(0x1UL)<<1
#define WDT_EN      		(0x1UL)<<0

// WDTISR register
#define WDTISR_FLAG (0x1UL)<<0


/* GPIO */
#define GPIO_0  			(0x3UL)<<0
#define GPIO_1  			(0x3UL)<<2
#define GPIO_2  			(0x3UL)<<4
#define GPIO_3  			(0x3UL)<<6
#define GPIO_4  			(0x3UL)<<8
#define GPIO_5  			(0x3UL)<<10
#define GPIO_6  			(0x3UL)<<12
#define GPIO_7  			(0x3UL)<<14


/* Interrupt */
// INTCON register
#define INT_GIE_EN  		(0x1UL)<<3
#define INT_VECT_EN 		(0x1UL)<<2
#define INT_IRQ_EN  		(0x1UL)<<1
#define INT_FIQ_EN  		(0x1UL)<<0

#define IRQ_EINT0      		0
#define IRQ_EINT1      		1
#define IRQ_EINT2      		2
#define IRQ_EINT3      		3
#define IRQ_I2C0       		4
#define IRQ_I2C0_AAS   		5
#define IRQ_TIMER0_TOF 		6
#define IRQ_TIMER0_TMC 		7
#define IRQ_TIMER1_TOF 		8
#define IRQ_TIMER1_TMC 		9
                       		
#define IRQ_TIMER2_TOF 		10
#define IRQ_TIMER2_TMC 		11
#define IRQ_EINT4      		12
#define IRQ_EINT5      		13
#define IRQ_EINT6      		14
#define IRQ_EINT7      		15
#define IRQ_I2C1       		16
#define IRQ_I2C1_AAS   		17
#define IRQ_WDT        		18
#define IRQ_ADC        		19
                       		
#define IRQ_UARTRX     		20
#define IRQ_UARTTX     		21
#define IRQ_TIMER3_TOF 		22
#define IRQ_TIMER3_TMC 		23
#define IRQ_TIMER4_TOF 		24
#define IRQ_TIMER4_TMC 		25
#define IRQ_TIMER5_TOF 		26
#define IRQ_TIMER5_TMC 		27
#define IRQ_TIMER6_TOF 		28
#define IRQ_TIMER6_TMC 		29
                       		
#define IRQ_TIMER7_TOF 		30
#define IRQ_TIMER7_TMC 		31

// INTPNC & INTMOD & INTMASK register
#define INT_EINT0_MASK      	((0x1UL)<<IRQ_EINT0)
#define INT_EINT1_MASK      	((0x1UL)<<IRQ_EINT1)
#define INT_EINT2_MASK      	((0x1UL)<<IRQ_EINT2)
#define INT_EINT3_MASK      	((0x1UL)<<IRQ_EINT3)
#define INT_I2C0_MASK       	((0x1UL)<<IRQ_I2C0)
#define INT_I2C0_AAS_MASK   	((0x1UL)<<IRQ_I2C0_AAS)
#define INT_TIMER0_TOF_MASK 	((0x1UL)<<IRQ_TIMER0_TOF)
#define INT_TIMER0_TMC_MASK 	((0x1UL)<<IRQ_TIMER0_TMC)
#define INT_TIMER1_TOF_MASK 	((0x1UL)<<IRQ_TIMER1_TOF)
#define INT_TIMER1_TMC_MASK 	((0x1UL)<<IRQ_TIMER1_TMC)
                            	
#define INT_TIMER2_TOF_MASK 	((0x1UL)<<IRQ_TIMER2_TOF)
#define INT_TIMER2_TMC_MASK 	((0x1UL)<<IRQ_TIMER2_TMC)
#define INT_EINT4_MASK      	((0x1UL)<<IRQ_EINT4)
#define INT_EINT5_MASK      	((0x1UL)<<IRQ_EINT5)
#define INT_EINT6_MASK      	((0x1UL)<<IRQ_EINT6)
#define INT_EINT7_MASK      	((0x1UL)<<IRQ_EINT7)
#define INT_I2C1_MASK       	((0x1UL)<<IRQ_I2C1)
#define INT_I2C1_AAS_MASK   	((0x1UL)<<IRQ_I2C1_AAS)
#define INT_WDT_MASK        	((0x1UL)<<IRQ_WDT)
#define INT_ADC_MASK        	((0x1UL)<<IRQ_ADC)
                            	
#define INT_UARTRX_MASK     	((0x1UL)<<IRQ_UARTRX)
#define INT_UARTTX_MASK     	((0x1UL)<<IRQ_UARTTX)
#define INT_TIMER3_TOF_MASK 	((0x1UL)<<IRQ_TIMER3_TOF)
#define INT_TIMER3_TMC_MASK 	((0x1UL)<<IRQ_TIMER3_TMC)
#define INT_TIMER4_TOF_MASK 	((0x1UL)<<IRQ_TIMER4_TOF)
#define INT_TIMER4_TMC_MASK 	((0x1UL)<<IRQ_TIMER4_TMC)
#define INT_TIMER5_TOF_MASK 	((0x1UL)<<IRQ_TIMER5_TOF)
#define INT_TIMER5_TMC_MASK 	((0x1UL)<<IRQ_TIMER5_TMC)
#define INT_TIMER6_TOF_MASK 	((0x1UL)<<IRQ_TIMER6_TOF)
#define INT_TIMER6_TMC_MASK 	((0x1UL)<<IRQ_TIMER6_TMC)
                            	
#define INT_TIMER7_TOF_MASK 	((0x1UL)<<IRQ_TIMER7_TOF)
#define INT_TIMER7_TMC_MASK 	((0x1UL)<<IRQ_TIMER7_TMC)

// I_PSLV/F_PSLV & I_CSLV/F_CSLV register
#define INT_PRIORITY_SEL0   	(0x7UL)<<0
#define INT_PRIORITY_SEL1   	(0x7UL)<<3
#define INT_PRIORITY_SEL2   	(0x7UL)<<6
#define INT_PRIORITY_SEL3   	(0x7UL)<<9
#define INT_PRIORITY_SEL4   	(0x7UL)<<12
#define INT_PRIORITY_SEL5   	(0x7UL)<<15
#define INT_PRIORITY_SEL6   	(0x7UL)<<18
#define INT_PRIORITY_SEL7   	(0x7UL)<<21

// I_PMST / F_PMST register
#define INT_MASTER_MODE_SEL 	(0x1UL)<<12
#define INT_SLAVE_MODE_SEL  	(0xfUL)<<8
#define INT_SLV_PRIORITY_SEL    (0xffUL)<<0
#define INT_SLV0_PRIORITY       (0x3UL)<<0
#define INT_SLV1_PRIORITY       (0x3UL)<<2
#define INT_SLV2_PRIORITY       (0x3UL)<<4
#define INT_SLV3_PRIORITY       (0x3UL)<<6

// IRQ vector table
#define AddrEINT0        (*(smtUint32 *)(_ISR_STARTADDRESS+0x20))
#define AddrEINT1        (*(smtUint32 *)(_ISR_STARTADDRESS+0x24))
#define AddrEINT2        (*(smtUint32 *)(_ISR_STARTADDRESS+0x28))
#define AddrEINT3        (*(smtUint32 *)(_ISR_STARTADDRESS+0x2c))
#define AddrIIC0         (*(smtUint32 *)(_ISR_STARTADDRESS+0x30))
#define AddrIIC0_AAS     (*(smtUint32 *)(_ISR_STARTADDRESS+0x34))
#define AddrTIMER0_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x38))
#define AddrTIMER0_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x3c))
#define AddrTIMER1_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x40))
#define AddrTIMER1_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x44))
#define AddrTIMER2_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x48))
#define AddrTIMER2_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x4c))
#define AddrEINT4        (*(smtUint32 *)(_ISR_STARTADDRESS+0x50))
#define AddrEINT5        (*(smtUint32 *)(_ISR_STARTADDRESS+0x54))
#define AddrEINT6        (*(smtUint32 *)(_ISR_STARTADDRESS+0x58))
#define AddrEINT7        (*(smtUint32 *)(_ISR_STARTADDRESS+0x5c))
#define AddrIIC1         (*(smtUint32 *)(_ISR_STARTADDRESS+0x60))
#define AddrIIC1_AAS     (*(smtUint32 *)(_ISR_STARTADDRESS+0x64))
#define AddrWDT          (*(smtUint32 *)(_ISR_STARTADDRESS+0x68))
#define AddrADC          (*(smtUint32 *)(_ISR_STARTADDRESS+0x6c))
#define AddrUTX          (*(smtUint32 *)(_ISR_STARTADDRESS+0x70))
#define AddrURX          (*(smtUint32 *)(_ISR_STARTADDRESS+0x74))
#define AddrTIMER3_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x78))
#define AddrTIMER3_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x7c))
#define AddrTIMER4_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x80))
#define AddrTIMER4_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x84))
#define AddrTIMER5_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x88))
#define AddrTIMER5_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x8c))
#define AddrTIMER6_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x90))
#define AddrTIMER6_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x94))
#define AddrTIMER7_TOF   (*(smtUint32 *)(_ISR_STARTADDRESS+0x98))
#define AddrTIMER7_TMC   (*(smtUint32 *)(_ISR_STARTADDRESS+0x9c))


/* ADC */
// ADCCON register
#define ADENABLE    	(0x1UL)<<0
#define ADC_READ_START  (0x1UL)<<1
#define ADC_STBY    	(0x1UL)<<2
#define ADC_IN_SEL  	(0x7UL)<<3
#define ADC_FLAG    	(0x1UL)<<15


/* Power */
// SYSCON register
#define STOP_CTL        (0x1UL)<<0
#define SYS_CLK_DIV 	(0x7UL)<<1
#define UART_CLK_DIV    (0x3UL)<<4
#define SYS_GIE_EN      (0x1UL)<<6
#define UART_INT_SEL    (0x1UL)<<7
#define ADC_CLK_DIV 	(0xffUL)<<8

// PWMCON register
#define PWM_OUT_CTRL    (0x1UL)<<0


#ifdef __cplusplus
}
#endif
#endif /*__SDI_V5_H___*/
