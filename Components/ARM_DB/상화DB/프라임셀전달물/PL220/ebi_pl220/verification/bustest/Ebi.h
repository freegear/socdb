/*----======================================================================----
--This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Ebi.h.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
--
-- -----------------------------------------------------------------------------
-- Purpose :
--         This test contains Counter register values. 
--
--==========================================================================--*/

/******************************************************************************/
#define ZERO        0x00000000
#define Data_0s     0x00000000

/******************************************************************************/
/************************* EBI TRICKBOX REGISTERS *****************************/
/******************************************************************************/

/* ---------------------------------------------------------------------------*/
/* The Offset values are from the EBI trickbox register base address.         */
/* ---------------------------------------------------------------------------*/
/******************************************************************************/
/*============================================================================*/
/* Register                Offset                 R/W            Width        */
/*============================================================================*/
/* EbiTrCntl               0x0000                 R/W            9-bits       */
/* EbiTrStatus             0x0004                 R/             6-bits       */
/* EbiTrClk                0x0008                 R/W            3-bits       */
/* EbiTrAddr1              0x000C                 R/W            32-bits      */
/* EbiTrAddr2              0x0010                 R/W            32-bits      */
/* EbiTrAddr3              0x0014                 R/W            32-bits      */
/* EbiTrData1              0x0018                 R/W            32-bits      */
/* EbiTrData2              0x001C                 R/W            32-bits      */
/* EbiTrData3              0x0020                 R/W            32-bits      */
/* nEbiTrDataEn1           0x0024                 R/W            4-bits       */
/* nEbiTrDataEn2           0x0028                 R/W            4-bits       */
/* nEbiTrDataEn3           0x002C                 R/W            4-bits       */
/* EbiTrExtDataIn          0x0030                 R/W            32-bits      */
/* EbiTrTimeOut1           0x0034                 R/W            10-bits      */
/* EbiTrTimeOut2           0x0038                 R/W            10-bits      */
/* EbiTrTimeOut3           0x003C                 R/W            10-bits      */
/******************************************************************************/
#define Ebi_Trick_Base                0x80000000
#define EbiTrCntl                     (Ebi_Trick_Base + 0x0000)
#define EbiTrStatus                   (Ebi_Trick_Base + 0x0004)
#define EbiTrClk                      (Ebi_Trick_Base + 0x0008)
#define EbiTrAddr1                    (Ebi_Trick_Base + 0x000C)
#define EbiTrAddr2                    (Ebi_Trick_Base + 0x0010)
#define EbiTrAddr3                    (Ebi_Trick_Base + 0x0014)
#define EbiTrData1                    (Ebi_Trick_Base + 0x0018)
#define EbiTrData2                    (Ebi_Trick_Base + 0x001C)
#define EbiTrData3                    (Ebi_Trick_Base + 0x0020)
#define nEbiTrDataEn1                 (Ebi_Trick_Base + 0x0024)
#define nEbiTrDataEn2                 (Ebi_Trick_Base + 0x0028)
#define nEbiTrDataEn3                 (Ebi_Trick_Base + 0x002C)
#define EbiTrExtDataIn                (Ebi_Trick_Base + 0x0030)
#define EbiTrTimeOut1                 (Ebi_Trick_Base + 0x0034)
#define EbiTrTimeOut2                 (Ebi_Trick_Base + 0x0038)
#define EbiTrTimeOut3                 (Ebi_Trick_Base + 0x003C)

/****************************** End *******************************************/



