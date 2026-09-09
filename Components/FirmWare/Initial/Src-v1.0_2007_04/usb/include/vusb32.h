#ifndef __vusb32_h__
#define __vusb32_h__ 
/*******************************************************************************
** File          : $HeadURL$ 
** Author        : $Author$
** Project       : HSCTRL 
** Instances     : 
** Creation date : 
********************************************************************************
********************************************************************************
** ChipIdea Microelectronica - IPCS
** TECMAIA, Rua Eng. Frederico Ulrich, n 2650
** 4470-920 MOREIRA MAIA
** Portugal
** Tel: +351 229471010
** Fax: +351 229471011
** e_mail: chipidea.com
********************************************************************************
** ISO 9001:2000 - Certified Company
** (C) 2005 Copyright Chipidea(R)
** Chipidea(R) - Microelectronica, S.A. reserves the right to make changes to
** the information contained herein without notice. No liability shall be
** incurred as a result of its use or application.
********************************************************************************
** Modification history:
** $Date$
** $Revision$
*******************************************************************************
*** Description:      
***   This file contains VUSB32 specific defines, macros, and structures.
***                                                               
**************************************************************************
**END*********************************************************/

#ifdef __USB_OS_MQX__
	#include "cache.h"
#endif

/*
** VUSB Interrupt status register masks
*/

#define VUSB_INT_STAT_RESET               (0x01)
#define VUSB_INT_STAT_ERROR               (0x02)
#define VUSB_INT_STAT_SOF                 (0x04)
#define VUSB_INT_STAT_TOKEN_DONE          (0x08)
#define VUSB_INT_STAT_SLEEP               (0x10)
#define VUSB_INT_STAT_RESUME              (0x20)
#define VUSB_INT_STAT_ATTACH              (0x40)
#define VUSB_INT_STAT_STALL               (0x80)

/* Interrupt Enable Register Bit Masks */
#define  VUSB_INT_ENB_USB_RST             (0x01)
#define  VUSB_INT_ENB_ERROR               (0x02)
#define  VUSB_INT_ENB_SOF_TOK             (0x04)
#define  VUSB_INT_ENB_TOK_DNE             (0x08)
#define  VUSB_INT_ENB_SLEEP               (0x10)
#define  VUSB_INT_ENB_RESUME              (0x20)
#define  VUSB_INT_ENB_ATTACH              (0x40)
#define  VUSB_INT_ENB_STALL               (0x80)

/* Error Interrupt Status Register Bit Masks */
#define  VUSB_ERR_STAT_PID_ERR            (0x01)
#define  VUSB_ERR_STAT_CRC5_EOF           (0x02)
#define  VUSB_ERR_STAT_CRC16              (0x04)
#define  VUSB_ERR_STAT_DFN8               (0x08)
#define  VUSB_ERR_STAT_BTO_ERR            (0x10)
#define  VUSB_ERR_STAT_DMA_ERR            (0x20)
#define  VUSB_ERR_STAT_RSVD               (0x40)
#define  VUSB_ERR_STAT_BTS_ERR            (0x80)

/* Error Interrupt Enable Register Bit Masks */
#define  VUSB_ERR_ENB_PID_ERR             (0x01)
#define  VUSB_ERR_ENB_CRC5_EOF            (0x02)
#define  VUSB_ERR_ENB_CRC16               (0x04)
#define  VUSB_ERR_ENB_DFN8                (0x08)
#define  VUSB_ERR_ENB_BTO_ERR             (0x10)
#define  VUSB_ERR_ENB_DMA_ERR             (0x20)
#define  VUSB_ERR_ENB_RSVD                (0x40)
#define  VUSB_ERR_ENB_BTS_ERR             (0x80)

/* Status Register Bit Masks */
#define  VUSB_STATUS_ODD                  (0x04)
#define  VUSB_STATUS_IN                   (0x08)
#define  VUSB_STATUS_ENDP                 (0xF0)

/* Control Register Bit Masks */
#define  VUSB_CTRL_USB_EN                 (0x01)
#define  VUSB_CTRL_ODD_RST                (0x02)
#define  VUSB_CTRL_RESUME                 (0x04)
#define  VUSB_CTRL_HOST_MODE_EN           (0x08)
#define  VUSB_CTRL_RESET                  (0x10)
#define  VUSB_CTRL_TOKEN_BUSY             (0x20)
#define  VUSB_CTRL_TXD_SUSPEND            (0x20)
#define  VUSB_CTRL_SINGLE_ENDED_0         (0x40)
#define  VUSB_CTRL_JSTATE                 (0x80)

/* VUSB Control Register Masks */
#define VUSB_CTL_USB_EN                   (1 << 0)
#define VUSB_CTL_ODD_RST                  (1 << 1)
#define VUSB_CTL_TXD_RESUME				  (1 << 2)
#define VUSB_CTL_TXD_SUSPEND              (1 << 5) /* overload bit 5 */

/* VUSB Endpoint Control Register Mask */
#define VUSB_EP_CTRL_STALL                (0x2)
#define VUSB_INT_ENABLE_RESET             (0x01)

/* Token Register Masks */
#define  VUSB_TOKEN_ENDPT                 (0x0F)
#define  VUSB_TOKEN_PID                   (0xF0)
#define  VUSB_TOKEN_OUT                   (0x10)
#define  VUSB_TOKEN_IN                    (0x90)
#define  VUSB_TOKEN_SETUP                 (0xD0)

/* SOF Threshold Register Masks */
#define  VUSB_SOF_THLD_CNT0               (0x01)
#define  VUSB_SOF_THLD_CNT1               (0x02)
#define  VUSB_SOF_THLD_CNT2               (0x04)
#define  VUSB_SOF_THLD_CNT3               (0x08)
#define  VUSB_SOF_THLD_CNT4               (0x10)
#define  VUSB_SOF_THLD_CNT5               (0x20)
#define  VUSB_SOF_THLD_CNT6               (0x40)
#define  VUSB_SOF_THLD_CNT7               (0x80)

#define  VUSB_ADDR_LS_EN                  (0x80)

/* Status Register Bit Masks */
#define  VUSB_STAT_DIRECTION_BIT          (0x03)

/* Endpoint Control Register Masks */
#define  VUSB_ENDPT_CTL_EP_CTL_DIS        (0x10)
#define  VUSB_ENDPT_CTL_RETRY_DIS         (0x40)
#define  VUSB_ENDPT_CTL_HOST_WO_HUB       (0x80)

/* Buffer Descriptor Bit Masks */
#define  VUSB_BD_PID_MASKS                (0x3C)
#define  VUSB_BD_INVALID_PID1             (0x18)
#define  VUSB_BD_NAK_PID                  (0x28)
#define  VUSB_BD_PID_OWN                  (0x80)
#define  VUSB_BD_PID_DATA01               (0x40)
#define  VUSB_BD_DTS_ENABLE               (0x08)
#define  VUSB_BD_STALL_PID                (0x04)

/* Define the bits within the endpoint control register */
#define VUSB_ENDPT_HSHK_BIT               (0x01)
#define VUSB_ENDPT_STALL_BIT              (0x02)
#define VUSB_ENDPT_TX_EN_BIT              (0x04)
#define VUSB_ENDPT_RX_EN_BIT              (0x08)

#define VUSB_ENDPT_DISABLE                (0x00)
#define VUSB_ENDPT_CONTROL      (VUSB_ENDPT_HSHK_BIT | VUSB_ENDPT_TX_EN_BIT | \
   VUSB_ENDPT_RX_EN_BIT | VUSB_ENDPT_CTL_RETRY_DIS)
#define VUSB_ENDPT_BULK_RX      (VUSB_ENDPT_HSHK_BIT | VUSB_ENDPT_RX_EN_BIT | \
   VUSB_ENDPT_CTL_EP_CTL_DIS | VUSB_ENDPT_CTL_RETRY_DIS)
#define VUSB_ENDPT_BULK_TX      (VUSB_ENDPT_HSHK_BIT | VUSB_ENDPT_TX_EN_BIT | \
   VUSB_ENDPT_CTL_EP_CTL_DIS | VUSB_ENDPT_CTL_RETRY_DIS)
#define VUSB_ENDPT_BULK_BIDIR   (VUSB_ENDPT_HSHK_BIT | VUSB_ENDPT_TX_EN_BIT | \
   VUSB_ENDPT_RX_EN_BIT | VUSB_ENDPT_CTL_EP_CTL_DIS | VUSB_ENDPT_CTL_RETRY_DIS)
#define VUSB_ENDPT_ISO_RX       (VUSB_ENDPT_RX_EN_BIT | VUSB_ENDPT_CTL_EP_CTL_DIS | \
   VUSB_ENDPT_CTL_RETRY_DIS)
#define VUSB_ENDPT_ISO_TX       (VUSB_ENDPT_TX_EN_BIT | VUSB_ENDPT_CTL_EP_CTL_DIS | \
   VUSB_ENDPT_CTL_RETRY_DIS)
#define VUSB_ENDPT_ISO_BIDIR    (VUSB_ENDPT_RX_EN_BIT | VUSB_ENDPT_TX_EN_BIT \
   | VUSB_ENDPT_CTL_EP_CTL_DIS | VUSB_ENDPT_CTL_RETRY_DIS)

#define  VUSB_ENDPT_INT_RX                (0x49)
#define  VUSB_ENDPT_INT_TX                (0x45)
#define  VUSB_ENDPT_INT_BIDIR             (0x4d)   

#define  VUSB_ENDPT_HOST_RETRY_DIS        (0x40)
#define  VUSB_ENDPT_HOST_WO_HUB           (0x80)

#define  VUSB32_PID_BIT_MASK              (0x3C)
#define  VUSB32_DATA01_BIT_MASK           (0x40)
#define  VUSB32_OWNS_BIT_MASK             (0x80)
#define  VUSB32_DATA01_BIT_POS            (6)

#define VUSB_IS_BDT_TOKEN_A(pbdt, token) (((pbdt)->PID_OWN_DATA01_BC & VUSB32_PID_BIT_MASK) == (token << 2))   


/*
** BDT Structure Macros
*/

#define VUSB_COPY_OWN_DATA_PID(BDT_to, BDT_from) \
   { \
      (BDT_to)->PID_OWN_DATA01_BC = (BDT_from)->PID_OWN_DATA01_BC; \
   }
#define VUSB_SET_ADDRESS(pBDT, a)  ((pBDT)->ADDRESS = (a))

#define VUSB_CLEAR_CURRENT_BDT(pBDT,pxd) \
   { \
      (pBDT)->PID_OWN_DATA01_BC= 0; \
      VUSB_SET_BC((pBDT), 0); \
      VUSB_SET_ADDRESS((pBDT), 0); \
      pxd->PACKETPENDING--; \
   }
   
#define VUSB_CLEAR_OTHER_BDT(pBDT,pxd) \
   { \
      if ((VUSB_TOGGLE_BDT(pBDT))->PID_OWN_DATA01_BC & VUSB32_OWNS_BIT_MASK) { \
         pxd->NEXTODDEVEN = VUSB_TOGGLE_BIT(pxd->NEXTODDEVEN); \
         pxd->NEXTDATA01 = VUSB_TOGGLE_BIT(pxd->NEXTDATA01); \
         pxd->PACKETPENDING--; \
      } /* Endif */ \
      (VUSB_TOGGLE_BDT(pBDT))->PID_OWN_DATA01_BC = 0; \
      VUSB_SET_BC(VUSB_TOGGLE_BDT(pBDT), 0); \
      VUSB_SET_ADDRESS(VUSB_TOGGLE_BDT(pBDT), 0); \
   }

#ifdef _DATA_CACHE_
#define USB_UNCACHED_REGISTER  USB_Uncached  uint_32
typedef  USB_UNCACHED_REGISTER USB_REGISTER,  _PTR_ USB_REGISTER_PTR;
#else
typedef  uint_32  USB_REGISTER, _PTR_ USB_REGISTER_PTR;
#endif

typedef USB_Uncached struct bdt_struct {
   uint_32     PID_OWN_DATA01_BC;
   uint_8_ptr  ADDRESS;
} BDT_STRUCT, _PTR_ BDT_STRUCT_PTR;

/* Multipurpose (MP) structure */
typedef union
{
   uint_32 W;
   struct {uint_16 L; uint_16 H;} B;
   uchar_ptr PB;
   USB_Uncached struct BD _PTR_ BDT_PTR;
} MP_STRUCT, _PTR_ MP_STRUCT_PTR;

typedef union
{
   uint_16  W;
   struct {uint_8 L; uint_8 H;} B;
   uchar    PB[2];
} MP_STRUCT16, _PTR_ MP_STRUCT16_PTR;

/* VUSB Buffer Descriptor Format */
typedef USB_Uncached struct BD
{
   uint_16     PID;   /* 7:own 6:data0/1 5-2:pid 1-0:bch bits */
   uint_16     BC;    /* Byte Count Low bits */
   MP_STRUCT   ADDR;  /* ZERO:2, ODD:1, EP:4, BDT_PAGE_REG: 8 */
} HOST_BDT_STRUCT, _PTR_ HOST_BDT_STRUCT_PTR;

#define VUSB_BDT_OWNS_BIT         (1 << 7)
#define VUSB_BDT_DATA01_BIT       (1 << 6)
#define VUSB_BDT_KEEP_BIT         (1 << 5)
#define VUSB_BDT_NINC_BIT         (1 << 4)
#define VUSB_BDT_DTS_BIT          (1 << 3)
#define VUSB_BDT_STALL_BIT        (1 << 2)
#define VUSB_BDT_DEQUEUED         (~VUSB_BDT_OWNS_BIT)

#define VUSB_GET_BC(pBdt)         ((((pBdt)->PID_OWN_DATA01_BC & 0xFFFF0000) >> 16))
#define VUSB_SET_BC(pBdt,bytes)   ((pBdt)->PID_OWN_DATA01_BC |= (((uint_32)bytes) << 16))
#define VUSB_GET_TOKEN(pBdt)	(((pBdt)->PID_OWN_DATA01_BC >> 2) & 0x0f)

#define VUSB_INIT_BDT(pBdt, address, length, bits) {(pBdt)->ADDRESS = address; (pBdt)->PID_OWN_DATA01_BC = (((uint_32)length) << 16) | bits; }

#define VUSB_TOGGLE_BDT(pBdt)     ((BDT_STRUCT_PTR)(((uint_32)(pBdt)) ^ 0x08))

/* Macro for aligning the BDT page head to the appropriate byte boundary */
#define USB_BDT_ALIGN(n)      ((n) + (-(n) & 511))

#define USB_SET_BDT_PAGE(devptr, bdtpage) \
   { \
      (devptr)->BDTPAGE1 = (((uint_32)(bdtpage)) >> 8) & 0xFF; \
      (devptr)->BDTPAGE2 = (((uint_32)(bdtpage)) >> 16) & 0xFF; \
      (devptr)->BDTPAGE3 = (((uint_32)(bdtpage)) >> 24) & 0xFF; \
   }

#define VUSB_TOGGLE_BIT(x)        ((x) ^ 1)
   
/* The ARC is little-endian, just like USB */
#define USB_uint_16_low(x)          ((x) & 0xFF)
#define USB_uint_16_high(x)         (((x) >> 8) & 0xFF)

#define  PIPE_RESERVED_FOR_ALIGNMENT         (2)
#define  XD_RESERVED_FOR_ALIGNMENT           (18)

#define  VUSB_ARC_BDT_OUT_BIT                (0x10)
#define  VUSB_ARC_BDT_IN_BIT                 (0x00)
#define  VUSB_ARC_BDT_ODD_EVEN_BIT           (0x08)

/* VUSB Register Structure */   
typedef USB_Uncached struct usb_struct {
   USB_REGISTER   INTSTATUS;
   USB_REGISTER   INTENABLE;
   USB_REGISTER   ERRORSTATUS;
   USB_REGISTER   ERRORENABLE;
   USB_REGISTER   STATUS;
   USB_REGISTER   CONTROL;
   USB_REGISTER   ADDRESS;
   USB_REGISTER   BDTPAGE1;
   USB_REGISTER   FRAMENUMLO;
   USB_REGISTER   FRAMENUMHI;
   USB_REGISTER   TOKEN;
   USB_REGISTER   SOFTHRESHOLDLO;
   USB_REGISTER   BDTPAGE2;
   USB_REGISTER   BDTPAGE3;
   USB_REGISTER   SOFTHRESHOLDHI;
   USB_REGISTER   RESERVED;
} USB_STRUCT, _PTR_ USB_STRUCT_PTR;

/*
** The USB STATUS register contains:
** Bits 7-4:   Endpoint
** Bit 3:      Tx(1)/Rx(0)
** Bit 2:      Odd(1)/Even(0)
** Bits 1-0:   Zero
*/
#define USB_REGISTER_STATUS_ENDPOINT(usbptr) (((usbptr)->STATUS >> 4) & 0x0F)
#define USB_REGISTER_STATUS_TXRX(usbptr)     (((usbptr)->STATUS >> 3) & 0x01)
#define USB_REGISTER_STATUS_ODDEVEN(usbptr)  (((usbptr)->STATUS >> 2) & 0x01)

#endif
/* EOF */
