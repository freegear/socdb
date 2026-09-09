//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//

#include <windows.h>
#include <bsp.h>
#include <ethdbg.h>
#include <fmd.h>
#include "loader.h"


char *inet_ntoa(DWORD dwIP);
DWORD inet_addr( char *pszDottedD );
BOOL EbootInitEtherTransport (EDBG_ADDR *pEdbgAddr, LPDWORD pdwSubnetMask,
                              BOOL *pfJumpImg,
                              DWORD *pdwDHCPLeaseTime,
                              UCHAR VersionMajor, UCHAR VersionMinor,
                              char *szPlatformString, char *szDeviceName,
                              UCHAR CPUId, DWORD dwBootFlags);
BOOL EbootEtherReadData (DWORD cbData, LPBYTE pbData);
EDBG_OS_CONFIG_DATA *EbootWaitForHostConnect (EDBG_ADDR *pDevAddr, EDBG_ADDR *pHostAddr);
// End   ***************************************


// Globals
//
DWORD			g_ImageType;
MultiBINInfo	g_BINRegionInfo;
PBOOT_CFG		g_pBootCfg;
UCHAR			g_TOC[SECTOR_SIZE];
const PTOC 		g_pTOC = (PTOC)&g_TOC;
DWORD			g_dwImageStartBlock;
DWORD			g_dwTocEntry;
BOOL			g_bBootMediaExist = FALSE;
BOOL			g_bDownloadImage  = TRUE;
BOOL 			g_bWaitForConnect = TRUE;

EDBG_ADDR 		g_DeviceAddr; // NOTE: global used so it remains in scope throughout download process
                        // since eboot library code keeps a global pointer to the variable provided.

// External definitions.
//
extern const BYTE ScreenBitmap[];



/*
    @func   void | SpinForever | Halts execution (used in error conditions).
    @rdesc  
    @comm    
    @xref   
*/
static void SpinForever(void)
{
    EdbgOutputDebugString("SpinForever...\r\n");

    while(1)
    {
        ;
    }
}


/*
    @func   void | main | Samsung bootloader C routine entry point.
    @rdesc  N/A.
    @comm    
    @xref   
*/
void main(void)
{
	
    // Clear LEDs.
    //   
    OEMWriteDebugLED(0, 0xF);
	
    // Common boot loader (blcommon) main routine.
    //    
    BootloaderMain();

    // Should never get here.
    // 
    SpinForever();
}


/*
    @func   void | InitDisplay | Initializes the LCD controller and displays a splashscreen image.
    @rdesc  N/A.
    @comm    
    @xref   
*/
static void InitDisplay(void)
{
    volatile SMT926A_IOPORT_REG *smtIOP = (SMT926A_IOPORT_REG *)OALPAtoVA(SMT926A_BASE_REG_PA_IOPORT, FALSE);
    volatile SMT926A_LCD_REG    *smtLCD = (SMT926A_LCD_REG *)OALPAtoVA(SMT926A_BASE_REG_PA_LCD, FALSE);
	unsigned int clkval_calc;  // 040507
    // Set up the LCD controller registers to display a power-on bitmap image.
    //
    smtIOP->GPCUP     = 0xFFFFFFFF;
    smtIOP->GPCCON    = 0xAAAAAAAA;
                                    
    smtIOP->GPDUP     = 0xFFFFFFFF;
    smtIOP->GPDCON    = 0xAAAAAAAA; 

	clkval_calc = (WORD)((float)(SMT926A_HCLK)/(2.0*5000000)+0.5)-1;
    smtLCD->LCDCON1   =  (clkval_calc           <<  8) |       /* VCLK = HCLK / ((CLKVAL + 1) * 2) -> About 7 Mhz  */
                           (LCD_MVAL   <<  7)  |       /* 0 : Each Frame                                   */
                           (3           <<  5) |       /* TFT LCD Pannel                                   */
                           (12          <<  1) |       /* 16bpp Mode                                       */
                           (0           <<  0) ;       /* Disable LCD Output                               */

    smtLCD->LCDCON2   =  (LCD_VBPD        << 24) |   /* VBPD          :   1                              */
                           (LCD_LINEVAL_TFT << 14) |   /* Vertical Size : 320 - 1                          */
                           (LCD_VFPD        <<  6) |   /* VFPD          :   2                              */
                           (LCD_VSPW        <<  0) ;   /* VSPW          :   1                              */

    smtLCD->LCDCON3   =  (LCD_HBPD        << 19) |   /* HBPD          :   6                              */
                           (LCD_HOZVAL_TFT  <<  8) |   /* HOZVAL_TFT    : 240 - 1                          */
                           (LCD_HFPD        <<  0) ;   /* HFPD          :   2                              */


    smtLCD->LCDCON4   =  (LCD_MVAL        <<  8) |   /* MVAL          :  13                              */
                           (LCD_HSPW        <<  0) ;   /* HSPW          :   4                              */

    smtLCD->LCDCON5   =  (0           << 12) |       /* BPP24BL       : LSB valid                        */
                           (1           << 11) |       /* FRM565 MODE   : 5:6:5 Format                     */
                           (0           << 10) |       /* INVVCLK       : VCLK Falling Edge                */
                           (1           <<  9) |       /* INVVLINE      : Inverted Polarity                */
                           (1           <<  8) |       /* INVVFRAME     : Inverted Polarity                */
                           (0           <<  7) |       /* INVVD         : Normal                           */
                           (0           <<  6) |       /* INVVDEN       : Normal                           */
                           (0           <<  5) |       /* INVPWREN      : Normal                           */
                           (0           <<  4) |       /* INVENDLINE    : Normal                           */
                           (1           <<  3) |       /* PWREN         : Disable PWREN                    */
                           (0           <<  2) |       /* ENLEND        : Disable LEND signal              */
                           (0           <<  1) |       /* BSWP          : Swap Disable                     */
                           (1           <<  0) ;       /* HWSWP         : Swap Enable                      */

    smtLCD->LCDSADDR1 = ((IMAGE_FRAMEBUFFER_DMA_BASE >> 22)     << 21) | 
                          ((M5D(IMAGE_FRAMEBUFFER_DMA_BASE >> 1)) <<  0);

    smtLCD->LCDSADDR2 = M5D((IMAGE_FRAMEBUFFER_DMA_BASE + (LCD_XSIZE_TFT * LCD_YSIZE_TFT * 2)) >> 1);

    smtLCD->LCDSADDR3 = (((LCD_XSIZE_TFT - LCD_XSIZE_TFT) / 1) << 11) | (LCD_XSIZE_TFT / 1);        

    //smtLCD->TCONSEL   |= 0x3;
	smtLCD->TCONSEL   &= (~7);
    smtLCD->TCONSEL   |= (0x1<<4);

	smtLCD->TPAL      = 0x0;        
    smtLCD->LCDCON1  |= 1;

    // Display a bitmap image on the LCD...
    //
    memcpy((void *)IMAGE_FRAMEBUFFER_UA_BASE, ScreenBitmap, LCD_ARRAY_SIZE_TFT_16BIT);

}


/*
    @func   void | SetIP | Accepts IP address from user input.
    @rdesc  N/A.
    @comm    
    @xref   
*/

static void SetIP(PBOOT_CFG pBootCfg)
{
    CHAR   szDottedD[16];   // The string used to collect the dotted decimal IP address.
    USHORT cwNumChars = 0;
    USHORT InChar = 0;

    EdbgOutputDebugString("\r\nEnter new IP address: ");

    while(!((InChar == 0x0d) || (InChar == 0x0a)))
    {
        InChar = OEMReadDebugByte();
        if (InChar != OEM_DEBUG_COM_ERROR && InChar != OEM_DEBUG_READ_NODATA) 
        {
            // If it's a number or a period, add it to the string.
            //
            if (InChar == '.' || (InChar >= '0' && InChar <= '9')) 
            {
                if (cwNumChars < 16) 
                {
                    szDottedD[cwNumChars++] = (char)InChar;
                    OEMWriteDebugByte((BYTE)InChar);
                }
            }
            // If it's a backspace, back up.
            //
            else if (InChar == 8) 
            {
                if (cwNumChars > 0) 
                {
                    cwNumChars--;
                    OEMWriteDebugByte((BYTE)InChar);
                }
            }
        }
    }

    // If it's a carriage return with an empty string, don't change anything.
    //
    if (cwNumChars) 
    {
        szDottedD[cwNumChars] = '\0';
        pBootCfg->EdbgAddr.dwIP = inet_addr(szDottedD);
    }
}


/*
    @func   void | SetMask | Accepts subnet mask from user input.
    @rdesc  N/A.
    @comm    
    @xref   
*/
static void SetMask(PBOOT_CFG pBootCfg)
{
    CHAR szDottedD[16]; // The string used to collect the dotted masks.
    USHORT cwNumChars = 0;
    USHORT InChar = 0;

    EdbgOutputDebugString("\r\nEnter new subnet mask: ");

    while(!((InChar == 0x0d) || (InChar == 0x0a)))
    {
        InChar = OEMReadDebugByte();
        if (InChar != OEM_DEBUG_COM_ERROR && InChar != OEM_DEBUG_READ_NODATA) 
        {
            // If it's a number or a period, add it to the string.
            //
            if (InChar == '.' || (InChar >= '0' && InChar <= '9')) 
            {
                if (cwNumChars < 16) 
                {
                    szDottedD[cwNumChars++] = (char)InChar;
                    OEMWriteDebugByte((BYTE)InChar);
                }
            }
            // If it's a backspace, back up.
            //
            else if (InChar == 8) 
            {
                if (cwNumChars > 0) 
                {
                    cwNumChars--;
                    OEMWriteDebugByte((BYTE)InChar);
                }
            }
        }
    }

    // If it's a carriage return with an empty string, don't change anything.
    //
    if (cwNumChars) 
    {
        szDottedD[cwNumChars] = '\0';
        pBootCfg->SubnetMask = inet_addr(szDottedD);
    }
}


/*
    @func   void | SetDelay | Accepts an autoboot delay value from user input.
    @rdesc  N/A.
    @comm    
    @xref   
*/
static void SetDelay(PBOOT_CFG pBootCfg)
{
    CHAR szCount[16];
    USHORT cwNumChars = 0;
    USHORT InChar = 0;

    EdbgOutputDebugString("\r\nEnter maximum number of seconds to delay [1-255]: ");

    while(!((InChar == 0x0d) || (InChar == 0x0a)))
    {
        InChar = OEMReadDebugByte();
        if (InChar != OEM_DEBUG_COM_ERROR && InChar != OEM_DEBUG_READ_NODATA) 
        {
            // If it's a number or a period, add it to the string.
            //
            if ((InChar >= '0' && InChar <= '9')) 
            {
                if (cwNumChars < 16) 
                {
                    szCount[cwNumChars++] = (char)InChar;
                    OEMWriteDebugByte((BYTE)InChar);
                }
            }
            // If it's a backspace, back up.
            //
            else if (InChar == 8) 
            {
                if (cwNumChars > 0) 
                {
                    cwNumChars--;
                    OEMWriteDebugByte((BYTE)InChar);
                }
            }
        }
    }

    // If it's a carriage return with an empty string, don't change anything.
    //
    if (cwNumChars) 
    {
        szCount[cwNumChars] = '\0';
        pBootCfg->BootDelay = atoi(szCount);
        if (pBootCfg->BootDelay > 255)
        {
            pBootCfg->BootDelay = 255;
        } 
        else if (pBootCfg->BootDelay < 1)
        {
            pBootCfg->BootDelay = 1;
        }
    }
}


static ULONG mystrtoul(PUCHAR pStr, UCHAR nBase)
{
    UCHAR nPos=0;
    BYTE c;
    ULONG nVal = 0;
    UCHAR nCnt=0;
    ULONG n=0;

    // fulllibc doesn't implement isctype or iswctype, which are needed by
    // strtoul, rather than including coredll code, here's our own simple strtoul.

    if (pStr == NULL)
        return(0);

    for (nPos=0 ; nPos < strlen(pStr) ; nPos++)
    {
        c = tolower(*(pStr + strlen(pStr) - 1 - nPos));
        if (c >= '0' && c <= '9')
            c -= '0';
        else if (c >= 'a' && c <= 'f')
        {
            c -= 'a';
            c  = (0xa + c);
        }

        for (nCnt = 0, n = 1 ; nCnt < nPos ; nCnt++)
        {
            n *= nBase;
        }
        nVal += (n * c);
    }

    return(nVal);
}


static void CvtMAC(USHORT MacAddr[3], char *pszDottedD ) 
{
    DWORD cBytes;
    char *pszLastNum;
    int atoi (const char *s);
    int i=0;    
    BYTE *p = (BYTE *)MacAddr;

    // Replace the dots with NULL terminators
    pszLastNum = pszDottedD;
    for(cBytes = 0 ; cBytes < 6 ; cBytes++)
    {
        while(*pszDottedD != '.' && *pszDottedD != '\0')
        {
            pszDottedD++;
        }
        if (pszDottedD == '\0' && cBytes != 5)
        {
            // zero out the rest of MAC address
            while(i++ < 6)
            {
                *p++ = 0;
            }
            break;
        }
        *pszDottedD = '\0';
        *p++ = (BYTE)(mystrtoul(pszLastNum, 16) & 0xFF);
        i++;
        pszLastNum = ++pszDottedD;
    }
}


static void SetLAN91C111MACAddress(PBOOT_CFG pBootCfg)
{
    CHAR szDottedD[24];
    USHORT cwNumChars = 0;
    USHORT InChar = 0;

    memset(szDottedD, '0', 24);

    EdbgOutputDebugString ( "\r\nEnter new MAC address in hexadecimal (hh.hh.hh.hh.hh.hh): ");

    while(!((InChar == 0x0d) || (InChar == 0x0a)))
    {
        InChar = OEMReadDebugByte();
        InChar = tolower(InChar);
        if (InChar != OEM_DEBUG_COM_ERROR && InChar != OEM_DEBUG_READ_NODATA) 
        {
            // If it's a hex number or a period, add it to the string.
            //
            if (InChar == '.' || (InChar >= '0' && InChar <= '9') || (InChar >= 'a' && InChar <= 'f')) 
            {
                if (cwNumChars < 17) 
                {
                    szDottedD[cwNumChars++] = (char)InChar;
                    OEMWriteDebugByte((BYTE)InChar);
                }
            }
            else if (InChar == 8)       // If it's a backspace, back up.
            {
                if (cwNumChars > 0) 
                {
                    cwNumChars--;
                    OEMWriteDebugByte((BYTE)InChar);
                }
            }
        }
    }

    EdbgOutputDebugString ( "\r\n");

    // If it's a carriage return with an empty string, don't change anything.
    //
    if (cwNumChars) 
    {
        szDottedD[cwNumChars] = '\0';
        CvtMAC(pBootCfg->EdbgAddr.wMAC, szDottedD);

        EdbgOutputDebugString("INFO: MAC address set to: %x:%x:%x:%x:%x:%x\r\n",
                  pBootCfg->EdbgAddr.wMAC[0] & 0x00FF, pBootCfg->EdbgAddr.wMAC[0] >> 8,
                  pBootCfg->EdbgAddr.wMAC[1] & 0x00FF, pBootCfg->EdbgAddr.wMAC[1] >> 8,
                  pBootCfg->EdbgAddr.wMAC[2] & 0x00FF, pBootCfg->EdbgAddr.wMAC[2] >> 8);
    }
    else
    {
        EdbgOutputDebugString("WARNING: SetLAN91C111MACAddress: Invalid MAC address.\r\n");
    }
}


/*
    @func   BOOL | MainMenu | Manages the Samsung bootloader main menu.
    @rdesc  TRUE == Success and FALSE == Failure.
    @comm    
    @xref   
*/

static BOOL MainMenu(PBOOT_CFG pBootCfg)
{
    BYTE KeySelect = 0;
    BOOL bConfigChanged = FALSE;
    BOOLEAN bDownload = TRUE;

    while(TRUE)
    {
        KeySelect = 0;

        EdbgOutputDebugString ( "\r\nEthernet Boot Loader Configuration:\r\n\r\n");
        EdbgOutputDebugString ( "0) IP address: %s\r\n",inet_ntoa(pBootCfg->EdbgAddr.dwIP));
        EdbgOutputDebugString ( "1) Subnet mask: %s\r\n", inet_ntoa(pBootCfg->SubnetMask));
        EdbgOutputDebugString ( "2) DHCP: %s\r\n", (pBootCfg->ConfigFlags & CONFIG_FLAGS_DHCP)?"Enabled":"Disabled");
        EdbgOutputDebugString ( "3) Boot delay: %d seconds\r\n", pBootCfg->BootDelay);
        EdbgOutputDebugString ( "4) Reset to factory default configuration\r\n");
        EdbgOutputDebugString ( "5) Startup image: %s\r\n", (g_pBootCfg->ConfigFlags & BOOT_TYPE_DIRECT) ? "LAUNCH EXISTING" : "DOWNLOAD NEW");
        EdbgOutputDebugString ( "6) Program disk image into SmartMedia card: %s\r\n", (pBootCfg->ConfigFlags & TARGET_TYPE_NAND)?"Enabled":"Disabled");
        EdbgOutputDebugString ( "7) Program LAN91C111 MAC address (%B:%B:%B:%B:%B:%B)\r\n",
                               g_pBootCfg->EdbgAddr.wMAC[0] & 0x00FF, g_pBootCfg->EdbgAddr.wMAC[0] >> 8,
                               g_pBootCfg->EdbgAddr.wMAC[1] & 0x00FF, g_pBootCfg->EdbgAddr.wMAC[1] >> 8,
                               g_pBootCfg->EdbgAddr.wMAC[2] & 0x00FF, g_pBootCfg->EdbgAddr.wMAC[2] >> 8);
        EdbgOutputDebugString ( "8) Kernel Debugger: %s\r\n", (g_pBootCfg->ConfigFlags & CONFIG_FLAGS_DEBUGGER) ? "ENABLED" : "DISABLED");
        EdbgOutputDebugString ( "9) Format Boot Media for BinFS\r\n");

        // N.B: we need this option here since BinFS is really a RAM image, where you "format" the media
        // with an MBR. There is no way to parse the image to say it's ment to be BinFS enabled.
        EdbgOutputDebugString ( "F) Low-level format the Smart Media card\r\n");
        EdbgOutputDebugString ( "D) Download image now\r\n");
        EdbgOutputDebugString ( "L) LAUNCH existing Boot Media image\r\n");
		EdbgOutputDebugString ( "R) Read Configuration \r\n");
		EdbgOutputDebugString ( "W) Write Configuration Right Now\r\n");
        EdbgOutputDebugString ( "\r\nEnter your selection: ");

        while (! ( ( (KeySelect >= '0') && (KeySelect <= '9') ) ||
                   ( (KeySelect == 'D') || (KeySelect == 'd') ) ||
                   ( (KeySelect == 'F') || (KeySelect == 'f') ) ||
                   ( (KeySelect == 'L') || (KeySelect == 'l') ) ||
                   ( (KeySelect == 'R') || (KeySelect == 'r') ) ||
                   ( (KeySelect == 'W') || (KeySelect == 'w') ) ||
                   ( (KeySelect == 'X') || (KeySelect == 'x') ) ))
        {
            KeySelect = OEMReadDebugByte();
        }

        EdbgOutputDebugString ( "%c\r\n", KeySelect);

        switch(KeySelect)
        {
        case '0':           // Change IP address.
            SetIP(pBootCfg);
            pBootCfg->ConfigFlags &= ~CONFIG_FLAGS_DHCP;   // clear DHCP flag
            bConfigChanged = TRUE;
            break;
        case '1':           // Change subnet mask.
            SetMask(pBootCfg);
            bConfigChanged = TRUE;
            break;
        case '2':           // Toggle static/DHCP mode.
            pBootCfg->ConfigFlags = (pBootCfg->ConfigFlags ^ CONFIG_FLAGS_DHCP);
            bConfigChanged = TRUE;
            break;
        case '3':           // Change autoboot delay.
            SetDelay(pBootCfg);
            bConfigChanged = TRUE;
            break;
        case '4':           // Reset the bootloader configuration to defaults.
            OALMSG(TRUE, (TEXT("Resetting default TOC...\r\n")));
            TOC_Init(DEFAULT_IMAGE_DESCRIPTOR, (IMAGE_TYPE_RAMIMAGE|IMAGE_TYPE_BINFS), 0, 0, 0);
            if ( !TOC_Write() ) {
                OALMSG(OAL_WARN, (TEXT("TOC_Write Failed!\r\n")));
            }
            OALMSG(TRUE, (TEXT("...TOC complete\r\n")));
            break;
        case '5':           // Toggle download/launch status.
            pBootCfg->ConfigFlags = (pBootCfg->ConfigFlags ^ BOOT_TYPE_DIRECT);
            bConfigChanged = TRUE;
            break;
        case '6':           // Toggle image storage to Smart Media.
            pBootCfg->ConfigFlags = (pBootCfg->ConfigFlags ^ TARGET_TYPE_NAND);
            bConfigChanged = TRUE;
            break;
        case '7':           // Configure Crystal LAN91C111 MAC address.
            SetLAN91C111MACAddress(pBootCfg);
            bConfigChanged = TRUE;
            break;
        case '8':           // Toggle KD
            g_pBootCfg->ConfigFlags = (g_pBootCfg->ConfigFlags ^ CONFIG_FLAGS_DEBUGGER);
            g_bWaitForConnect = (g_pBootCfg->ConfigFlags & CONFIG_FLAGS_DEBUGGER) ? TRUE : FALSE;
            bConfigChanged = TRUE;
            continue;
            break;            
        case '9':
            // format the boot media for BinFS
            // N.B: this does not destroy our OEM reserved sections (TOC, bootloaders, etc)
            if ( !g_bBootMediaExist ) {
				OALMSG(OAL_ERROR, (TEXT("ERROR: BootMonitor: boot media does not exist.\r\n")));
                continue;
            }
            // N.B: format offset by # of reserved blocks,
            // decrease the ttl # blocks available by that amount.
            if ( !BP_LowLevelFormat( g_dwImageStartBlock,
                                     NAND_BLOCK_CNT - g_dwImageStartBlock,
                                     0) )
            {
                OALMSG(OAL_ERROR, (TEXT("ERROR: BootMonitor: Low-level boot media format failed.\r\n")));
                continue;
            }
            break;
        case 'F':
        case 'f':
            // low-level format
            // N.B: this erases images, BinFs, FATFS, user data, etc.
            // However, we don't format Bootloaders & TOC bolcks; use JTAG for this.
            if ( !g_bBootMediaExist ) {
				OALMSG(OAL_ERROR, (TEXT("ERROR: BootMonitor: boot media does not exist.\r\n")));
                continue;
            } else {
                DWORD i;
                SectorInfo si;

                // to keep bootpart off of our reserved blocks we must mark it as bad, reserved & read-only
                si.bOEMReserved = OEM_BLOCK_RESERVED | OEM_BLOCK_READONLY;
                si.bBadBlock    = BADBLOCKMARK;
                si.dwReserved1  = 0xffffffff;
                si.wReserved2   = 0xffff;

                OALMSG(TRUE, (TEXT("Reserving Blocks [0x%x - 0x%x] ...\r\n"), 0, IMAGE_START_BLOCK-1));
                for (i = 0; i < IMAGE_START_SECTOR; i++) {
                    FMD_WriteSector(i, NULL, &si, 1);
                }
                OALMSG(TRUE, (TEXT("...reserve complete.\r\n")));

                OALMSG(TRUE, (TEXT("Low-level format Blocks [0x%x - 0x%x] ...\r\n"), IMAGE_START_BLOCK, NAND_BLOCK_CNT-1));
                for (i = IMAGE_START_BLOCK; i < NAND_BLOCK_CNT; i++) {
                    FMD_EraseBlock(i);
                }
                OALMSG(TRUE, (TEXT("...erase complete.\r\n")));
            } break;
        case 'D':           // Download? Yes.
        case 'd':
            bDownload = TRUE;
            goto MENU_DONE;
        case 'L':           // Download? No.
        case 'l':
            bDownload = FALSE;
            goto MENU_DONE;
        case 'R':
        case 'r':
			TOC_Read();
			TOC_Print();
            // TODO
            break;
        case 'W':           // Configuration Write
        case 'w':
            if (!TOC_Write())
            {
                OALMSG(OAL_WARN, (TEXT("WARNING: MainMenu: Failed to store updated eboot configuration in flash.\r\n")));
            }
            else
            {
                OALMSG(OAL_INFO, (TEXT("Successfully Written\r\n")));
                bConfigChanged = FALSE;
            }
            break;
        default:
            break;
        }
    }

MENU_DONE:

    // If eboot settings were changed by user, save them to flash.
    //
    if (bConfigChanged && !TOC_Write())
    {
        OALMSG(OAL_WARN, (TEXT("WARNING: MainMenu: Failed to store updated bootloader configuration to flash.\r\n")));
    }

    return(bDownload);    
}


/*
    @func   BOOL | OEMPlatformInit | Initialize the SMT SMT926 platform hardware.
    @rdesc  TRUE = Success, FALSE = Failure.
    @comm    
    @xref   
*/
BOOL OEMPlatformInit(void)
{
    ULONG BootDelay;
    UINT8 KeySelect;
    UINT32 dwStartTime, dwPrevTime, dwCurrTime;
    BOOLEAN bResult = FALSE;

    OALMSG(OAL_FUNC, (TEXT("+OEMPlatformInit.\r\n")));

    EdbgOutputDebugString("Microsoft Windows CE Bootloader for the SMT SkyWalker Version %d.%d Built %s\r\n\r\n", 
                          EBOOT_VERSION_MAJOR, EBOOT_VERSION_MINOR, __DATE__);

    // Initialize the display.
    //
    InitDisplay();

    // Initialize the BSP args structure.
    //
    memset(pBSPArgs, 0, sizeof(BSP_ARGS));
    pBSPArgs->header.signature       = OAL_ARGS_SIGNATURE;
    pBSPArgs->header.oalVersion      = OAL_ARGS_VERSION;
    pBSPArgs->header.bspVersion      = BSP_ARGS_VERSION;
    pBSPArgs->kitl.flags             = OAL_KITL_FLAGS_ENABLED | OAL_KITL_FLAGS_VMINI;
    pBSPArgs->kitl.devLoc.IfcType    = Internal;
    pBSPArgs->kitl.devLoc.BusNumber  = 0;
    pBSPArgs->kitl.devLoc.LogicalLoc = BSP_BASE_REG_PA_LAN91C111_IOBASE;

    // This should not change unless reserved blocks are added/removed;
    // made global to do the calc only once.
    g_dwImageStartBlock = IMAGE_START_BLOCK;

    // Try to initialize the boot media block driver and BinFS partition.
    //
    if ( !BP_Init((LPBYTE)BINFS_RAM_START, BINFS_RAM_LENGTH, NULL, NULL, NULL) )
    {
        OALMSG(OAL_WARN, (TEXT("WARNING: OEMPlatformInit failed to initialize Boot Media.\r\n")));
        g_bBootMediaExist = FALSE;
    }
    else
        g_bBootMediaExist = TRUE;

    // Try to retrieve TOC (and Boot config) from boot media
    //
    if ( !TOC_Read( ) ) 
    {
        // use default settings
        TOC_Init(DEFAULT_IMAGE_DESCRIPTOR, (IMAGE_TYPE_RAMIMAGE), 0, 0, 0);
    }

    // Display boot message - user can halt the autoboot by pressing any key on the serial terminal emulator.
    //
    BootDelay = g_pBootCfg->BootDelay;

    if (g_pBootCfg->ConfigFlags & BOOT_TYPE_DIRECT)
    {
        OALMSG(TRUE, (TEXT("Press [ENTER] to launch image stored on boot media, or [SPACE] to enter boot monitor.\r\n")));
        OALMSG(TRUE, (TEXT("\r\nInitiating image launch in %d seconds. "),BootDelay--));

    }
    else
    {
        OALMSG(TRUE, (TEXT("Press [ENTER] to download image stored on boot media, or [SPACE] to enter boot monitor.\r\n")));
        OALMSG(TRUE, (TEXT("\r\nInitiating image download in %d seconds. "),BootDelay--));
    }

    dwStartTime = OEMEthGetSecs();
    dwPrevTime  = dwStartTime;
    dwCurrTime  = dwStartTime;
    KeySelect   = 0;

    // Allow the user to break into the bootloader menu.
    //
    while((dwCurrTime - dwStartTime) < g_pBootCfg->BootDelay)
    {
        KeySelect = OEMReadDebugByte();
        if ((KeySelect == 0x20) || (KeySelect == 0x0d))
            break;
        dwCurrTime = OEMEthGetSecs();

        if (dwCurrTime > dwPrevTime)
        {
            int i, j;

            // 1 Second has elapsed - update the countdown timer.
            dwPrevTime = dwCurrTime;
            if (BootDelay < 9)
                i = 11;
            else if (BootDelay < 99)
                i = 12;
            else if (BootDelay < 999)
                i = 13;

            for(j = 0; j < i; j++)
                OEMWriteDebugByte((BYTE)0x08); // print back space
            EdbgOutputDebugString ( "%d seconds. ", BootDelay--);
        }
    }
	OALMSG(OAL_INFO, (TEXT("\r\n")));

    // Boot or enter bootloader menu.
    //
    switch(KeySelect)
    {
    case 0x20: // Boot menu.
        g_bDownloadImage = MainMenu(g_pBootCfg);
        break;
    case 0x00: // Fall through if no keys were pressed -or-
    case 0x0d: // the user cancelled the countdown.
    default:
        if (g_pBootCfg->ConfigFlags & BOOT_TYPE_DIRECT)
        {
			OALMSG(TRUE, (TEXT("\r\nLaunching image from boot media ... \r\n")));
            g_bDownloadImage = FALSE;
        }
        else
        {
			OALMSG(TRUE, (TEXT("\r\nStarting auto-download ... \r\n")));
            g_bDownloadImage = TRUE;
        }
        break;
    }

    if ( !g_bDownloadImage )
    {
        // User doesn't want to download image - load it from the boot media.
        // We could read an entire nk.bin or nk.nb0 into ram and jump.
        if ( !VALID_TOC(g_pTOC) ) {
			OALMSG(OAL_ERROR, (TEXT("OEMPlatformInit: ERROR_INVALID_TOC, can not autoboot.\r\n")));
            return FALSE;
        }
        switch (g_ImageType) {
        	case IMAGE_TYPE_STEPLDR:
				OALMSG(TRUE, (TEXT("Don't support launch STEPLDR.bin\r\n")));
                break;
        	
            case IMAGE_TYPE_LOADER:
				OALMSG(TRUE, (TEXT("Don't support launch EBOOT.bin\r\n")));
                break;

            case IMAGE_TYPE_RAMIMAGE:
				OALMSG(TRUE, (TEXT("OEMPlatformInit: IMAGE_TYPE_RAMIMAGE\r\n")));
                if ( !ReadOSImageFromBootMedia( ) ) 
                {
                    OALMSG(OAL_ERROR, (TEXT("OEMPlatformInit ERROR: Failed to load kernel region into RAM.\r\n")));
                    return FALSE;
                }
				break;

            default:
				OALMSG(OAL_ERROR, (TEXT("OEMPlatformInit ERROR: unknown image type: 0x%x \r\n"), g_ImageType));
                return FALSE;
        }
    }

    // Configure Ethernet controller.
    //
		if (!InitEthDevice(g_pBootCfg))
    	{
        	OALMSG(OAL_ERROR, (TEXT("ERROR: OEMPlatformInit: Failed to initialize Ethernet controller.\r\n")));
        	goto CleanUp;
        }

    bResult = TRUE;

CleanUp:

    OALMSG(OAL_FUNC, (TEXT("_OEMPlatformInit.\r\n")));
    return(bResult);
}


/*
    @func   DWORD | OEMPreDownload | Complete pre-download tasks - get IP address, initialize TFTP, etc.
    @rdesc  BL_DOWNLOAD = Platform Builder is asking us to download an image, BL_JUMP = Platform Builder is requesting we jump to an existing image, BL_ERROR = Failure.
    @comm    
    @xref   
*/
DWORD OEMPreDownload(void)
{
    BOOL  bGotJump = FALSE;
    DWORD dwDHCPLeaseTime = 0;
    PDWORD pdwDHCPLeaseTime = &dwDHCPLeaseTime;
    DWORD dwBootFlags = 0;

    OALMSG(OAL_FUNC, (TEXT("+OEMPreDownload.\r\n")));

    // Create device name based on Ethernet address (this is how Platform Builder identifies this device).
    //
    OALKitlCreateName(BSP_DEVICE_PREFIX, pBSPArgs->kitl.mac, pBSPArgs->deviceId);
    OALMSG(OAL_INFO, (L"INFO: *** Device Name '%hs' ***\r\n", pBSPArgs->deviceId));

    // If the user wants to use a static IP address, don't request an address 
    // from a DHCP server.  This is done by passing in a NULL for the DHCP 
    // lease time variable.  If user specified a static IP address, use it (don't use DHCP).
    //
    if (!(g_pBootCfg->ConfigFlags & CONFIG_FLAGS_DHCP))
    {
        // Static IP address.
        pBSPArgs->kitl.ipAddress  = g_pBootCfg->EdbgAddr.dwIP;
        pBSPArgs->kitl.ipMask     = g_pBootCfg->SubnetMask;
        pBSPArgs->kitl.flags     &= ~OAL_KITL_FLAGS_DHCP;
        pdwDHCPLeaseTime = NULL;
        OALMSG(OAL_INFO, (TEXT("INFO: Using static IP address %s.\r\n"), inet_ntoa(pBSPArgs->kitl.ipAddress))); 
        OALMSG(OAL_INFO, (TEXT("INFO: Using subnet mask %s.\r\n"),       inet_ntoa(pBSPArgs->kitl.ipMask))); 
    }
    else
    {
        pBSPArgs->kitl.ipAddress = 0;
        pBSPArgs->kitl.ipMask    = 0;
    }

    if ( !g_bDownloadImage)
    {
        return(BL_JUMP);
    }

    // Initialize the the TFTP transport.
    //
    g_DeviceAddr.dwIP = pBSPArgs->kitl.ipAddress;
    memcpy(g_DeviceAddr.wMAC, pBSPArgs->kitl.mac, (3 * sizeof(UINT16)));
    g_DeviceAddr.wPort = 0;

    if (!EbootInitEtherTransport(&g_DeviceAddr,
                                 &pBSPArgs->kitl.ipMask,
                                 &bGotJump,
                                 pdwDHCPLeaseTime,
                                 EBOOT_VERSION_MAJOR,
                                 EBOOT_VERSION_MINOR,
                                 BSP_DEVICE_PREFIX,
                                 pBSPArgs->deviceId,
                                 EDBG_CPU_ARM720,
                                 dwBootFlags))
    {
        OALMSG(OAL_ERROR, (TEXT("ERROR: OEMPreDownload: Failed to initialize Ethernet connection.\r\n")));
        return(BL_ERROR);
    }


    // If the user wanted a DHCP address, we presumably have it now - save it for the OS to use.
    //
    if (g_pBootCfg->ConfigFlags & CONFIG_FLAGS_DHCP)
    {
        // DHCP address.
        pBSPArgs->kitl.ipAddress  = g_DeviceAddr.dwIP;
        pBSPArgs->kitl.flags     |= OAL_KITL_FLAGS_DHCP;
    }
        
    OALMSG(OAL_FUNC, (TEXT("_OEMPreDownload.\r\n")));

    return(bGotJump ? BL_JUMP : BL_DOWNLOAD);
}


/*
    @func   BOOL | OEMReadData | Generically read download data (abstracts actual transport read call).
    @rdesc  TRUE = Success, FALSE = Failure.
    @comm    
    @xref   
*/
BOOL OEMReadData(DWORD dwData, PUCHAR pData)
{
    OALMSG(OAL_FUNC, (TEXT("+OEMReadData.\r\n")));
    return(EbootEtherReadData(dwData, pData));
}


/*
    @func   void | OEMShowProgress | Displays download progress for the user.
    @rdesc  N/A.
    @comm    
    @xref   
*/
void OEMShowProgress(DWORD dwPacketNum)
{
    OALMSG(OAL_FUNC, (TEXT("+OEMShowProgress.\r\n")));
}


/*
    @func   void | OEMLaunch | Executes the stored/downloaded image.
    @rdesc  N/A.
    @comm    
    @xref   
*/

void OEMLaunch( DWORD dwImageStart, DWORD dwImageLength, DWORD dwLaunchAddr, const ROMHDR *pRomHdr )
{
    DWORD dwPhysLaunchAddr;
    EDBG_ADDR EshellHostAddr;
    EDBG_OS_CONFIG_DATA *pCfgData;    

    OALMSG(OAL_FUNC, (TEXT("+OEMLaunch.\r\n")));

    // If the user requested that a disk image (stored in RAM now) be written to the SmartMedia card, so it now.
    //
    if (g_bDownloadImage && (g_pBootCfg->ConfigFlags & TARGET_TYPE_NAND))
    {
        // Since this platform only supports RAM images, the image cache address is the same as the image RAM address.
        //

        switch (g_ImageType) 
        {
        	case IMAGE_TYPE_STEPLDR:
		        if (!WriteRawImageToBootMedia(dwImageStart, dwImageLength, dwLaunchAddr))
		        {
            		OALMSG(OAL_ERROR, (TEXT("ERROR: OEMLaunch: Failed to store image to Smart Media.\r\n")));
            		goto CleanUp;
        		}
		        OALMSG(TRUE, (TEXT("INFO: Step loader image stored to Smart Media.  Please Reboot.  Halting...\r\n")));
	        	while(1)
	        	{
            		// Wait...
	        	}
        		break;
        	
            case IMAGE_TYPE_LOADER:
				g_pTOC->id[0].dwLoadAddress = dwImageStart;
				g_pTOC->id[0].dwTtlSectors = FILE_TO_SECTOR_SIZE(dwImageLength);
		        if (!WriteRawImageToBootMedia(dwImageStart, dwImageLength, dwLaunchAddr))
		        {
            		OALMSG(OAL_ERROR, (TEXT("ERROR: OEMLaunch: Failed to store image to Smart Media.\r\n")));
            		goto CleanUp;
        		}
				if (dwLaunchAddr && (g_pTOC->id[0].dwJumpAddress != dwLaunchAddr))
				{
					g_pTOC->id[0].dwJumpAddress = dwLaunchAddr;
					if ( !TOC_Write() ) {
	            		EdbgOutputDebugString("*** OEMLaunch ERROR: TOC_Write failed! Next boot may not load from disk *** \r\n");
					}
	        		TOC_Print();
				}
		        OALMSG(TRUE, (TEXT("INFO: Eboot image stored to Smart Media.  Please Reboot.  Halting...\r\n")));
		        while(1)
		        {
            		// Wait...
        		}        		
        		        		
                break;

            case IMAGE_TYPE_RAMIMAGE:
				g_pTOC->id[g_dwTocEntry].dwLoadAddress = dwImageStart;
				g_pTOC->id[g_dwTocEntry].dwTtlSectors = FILE_TO_SECTOR_SIZE(dwImageLength);
		        if (!WriteOSImageToBootMedia(dwImageStart, dwImageLength, dwLaunchAddr))
		        {
            		OALMSG(OAL_ERROR, (TEXT("ERROR: OEMLaunch: Failed to store image to Smart Media.\r\n")));
            		goto CleanUp;
        		}

				if (dwLaunchAddr && (g_pTOC->id[g_dwTocEntry].dwJumpAddress != dwLaunchAddr))
				{
					g_pTOC->id[g_dwTocEntry].dwJumpAddress = dwLaunchAddr;
					if ( !TOC_Write() ) {
	            		EdbgOutputDebugString("*** OEMLaunch ERROR: TOC_Write failed! Next boot may not load from disk *** \r\n");
					}
	        		TOC_Print();
				}
				else
				{
					dwLaunchAddr= g_pTOC->id[g_dwTocEntry].dwJumpAddress;
					EdbgOutputDebugString("INFO: using TOC[%d] dwJumpAddress: 0x%x\r\n", g_dwTocEntry, dwLaunchAddr);
				}
        		        		
                break;
        }
    }
    else if(g_bDownloadImage)
    {
        switch (g_ImageType) 
        {
        	case IMAGE_TYPE_STEPLDR:
		        OALMSG(TRUE, (TEXT("Stepldr image can't launch from ram.\r\n")));
		        OALMSG(TRUE, (TEXT("You should program it into flash.\r\n")));
		        SpinForever();
				break;
            case IMAGE_TYPE_LOADER:
		        OALMSG(TRUE, (TEXT("Eboot image can't launch from ram.\r\n")));
		        OALMSG(TRUE, (TEXT("You should program it into flash.\r\n")));
		        SpinForever();
		        break;
            default:
            	break;
    	}
    }

    OALMSG(1, (TEXT("waitforconnect\r\n")));
    // Wait for Platform Builder to connect after the download and send us IP and port settings for service
    // connections - also sends us KITL flags.  This information is used later by the OS (KITL).
    //
    if (g_bDownloadImage & g_bWaitForConnect)
    {
        memset(&EshellHostAddr, 0, sizeof(EDBG_ADDR));

        g_DeviceAddr.dwIP  = pBSPArgs->kitl.ipAddress;
        memcpy(g_DeviceAddr.wMAC, pBSPArgs->kitl.mac, (3 * sizeof(UINT16)));
        g_DeviceAddr.wPort = 0;

        if (!(pCfgData = EbootWaitForHostConnect(&g_DeviceAddr, &EshellHostAddr)))
        {
            OALMSG(OAL_ERROR, (TEXT("ERROR: OEMLaunch: EbootWaitForHostConnect failed.\r\n")));
            goto CleanUp;
        }

        // If the user selected "passive" KITL (i.e., don't connect to the target at boot time), set the
        // flag in the args structure so the OS image can honor it when it boots.
        //
        if (pCfgData->KitlTransport & KTS_PASSIVE_MODE)
        {
            pBSPArgs->kitl.flags |= OAL_KITL_FLAGS_PASSIVE;
        }
	}
    
    // If a launch address was provided, we must have downloaded the image, save the address in case we
    // want to jump to this image next time.  If no launch address was provided, retrieve the last one.
    //
	if (dwLaunchAddr && (g_pTOC->id[g_dwTocEntry].dwJumpAddress != dwLaunchAddr))
	{
		g_pTOC->id[g_dwTocEntry].dwJumpAddress = dwLaunchAddr;
	}
	else
	{
		dwLaunchAddr= g_pTOC->id[g_dwTocEntry].dwJumpAddress;
		OALMSG(OAL_INFO, (TEXT("INFO: using TOC[%d] dwJumpAddress: 0x%x\r\n"), g_dwTocEntry, dwLaunchAddr));
	}

    // Jump to downloaded image (use the physical address since we'll be turning the MMU off)...
    //
    dwPhysLaunchAddr = (DWORD)OALVAtoPA((void *)dwLaunchAddr);
    OALMSG(TRUE, (TEXT("INFO: OEMLaunch: Jumping to Physical Address 0x%Xh (Virtual Address 0x%Xh)...\r\n\r\n\r\n"), dwPhysLaunchAddr, dwLaunchAddr));

    // Jump...
    //
    Launch(dwPhysLaunchAddr);


CleanUp:

    OALMSG(TRUE, (TEXT("ERROR: OEMLaunch: Halting...\r\n")));
    SpinForever();
}


//------------------------------------------------------------------------------
//
//  Function Name:  OEMVerifyMemory( DWORD dwStartAddr, DWORD dwLength )
//  Description..:  This function verifies the passed address range lies
//                  within a valid region of memory. Additionally this function
//                  sets the g_ImageType if the image is a boot loader. 
//  Inputs.......:  DWORD           Memory start address
//                  DWORD           Memory length
//  Outputs......:  BOOL - true if verified, false otherwise
//
//------------------------------------------------------------------------------

BOOL OEMVerifyMemory( DWORD dwStartAddr, DWORD dwLength )
{

    OALMSG(OAL_FUNC, (TEXT("+OEMVerifyMemory.\r\n")));

    // Is the image being downloaded the stepldr?
    if ((dwStartAddr >= STEPLDR_RAM_IMAGE_BASE) &&
        ((dwStartAddr + dwLength - 1) < (STEPLDR_RAM_IMAGE_BASE + STEPLDR_RAM_IMAGE_SIZE)))
    {
        OALMSG(OAL_INFO, (TEXT("Stepldr image\r\n")));
        g_ImageType = IMAGE_TYPE_STEPLDR;     // Stepldr image.
        return TRUE;
    }
    // Is the image being downloaded the bootloader?
    else if ((dwStartAddr >= EBOOT_STORE_ADDRESS) &&
        ((dwStartAddr + dwLength - 1) < (EBOOT_STORE_ADDRESS + EBOOT_STORE_MAX_LENGTH)))
    {
        OALMSG(OAL_INFO, (TEXT("Eboot image\r\n")));
        g_ImageType = IMAGE_TYPE_LOADER;     // Eboot image.
        return TRUE;
    }

    // Is it a ram image?
    else if ((dwStartAddr >= ROM_RAMIMAGE_START) &&
        ((dwStartAddr + dwLength - 1) < (ROM_RAMIMAGE_START + ROM_RAMIMAGE_SIZE)))
    {
        OALMSG(OAL_INFO, (TEXT("RAM image\r\n")));
        g_ImageType = IMAGE_TYPE_RAMIMAGE;
        return TRUE;
    }
	else if (!dwStartAddr && !dwLength)
	{
        OALMSG(TRUE, (TEXT("Don't support raw image\r\n")));
		g_ImageType = IMAGE_TYPE_RAWBIN;
    	return FALSE;
	}

    // HACKHACK: get around MXIP images with funky addresses
    OALMSG(TRUE, (TEXT("BIN image type unknow\r\n")));

    OALMSG(OAL_FUNC, (TEXT("_OEMVerifyMemory.\r\n")));

    return FALSE;
}

/*
    @func   void | OEMMultiBINNotify | Called by blcommon to nofity the OEM code of the number, size, and location of one or more BIN regions,
                                       this routine collects the information and uses it when temporarily caching a flash image in RAM prior to final storage.
    @rdesc  N/A.
    @comm
    @xref
*/
void OEMMultiBINNotify(const PMultiBINInfo pInfo)
{
    BYTE nCount;
	DWORD g_dwMinImageStart;

    OALMSG(OAL_FUNC, (TEXT("+OEMMultiBINNotify.\r\n")));

    if (!pInfo || !pInfo->dwNumRegions)
    {
        OALMSG(OAL_WARN, (TEXT("WARNING: OEMMultiBINNotify: Invalid BIN region descriptor(s).\r\n")));
        return;
    }

	if (!pInfo->Region[0].dwRegionStart && !pInfo->Region[0].dwRegionLength)
	{
    	return;
	}

    g_dwMinImageStart = pInfo->Region[0].dwRegionStart;

    OALMSG(TRUE, (TEXT("\r\nDownload BIN file information:\r\n")));
    OALMSG(TRUE, (TEXT("-----------------------------------------------------\r\n")));
    for (nCount = 0 ; nCount < pInfo->dwNumRegions ; nCount++)
    {
        OALMSG(TRUE, (TEXT("[%d]: Base Address=0x%x  Length=0x%x\r\n"),
            nCount, pInfo->Region[nCount].dwRegionStart, pInfo->Region[nCount].dwRegionLength));
        if (pInfo->Region[nCount].dwRegionStart < g_dwMinImageStart)
        {
            g_dwMinImageStart = pInfo->Region[nCount].dwRegionStart;
            if (g_dwMinImageStart == 0)
            {
                OALMSG(OAL_WARN, (TEXT("WARNING: OEMMultiBINNotify: Bad start address for region (%d).\r\n"), nCount));
                return;
            }
        }
    }

    memcpy((LPBYTE)&g_BINRegionInfo, (LPBYTE)pInfo, sizeof(MultiBINInfo));

    OALMSG(TRUE, (TEXT("-----------------------------------------------------\r\n")));
    OALMSG(OAL_FUNC, (TEXT("_OEMMultiBINNotify.\r\n")));
}

/////////////////////// START - Stubbed functions - START //////////////////////////////
/*
    @func   void | SC_WriteDebugLED | Write to debug LED.
    @rdesc  N/A.
    @comm    
    @xref   
*/

void SC_WriteDebugLED(USHORT wIndex, ULONG dwPattern)
{
    // Stub - needed by NE2000 EDBG driver...
    //
}


ULONG HalSetBusDataByOffset(IN BUS_DATA_TYPE BusDataType,
                            IN ULONG BusNumber,
                            IN ULONG SlotNumber,
                            IN PVOID Buffer,
                            IN ULONG Offset,
                            IN ULONG Length)
{
    return(0);
}


ULONG
HalGetBusDataByOffset(IN BUS_DATA_TYPE BusDataType,
                      IN ULONG BusNumber,
                      IN ULONG SlotNumber,
                      IN PVOID Buffer,
                      IN ULONG Offset,
                      IN ULONG Length)
{
    return(0);
}


BOOLEAN HalTranslateBusAddress(IN INTERFACE_TYPE  InterfaceType,
                               IN ULONG BusNumber,
                               IN PHYSICAL_ADDRESS BusAddress,
                               IN OUT PULONG AddressSpace,
                               OUT PPHYSICAL_ADDRESS TranslatedAddress)
{

    // All accesses on this platform are memory accesses...
    //
    if (AddressSpace)
        *AddressSpace = 0;
 
    // 1:1 mapping...
    //
    if (TranslatedAddress)
    {
        *TranslatedAddress = BusAddress;
        return(TRUE);
    }

    return(FALSE);
}


PVOID MmMapIoSpace(IN PHYSICAL_ADDRESS PhysicalAddress,
                   IN ULONG NumberOfBytes,
                   IN BOOLEAN CacheEnable)
{
    DWORD dwAddr = PhysicalAddress.LowPart;

    if (CacheEnable)
        dwAddr &= ~CACHED_TO_UNCACHED_OFFSET; 
    else
        dwAddr |= CACHED_TO_UNCACHED_OFFSET; 

    return((PVOID)dwAddr);
}


VOID MmUnmapIoSpace(IN PVOID BaseAddress,
                    IN ULONG NumberOfBytes)
{
}

VOID WINAPI SetLastError(DWORD dwErrCode)
{
}
/////////////////////// END - Stubbed functions - END //////////////////////////////


/*
    @func   PVOID | GetKernelExtPointer | Locates the kernel region's extension area pointer.
    @rdesc  Pointer to the kernel's extension area.
    @comm    
    @xref   
*/
PVOID GetKernelExtPointer(DWORD dwRegionStart, DWORD dwRegionLength)
{
    DWORD dwCacheAddress = 0;
    ROMHDR *pROMHeader;
    DWORD dwNumModules = 0;
    TOCentry *pTOC;

    if (dwRegionStart == 0 || dwRegionLength == 0)
        return(NULL);

    if (*(LPDWORD) OEMMapMemAddr (dwRegionStart, dwRegionStart + ROM_SIGNATURE_OFFSET) != ROM_SIGNATURE)
        return NULL;

    // A pointer to the ROMHDR structure lives just past the ROM_SIGNATURE (which is a longword value).  Note that
    // this pointer is remapped since it might be a flash address (image destined for flash), but is actually cached
    // in RAM.
    //
    dwCacheAddress = *(LPDWORD) OEMMapMemAddr (dwRegionStart, dwRegionStart + ROM_SIGNATURE_OFFSET + sizeof(ULONG));
    pROMHeader     = (ROMHDR *) OEMMapMemAddr (dwRegionStart, dwCacheAddress);

    // Make sure sure are some modules in the table of contents.
    //
    if ((dwNumModules = pROMHeader->nummods) == 0)
        return NULL;

    // Locate the table of contents and search for the kernel executable and the TOC immediately follows the ROMHDR.
    //
    pTOC = (TOCentry *)(pROMHeader + 1);

    while(dwNumModules--) {
        LPBYTE pFileName = OEMMapMemAddr(dwRegionStart, (DWORD)pTOC->lpszFileName);
        if (!strcmp((const char *)pFileName, "nk.exe")) {
            return ((PVOID)(pROMHeader->pExtensions));
        }
        ++pTOC;
    }
    return NULL;
}


/*
    @func   BOOL | OEMDebugInit | Initializes the serial port for debug output message.
    @rdesc  TRUE == Success and FALSE == Failure.
    @comm    
    @xref   
*/
BOOL OEMDebugInit(void)
{

    // Set up function callbacks used by blcommon.
    //
    g_pOEMVerifyMemory   = OEMVerifyMemory;      // Verify RAM.
    g_pOEMMultiBINNotify = OEMMultiBINNotify;

    // Call serial initialization routine (shared with the OAL).
    //
    OEMInitDebugSerial();

    return(TRUE);
}
