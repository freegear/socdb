/******************************** (c)MIKRON ********************************\
*                                                                           *
*  Program-File      PROLBLT6.C                                             *
*                                                                           *
*  Project-Files     PROLIB6.C / (PROLIB6.IDE)                              *
*  Project-Output    PROLIB6.LIB / DOS                                      *
*                                                                           *
*  Compiler          BC++ 3.1                                               *
*  Memory-Model      LARGE                                                  *
*                                                                           *
*===========================================================================*
*  versions see PROLIB6.c                                                   *
\*-------------------------------------------------------------------------*/



//CUST ===================== CUSTOMER-INFORMATION ===========================
//CUST
//CUST   CUSTOMER-INFORMATION:
//CUST   ---------------------
//CUST
//CUST   Do NOT INCLUDE this C-source in your sourcefile, since it is
//CUST   contents of the library PROLIB6.LIB!
//CUST   It's for your information.
//CUST   You only have to include header PROLBLT6.H, when you want to use
//CUST   functions for HITAG2. For more information see
//CUST   PROLBLT6.H and PROLIB6.H.
//CUST
//CUST   Below are the C-sources of all the specific HITAG2-functions
//CUST
//CUST ----------------------------------------------------------------------


//*************************** FUNCTION OVERVIEW *****************************
//
//   Function overview: shows the order of functions in this file
//   ------------------      (mark function-name to search & find)
//
//   HITAG2:
//         proloc_GetSnr_LT
//         proloc_HaltSelected_LT
//         proloc_ReadPage_LT
//         proloc_ReadPageInv_LT
//         proloc_WritePage_LT
//         proloc_ReadPit_LT
//         proloc_ReadPublicB_LT
//
//   RWD:
//         proloc_SetBCDOffset
//
//   RWD PERSONALIZATION:
//         proloc_ReadControl_LT
//         proloc_WriteControl_LT
//         proloc_ReadSecret_LT
//         proloc_WriteSecret_LT
//         proloc_GetSnrReset_LT
//
//**************************************************************************/



/***************************************************************************\
*  proloc_GetSnr_LT (BYTE_T mode, DWORD_T *snr, BYTE_T *config)
*
*  reads the serial number and the configuration byte from the HITAG2
*  either in PASSWORD(0) or CRYPTO(1) mode. This command selects the HITAG2
*  for reading and writing. Errors are reported in RWDErr.
*
*  Input    BYTE_T    mode     // either PASSWORD(0) or CRYPTO(1)
*  Output   DWORD_T   *snr     // Pointer to the 4 byte serial number.
*           BYTE_T    config   // configuration byte.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SendBlock.
\***************************************************************************/
void proloc_GetSnr_LT (BYTE_T mode, DWORD_T *snr, BYTE_T *config)
{
	 //
	 //      +------+------+------+-----+
	 //      | 0x03 | 0x80 | mode | BCC |
	 //      +------+------+------+-----+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = LT_GET_SNR;
	 SBuffer[2] = mode;
	 UPtr       = (char *) snr;
	 UPtr2      = (char *) config;

	 starttimer_2 ();
	 SendBlock (3);
}


/***************************************************************************\
*  proloc_GetSnrReset_LT (BYTE_T mode,DWORD_T *snr, BYTE_T *config)
*
*  command reads the serial number and configuration byte of a HITAG2
*  transponder not in Password or Crypto Mode. This command selects the HITAG2
*  for reading and writing. Errors are reported in RWDErr.
*
*  Input    BYTE_T    mode     // either PASSWORD(0) or CRYPTO(1)
*  Output   DWORD_T   *snr     // Pointer to the 4 byte serial number.
*           BYTE_T    *config  // config-byte.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_GetSnrReset_LT (BYTE_T mode,DWORD_T *snr, BYTE_T *config)
{
	 //
	 //      +------+------+------+-----+-----+
	 //      | 0x04 | 0x80 | mode | 'M' | BCC |
	 //      +------+------+------+-----+-----+
	 //

	 SBuffer[0] = 4;
	 SBuffer[1] = LT_GET_SNR;
	 SBuffer[2] = mode;
	 SBuffer[3] = 'M';
	 UPtr       = (char *) snr;
	 UPtr2      = (char *) config;

	 starttimer_2 ();
	 SendBlock (4);
}


/***************************************************************************\
*  proloc_HaltSelected_LT (void)
*
*  puts the selected HITAG2 in Halt Mode. In this mode the
*  HITAG2 doesn't reply on any kind of command. You have to put it out of
*  rf-field or call a proloc_HFReset-command to be able to select it again.
*
*  Input    -
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SendBlock.
\***************************************************************************/
void proloc_HaltSelected_LT (void)
{
	 //
	 //      +------+------+------+
	 //      | 0x02 | 0x81 | 0x83 |
	 //      +------+------+------+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = LT_HALT_SELECTED;

	 starttimer_2 ();
	 SendBlock (2);
}


/***************************************************************************\
*  proloc_ReadPage_LT (BYTE_T pagenr, char *data)
*
*  reads one page (4 bytes) of a selected HITAG2.
*
*  Input    BYTE_T    pagenr   // page address, range 0 - 7
*  Output   char      *data    // Pointer to 4 bytes read data.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SendBlock.
\***************************************************************************/
void proloc_ReadPage_LT (BYTE_T pagenr, char *data)
{
	 //
	 //      +------+------+--------+-----+
	 //      | 0x04 | 0x82 | pagenr | BCC |
	 //      +------+------+--------+-----+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = LT_READ_PAGE;
	 SBuffer[2] = pagenr;
	 UPtr       = data;

	 starttimer_2 ();
	 SendBlock (3);
}

/***************************************************************************\
*  proloc_ReadPageInv_LT (BYTE_T pagenr, char *data)
*
*  reads one page (4 bytes) bit-inverse of a selected HITAG2. This is for
*  data-reliability.
*
*  Input    BYTE_T    pagenr   // page address, range 0 - 7
*  Output   char      *data    // Pointer to bit-inverse 4 bytes read data.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SendBlock.
\***************************************************************************/
void    proloc_ReadPageInv_LT (BYTE_T pagenr, char *data)
{
	 //
	 //      +------+------+--------+-----+
	 //      | 0x03 | 0x83 | pagenr | BCC |
	 //      +------+------+--------+-----+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = LT_READ_PAGE_INV;
	 SBuffer[2] = pagenr;
	 UPtr       = data;

	 starttimer_2 ();
	 SendBlock (3);
}



/***************************************************************************\
*  proloc_WritePage_LT (BYTE_T pagenr, char *data)
*
*  writes a page (4 bytes) to a selected HITAG2. Errors are reported in
*  RWDErr.
*
*  Input    BYTE_T    pagenr   // page address, range 0 - 7.
*           char      *data    // Pointer to 4 bytes write-data.
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SendBlock.
\***************************************************************************/
void    proloc_WritePage_LT (BYTE_T pagenr, char *data)
{

	 //
	 //      +------+------+--------+---------+-----+---------+-----+
	 //      | 0x07 | 0x84 | pagenr | data[0] | ... | data[3] | BCC |
	 //      +------+------+--------+---------+-----+---------+-----+
	 //

   SBuffer[0] = 7;
   SBuffer[1] = LT_WRITE_PAGE;
	 SBuffer[2] = pagenr;
   memcpy (&SBuffer[3], data, 4);
   UPtr       = (char *) 0; //data;

	 starttimer_2 ();
   SendBlock (7);
}



/***************************************************************************\
*  proloc_ReadPit_LT (char *data)
*
*  reads data from HITAG2 transponders which are in PIT-mode.
*  This command is interrupted by proloc_StopCommand.
*
*  Input    -
*  Output   char      *data    // Pointer to 16 bytes read-data.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SendBlock.
\***************************************************************************/
void proloc_ReadPit_LT (char *data)
{

	 //
	 //      +------+------+-----+
	 //      | 0x02 | 0x85 | BCC |
	 //      +------+------+-----+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = LT_READ_PIT;
	 UPtr       = data;

	 SendBlock (2);
}



/***************************************************************************\
*  proloc_ReadPublicB_LT
*
*  reads a block (16 bytes) from the a HITAG2-transponder in PublicB-mode
*  (4kBaud).
*  The data represent an 128-bit-stream and have to be prepared afterwards
*  for subsequent treatment.
*  This command is interrupted by proloc_StopCommand.
*
*  Output   char      *data    // Pointer to 16 bytes read-data
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void	proloc_ReadPublicB_LT (char *data)
{
	//
	//		ÚÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿
	//		³ 0x02 ³ '0x9E' ³ BCC ³
	//		ÀÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ
	//

	SBuffer[0] = 2;
	SBuffer[1] = LT_READ_PUBLICB;
	UPtr       = data;

	SendBlock (2);
}






//===========================================================================
//
//                           RWD FUNCTIONS
//
//===========================================================================



/***************************************************************************\
*  proloc_SetBCDOffset (BYTE_T bcd_offset)
*
*  sets the bitclockdata-offset-value
*
*  Input    BYTE_T    bcd_offset // bcd-offset-value for HITAG2 transponders.
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void   proloc_SetBCDOffset (BYTE_T bcd_offset)
{
	 //
	 //      +------+------+------------+-----+
	 //      | 0x03 | 0xA4 | bcd_offset | BCC |
	 //      +------+------+------------+-----+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = SET_BCD_OFFSET;
	 SBuffer[2] = bcd_offset;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (3);
}






//===========================================================================
//
//                       RWD PERSONALITATION FUNCTIONS
//
//===========================================================================



/***************************************************************************\
*  proloc_ReadControl_LT (BYTE_T *data)
*
*  reads the control byte Control_LT from the EEPROM of the RWD.
*
*  Input    -
*  Output   BYTE_T    *data    // data-byte holding all security-issues.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SendBlock.
\***************************************************************************/
void proloc_ReadControl_LT (BYTE_T *data)
{
	 //
	 //      +------+------+-------+
	 //      | 0x02 | 0x90 | 0x92  |
	 //      +------+------+-------+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = LT_READ_CONTROL;
	 UPtr       = (char *) data;

	 starttimer_2 ();
	 SendBlock (2);
}



/***************************************************************************\
*  proloc_WriteControl_LT (BYTE_T control_lt)
*
*  writes a value into the control byte Control_LT in the EEPROM of the RWD
*
*  Input    BYTE_T    control_lt // data-byte holding all security-issues.
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SendBlock.
\***************************************************************************/
void proloc_WriteControl_LT (BYTE_T control_lt)
{
	 //
	 //      +------+------+-------------+------+
	 //      | 0x03 | 0x91 | CONTROL_LT  | BCC  |
	 //      +------+------+-------------+------+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = LT_WRITE_CONTROL;
	 SBuffer[2] = control_lt;

	 starttimer_2 ();
	 SendBlock (3);
}


/***************************************************************************\
*  proloc_ReadSecret_LT (BYTE_T num, DWORD_T *data)
*
*  reads personalization data from the EEPROM of the RWD.
*
*  Input    BYTE_T    num      // kind of personalization data to be read,
*                              // possible values: KEY_LOW, KEY_HIGH,
*                              // PASSWORD_TAG, PASSWORD_RWD
*  Output   DWORD_T   *data    // replied data-string, 4-byte long.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SendBlock.
\***************************************************************************/
void proloc_ReadSecret_LT (BYTE_T num, DWORD_T *data)
{
	 //
	 //      +------+-----+-----+------+
	 //      | 0x03 | 'V' | num | BCC  |
	 //      +------+-----+-----+------+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = LT_READ_SECRET;
	 SBuffer[2] = num;
	 UPtr       = (char *)data;

	 starttimer_2 ();
	 SendBlock (3);
}


/***************************************************************************\
*  proloc_WriteSecret_LT (BYTE_T num, DWORD_T od, DWORD_T nd)
*
*  writes new personalization data into the EEPROM of the RWD.
*
*  Input    BYTE_T    num      // page address, possible values: KEY_LOW,
*                              // KEY_HIGH, PASSWORD_TAG, PASSWORD_RWD
*           DWORD_T   od       // old data-string, 4-byte long.
*           DWORD_T   nd       // new data-string, 4-byte long.
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_WriteSecret_LT (BYTE_T num, DWORD_T od, DWORD_T nd)
{
	 //
	 //      +------+-----+-----+----------+----------+-----+
	 //      | 0x0B | 'W' | num | od[0..3] | nd[0..3] | BCC |
	 //      +------+-----+-----+----------+----------+-----+
	 //                        LSB.....MSB  LSB.....MSB
	 //

	 SBuffer[0] = 11;
	 SBuffer[1] = LT_WRITE_SECRET;
	 SBuffer[2] = num;
	 memcpy (&SBuffer[3], (char *) &od, 4);
	 memcpy (&SBuffer[7], (char *) &nd, 4);
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (11);
}


