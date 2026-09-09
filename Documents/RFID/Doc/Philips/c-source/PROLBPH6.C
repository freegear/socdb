/******************************** (c)MIKRON ********************************\
*                                                                           *
*  Program-File      PROLBPH6.C                                             *
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
//CUST   You only have to include header PROLBPH6.H, when you want to use
//CUST   functions for PIT. For more information see PROLBPH6.H and PROLIB6.H.
//CUST
//CUST   Below are the C-sources of all the specific PIT-functions
//CUST
//CUST ----------------------------------------------------------------------


//*************************** FUNCTION OVERVIEW *****************************
//
//   Function overview: shows the order of functions in this file
//   ------------------      (mark function-name to search & find)
//
//   PIT:
//         proloc_ReadPit
//         proloc_WritePit
//         proloc_WritePitBlock
//
//   RWD PERSONALIZATION:
//         proloc_WritePitSecurity
//         proloc_WritePitPassword
//
//**************************************************************************/


/***************************************************************************\
*  proloc_ReadPit (BYTE_T blknmb, BYTE_T next, char *data)
*
*  reads blocks from the PIT in 16-byte blocks.
*  ATTENTION: When using this command, do no other action between reading
*             blocks, since data can be lost if they are not read in time.
*             If a block is lost EPIT (-14) arises.
*
*  Input    BYTE_T    blknmb   // number of blocks to read from PIT
*           BYTE_T    next     // 0..send command & receive first data block
*                              // 1..receive following blocks.
*  Output   char      *data    // data read from the PIT ( 16 byte ).
*  Global   BYTE_T    pit_command  // used in proloc_ComISR to control
*                                  // serial interface actions.
*           BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_ReadPit (BYTE_T blknmb, BYTE_T next, char *data)
{
	 //
		//      if (next==0)      write command & receive first data block
		//      if (next!=0)      only receive next data block
		//

	 pit_command=1;
	 if (!next)
	 {
			//
			//      +------+-----+--------+-----+
			//      | 0x03 | 'T' | blknmb | BCC |
			//      +------+-----+--------+-----+
			//

			SBuffer[0] = 3;
			SBuffer[1] = READ_PHILIPS;
			SBuffer[2] = blknmb;
			UPtr       = data;

			SendBlock (3);
	 }
	 else
	 {
			//
			//      set variables to receive next block
			//
			RWDEot   = 0;
			UPtr = data;      //      set data pointer
	 }
}



/***************************************************************************\
*  proloc_WritePit (BYTE_T byteaddr, BYTE_T bytenmb, char *data)
*
*  writes a block of up to 16 bytes to a PIT
*
*  Input    BYTE_T    byteaddr      // start address on the PIT
*           BYTE_T    bytenmb      // number of bytes to be written
*           char      *data    // datastring, up to 16 data-bytes long
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_WritePit (BYTE_T byteaddr, BYTE_T bytenmb, char *data)
{
 //
 // +-----------+-----+----------+---------+---------+-----+-----------------+-----+
 // | 4+bytenmb | 't' | byteaddr | bytenmb | data[0] | ... | data[bytenmb-1] | BCC |
 // +-----------+-----+----------+---------+---------+-----+-----------------+-----+
 //

		//
		//      maximum 16 characters
		//

		if (bytenmb>16)      bytenmb=16;

	 SBuffer[0] = bytenmb+4;
	 SBuffer[1] = WRITE_PHILIPS;
	 SBuffer[2] = byteaddr;
	 SBuffer[3] = bytenmb;
	 memcpy (&SBuffer[4], data, bytenmb);

	 SendBlock (bytenmb+4);
}



/***************************************************************************\
*  proloc_WritePitBlock (BYTE_T blkaddr, BYTE_T bytenmb, char *data)
*
*  writes up to 16 bytes to a PIT from beginning of a block-address
*
*  Input    BYTE_T    blkaddr  // block address, range: 0 - 7
*           BYTE_T    bytenmb  // number of bytes to be written. Max 16 bytes
*           char      *data    // datapointer to data to be written
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_WritePitBlock (BYTE_T blkaddr, BYTE_T bytenmb, char *data)
{
 //
 // +-----------+-----+---------+---------+-----+-----------------+-----+
 // | 3+bytenmb | 'u' | blkaddr | data[0] | ... | data[bytenmb-1] | BCC |
 // +-----------+-----+---------+---------+-----+-----------------+-----+
 //

	 SBuffer[0] = bytenmb+3;
	 SBuffer[1] = WRITE_PIT_BLOCK;
	 SBuffer[2] = blkaddr;
	 memcpy (&SBuffer[3], data, bytenmb);

	 SendBlock (bytenmb+3);
}






//===========================================================================
//
//                       RWD PERSONALITATION FUNCTIONS
//
//===========================================================================



/***************************************************************************\
*  proloc_WritePitSecurity (BYTE_T mode)
*
*  switches the Password Mode for Philips transponders on or off.
*
*  Input    BYTE_T    mode     // Password Mode: ON  (1),
*                                                OFF (0).
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_WritePitSecurity (BYTE_T mode)
{
	 //
	 //      +------+-----+------+-----+
	 //      | 0x03 | 'v' | mode | BCC |
	 //      +------+-----+------+-----+
	 //

	 SBuffer[0] = 0x03;
	 SBuffer[1] = WRITE_PIT_SECURITY;
	 SBuffer[2] = mode;

	 starttimer_2 ();
	 SendBlock (3);
}

/***************************************************************************\
*  proloc_WritePitPassword (char *data)
*
*  writes the 7-byte password to the internal EEPROM of the RWD.
*
*  Input    char      *data    // datapointer to the password.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_WritePitPassword (char *data)
{
	 //
	 //      +------+-----+---------+-----+---------+-----+
	 //      | 0x09 | 'w' | Data[0] | ... | Data[6] | BCC |
	 //      +------+-----+---------+-----+---------+-----+
	 //

	 SBuffer[0] = 0x09;
	 SBuffer[1] = WRITE_PIT_PASSWORD;
	 memcpy (&SBuffer[2], data, 7);

	 starttimer_2 ();
	 SendBlock (9);
}
