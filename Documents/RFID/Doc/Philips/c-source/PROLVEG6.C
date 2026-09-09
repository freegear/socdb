/******************************** (c)MIKRON ********************************\
*                                                                           *
*  Program-File      PROLVEG6.C                                             *
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
//CUST   You only have to include header PROLVEG6.H, when you want to use
//CUST   VEGAS-functions. For more informations see PROLVEG6.H and
//CUST   PROLIB6.H.
//CUST
//CUST   Below are the C-sources of all the specific VEGAS-functions
//CUST
//CUST ----------------------------------------------------------------------


//*************************** FUNCTION OVERVIEW *****************************
//
//   Function overview: shows the order of functions in this file
//   ------------------      (mark function-name to search & find)
//
//   RWD:
//         proloc_GetDspVersion
//
//   HITAG1:
//         proloc_ReadAllPage
//
//**************************************************************************/


/***************************************************************************\
*  proloc_GetDspVersion (char *data)
*
*  Retrieves the version number of the DSP-software.
*
*  Input    -
*  Output   char *data // Version of the DSP. 16 bytes
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/

void	proloc_GetDspVersion(char *data)
{
	 //
	 //      +------+-----+-----+
	 //      | 0x02 | 'v' | BCC |
	 //      +------+-----+-----+
	 //

	SBuffer[0] = 2;
	SBuffer[1] = GET_DSP_VERSION;
	UPtr       = (char *) data;

	starttimer_2 ();
	SendBlock (2);
}



/***************************************************************************\
*  proloc_ReadAllPage (BYTE_T mode, BYTE_T pagenr, char *data,
*                      WORD_T *data_len)
*
*  Reads the same page of all HITAG 1 transponders in the active antenna
*  field.
*
*  Input    BYTE_T mode
*           BYTE_T pagenr
*  Output   char *data   // buffer for received data bytes. Caution: size
*                        // of buffer must be dimensioned big enough by
*                        // the user
*           WORD_T *datalen  // number of received data bytes
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/

void	proloc_ReadAllPage(BYTE_T mode, BYTE_T pagenr, char *data, WORD_T *data_len)
{
	 //
	 //      +------+------+------+--------+-----+
	 //      | 0x04 | 0x98 | mode | pagenr | BCC |
	 //      +------+------+------+--------+-----+
	 //

	SBuffer[0] = 4;
	SBuffer[1] = READ_ALL_PAGE;
	SBuffer[2] = mode;
	SBuffer[3] = pagenr;

	UPtr       = data;

	starttimer_2 ();
	SendBlock (4);
	*data_len=0;
	while(1)
	{
		while (!RWDEot);
		if (!RWDErr)
		{
			*data_len+=4;
			UPtr       = (data+ (*data_len));
			starttimer_2 ();
			RWDEot=0;
		}
		else break;
	}
}


