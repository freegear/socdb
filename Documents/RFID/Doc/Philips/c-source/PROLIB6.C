/******************************** (c)MIKRON ********************************\
*                                                                           *
*  Program-File      PROLIB6.C                                              *
*                                                                           *
*  Project-Files     PROLIB6.C / (PROLIB6.IDE)                              *
*  Project-Output    PROLIB6.LIB / DOS                                      *
*                                                                           *
*  Compiler          BC++ 4.5                                               *
*  Memory-Model      LARGE                                                  *
*                                                                           *
*===========================================================================*
*  Version 6.06      18-02-97  dk                                           *
\***************************************************************************/

#define MIKRON_TEST 0  // set to 0 for customers
											 // (set to 1 only for MIKRON-test)

#include    <bios.h>
#include    <string.h>
#include    <dos.h>

//   INTERNAL FUNCTIONS - prototypes
//

static void             InitComPort(unsigned);
static void             SendBlock(unsigned);
static void             SendOneCharacter(char);
static int              ReceiveOneCharacter(void);
static void             SetReadMode(void);         // init RS485 mode
static void             SetWriteMode(void);        // init RS485 mode
static void             SetErrorFlag(int);

static void     interrupt       proloc_TimerISR(void);
static void     interrupt       proloc_ComISR(void);

static void     interrupt       (far * old_com_isr) (void);
static void     interrupt       (far * old_timer_isr) (void);

#include "prolib6.h"  // all DEFINES, TYPEDEFs, GLOBAL VARIABLES and function-
											// declarations for HITAG1/MIRO-products and LOW-LEVEL.
#include "prolblt6.h" // function declarations & examples for HITAG2
#include "prolbph6.h" // function declarations & examples for PITs
#include "prolbmu6.h" // function declarations & examples for multiple RWDs
#include "prolveg6.h" // function declarations for VEGAS-functions
#pragma hdrstop
#include "prolblt6.c" // function definition for HITAG2
#include "prolbph6.c" // function definition for PITs
#include "prolveg6.c" // function definition for VEGAS-functions

#if MIKRON_TEST
	#include "prohide6.h" // test-functions
	#include "prohide6.c" // test-functions
	#include "proltt6.h"  // test-functions
	#include "proltt6.c"  // test-functions
#endif

//  global variables which hold user information after a call of one of the
//  proloc_functions:
//

char                 RWDErr;      // Errormassages, described in PROLIB6.H.
unsigned char        RWDEot;      // Signaling end of transmission.
unsigned char        RWDDataLen;  // Length of data-string, in the case when
																	// data is replied.
unsigned char        RWDAdr;      // Nodeaddress of the RWDs, should not be
																	// directly accessed by the customer.


//
//    GLOBAL VARIABLES
//

volatile int         Counter;
volatile BYTE_T      Timer;

static               int                  BaseAddr;
static               BYTE_T               Com;
static               BYTE_T               RecState;

BYTE_T               SBuffer[30];
BYTE_T               RBuffer[30];
BYTE_T               TempBuffer[100];
char                 *UPtr;
char                 *UPtr2;
static               char                 BCCMode;
BYTE_T               pit_command;
static               BYTE_T               pit_overflow;
volatile unsigned char serf;  // only for test
			 // Code for serial Errors: 1=PC-Statusregister, 2=Timeout
			 //                         3=BCC-Error, 4=RWD-Error
BYTE_T drecbuf[200];    // only for test
BYTE_T drecbuf_zeig;    // only for test
BYTE_T dtrmbuf[200];    // only for test
BYTE_T dtrmbuf_zeig;    // only for test
BYTE_T dstatbuf[200];   // only for test
BYTE_T dstatebuf[200];  // only for test


//*************************** FUNCTION OVERVIEW *****************************
//
//   Function overview: shows the order of functions in this file
//   ------------------      (mark function-name to search & find)
//
//   BASIC:
//         proloc_open
//         proloc_close
//
//   HITAG1:
//         proloc_GetSnr
//         proloc_GetSnr_Adv
//         proloc_SelectSnr
//         proloc_SelectLast
//         proloc_HaltSelected
//         proloc_ReadPage
//         proloc_ReadBlock
//         proloc_WritePage
//         proloc_WriteBlock
//         proloc_TagAuthent
//         proloc_MutualAuthent
//
//   MIRO:
//         proloc_ReadMiro
//
//   RWD:
//         proloc_GetVersion
//         proloc_Reset
//         proloc_HFReset
//         proloc_StopCommand
//         proloc_SetHFMode
//         proloc_ReadLRStatus
//         proloc_SetPowerDown
//         proloc_StartFFT
//         proloc_SetBCD
//         proloc_ReadBCD
//         proloc_ReadEEData
//         proloc_WriteEEData
//         proloc_SetOutput
//         proloc_ReadInput
//         proloc_ConfigPorts
//         proloc_ReadPorts
//         proloc_WritePorts
//         proloc_PollTags
//         proloc_PollKbTags
//         proloc_SetProxTrmTime
//         proloc_SetModuleAdr
//
//   RWD PERSONALIZATION:
//         proloc_KeyInitMode
//         proloc_ReadControl
//         proloc_WriteControl
//         proloc_ReadEEPROM
//         proloc_WriteEEPROM
//         proloc_WriteSerNum
//         proloc_SetBCC
//
//   LOW LEVEL:
//         InitComPort
//         SetReadMode
//         SetWriteMode
//         SendBlock
//         SetErrorFlag
//         SendOneCharacter
//         ReceiveOneCharacter
//         proloc_ComISR
//         proloc_TimerISR
//
//**************************************************************************/



//===========================================================================
//
//                           BASIC FUNCTIONS
//
//===========================================================================




/***************************************************************************\
*  proloc_open (char *ComStr)
*
*  opens the communication path from HOST to RWD by programming the serial
*  interface. The old values of interrupt and timer are stored to be re-
*  stored at the end of the proloc session.
*
*  Input    char      *ComStr  // "COM1" for COM1
*                              // "COM2" for COM2
*  Output   -
*  Return   int                // EOK : no error
*                              // ERR : error
\***************************************************************************/
int proloc_open (char *ComStr)
{
   BYTE_T            IMR;


	 strupr            (ComStr);

   //
   //              switch to standard bcc mode
	 //

   BCCMode = 0;

   //
	 //      - open serial port
   //      - init serial interrupt
	 //

   if (strcmp (ComStr, "COM1") == 0)
   {
      Com = 0;

      //
      //      - init IMR - register
      //      - init interrupt routine
			//      - set read mode of rs485
			//

      IMR =  inportb (0x21);
      IMR |= 0x11;

      outportb (0x21, IMR);                   //  disable interrupt   //
			InitComPort ((BaseAddr = 0x3F0));
			old_com_isr = getvect (0x0C);
			setvect (0x0C, proloc_ComISR);
			old_timer_isr = getvect (0x08);
      setvect (0x08, proloc_TimerISR);

			IMR &= (~0x11);

      outportb (0x21, IMR);                   //  enable interrupt    //
      inportb (BaseAddr+READ_WRITE);          //  DUMMY - READ        //

      return (EOK);
      }

	 if (strcmp (ComStr, "COM2") == 0)
	 {
      Com = 1;

      //
			//              - init IMR - register
      //              - init interrupt routine
      //              - set read mode of rs485
      //

			IMR =  inportb (0x21);
      IMR |= 0x09;

			outportb (0x21, IMR);                   //  disable interrupt   //
      InitComPort ((BaseAddr = 0x2F0));
      old_com_isr = getvect (0x0B);
      setvect (0x0B, proloc_ComISR);
      old_timer_isr = getvect (0x08);
      setvect (0x08, proloc_TimerISR);

      IMR &= (~0x09);

      outportb (0x21, IMR);                   //  enable interrupt    //
      inportb (BaseAddr+READ_WRITE);          //  DUMMY - READ        //

      return (EOK);
	 }

   return (ERR);
}



/***************************************************************************\
*  proloc_close (void)
*
*  restores old interrupt and timer values at the end of a proloc session.
*
*  Input    -
*  Output   -
*  Return   -
\***************************************************************************/
void proloc_close (void)
{
   //
   //              restore timer interrupt
   //

   if (old_timer_isr)
      setvect (0x08, old_timer_isr);

   //
	 //              restore serial interrupt
   //

	 if (!old_com_isr)
      return;

   if (!Com)
      setvect (0x0C, old_com_isr);
   else
      setvect (0x0B, old_com_isr);
}










//===========================================================================
//
//                           HITAG1 FUNCTIONS
//
//===========================================================================




/***************************************************************************\
*  proloc_GetSnr (DWORD_T *snr, BYTE_T *more)
*
*  replys the serial number of a HITAG1 in the rf-field. If there are more
*  HITAGs in field when using longrange-mode, then parameter 'more' is set to
*  1. If there aren't any HITAGs, RWDErr is set to ENOTAG.
*
*  Input    -
*  Output   DWORD_T   *snr     // Pointer to serialnumber of the HITAG1.
*                              // 4 bytes
*           BYTE_T    *more    // Pointer to -more-; set to 1, if more HITAGs are detected.
*                              // Only in longrange-mode
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           BYTE_T    *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_GetSnr (DWORD_T *snr, BYTE_T *more)
{
	 //
	 //      +------+-----+------+
	 //      | 0x02 | 'G' | 0x45 |
	 //      +------+-----+------+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = GET_SNR;
	 UPtr       = (char *) snr;
	 UPtr2      = (char *) more;

	 starttimer_2 ();
	 SendBlock (2);
}



/***************************************************************************\
*  proloc_GetSnr_Adv (DWORD_T *snr, BYTE_T *more)
*
*  replys the serial number of a advanced-mode capable HITAG1 in the rf-field
*  and sets the transponder in Advanced-mode.
*  If there are more HITAGs in field when using longrange-mode, then
*  parameter 'more' is set to 1.
*  If there aren't any new-mode capable HITAGs, RWDErr is set to ENOTAG.
*
*  Input    -
*  Output   DWORD_T   *snr     // Pointer to serialnumber of the HITAG1.
*                              // 4 bytes
*           BYTE_T    *more    // Pointer to -more-; set to 1, if more HITAGs are detected.
*                              // Only in longrange-mode
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_GetSnr_Adv (DWORD_T *snr, BYTE_T *more)
{
	 //
	 //      +------+------+------+
	 //      | 0x02 | 0xA2 | BCC  |
	 //      +------+------+------+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = GET_SNR_ADV;
	 UPtr       = (char *) snr;
	 UPtr2      = (char *) more;

	 starttimer_2 ();
	 SendBlock (2);
}



/***************************************************************************\
*  proloc_SelectSnr (DWORD_T snr, DWORD_T *otp)
*
*  selects a HITAG1 with a specified serial number. If this TAG is not in HF-
*  field RWDErr is set to ENOTAG. If the HITAG1 was selected correctly, the
*  configuration page 'otp' is replied.
*
*  Input    DWORD_T   snr      // serial number
*  Output   DWORD_T   *otp     // Pointer to the configuration page of the
*                              // HITAG1.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock..
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void    proloc_SelectSnr (DWORD_T snr, DWORD_T *otp)
{
	 //
	 //      +------+-----+--------+--------+--------+--------+-----+
	 //      | 0x06 | 'S' | snr[0] | snr[1] | snr[2] | snr[3] | BCC |
	 //      +------+-----+--------+--------+--------+--------+-----+
	 //                   LSB     .....    .....     MSB
	 //

	 SBuffer[0] = 6;
	 SBuffer[1] = SELECT_SNR;
	 *((DWORD_T *) &SBuffer[2]) = snr;
	 UPtr       = (char *) otp;

	 starttimer_2 ();
	 SendBlock (6);
}



/***************************************************************************\
*  proloc_SelectLast
*
*  selects the last correctly read HITAG for read/write mode. If no HITAG1 is
*  detected, RWDErr is set to ENOTAG.
*
*  Input    -
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_SelectLast (void)
{
   //
	 //      +------+-----+------+
	 //      | 0x02 | 'S' | 0x51 |
   //      +------+-----+------+
   //

   SBuffer[0] = 2;
   SBuffer[1] = SELECT_SNR;
   UPtr       = (char *) 0;

   starttimer_2 ();
   SendBlock (2);
}



/***************************************************************************\
*  proloc_HaltSelected (void)
*
*  puts the previously selected HITAG1 in the halt-mode, so it doesn't reply
*  on any commands until it is reseted by a HF-reset or you take it out
*  of rf-field.
*
*  Input    -
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_HaltSelected (void)
{
   //
   //      +------+-----+------+
   //      | 0x02 | 'H' | 0x4A |
   //      +------+-----+------+
   //

	 SBuffer[0] = 2;
   SBuffer[1] = HALT_SELECTED;
	 UPtr       = (char *) 0;

   starttimer_2 ();
	 SendBlock (2);
}



/***************************************************************************\
*  proloc_ReadPage (BYTE_T crypto, BYTE_T pagenr, char *data)
*
*  reads a page (4 byte) from the selected HITAG1.
*
*  Input    BYTE_T    crypto   // PLAIN .. normal mode, CRYPTO .. crypto mode
*           BYTE_T    pagenr   // pagenumber values: 0 .. 63; 1 page = 4 byte
*  Output   char      *data    // datastring, 4 bytes long
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_ReadPage (BYTE_T crypto, BYTE_T pagenr, char *data)
{
   //
	 //      +------+-----+--------+--------+-----+
	 //      | 0x04 | 'P' | crypto | pagenr | BCC |
   //      +------+-----+--------+--------+-----+
   //

   SBuffer[0] = 4;
   SBuffer[1] = READ_PAGE;
   SBuffer[2] = crypto;
   SBuffer[3] = pagenr;
	 UPtr       = data;

   starttimer_2 ();
   SendBlock (4);
}



/***************************************************************************\
*  proloc_ReadBlock (BYTE_T crypto, BYTE_T pagenr, char *data)
*
*  reads a block (1 - 4 pages, 1 page = 4 byte), starting at address 'pagenr',
*  from the selected HITAG1. If the address is not the beginn of a block,
*  data is read from the addressed page until the end of the block.
*
*  Input    BYTE_T    crypto   // PLAIN .. normal mode, CRYPTO .. crypto mode
*           BYTE_T    pagenr   // pagenumber values: 0 .. 63; 1 page = 4 byte
*  Output   char      *data    // datastring, 4 - 16 bytes long
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_ReadBlock (BYTE_T crypto, BYTE_T pagenr, char *data)
{
   //
   //      +------+-----+--------+--------+-----+
   //      | 0x04 | 'B' | crypto | pagenr | BCC |
	 //      +------+-----+--------+--------+-----+
   //

	 SBuffer[0] = 4;
   SBuffer[1] = READ_BLOCK;
	 SBuffer[2] = crypto;
	 SBuffer[3] = pagenr;
   UPtr       = data;

   starttimer_2 ();
   SendBlock (4);
}


/***************************************************************************\
*  proloc_WritePage (BYTE_T crypto, BYTE_T pagenr, char *data)
*
*  writes a page (4 byte) to the selected HITAG1.
*
*  Input    BYTE_T    crypto   // PLAIN .. normal mode, CRYPTO .. crypto mode
*           BYTE_T    pagenr   // pagenumber values: 0 .. 63; 1 page = 4 byte
*           char      *data    // datastring, 4 bytes long
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void    proloc_WritePage (BYTE_T crypto, BYTE_T pagenr, char *data)
{
   //
   //      +------+-----+--------+--------+---------+-----+---------+-----+
   //      | 0x08 | 'p' | crypto | pagenr | data[0] | ... | data[3] | BCC |
   //      +------+-----+--------+--------+---------+-----+---------+-----+
   //

	 SBuffer[0] = 8;
   SBuffer[1] = WRITE_PAGE;
   SBuffer[2] = crypto;
   SBuffer[3] = pagenr;
   memcpy (&SBuffer[4], data, 4);
   UPtr       = data;

	 starttimer_2 ();
   SendBlock (8);
}



/***************************************************************************\
*  proloc_WriteBlock (BYTE_T crypto, BYTE_T pagenr, char *data)
*
*  writes a block (1 - 4 pages, 1 page = 4 byte) starting at address 'pagenr'
*  to the selected HITAG1. If the address is not the beginn of a block
*  the block is written from the address until blockend.
*
*  Input    BYTE_T    crypto   // PLAIN .. normal mode, CRYPTO .. crypto mode
*           BYTE_T    pagenr   // pagenumber values: 0 .. 63; 1 page = 4 byte
*           char      *data    // datastring, 4 - 16 bytes long
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void    proloc_WriteBlock (BYTE_T crypto, BYTE_T pagenr, char *data)
{
	 BYTE_T len;


	 //
	 //      +-------+-----+--------+--------+---------+-----+---------+-----+
	 //      | 4+len | 'b' | crypto | pagenr | data[0] | ... | data[n] | BCC |
	 //      +-------+-----+--------+--------+---------+-----+---------+-----+
	 //

	 len = (4-(pagenr%4))*4;

	 SBuffer[0] = 4+len;
	 SBuffer[1] = WRITE_BLOCK;
	 SBuffer[2] = crypto;
	 SBuffer[3] = pagenr;
	 memcpy (&SBuffer[4], data, len);
	 UPtr       = data;

	 starttimer_2 ();
	 SendBlock (4+len);
}



/***************************************************************************\
*  proloc_TagAuthent (BYTE_T keyinfo)
*
*  starts a simple authentification process for a HITAG1. If it was successful
*  you can only use proloc_GetSnr or proloc_HFReset to continue.
*  No cyphered communication is possible. If the authentification failed
*  RWDErr is set to EAUTHENT.
*
*  Input    BYTE_T    keyinfo  // use either AUTHENT_KEY_A or AUTHENT_KEY_B
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void    proloc_TagAuthent (BYTE_T keyinfo)
{
   //
	 //      +------+-----+---------+-----+
	 //      | 0x03 | 'a' | keyinfo | BCC |
   //      +------+-----+---------+-----+
	 //

   SBuffer[0] = 0x03;
   SBuffer[1] = TAG_AUTHENT;
   SBuffer[2] = keyinfo;
   UPtr       = (char *) 0;

   starttimer_2 ();
   SendBlock (3);
}


/***************************************************************************\
*  proloc_MutualAuthent (BYTE_T keyinfo)
*
*  starts the authentfication between the RWD and the HITAG1. If it was
*  successful a cyphered communication can take place.
*
*  Input    BYTE_T    keyinfo  // use either AUTHENT_KEY_A or AUTHENT_KEY_B
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_MutualAuthent (BYTE_T keyinfo)
{
	 //
	 //      +------+-----+---------+-----+
	 //      | 0x03 | 'A' | keyinfo | BCC |
	 //      +------+-----+---------+-----+
	 //

	 SBuffer[0] = 0x03;
	 SBuffer[1] = MUTUAL_AUTHENT;
	 SBuffer[2] = keyinfo;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (3);
}









//===========================================================================
//
//                           MIRO FUNCTIONS
//
//===========================================================================





/***************************************************************************\
*  proloc_ReadMiro (char *data)
*
*  reads the data from MIRO-TAGs. This command tries to reads continuously
*  until it is interrupted by proloc_StopCommand or the reading is successful.
*
*  Input    -
*  Output   char      *data    // datastring, 5 bytes long.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_ReadMiro (char *data)
{
	 //
	 //      +------+-----+------+
	 //      | 0x02 | 'M' | 0x4F |
	 //      +------+-----+------+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = READ_MIRO;
	 UPtr       = data;

	 SendBlock (2);
}






//===========================================================================
//
//                           RWD FUNCTIONS
//
//===========================================================================



/***************************************************************************\
*  proloc_GetVersion (char *data)
*
*  reads the SW - version, date and serialnumber of the RWD.
*
*  Input    -
*  Output   char      *data    // data[0-7]   .. version X.YY.ZZZ
*                              // data[8-15]  .. date DD.MM.YY
*                              // data[16-26] .. snr
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_GetVersion (char *data)
{
	 //
	 //      +------+-----+------+
	 //      | 0x02 | 'V' | 0x54 |
	 //      +------+-----+------+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = GET_VERSION;
	 UPtr       = data;

	 starttimer_2 ();
	 SendBlock (2);
}



/***************************************************************************\
*  proloc_Reset (void)
*
*  Standard Mode:
*   resets basic function of read/write device. Port Pins of the
*   microcontroller are reset to an initial state (output pins are set to '0',
*   input pins are set to '1').
*  KeyInit Mode:
*   This only sets the mode to Standard mode.
*
*  Input    -
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void    proloc_Reset (void)
{
	 //
	 //      +------+-----+------+
	 //      | 0x02 | 'R' | 0x50 |
	 //      +------+-----+------+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = RESET_SYS;
	 UPtr       = (char *) TempBuffer;

	 starttimer_2 ();
	 SendBlock (2);
}



/***************************************************************************\
*  proloc_HFReset (void)
*
*  switches the HF off about a 100 ms in proximity and 40 ms in long range
*  mode, to bring all TAGs in idle mode.
*
*  Input    -
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_HFReset (void)
{
	 //
	 //      +------+-----+------+
	 //      | 0x02 | 'h' | 0x6A |
	 //      +------+-----+------+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = HF_RESET;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (2);
}



/***************************************************************************\
*  proloc_StopCommand (void)
*
*  stops the permanent reading mode of the read/write device, e.g. during
*  ReadMiro or PollTags
*
*  Input    -
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void    proloc_StopCommand (void)
{
	 //
	 //      +------+------+-----+
	 //      | 0x02 | 0xA6 | BCC |
	 //      +------+------+-----+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = STOP_CMD;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (2);
}



/***************************************************************************\
*  proloc_SetHFMode (BYTE_T mode)
*
*  switches the RWD in either proximity or longrange mode.
*
*  Input    BYTE_T    mode     // INTERNAL_HF (0) .. proximity
*                              // EXTERNAL_HF (1) .. long range
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_SetHFMode (BYTE_T mode)
{
	 //
	 //      +------+-----+------+-----+
	 //      | 0x03 | 'L' | mode | BCC |
	 //      +------+-----+------+-----+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = SET_HF_MODE;
	 SBuffer[2] = mode;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (3);
}



/***************************************************************************\
*  proloc_ReadLRStatus (void)
*
*  read status of the longrange-reader. Replies a EANTOVERLOAD (-20) when
*  the antenna is overloaded in RWDErr. Replies a EOK if it is OK.
*
*  Input    -
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void   proloc_ReadLRStatus (void)
{
	 //
	 //      +------+-----+------+
	 //      | 0x02 | 'r' | 0x70 |
	 //      +------+-----+------+
	 //

	 SBuffer[0] = 2;
   SBuffer[1] = READ_LR_STATUS;
   UPtr       = (char *) 0;

   starttimer_2 ();
	 SendBlock (2);
}




/***************************************************************************\
*  proloc_SetPowerDown (BYTE_T mode)
*
*  to switch on/off the power for the antenna-circuits in longrange mode
*
*  Input    BYTE_T    mode     // 0 .. POWERDOWN MODE
*                              // 1 .. ACTIVE MODE
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void   proloc_SetPowerDown (BYTE_T mode)
{
	 //
	 //      +------+-----+-------+-----+
	 //      | 0x03 | 'D' | mode  | BCC |
	 //      +------+-----+-------+-----+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = SET_POWER_DOWN;
	 SBuffer[2] = mode;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (3);
}



/***************************************************************************\
*  proloc_StartFFT (void)
*
*  start FFT for longrange - application
*
*  Input    -
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void  proloc_StartFFT (void)
{
	 //
	 //      +------+-----+------+
	 //      | 0x02 | 'F' | 0x44 |
	 //      +------+-----+------+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = FFT_COMMAND;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (2);
}



/***************************************************************************\
*  proloc_SetBCD (BYTE_T bitclockdata)
*
*  sets the bitclockdata-value
*  (finetuning value for longrange application)
*
*  Input    BYTE_T    bitclockdata  // finetuning value for LR-application.
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void   proloc_SetBCD (BYTE_T bitclockdata)
{
	 //
	 //      +------+-----+--------------+-----+
	 //      | 0x03 | 'F' | bitclockdata | BCC |
	 //      +------+-----+--------------+-----+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = FFT_COMMAND;
	 SBuffer[2] = bitclockdata;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (3);

}



/***************************************************************************\
*  proloc_ReadBCD (BYTE_T *input)
*
*  Reads the bitclockdata-value (finetuning value for longrange application)
*
*  Input    -
*  Output   BYTE_T    *bitclockdata
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/

void    proloc_ReadBCD (BYTE_T *bitclockdata)
{
	//
	//		ÚÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄ¿
	//		³ 0x02 ³ 'f' ³ BCC ³
	//		ÀÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÙ
	//

	SBuffer[0] = 2;
	SBuffer[1] = READ_BCD;
	UPtr       = (char *) bitclockdata;

	starttimer_2 ();
	SendBlock (2);
}



/***************************************************************************\
*  proloc_ReadEEData (BYTE_T addr, BYTE_T bytenmb, char *data)
*
*  reads a number of bytes form the internal customer EEPROM area of the RWD.
*
*  Input    BYTE_T    addr      // address of first byte: 0 - 84
*           BYTE_T    bytenmb  // number of bytes to read, max 16.
*           char      *data    // read datastring. Maximum 16 bytes long.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void    proloc_ReadEEData (BYTE_T addr, BYTE_T bytenmb, char *data)
{
	 //
	 //      +------+-----+------+---------+-----+
	 //      | 0x04 | 'E' | addr | bytenmb | BCC |
	 //      +------+-----+------+---------+-----+
	 //

	 if (bytenmb>16) bytenmb = 16;

	 SBuffer[0] = 0x04;
	 SBuffer[1] = EE_READ;
	 SBuffer[2] = addr;
	 SBuffer[3] = bytenmb;
	 UPtr       = data;

	 starttimer_2 ();
	 SendBlock (4);
}



/***************************************************************************\
*  proloc_WriteEEData (BYTE_T addr, BYTE_T bytenmb, char *data)
*
*  writes a number of bytes to the internal customer EEPROM area of the RWD.
*
*  Input    BYTE_T    addr      // address of first byte: 0 - 84
*           BYTE_T    bytenmb   // number of bytes to write, max 16.
*  Output   char      *data    // write datastring. Maximum 16 bytes long.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_WriteEEData (BYTE_T addr, BYTE_T bytenmb, char *data)
{
 //
 //      +----------+-----+------+---------+---------+-----+---------+-----+
 //      | anz+0x04 | 'e' | addr | bytenmb | data(0) | ... | data(n) | BCC |
 //      +----------+-----+------+---------+---------+-----+---------+-----+
 //

	 if (bytenmb>16) bytenmb = 16;

	 SBuffer[0] = 0x04+bytenmb;
	 SBuffer[1] = EE_WRITE;
	 SBuffer[2] = addr;
	 SBuffer[3] = bytenmb;
	 memcpy (&SBuffer[4], data, bytenmb);
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (4+bytenmb);
}



/***************************************************************************\
*  proloc_SetOutput (BYTE_T output)
*
*  sets or resets output pins of the RWD.
*
*  Input    BYTE_T    output
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_SetOutput (BYTE_T output)
{
	 //
	 //      +------+-----+--------+-----+
	 //      | 0x03 | 'O' | output | BCC |
	 //      +------+-----+--------+-----+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = SET_OUTPUT;
	 SBuffer[2] = output;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (3);
}



/***************************************************************************\
*  proloc_ReadInput (BYTE_T *input)
*
*  reads the input pins of the RWD.
*
*  Input    -
*  Output   BYTE_T    *input
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_ReadInput (BYTE_T *input)
{
	 //
	 //      +------+-----+------+
	 //      | 0x02 | 'I' | 0x4B |
	 //      +------+-----+------+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = READ_INPUT;
	 UPtr       = (char *)input;

	 starttimer_2 ();
	 SendBlock (2);
}



/***************************************************************************\
*  proloc_ConfigPorts (BYTE_T config)
*
*  configures the eight portpins of Port0 as inputs or outputs.
*
*  Input    BYTE_T    config   // bit0 = P0.0, bit7 = P0.7 | 0..in, 1..out
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_ConfigPorts (BYTE_T config)
{
	 //
	 //      +------+-----+--------+-----+
	 //      | 0x03 | 'c' | config | BCC |
	 //      +------+-----+--------+-----+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = CONFIG_PORTS;
	 SBuffer[2] = config;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (3);
}



/***************************************************************************\
*  proloc_ReadPorts (BYTE_T *input)
*
*  reads the portpins of port0 that are configured as inputs. Bit-
*  positions of output-configurated pins are read as '0'.
*
*  Input    -
*  Output   BYTE_T    *input   // bit0 = P0.0, bit7 = P0.7
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_ReadPorts (BYTE_T *input)
{
	 //
	 //      +------+-----+-----+
	 //      | 0x03 | 'i' | BCC |
	 //      +------+-----+-----+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = READ_PORTS;
	 UPtr       = (char *)input;

	 starttimer_2 ();
	 SendBlock (2);
}



/***************************************************************************\
*  proloc_WritePorts (BYTE_T data, BYTE_T mode)
*
*  changes the value of those portpins of port0 that are configured as out-
*  puts, depending on one of four modes (which combines the new sent data-byte
*  with the existing output data with the chosen operator).
*
*  Input    BYTE_T    output   // bit0 = P0.0, bit 7 = P0.7
*           BYTE_T    mode     // 0..direct, 1..AND, 2..OR, 3..EXOR
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_WritePorts (BYTE_T output, BYTE_T mode)
{
	 //
	 //      +------+-----+--------+------+-----+
	 //      | 0x04 | 'o' | output | mode | BCC |
	 //      +------+-----+--------+------+-----+
	 //

	 SBuffer[0] = 4;
	 SBuffer[1] = WRITE_PORTS;
	 SBuffer[2] = output;
	 SBuffer[3] = mode;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (4);
}



/***************************************************************************\
*  proloc_PollTags (BYTE_T mode, char *data)
*
*  polls for different kinds of TAGs until a TAG is in field or the command
*  is interrupted. In 'mode' you can decide which kinds of TAGs are to select.
*
*  Input    BYTE_T    mode     // selects mode of poll-operation
*  Output   char      *data    // reply from reader
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_PollTags (BYTE_T mode, char *data)
{
	 //
	 //      +------+-----+------+-----+
	 //      | 0x02 | 'l' | mode | BCC |
	 //      +------+-----+------+-----+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = POLL_TAGS;
	 SBuffer[2] = mode;
	 UPtr       = (char *) data;

	 SendBlock (3);
}



/***************************************************************************\
*  proloc_PollKbTags (BYTE_T mode, char *data)
*
*  polls once for a selectable transponder (HITAG1 or HITAG2) and reads
*  the keyboard-buffer and the inputs.
*
*  Input    BYTE_T    mode     // selects mode of PollKbTags-operation
*  Output   char      *data    // received data
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void    proloc_PollKbTags (BYTE_T mode, char *data)
{
	 //
	 //      +------+------+------+-----+
	 //      | 0x02 | 0x90 | mode | BCC |
	 //      +------+------+------+-----+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = POLL_KBTAGS;
	 SBuffer[2] = mode;
	 UPtr       = (char *) data;

	 starttimer_2 ();
	 SendBlock (3);
}



/***************************************************************************\
*  proloc_SetProxTrmTime
*
*  This command sets the RF-bit-times for a Proximity-RWD.
*
*  Input                   the following conversions for T0,T1,TP in
*                          micro-seconds have to be done to get t_0, t_1
*                          and t_p:
*       BYTE_T t_0         t_0=(BYTE_T)(32768-((T0-TP-24)/1.2));
*       BYTE_T t_1         t_1=(BYTE_T)(32768-((T1-TP-24)/1.2));
*       BYTE_T t_p         t_p=(BYTE_T)(32768-((TP-24)/1.2));
*  Output   char      *data    // datastring, 16 bytes long
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void	proloc_SetProxTrmTime (BYTE_T t_0, BYTE_T t_1, BYTE_T t_p)
{
	//
	//		ÚÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//		³ 0x05 ³ '0xA1' ³ 't_0' ³ 't_1' ³ 't_p' ³ BCC ³
	//		ÀÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//

	SBuffer[0] = 5;
	SBuffer[1] = SET_PROX_TRM_TIME;
	SBuffer[2] = t_0;
	SBuffer[3] = t_1;
	SBuffer[4] = t_p;

	UPtr       = (char *) 0;

	starttimer_2 ();
	SendBlock (5);
}



/***************************************************************************\
*  proloc_SetModuleAdr (BYTE_T addr, char *snr)
*
*  sets the node address of a RWD which is identified by the serial-number,
*  out of multiple RWDs that are connected parallel at one serial interface.
*  (RS485).
*
*  Input    BYTE_T    addr     // node address
*           char      *snr     // serial number, 11 bytes long.
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_SetModuleAdr (BYTE_T addr, char *snr)
{
	 BYTE_T i;
	 //
	 //      +------+------+------+--------+-------+---------+-----+
	 //      | 0x02 | 0x91 | addr | snr[0] |  ...  | snr[10] | BCC |
	 //      +------+------+------+--------+-------+---------+-----+
	 //

	 RWDAdr = 0;           // send string in standard protocol !
	 SBuffer[0] = 14;
	 SBuffer[1] = SET_MODULE_ADR;
	 for (i=0;i<11;i++) SBuffer[i+2]=snr[i];
	 SBuffer[13] = addr;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (14);
}






//===========================================================================
//
//                       RWD PERSONALITATION FUNCTIONS
//
//===========================================================================



/***************************************************************************\
*  proloc_KeyInitMode (DWORD_T data)
*
*  to start the personalization of the RWD. If it failed RWDErr is set to
*  EEWRONGOLD (-11), if it is OK, RWDErr is set to EOK. The BCC-calculation
*  is to be changed after a succuessful KeyInitMode-command!
*
*  Input    DWORD_T   data     // 4 byte password
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void    proloc_KeyInitMode (DWORD_T data)
{
	 //
	 //      +------+-----+---------+---------+---------+---------+-----+
	 //      | 0x06 | 'K' | data[0] | data[1] | data[2] | data[3] | BCC |
	 //      +------+-----+---------+---------+---------+---------+-----+
	 //                      LSB       .....     .....      MSB
	 //

	 SBuffer[0] = 6;
	 SBuffer[1] = KEY_INIT_MODE;
	 memcpy (&SBuffer[2], (char *) &data, 4);
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (6);
}



/***************************************************************************\
*  proloc_ReadControl (BYTE_T *data)
*
*  reads the 2 control bytes Control_RW and Control_WO from the EEPROM of the
*  RWD.
*
*  Input    -
*  Output   BYTE_T    *data    // datastring, holding the 2 control-bytes
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_ReadControl (BYTE_T *data)
{
	 //
	 //      +------+-----+------+
	 //      | 0x02 | 'C' | 0x41 |
	 //      +------+-----+------+
	 //

	 SBuffer[0] = 2;
	 SBuffer[1] = READ_CONTROL;
	 UPtr       = (char *) data;

	 starttimer_2 ();
	 SendBlock (2);
}



/***************************************************************************\
*  proloc_WriteControl (BYTE_T control_rw, BYTE_T control_wo)
*
*  writes the 2 control bytes into the EEPROM of the RWD: Control_RW,
*  Control_WO.
*
*  Input    BYTE_T    control_rw
*           BYTE_T    control_wo
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void   proloc_WriteControl (BYTE_T control_rw, BYTE_T control_wo)
{
	 //
	 //      +------+-----+------------+------------+-----+
	 //      | 0x04 | 'c' | control_rw | control_wo | BCC |
	 //      +------+-----+------------+------------+-----+
	 //

	 SBuffer[0] = 4;
	 SBuffer[1] = WRITE_CONTROL;
	 SBuffer[2] = control_rw;
	 SBuffer[3] = control_wo;
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (4);
}



/***************************************************************************\
*  proloc_ReadEEPROM (BYTE_T num, DWORD_T *data)
*
*  Reads personalization data (4 databytes) from the EEPROM of the RWD.
*  Access permissions are checked automatically.
*  If command fails, EERDPROT (-13) is reported to RWDErr.
*
*  Input    BYTE_T    num      // defines which personalisation data is to
*                              // read.
*  Output   DWORD_T   *data    // data to be read, 4 bytes.
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void   proloc_ReadEEPROM (BYTE_T num, DWORD_T *data)
{
	 //
	 //      +------+-----+-----+-----+
	 //      | 0x03 | 'X' | num | BCC |
	 //      +------+-----+-----+-----+
	 //

	 SBuffer[0] = 3;
	 SBuffer[1] = READ_EE_DATA;
	 SBuffer[2] = num;
	 UPtr       = (char *) data;

	 starttimer_2 ();
	 SendBlock (3);
}



/***************************************************************************\
*  proloc_WriteEEPROM (BYTE_T num, DWORD_T od, DWORD_T nd)
*
*  Writes new personalization data (4 databytes) into the EEPROM of the RWD.
*  Access permissions are checked automatically.
*  If command fails, EEWRPROT (-12) or EEWRONGOLD (-11) is reportet to RWDErr.
*
*  Input    BYTE_T    num      // defines which personalization data is to
*                              // be written
*           DWORD_T   od       // old data, 4 bytes.
*           DWORD_T   nd       // new data, 4 bytes.
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock.
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void   proloc_WriteEEPROM (BYTE_T num, DWORD_T od, DWORD_T nd)
{
	 //
	 //      +------+-----+-----+-----------+------------+-----+
	 //      | 0x0B | 'Y' | num | od[0..3]  |  nd[0..3]  | BCC |
	 //      +------+-----+-----+-----------+------------+-----+
	 //                      LSB.....MSB  LSB.....MSB
	 //

	 SBuffer[0] = 11;
	 SBuffer[1] = WRITE_EE_DATA;
	 SBuffer[2] = num;
	 memcpy (&SBuffer[3], (char *) &od, 4);
	 memcpy (&SBuffer[7], (char *) &nd, 4);
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (11);
}



/***************************************************************************\
*  proloc_WriteSerNum (char *snr)
*
*  writes the serial number to internal EEPROM of the RWD.
*
*  Input    char      *snr     // datastring including snr, 11 bytes long.
*  Output   -
*  Global   BYTE_T    SBuffer  // SBuffer: sendstring for serial interface.
*                              // Used in prolocComISR and SendBlock..
*           char      *UPtr(2) // Additional buffers to send/receive data.
*                              // Used in prolocComISR and SetErrorFlag.
\***************************************************************************/
void proloc_WriteSerNum (char *snr)
{
	 //
	 //      +------+-----+---------+-----+----------+-----+
	 //      | 0x0D | 's' | data[0] | ... | data[10] | BCC |
	 //      +------+-----+---------+-----+----------+-----+
	 //

	 SBuffer[0] = 13;
	 SBuffer[1] = WRITE_SERNUM;
	 memcpy (&SBuffer[2], snr, 11);
	 UPtr       = (char *) 0;

	 starttimer_2 ();
	 SendBlock (13);
}



/***************************************************************************\
*  proloc_SetBCCMode (BYTE_T mode)
*
*  Sets an alternate BCC calculation for the serial prtocol. Have to be done
*  after activating KeyInitMode! Is to be reseted after personalization
*  process.
*
*  Input    BYTE_T    mode     // 0 .. standard,  1 .. KeyInit
*  Output   -
*  Return   -
\***************************************************************************/
void proloc_SetBCCMode (BYTE_T mode)
{
	 BCCMode = mode;
}









//===========================================================================
//
//                      LOW LEVEL - FUNCTIONS
//
//===========================================================================



/***************************************************************************\
*  InitComPort
*
*  Input    unsigned PortBaseAddr    // Address for Serial Port
*  Output   -
*  Return   -
\***************************************************************************/

static void     InitComPort (unsigned PortBaseAddr)
{
   unsigned     In;

   //
   //              switch serial port to 9600,n,8,1
   //

   bioscom (0, 0xE0 | 0x03, Com);

   //
   //              enable serial interrupt
	 //

	 In = inportb (PortBaseAddr + MODEM_CONTROL);
   outportb (PortBaseAddr + MODEM_CONTROL, In | OUT2);
	 outportb (PortBaseAddr + EN_INT, ERBFI);
}




/***************************************************************************\
*  SetReadMode
*
*  Input    -
*  Output   -
*  Return   -
\***************************************************************************/

static void     SetReadMode (void)
{
   //
	 //              switch RTS, CTL to read mode
   //

   outportb (BaseAddr+MODEM_CONTROL, inportb (BaseAddr+MODEM_CONTROL) & (~RTS));
	 outportb (BaseAddr+CTL_CONTROL, inportb (BaseAddr+CTL_CONTROL) | CTL);

   //
   //              clear read buffer
   //

   inportb (BaseAddr+READ_WRITE);
}



/***************************************************************************\
*  SetWriteMode
*
*  Input    -
*  Output   -
*  Return   -
\***************************************************************************/

static void     SetWriteMode (void)
{
	 //
   //              switch RTS, CTL to write mode
   //

   outportb (BaseAddr+CTL_CONTROL, inportb (BaseAddr+CTL_CONTROL) & (~CTL));
   outportb (BaseAddr+MODEM_CONTROL, inportb (BaseAddr+MODEM_CONTROL) | RTS);

   //
   //              clear read buffer
	 //

	 inportb (BaseAddr+READ_WRITE);
}



/***************************************************************************\
*  SendBlock
*
*  Input    unsigned number  // number of bytes to transmit without BCC
*  Output   -
*  Return   -
\***************************************************************************/

static void     SendBlock (unsigned number)
{
	 unsigned        index;
	 unsigned char   bcc;

	 if (RWDAdr)
	 {
			SBuffer[0]+=0x81;
			SBuffer[number]=RWDAdr;
			number+=1;
	 }

	 //
	 //              clear read buffer
	 //

	 inportb (BaseAddr+READ_WRITE);

	 //
	 //              set variables to receive data
	 //

	 RWDErr   = 0;
	 RWDEot   = 0;
	 RecState = 1;
	 pit_overflow = 0;
	 RWDDataLen=0;  // Default

	 // Set RS-485-Lines for Write

	 SetWriteMode ();

	 //
	 //              transmitt serial data
	 //

	 for (index=0, bcc=0; index<number; index++)
	 {
			SendOneCharacter (SBuffer[index]);

			//
			//              calculate bcc
			//
			//                      BCCMode  = 0    -->             bcc ^ character
			//                      BCCMode != 0    -->             bcc + character
			//

			if (!BCCMode)           bcc ^= (BYTE_T) SBuffer[index];
			else
				 bcc += (BYTE_T) SBuffer[index];
	 }

	 if (number)
	 {
			//
			//              transmitt bcc character
			//

			SendOneCharacter (bcc);

			//
			//              wait until last character send
			//

			while ((inportb (BaseAddr+LINE_STATUS)&0x60)!=0x60);
	 }
	 // Set RS-485-Lines for Read

	 SetReadMode();
}




/***************************************************************************\
*  SetErrorFlag
*
*  Input    int Err    // Error-Code
*  Output   -
*  Return   -
****************************************************************************/

static void     SetErrorFlag (int Err)
{
	 RWDErr = Err;
	 RWDEot = TRUE;
   UPtr   = NULL;

	 stoptimer ();
}



/***************************************************************************\
*  SendOneCharacter
*
*  Input    char data    // character to send
*  Output   -
*  Return   -
\***************************************************************************/

static void     SendOneCharacter (char data)
{
	 //
	 //              wait until last character send
	 //

	 while ((inportb (BaseAddr+LINE_STATUS)&0x60)!=0x60);

	 //
	 //              transmitt next character to serial register
	 //

	 outportb (BaseAddr+READ_WRITE, data);
	 if (dtrmbuf_zeig<199)
	 {
			dtrmbuf[dtrmbuf_zeig]=data;
			++dtrmbuf_zeig;
	 }
}



/***************************************************************************\
*  ReceiveOneCharacter
*
*  Input    -
*  Output   -
*  Return   Value        // >=0: Received character
*                        // <0:  Error-Code
\***************************************************************************/

static int  ReceiveOneCharacter (void)
{
	 BYTE_T temp;
	 //
	 //              read line-status register
	 //
	 temp=(inportb (BaseAddr+LINE_STATUS))&0x1E;
	 if (drecbuf_zeig<199)
	 {
		 dstatbuf[drecbuf_zeig]=temp;
	 }
	 if (temp)               //  error  ??
	 {
			//
			//              - clear read-register
			//      - return ERR   (-1)
			//
			temp=inportb (BaseAddr+READ_WRITE);

			if (drecbuf_zeig<199)
			{
				 drecbuf[drecbuf_zeig]=temp;
				 ++drecbuf_zeig;
			}
			return (ERR);
	 }

	 //
	 //              read and return character
	 //

	 temp=(inportb (BaseAddr+READ_WRITE));
	 if (drecbuf_zeig<199)
	 {
			drecbuf[drecbuf_zeig]=temp;
			++drecbuf_zeig;
	 }
	 return ((int)temp);
}



/***************************************************************************\
*  proloc_ComISR
*
*  Interrupt-Function for Serial Communication
*
*  Input    -
*  Output   -
*  Return   -
\***************************************************************************/

static void interrupt   proloc_ComISR (void)
{
	 int             Received;
	 static char     RecLen;
	 static char     BCC;
	 static unsigned char test_adr;

	 //
	 //              read byte or errorflag
	 //

	 if (drecbuf_zeig<199)
	 {
		 dstatebuf[drecbuf_zeig]=RecState;
	 }

	 if ((Received=ReceiveOneCharacter ())<0)
	 {
			serf=1;
			if (drecbuf_zeig<199)
			{
				 dstatbuf[drecbuf_zeig]=0xFF;
				 drecbuf[drecbuf_zeig]=0xFF;
				 ++drecbuf_zeig;
			}
			//
			//              set error to serial error and return
			//
			SetErrorFlag (ESERIELL);
			set8259A();
			return;
	 }

	 if (pit_overflow)
	 {
			SetErrorFlag (EPIT);
			set8259A();
			return;
	 }

	 //
	 //              receive - state - maschine
	 //

	 switch (RecState)
   {
			case 1:     //
							 //              first character
               //
							 //              - protocol length information to RWDDataLen
							 //              - set number of received bytes to 0
               //              - init bcc register
               //              - set state to 2
               //              - start timer with timeout = 165 ms
               //

               RWDDataLen = ((BYTE_T) Received)-2;
							 BCC        =  (BYTE_T) Received;

							 test_adr=0;  // Defaultvalue for no node-addressing in use
							 if (RWDDataLen>127) // MSB of RWDDataLen decides, if node-
               {                   // addressing is in use.
                  test_adr=1;
                  RWDDataLen-=129;
							 }

               RecState   = 2;
							 RecLen     = 0;

               starttimer_1 ();
							 break;

      case 2:     //
               //              status character
               //
							 //              - stop timeout counter
               //              - save status to RWDErr
               //              - calculate new bcc
							 //              - set state to 3 (RWDDatalen!=0) or 4
							 //              - start timer with timeout = 165 ms
							 //

							 stoptimer();

							 RWDErr = (char) Received;
							 if (RWDErr== -1)
							 {
									serf=4;
							 }
							 //
							 //              calculate new bcc
							 //

							 if (!BCCMode)   BCC ^= (BYTE_T) Received;
							 else
									BCC += (BYTE_T) Received;

							 //
							 //              set new state
							 //

							 if (RWDDataLen)     RecState = 3;
							 else
									RecState= 4;

							 starttimer_1 ();
							 break;

			case 3:  //
							 //              data bytes
							 //
							 //              - stop timeout counter
							 //              - save received byte to RBuffer
							 //              - calculate new bcc
							 //              - set state to 4 if all bytes received
							 //              - start timer with timeout = 165 ms
							 //

							 stoptimer ();

							 //
							 //              save character to RBuffer
							 //

							 RBuffer[RecLen] = (char) Received;

               //
               //              calculate new bcc
							 //

							 if (!BCCMode)   BCC ^= (BYTE_T) Received;
							 else
									BCC += (BYTE_T) Received;

							 //
							 //              set new RecState
							 //

							 if (++RecLen==RWDDataLen)       RecState = 4;

							 starttimer_1 ();
							 break;

			case 4:     //

							 if (test_adr)
							 {
									test_adr=0;
									// Check, if node address is OK ...
									if (!BCCMode)   BCC ^= (BYTE_T) Received;
									else
										 BCC += (BYTE_T) Received;
									starttimer_1 ();
									break;
							 }


							 //              bcc character
							 //
							 //              - stop timeout counter
							 //              - check received bcc with calculated bcc
							 //              - copy received bytes to buffer
							 //              - set RWDEot to 1
							 //              - set RecState to default path
							 //

							 stoptimer ();

							 if ((BYTE_T) BCC != (BYTE_T) Received)
							 {
									if (drecbuf_zeig<199)
									{
										dstatbuf[drecbuf_zeig]=0x80;
										drecbuf[drecbuf_zeig]=BCC;
										++drecbuf_zeig;
									}
									serf=3;
									RWDErr  = ESERIELL;
									BCCMode = 0;
							 }
							 else
							 {
									if (RWDDataLen)
									{
										 //
										 //              command == GET_SNR or LT_GET_SNR
										 //
										 //              Y ->  copy RBuffer[4] to *UPTr2
										 //

										 if ((SBuffer[1]==GET_SNR) || (SBuffer[1]==LT_GET_SNR) ||
										  (SBuffer[1]== GET_SNR_ADV))
										 {
												if (UPtr != (char *)0) memcpy (UPtr, RBuffer, 4);
												*UPtr2 = RBuffer[4];
										 }
										 else
										 {
												if ((SBuffer[1]==READ_PHILIPS) && (pit_command==0))
												{
												 pit_overflow=1;
												}
												else
												{
												 pit_command=0;
												 if (UPtr != (char *)0) memcpy (UPtr, RBuffer, RWDDataLen);
												}
										 }
									}
							 }

							 RWDEot = 1;
							 RecState = 5;
							 if (SBuffer[1]==READ_PHILIPS || SBuffer[1]==READ_ALL_PAGE)
							 {
									RecState = 1;
							 }
							 break;

			default:    break;
	 }
	 set8259A();
}



/***************************************************************************\
*  proloc_TimerISR
*
*  Interrupt Function for Timer-Interrupt
*
*  Input    -
*  Output   -
*  Return   -
\***************************************************************************/

static void interrupt   proloc_TimerISR (void)
{
	 //
	 //              call old interrupt function
	 //

	 enable();

	 (*old_timer_isr) ();

	 enable();

	 //
	 //              check timer is running
	 //

	 if (Timer)
	 {
			//
			//              timeout time is over ?
			//

			if (!(--Counter))
			{
				 if (drecbuf_zeig<199)
				 {
						dstatbuf[drecbuf_zeig]=0x40;
						drecbuf[drecbuf_zeig]=0xff;
						++drecbuf_zeig;
				 }
				 serf=2;
				 //
				 //              - stop timeout counter
				 //              - set serial error
				 //

				 stoptimer ();
				 SetErrorFlag (ESERIELL);
			}
   }
   set8259A();
}
