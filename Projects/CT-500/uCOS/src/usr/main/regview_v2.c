#include "sysreg.h"

/*

Enter__ESMC_BASEADDR
Enter__DDRCTL_BASEADDR
Enter__NAND_BASEADDR
Enter__DMAC_BASEADDR
Enter__DMA2D_BASEADDR
Enter__DM_BASEADDR
Enter__VIDEOENC_BASEADDR
Enter__UART0_BASEADDR
Enter__UART1_BASEADDR
Enter__UART2_BASEADDR
Enter__UART3_BASEADDR
Enter__I2C_BASEADDR
Enter__TIMER_BASEADDR
Enter__GPIO_BASEADDR
Enter__VIC_BASEADDR
Enter__MMC_BASEADDR
Enter__VIF_BASEADDR
Enter__I2S_BASEADDR
Enter__RS_BASEADDR
Enter__SEIP_BASEADDR

*/


struct
{
    volatile unsigned ___ESMC_BASEADDR;
    volatile unsigned *pREG___ESMC_B0_CON;
    volatile unsigned *pREG___ESMC_B1_CON;
    volatile unsigned *pREG___ESMC_B2_CON;
    volatile unsigned *pREG___ESMC_B3_CON;
} Enter__ESMC_BASEADDR =
{
    ESMC_BASEADDR,
    &ESMC_B0_CON,
    &ESMC_B1_CON,
    &ESMC_B2_CON,
    &ESMC_B3_CON
};


struct
{
    volatile unsigned ___DDRCTL_BASEADDR;
    volatile unsigned *gREG___DDRTCON;
    volatile unsigned *gREG___DDRCON;
    volatile unsigned *gREG___DDRPCON;
    volatile unsigned *gREG___DDRREF;
    volatile unsigned *gREG___DDRDLL;
} Enter__DDRCTL_BASEADDR =
{
    DDRCTL_BASEADDR,
    &DDRTCON,
    &DDRCON,
    &DDRPCON,
    &DDRREF,
    &DDRDLL
};

struct
{
    volatile unsigned ___NAND_BASEADDR;
    volatile unsigned *gREG___NANDNFOPER  ;
    volatile unsigned *gREG___NANDDATA    ;
    volatile unsigned *gREG___NANDCONF    ;
    volatile unsigned *gREG___NANDCTRL    ;
    volatile unsigned *gREG___NANDSTAT    ;
    volatile unsigned *gREG___ECCSECTOR0  ;
    volatile unsigned *gREG___ECCSECTOR1  ;
    volatile unsigned *gREG___ECCSECTOR2  ;
    volatile unsigned *gREG___ECCSECTOR3  ;
    volatile unsigned *gREG___ECCSECTOR4  ;
    volatile unsigned *gREG___ECCSECTOR5  ;
    volatile unsigned *gREG___ECCSECTOR6  ;
    volatile unsigned *gREG___ECCSECTOR7  ;
    volatile unsigned *gREG___ECCSECTOR8  ;
    volatile unsigned *gREG___ECCSECTOR9  ;
    volatile unsigned *gREG___ECCSECTOR10 ;
    volatile unsigned *gREG___ECCSECTOR11 ;
    volatile unsigned *gREG___ECCSECTOR12 ;
    volatile unsigned *gREG___ECCSECTOR13 ;
    volatile unsigned *gREG___ECCSECTOR14 ;
    volatile unsigned *gREG___ECCSECTOR15 ;
    volatile unsigned *gREG___SECCSECTOR0 ;
    volatile unsigned *gREG___SECCSECTOR1 ;
    volatile unsigned *gREG___SECCSECTOR2 ;
    volatile unsigned *gREG___SECCSECTOR3 ;
    volatile unsigned *gREG___SECCSECTOR4 ;
    volatile unsigned *gREG___SECCSECTOR5 ;
    volatile unsigned *gREG___SECCSECTOR6 ;
    volatile unsigned *gREG___SECCSECTOR7 ;
    volatile unsigned *gREG___SECCSECTOR8 ;
    volatile unsigned *gREG___SECCSECTOR9 ;
    volatile unsigned *gREG___SECCSECTOR10;
    volatile unsigned *gREG___SECCSECTOR11;
    volatile unsigned *gREG___SECCSECTOR12;
    volatile unsigned *gREG___SECCSECTOR13;
    volatile unsigned *gREG___SECCSECTOR14;
    volatile unsigned *gREG___SECCSECTOR15;
    volatile unsigned *gREG___ECCERR0     ;
    volatile unsigned *gREG___ECCERR1     ;
} Enter__NAND_BASEADDR =
{
     NAND_BASEADDR  ,
    &NANDNFOPER     ,
    &NANDDATA       ,
    &NANDCONF       ,
    &NANDCTRL       ,
    &NANDSTAT       ,
    &ECCSECTOR0     ,
    &ECCSECTOR1     ,
    &ECCSECTOR2     ,
    &ECCSECTOR3     ,
    &ECCSECTOR4     ,
    &ECCSECTOR5     ,
    &ECCSECTOR6     ,
    &ECCSECTOR7     ,
    &ECCSECTOR8     ,
    &ECCSECTOR9     ,
    &ECCSECTOR10    ,
    &ECCSECTOR11    ,
    &ECCSECTOR12    ,
    &ECCSECTOR13    ,
    &ECCSECTOR14    ,
    &ECCSECTOR15    ,
    &SECCSECTOR0    ,
    &SECCSECTOR1    ,
    &SECCSECTOR2    ,
    &SECCSECTOR3    ,
    &SECCSECTOR4    ,
    &SECCSECTOR5    ,
    &SECCSECTOR6    ,
    &SECCSECTOR7
};

struct
{
    volatile unsigned ___DMAC_BASEADDR;
    volatile unsigned *gREG___DMACSADR0     ;
    volatile unsigned *gREG___DMACDADR0     ;
    volatile unsigned *gREG___DMACCON0      ;
    volatile unsigned *gREG___DMACDESCRP0   ;
    volatile unsigned *gREG___DMACSTA0      ;
    volatile unsigned *gREG___DMACSADR1     ;
    volatile unsigned *gREG___DMACDADR1     ;
    volatile unsigned *gREG___DMACCON1      ;
    volatile unsigned *gREG___DMACDESCRP1   ;
    volatile unsigned *gREG___DMACSTA1      ;
    volatile unsigned *gREG___DMACSADR2     ;
    volatile unsigned *gREG___DMACDADR2     ;
    volatile unsigned *gREG___DMACCON2      ;
    volatile unsigned *gREG___DMACDESCRP2   ;
    volatile unsigned *gREG___DMACSTA2      ;
    volatile unsigned *gREG___DMACSADR3     ;
    volatile unsigned *gREG___DMACDADR3     ;
    volatile unsigned *gREG___DMACCON3      ;
    volatile unsigned *gREG___DMACDESCRP3   ;
    volatile unsigned *gREG___DMACSTA3      ;
    volatile unsigned *gREG___DMACSADR4     ;
    volatile unsigned *gREG___DMACDADR4     ;
    volatile unsigned *gREG___DMACCON4      ;
    volatile unsigned *gREG___DMACDESCRP4   ;
    volatile unsigned *gREG___DMACSTA4      ;
    volatile unsigned *gREG___DMACSADR5     ;
    volatile unsigned *gREG___DMACDADR5     ;
    volatile unsigned *gREG___DMACCON5      ;
    volatile unsigned *gREG___DMACDESCRP5   ;
    volatile unsigned *gREG___DMACSTA5      ;
    volatile unsigned *gREG___DMACSADR6     ;
    volatile unsigned *gREG___DMACDADR6     ;
    volatile unsigned *gREG___DMACCON6      ;
    volatile unsigned *gREG___DMACDESCRP6   ;
    volatile unsigned *gREG___DMACSTA6      ;
    volatile unsigned *gREG___DMACSADR7     ;
    volatile unsigned *gREG___DMACDADR7     ;
    volatile unsigned *gREG___DMACCON7      ;
    volatile unsigned *gREG___DMACDESCRP7   ;
    volatile unsigned *gREG___DMACSTA7      ;


} Enter__DMAC_BASEADDR =
{
    DMAC_BASEADDR   ,
    &DMACSADR0      ,
    &DMACDADR0      ,
    &DMACCON0       ,
    &DMACDESCRP0    ,
    &DMACSTA0       ,
    &DMACSADR1      ,
    &DMACDADR1      ,
    &DMACCON1       ,
    &DMACDESCRP1    ,
    &DMACSTA1       ,
    &DMACSADR2      ,
    &DMACDADR2      ,
    &DMACCON2       ,
    &DMACDESCRP2    ,
    &DMACSTA2       ,
    &DMACSADR3      ,
    &DMACDADR3      ,
    &DMACCON3       ,
    &DMACDESCRP3    ,
    &DMACSTA3       ,
    &DMACSADR4      ,
    &DMACDADR4      ,
    &DMACCON4       ,
    &DMACDESCRP4    ,
    &DMACSTA4       ,
    &DMACSADR5      ,
    &DMACDADR5      ,
    &DMACCON5       ,
    &DMACDESCRP5    ,
    &DMACSTA5       ,
    &DMACSADR6      ,
    &DMACDADR6      ,
    &DMACCON6       ,
    &DMACDESCRP6    ,
    &DMACSTA6       ,
    &DMACSADR7      ,
    &DMACDADR7      ,
    &DMACCON7       ,
    &DMACDESCRP7    ,
    &DMACSTA7


};

struct
{
        volatile unsigned ___DMA2D_BASEADDR;
        volatile unsigned *gREG___DMA2D_SRCADDR;
        volatile unsigned *gREG___DMA2D_DSTADDR;
        volatile unsigned *gREG___DMA2D_SIZE   ;
        volatile unsigned *gREG___DMA2D_CNT    ;
        volatile unsigned *gREG___DMA2D_ADDRUPD;
        volatile unsigned *gREG___DMA2D_STATUS;

} Enter__DMA2D_BASEADDR =
{
        DMA2D_BASEADDR  ,
        &DMA2D_SRCADDR  ,
        &DMA2D_DSTADDR  ,
        &DMA2D_SIZE     ,
        &DMA2D_CNT      ,
        &DMA2D_ADDRUPD  ,
        &DMA2D_STATUS
};


struct
{
    volatile unsigned ___DM_BASEADDR  ;
    volatile unsigned *gREG___DMCON   ;
    volatile unsigned *gREG___DMSTS   ;
    volatile unsigned *gREG___CCON    ;
    volatile unsigned *gREG___CBLND   ;
    volatile unsigned *gREG___CBMOD   ;
    volatile unsigned *gREG___CBASE   ;
    volatile unsigned *gREG___CADDR   ;
    volatile unsigned *gREG___CPALADDR;
    volatile unsigned *gREG___CPALM   ;
    volatile unsigned *gREG___CBLINK  ;
    volatile unsigned *gREG___BGCOL   ;
    volatile unsigned *gREG___GCON    ;
    volatile unsigned *gREG___GBLND   ;
    volatile unsigned *gREG___GBMOD   ;
    volatile unsigned *gREG___GBASE   ;
    volatile unsigned *gREG___GADDR   ;
    volatile unsigned *gREG___GPALADDR;
    volatile unsigned *gREG___GPALM   ;
    volatile unsigned *gREG___VCON    ;
    volatile unsigned *gREG___VBLND   ;
    volatile unsigned *gREG___VBMOD   ;
    volatile unsigned *gREG___VBASE   ;
    volatile unsigned *gREG___VADDR   ;
    volatile unsigned *gREG___VADDR2  ;
    volatile unsigned *gREG___SCON    ;
    volatile unsigned *gREG___SSIZE   ;
    volatile unsigned *gREG___SRATIO  ;
    volatile unsigned *gREG___LCDCON  ;
    volatile unsigned *gREG___VIDCON  ;
    volatile unsigned *gREG___HSYNC0  ;
    volatile unsigned *gREG___HSYNC1  ;
    volatile unsigned *gREG___VSYNC0  ;
    volatile unsigned *gREG___VSYNC1  ;
    volatile unsigned *gREG___GGAMMA00 ;
    volatile unsigned *gREG___GGAMMA01 ;
    volatile unsigned *gREG___GGAMMA02 ;
    volatile unsigned *gREG___GGAMMA03 ;
    volatile unsigned *gREG___GGAMMA04 ;
    volatile unsigned *gREG___GGAMMA05 ;
    volatile unsigned *gREG___GGAMMA06 ;
    volatile unsigned *gREG___GGAMMA07 ;
    volatile unsigned *gREG___GGAMMA08 ;
    volatile unsigned *gREG___GGAMMA09 ;
    volatile unsigned *gREG___GGAMMA0A ;
    volatile unsigned *gREG___GGAMMA0B ;
    volatile unsigned *gREG___GGAMMA0C ;
    volatile unsigned *gREG___GGAMMA0D ;
    volatile unsigned *gREG___GGAMMA0E ;
    volatile unsigned *gREG___GGAMMA0F ;
    volatile unsigned *gREG___GGAMMA10 ;
    volatile unsigned *gREG___VGAMMA00 ;
    volatile unsigned *gREG___VGAMMA01 ;
    volatile unsigned *gREG___VGAMMA02 ;
    volatile unsigned *gREG___VGAMMA03 ;
    volatile unsigned *gREG___VGAMMA04 ;
    volatile unsigned *gREG___VGAMMA05 ;
    volatile unsigned *gREG___VGAMMA06 ;
    volatile unsigned *gREG___VGAMMA07 ;
    volatile unsigned *gREG___VGAMMA08 ;
    volatile unsigned *gREG___VGAMMA09 ;
    volatile unsigned *gREG___VGAMMA0A ;
    volatile unsigned *gREG___VGAMMA0B ;
    volatile unsigned *gREG___VGAMMA0C ;
    volatile unsigned *gREG___VGAMMA0D ;
    volatile unsigned *gREG___VGAMMA0E ;
    volatile unsigned *gREG___VGAMMA0F ;
    volatile unsigned *gREG___VGAMMA10 ;
} Enter__DM_BASEADDR =
{
    DM_BASEADDR,
    &DMCON    ,
    &DMSTS    ,
    &CCON     ,
    &CBLND    ,
    &CBMOD    ,
    &CBASE    ,
    &CADDR    ,
    &CPALADDR ,
    &CPALM    ,
    &CBLINK   ,
    &BGCOL    ,
    &GCON     ,
    &GBLND    ,
    &GBMOD    ,
    &GBASE    ,
    &GADDR    ,
    &GPALADDR ,
    &GPALM    ,
    &VCON     ,
    &VBLND    ,
    &VBMOD    ,
    &VBASE    ,
    &VADDR    ,
    &VADDR2   ,
    &SCON     ,
    &SSIZE    ,
    &SRATIO  ,
    &LCDCON  ,
    &VIDCON  ,
    &HSYNC0  ,
    &HSYNC1  ,
    &VSYNC0  ,
    &VSYNC1  ,
    &GGAMMA00 ,
    &GGAMMA01 ,
    &GGAMMA02 ,
    &GGAMMA03 ,
    &GGAMMA04 ,
    &GGAMMA05 ,
    &GGAMMA06 ,
    &GGAMMA07 ,
    &GGAMMA08 ,
    &GGAMMA09 ,
    &GGAMMA0A ,
    &GGAMMA0B ,
    &GGAMMA0C ,
    &GGAMMA0D ,
    &GGAMMA0E ,
    &GGAMMA0F ,
    &GGAMMA10 ,
    &VGAMMA00 ,
    &VGAMMA01 ,
    &VGAMMA02 ,
    &VGAMMA03 ,
    &VGAMMA04 ,
    &VGAMMA05 ,
    &VGAMMA06 ,
    &VGAMMA07 ,
    &VGAMMA08 ,
    &VGAMMA09 ,
    &VGAMMA0A ,
    &VGAMMA0B ,
    &VGAMMA0C ,
    &VGAMMA0D ,
    &VGAMMA0E ,
    &VGAMMA0F ,
    &VGAMMA10
};


struct
{
        volatile unsigned ___VIDEOENC_BASEADDR       ;
        volatile unsigned *gREG___VIDEOENC_STATUS    ;
        volatile unsigned *gREG___VIDEOENC_CONTROL   ;
        volatile unsigned *gREG___VIDEOENC_INTERNAL  ;
        volatile unsigned *gREG___VIDEOENC_SUBPHASE  ;
        volatile unsigned *gREG___VIDEOENC_SUBCARRIER;

} Enter__VIDEOENC_BASEADDR =
{
        VIDEOENC_BASEADDR           ,
        &VIDEOENC_STATUS            ,
        &VIDEOENC_CONTROL           ,
        &VIDEOENC_INTERNAL          ,
        &VIDEOENC_SUBPHASE          ,
        &VIDEOENC_SUBCARRIER
};

struct
{
    volatile unsigned ___UART0_BASEADDR         ;
    volatile unsigned *gREG___UART0MASTER       ;
    volatile unsigned *gREG___UART0STATUS       ;
    volatile unsigned *gREG___UART0BRD          ;
    volatile unsigned *gREG___UART0TXFIFO       ;
    volatile unsigned *gREG___UART0RXFIFO       ;
    volatile unsigned *gREG___UART0RXTIMEOUT    ;
} Enter__UART0_BASEADDR =
{
    UART0_BASEADDR   ,
    &UART0MASTER     ,
    &UART0STATUS     ,
    &UART0BRD        ,
    &UART0TXFIFO     ,
    &UART0RXFIFO     ,
    &UART0RXTIMEOUT
};


struct
{
    volatile unsigned ___UART1_BASEADDR         ;
    volatile unsigned *gREG___UART1MASTER       ;
    volatile unsigned *gREG___UART1STATUS       ;
    volatile unsigned *gREG___UART1BRD          ;
    volatile unsigned *gREG___UART1TXFIFO       ;
    volatile unsigned *gREG___UART1RXFIFO       ;
    volatile unsigned *gREG___UART1RXTIMEOUT    ;
} Enter__UART1_BASEADDR =
{
    UART1_BASEADDR  ,
    &UART1MASTER    ,
    &UART1STATUS    ,
    &UART1BRD       ,
    &UART1TXFIFO    ,
    &UART1RXFIFO    ,
    &UART1RXTIMEOUT
};

struct
{
    volatile unsigned ___UART2_BASEADDR         ;
    volatile unsigned *gREG___UART2MASTER       ;
    volatile unsigned *gREG___UART2STATUS       ;
    volatile unsigned *gREG___UART2BRD          ;
    volatile unsigned *gREG___UART2TXFIFO       ;
    volatile unsigned *gREG___UART2RXFIFO       ;
    volatile unsigned *gREG___UART2RXTIMEOUT    ;
} Enter__UART2_BASEADDR =
{
    UART2_BASEADDR  ,
    &UART2MASTER    ,
    &UART2STATUS    ,
    &UART2BRD       ,
    &UART2TXFIFO    ,
    &UART2RXFIFO    ,
    &UART2RXTIMEOUT
};

struct
{
    volatile unsigned ___UART3_BASEADDR         ;
    volatile unsigned *gREG___UART3MASTER       ;
    volatile unsigned *gREG___UART3STATUS       ;
    volatile unsigned *gREG___UART3BRD          ;
    volatile unsigned *gREG___UART3TXFIFO       ;
    volatile unsigned *gREG___UART3RXFIFO       ;
    volatile unsigned *gREG___UART3RXTIMEOUT    ;
} Enter__UART3_BASEADDR =
{
    UART3_BASEADDR  ,
    &UART3MASTER    ,
    &UART3STATUS    ,
    &UART3BRD       ,
    &UART3TXFIFO    ,
    &UART3RXFIFO    ,
    &UART3RXTIMEOUT
};

struct
{
    volatile unsigned ___I2C_BASEADDR       ;
    volatile unsigned *gREG___ICCR0_0       ;
    volatile unsigned *gREG___ICSR0         ;
    volatile unsigned *gREG___IAR0          ;
    volatile unsigned *gREG___IDSR0         ;
    volatile unsigned *gREG___ICCR0_1       ;
    volatile unsigned *gREG___I2C0_SRST     ;
    volatile unsigned *gREG___I2CCON        ;
    volatile unsigned *gREG___I2CSTA        ;
    volatile unsigned *gREG___I2CDATA       ;
    volatile unsigned *gREG___ICCR1_0       ;
    volatile unsigned *gREG___ICSR1         ;
    volatile unsigned *gREG___IAR1          ;
    volatile unsigned *gREG___IDSR1         ;
    volatile unsigned *gREG___ICCR1_1       ;
    volatile unsigned *gREG___I2C1_SRST     ;
} Enter__I2C_BASEADDR =
{
    I2C_BASEADDR ,
    &ICCR0_0     ,
    &ICSR0       ,
    &IAR0        ,
    &IDSR0       ,
    &ICCR0_1     ,
    &I2C0_SRST   ,
    &I2CCON      ,
    &I2CSTA      ,
    &I2CDATA     ,
    &ICCR1_0     ,
    &ICSR1       ,
    &IAR1        ,
    &IDSR1       ,
    &ICCR1_1     ,
    &I2C1_SRST
};


struct
{
    volatile unsigned ___TIMER_BASEADDR     ;
    volatile unsigned *gREG___TIMER0_DAT    ;
    volatile unsigned *gREG___TIMER0_PRE    ;
    volatile unsigned *gREG___TIMER0_CON    ;
    volatile unsigned *gREG___TIMER0_CNT    ;
    volatile unsigned *gREG___TIMER1_DAT    ;
    volatile unsigned *gREG___TIMER1_PRE    ;
    volatile unsigned *gREG___TIMER1_CON    ;
    volatile unsigned *gREG___TIMER1_CNT    ;
    volatile unsigned *gREG___TIMER2_DAT    ;
    volatile unsigned *gREG___TIMER2_PRE    ;
    volatile unsigned *gREG___TIMER2_CON    ;
    volatile unsigned *gREG___TIMER2_CNT    ;
    volatile unsigned *gREG___TIMER3_DAT    ;
    volatile unsigned *gREG___TIMER3_PRE    ;
    volatile unsigned *gREG___TIMER3_CON    ;
    volatile unsigned *gREG___TIMER3_CNT    ;
} Enter__TIMER_BASEADDR =
{
    TIMER_BASEADDR,
    &TIMER0_DAT   ,
    &TIMER0_PRE   ,
    &TIMER0_CON   ,
    &TIMER0_CNT   ,
    &TIMER1_DAT   ,
    &TIMER1_PRE   ,
    &TIMER1_CON   ,
    &TIMER1_CNT   ,
    &TIMER2_DAT   ,
    &TIMER2_PRE   ,
    &TIMER2_CON   ,
    &TIMER2_CNT   ,
    &TIMER3_DAT   ,
    &TIMER3_PRE   ,
    &TIMER3_CON   ,
    &TIMER3_CNT
};

struct
{
    volatile unsigned ___GPIO_BASEADDR          ;
    volatile unsigned *gREG___GPIO0_OE          ;
    volatile unsigned *gREG___GPIO0_IN          ;
    volatile unsigned *gREG___GPIO0_OUT         ;
    volatile unsigned *gREG___DBG_GPIO0_OUT     ;
    volatile unsigned *gREG___GPIO0_INTSTAT     ;
    volatile unsigned *gREG___GPIO0_INTEN       ;
    volatile unsigned *gREG___GPIO0_INTLEVEL    ;
    volatile unsigned *gREG___GPIO0_INTPOL      ;
    volatile unsigned *gREG___GPIO0_INTBEDGE    ;
    volatile unsigned *gREG___GPIO1_OE          ;
    volatile unsigned *gREG___GPIO1_IN          ;
    volatile unsigned *gREG___GPIO1_OUT         ;
    volatile unsigned *gREG___GPIO1_INTSTAT     ;
    volatile unsigned *gREG___GPIO1_INTEN       ;
    volatile unsigned *gREG___GPIO1_INTLEVEL    ;
    volatile unsigned *gREG___GPIO1_INTPOL      ;
    volatile unsigned *gREG___GPIO1_INTBEDGE    ;
} Enter__GPIO_BASEADDR =
{
    GPIO_BASEADDR   ,
    &GPIO0_OE       ,
    &GPIO0_IN       ,
    &GPIO0_OUT      ,
    &DBG_GPIO0_OUT  ,
    &GPIO0_INTSTAT  ,
    &GPIO0_INTEN    ,
    &GPIO0_INTLEVEL ,
    &GPIO0_INTPOL   ,
    &GPIO0_INTBEDGE ,
    &GPIO1_OE       ,
    &GPIO1_IN       ,
    &GPIO1_OUT      ,
    &GPIO1_INTSTAT  ,
    &GPIO1_INTEN    ,
    &GPIO1_INTLEVEL ,
    &GPIO1_INTPOL   ,
    &GPIO1_INTBEDGE
};

struct
{
    volatile unsigned ___VIC_BASEADDR       ;
    volatile unsigned *gREG___INTCON        ;
    volatile unsigned *gREG___INTPND        ;
    volatile unsigned *gREG___INTMOD        ;
    volatile unsigned *gREG___INTMSK        ;
    volatile unsigned *gREG___LEVEL         ;
    volatile unsigned *gREG___I_PSLV0       ;
    volatile unsigned *gREG___I_PSLV1       ;
    volatile unsigned *gREG___I_PSLV2       ;
    volatile unsigned *gREG___I_PSLV3       ;
    volatile unsigned *gREG___F_PSLV0       ;
    volatile unsigned *gREG___F_PSLV1       ;
    volatile unsigned *gREG___F_PSLV2       ;
    volatile unsigned *gREG___F_PSLV3       ;
    volatile unsigned *gREG___I_PMST        ;
    volatile unsigned *gREG___F_PMST        ;
    volatile unsigned *gREG___ICSLV0        ;
    volatile unsigned *gREG___ICSLV1        ;
    volatile unsigned *gREG___ICSLV2        ;
    volatile unsigned *gREG___ICSLV3        ;
    volatile unsigned *gREG___F_CSLV0       ;
    volatile unsigned *gREG___F_CSLV1       ;
    volatile unsigned *gREG___F_CSLV2       ;
    volatile unsigned *gREG___F_CSLV3       ;
    volatile unsigned *gREG___I_CMST        ;
    volatile unsigned *gREG___F_CMST        ;
    volatile unsigned *gREG___I_ISPR        ;
    volatile unsigned *gREG___F_ISPR        ;
    volatile unsigned *gREG___I_ISPC        ;
    volatile unsigned *gREG___F_ISPC        ;
    volatile unsigned *gREG___POLARITY      ;
    volatile unsigned *gREG___I_VECADDR     ;
    volatile unsigned *gREG___F_VECADDR     ;
} Enter__VIC_BASEADDR =
{
    VIC_BASEADDR,
    &INTCON    ,
    &INTPND    ,
    &INTMOD    ,
    &INTMSK    ,
    &LEVEL     ,
    &I_PSLV0   ,
    &I_PSLV1   ,
    &I_PSLV2   ,
    &I_PSLV3   ,
    &F_PSLV0   ,
    &F_PSLV1   ,
    &F_PSLV2   ,
    &F_PSLV3   ,
    &I_PMST    ,
    &F_PMST    ,
    &ICSLV0    ,
    &ICSLV1    ,
    &ICSLV2    ,
    &ICSLV3    ,
    &F_CSLV0   ,
    &F_CSLV1   ,
    &F_CSLV2   ,
    &F_CSLV3   ,
    &I_CMST    ,
    &F_CMST    ,
    &I_ISPR    ,
    &F_ISPR    ,
    &I_ISPC    ,
    &F_ISPC    ,
    &POLARITY  ,
    &I_VECADDR ,
    &F_VECADDR
};

struct
{
    volatile unsigned ___MMC_BASEADDR           ;
    volatile unsigned *gREG___SDCON             ;
    volatile unsigned *gREG___SDPRE             ;
    volatile unsigned *gREG___SDCmdArg          ;
    volatile unsigned *gREG___SDCmdCon          ;
    volatile unsigned *gREG___SDCmdSta          ;
    volatile unsigned *gREG___SDRSP0            ;
    volatile unsigned *gREG___SDRSP1            ;
    volatile unsigned *gREG___SDRSP2            ;
    volatile unsigned *gREG___SDRSP3            ;
    volatile unsigned *gREG___SDDTimer          ;
    volatile unsigned *gREG___SDBSize           ;
    volatile unsigned *gREG___SDDatCon          ;
    volatile unsigned *gREG___SDDatCnt          ;
    volatile unsigned *gREG___SDDatSta          ;
    volatile unsigned *gREG___SDFSTA            ;
    volatile unsigned *gREG___SDIntMsk          ;
    volatile unsigned *gREG___SDIntSta          ;
    volatile unsigned *gREG___SDDAT             ;
    volatile unsigned *gREG___SDAutoReadCon     ;
    volatile unsigned *gREG___SDAutoReadSta     ;
} Enter__MMC_BASEADDR =
{
    MMC_BASEADDR   ,
    &SDCON         ,
    &SDPRE         ,
    &SDCmdArg      ,
    &SDCmdCon      ,
    &SDCmdSta      ,
    &SDRSP0        ,
    &SDRSP1        ,
    &SDRSP2        ,
    &SDRSP3        ,
    &SDDTimer      ,
    &SDBSize       ,
    &SDDatCon      ,
    &SDDatCnt      ,
    &SDDatSta      ,
    &SDFSTA        ,
    &SDIntMsk      ,
    &SDIntSta      ,
    &SDDAT         ,
    &SDAutoReadCon ,
    &SDAutoReadSta
};

struct
{
    volatile unsigned ___VIF_BASEADDR   ;
    volatile unsigned *gREG__VIFCON     ;
    volatile unsigned *gREG__VIFSTS     ;
    volatile unsigned *gREG__VIFPOS     ;
    volatile unsigned *gREG__VIFSIZ     ;
    volatile unsigned *gREG__VIFADDR    ;
} Enter__VIF_BASEADDR =
{
    VIF_BASEADDR,
    &VIFCON     ,
    &VIFSTS     ,
    &VIFPOS     ,
    &VIFSIZ     ,
    &VIFADDR
};

struct
{
    volatile unsigned ___I2S_BASEADDR       ;
    volatile unsigned *gREG__I2S_CLKCTRL    ;
    volatile unsigned *gREG__I2S_CTRL       ;
    volatile unsigned *gREG__I2S_STATUS     ;
    volatile unsigned *gREG__I2S_DATA       ;
} Enter__I2S_BASEADDR =
{
    I2S_BASEADDR ,
    &I2S_CLKCTRL ,
    &I2S_CTRL    ,
    &I2S_STATUS  ,
    &I2S_DATA
};

struct
{
    volatile unsigned ___RS_BASEADDR    ;
    volatile unsigned *gREG__RS_SEIPMUX ;
    volatile unsigned *gREG__RS_DMAMUX  ;
} Enter__RS_BASEADDR =
{
    RS_BASEADDR ,
    &RS_SEIPMUX ,
    &RS_DMAMUX
};

struct
{
        volatile unsigned ___SEIP_BASEADDR;
        volatile unsigned *gREG__SEIP_RXCON;
        volatile unsigned *gREG__SEIP_RXSTS;
        volatile unsigned *gREG__SEIP_RXDAT;
        volatile unsigned *gREG__SEIP_TXCON;
        volatile unsigned *gREG__SEIP_TXSTS;
        volatile unsigned *gREG__SEIP_TXDAT;
        volatile unsigned *gREG__SEIP_RST  ;

} Enter__SEIP_BASEADDR =
{
        SEIP_BASEADDR,
        &SEIP_RXCON,
        &SEIP_RXSTS,
        &SEIP_RXDAT,
        &SEIP_TXCON,
        &SEIP_TXSTS,
        &SEIP_TXDAT,
        &SEIP_RST
};

