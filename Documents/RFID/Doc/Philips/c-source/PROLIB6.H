//===========================================================================
//=                                                                         =
//=                PROLOC C-LIBRARY HEADERFILE "prolib6.h"                  =
//=                                                                         =
//=                      MIKRON Gratkorn Austria                            =
//=                             (c) 1996                                    =
//=                                                                         =
//===========================================================================

//CUST =================== CUSTOMER      INFORMATION ========================
//CUST
//CUST   CUSTOMER-INFORMATION:
//CUST   ---------------------
//CUST
//CUST   Include this headerfile in your sourcefile, if you want to use
//CUST   HITAG1&MIRO products.
//CUST   If you want to use HITAG2 also include "prolblt6.h".
//CUST   If you want to use PITs (PHILIPS TAGs) also include "prolbph6.h".
//CUST   If you want to use several RWDs on one serial interface (RS485)
//CUST   include "prolbmu6.h".
//CUST
//CUST   #include "prolib6.h"    /* general RWD & HITAG1&MIRO functions    */
//CUST   #include "prolbph6.h"   /* optional for PITs                      */
//CUST   #include "prolblt6.h"   /* optional for HITAG2                    */
//CUST   #include "prolbmu6.h"   /* optional for multiple RWD use on RS485 */
//CUST   #include "prolveg6.h"   /* optional for VEGAS-RWD                 */
//CUST
//CUST   (Add PROLIB6x.LIB proloc-library to your project)
//CUST
//CUST   IMPORTANT: No proloc-function (except proloc_open) returns a value.
//CUST   ---------  Errormessages, the flag for the end of transmission of
//CUST              serial-interface commands and length of replied data are
//CUST              reported in the global variables RWDErr, RWDEot and
//CUST              RWDDataLen. See GENERAL INFORMATION, GLOBAL VARIABLES
//CUST              below in this file.
//CUST              No proloc-function allocates memory, it is done by
//CUST              you before function calls.
//CUST
//CUST   PROLIB6.H contains:
//CUST
//CUST   o  All defines of GLOBAL USED ERRORMESSAGES, PARAMETER-SWITCHES
//CUST      for proloc library functions.
//CUST
//CUST   o  Typedefinitions of GLOBAL DATATYPES, which are used
//CUST      for parameter passing in proloc library functions.
//CUST
//CUST   o  Declarations of GLOBAL VARIABLES (RWDErr, RWDEot, RWDDataLen,
//CUST      RWDAdr), which are important for handling of HOST (PC) to RWD
//CUST      communitation.
//CUST
//CUST   o  A GENERAL INFORMATION over proloc library usage.
//CUST
//CUST   o  Prototypes of BASIC-, RWD-, RWD-PERSONALIZATION-functions and
//CUST      HITAG1/MIRO functions with examples for function usage.
//CUST
//CUST   All comments starting with 'CUST' are of special interest
//CUST   for the customers of MIKRON.
//CUST   Function descriptions HITAG2 ............. PROLBLT6.H
//CUST                         PIT ................ PROLBPH6.H
//CUST                         Multiple RWD use ... PROLBMU6.H
//CUST
//CUST ----------------------------------------------------------------------





//CUST ================== FUNCTION-HEADER    OVERVIEW =======================
//CUST
//CUST   Overview: The list of commented function prototypes in this file
//CUST   ---------                  (mark function name to search & find)
//CUST
//CUST   BASIC:
//CUST         proloc_open
//CUST         proloc_close
//CUST
//CUST   HITAG1:
//CUST         proloc_GetSnr
//CUST         proloc_GetSnr_Adv
//CUST         proloc_SelectSnr
//CUST         proloc_SelectLast
//CUST         proloc_HaltSelected
//CUST         proloc_ReadPage
//CUST         proloc_ReadBlock
//CUST         proloc_WritePage
//CUST         proloc_WriteBlock
//CUST         proloc_TagAuthent
//CUST         proloc_MutualAuthent
//CUST
//CUST   MIRO:
//CUST         proloc_ReadMiro
//CUST
//CUST   RWD:
//CUST         proloc_GetVersion
//CUST         proloc_Reset
//CUST         proloc_StopCommand
//CUST         proloc_HFReset
//CUST         proloc_SetHFMode
//CUST         proloc_ReadLRStatus
//CUST         proloc_SetPowerDown
//CUST         proloc_StartFFT
//CUST         proloc_SetBCD
//CUST         proloc_ReadBCD
//CUST         proloc_ReadEEData
//CUST         proloc_WriteEEData
//CUST         proloc_SetOutput
//CUST         proloc_ReadInput
//CUST         proloc_ConfigPorts
//CUST         proloc_ReadPorts
//CUST         proloc_WritePorts
//CUST         proloc_PollTags
//CUST         proloc_PollKbTags
//CUST         proloc_SetProxTrmTime
//CUST         proloc_SetModuleAdr
//CUST
//CUST   RWD HITAG1 PERSONALIZATION:
//CUST         proloc_KeyInitMode
//CUST         proloc_ReadControl
//CUST         proloc_WriteControl
//CUST         proloc_ReadEEPROM
//CUST         proloc_WriteEEPROM
//CUST         proloc_SetBCCMode
//CUST




//CUST ====================== ERROR   MESSAGES ==============================
//CUST
//CUST   ERROR-MESSAGES, replied by all HITAG1&MIRO/HITAG2/PIT
//CUST   library-functions.
//CUST   After calling one of these functions, the errormessage is stored in
//CUST   RWDErr (defined as a global variable in this header).
//CUST
//CUST ----------------------------------------------------------------------

#define        EOK            (0)   // transmission OK
#define        ESERIELL       (-1)  // serial interface error
#define        ENOTAG         (-3)  // no TAG in rf field
#define        ETIMEOUT       (-4)  // not enough energy in TAG to write/read
#define        EPWDRWD        (-5)  // password for RWD -> HITAG2 wrong
#define        EPWDTAG        (-6)  // password for HITAG2 -> RWD wrong
#define        EAUTHENT       (-7)  // authentication error.
#define        EQUIT          (-8)  // no quit (acknowledge) received from RWD
#define        ECRYPTO        (-9)  // data for cryptogaphy not initialized
#define        EE2CHK         (-10) // EEPROM functionality error
#define        EEWRONGOLD     (-11) // wrong old data at write key/log-data
#define        EEWRPROT       (-12) // EEPROM is write protected
#define        EERDPROT       (-13) // EEPROM is read protected
#define        EPIT           (-14) // read blocks of PIT has run out of time
#define        ECRC           (-15) // wrong CRC from HITAG1 in advanced mode
#define        EANTOVERLOAD   (-20) // antenna for long range overloaded

//CUST ----------------------------------------------------------------------






//CUST ==================== PARAMETER   SWITCHES =============================
//CUST
//CUST   SWITCHES, used in different HITAG1&MIRO/HITAG2/PIT
//CUST   functions. Their use is commented in the header of the function-
//CUST   descriptions which you can find below in this file.
//CUST
//CUST ----------------------------------------------------------------------

#define        INTERNAL_HF    (0)   // proximity - operation (short range)
#define        EXTERNAL_HF    (1)   // long range - operation (handsfree)
																		// Function: proloc_SetHFMode()

#define        NORMAL_BCC     (0)   // bcc calculation for standard mode
#define        INIT_BCC       (1)   // bcc calculation for key init mode
																		// Function: proloc_SetBCCMode()

#define        AUTHENT_KEY_A  (0)   // switches for the keys used at HITAG1
#define        AUTHENT_KEY_B  (1)   // authentication process.
																		// Function: proloc_MutualAuthent()
																		//           proloc_TagAuthent()

#define        PLAIN          (0)   // plain mode for RWD - HITAG1 comm.
#define        CRYPTO         (1)   // crypto mode for RWD - HITAG1 comm.
																		// Function: proloc_ReadPage()
																		//           proloc_ReadBlock()
																		//           proloc_WritePage()
																		//           proloc_WriteBlock()

#define        PASSWORD       (0)   // codes for addresses of HITAG1
#define        KEY_A          (1)   // personalization pages
#define        KEY_B          (2)   //
#define        LOG_0A         (3)   // Function: proloc_ReadEEPROM()
#define        LOG_0B         (4)   //           proloc_WriteEEPROM()
#define        LOG_1A         (5)   //
#define        LOG_1B         (6)

#define        PASSWORD       (0)   // the 2 possible modes to select a
#define        CRYPTO         (1)   // HITAG2.
																		// Function: proloc_GetSnr_LT()

#define        KEY_LOW        (0)   // codes for addresses of HITAG2
#define        KEY_HIGH       (1)   // personalization pages
#define        PASSWORD_TAG   (2)   //
#define        PASSWORD_RWD   (3)   // Function: proloc_ReadSecret_LT()
																		// Function: proloc_WriteSecret_LT()

#define        OFF            (0)   // PIT security-mode switches &
#define        ON             (1)   // rf power switch for LR-application
																		// Function: proloc_WritePitSecurity()
																		// Function: proloc_SetPowerDown()

#define        DIRECT         (0)   // operation modes for
#define        AND            (1)   // Function: proloc_WritePorts()
#define        OR             (2)   //
#define        EXOR           (3)   //

#define        TRUE           (1)   // useful defines for all functions
#define        FALSE          (0)   //
#define        ERR            (-1)  //
#define        EOK            (0)   //

//CUST ----------------------------------------------------------------------





//      register defines for controlling
//      serial communication on the host:
//
#define        READ_WRITE              0x08
#define        EN_INT                  0x09
#define        ERBFI                   0x01
#define        MODEM_CONTROL           0x0C
#define        CTL_CONTROL             0x0F
#define        RTS                     0x02
#define        CTL                     0x02
#define        OUT2                    0x08
#define        LINE_STATUS             0x0D

//      Codes of HITAG1/MIRO commands for HOST - RWD communication
//
#define        GET_SNR                 'G'
#define        GET_SNR_ADV             0xA2
#define        SELECT_SNR              'S'
#define        HALT_SELECTED           'H'
#define        READ_PAGE               'P'
#define        READ_BLOCK              'B'
#define        WRITE_PAGE              'p'
#define        WRITE_BLOCK             'b'
#define        TAG_AUTHENT             'a'
#define        MUTUAL_AUTHENT          'A'
#define        READ_MIRO               'M'

//      Codes of RWD commands for HOST - RWD communication
//
#define        GET_VERSION             'V'
#define        RESET_SYS               'R'
#define        STOP_CMD                0xA6
#define        HF_RESET                'h'
#define        SET_HF_MODE             'L'
#define        SET_POWER_DOWN          'D'
#define        READ_LR_STATUS          'r'
#define        FFT_COMMAND             'F'
#define        READ_BCD                'f'
#define        SET_BCD_OFFSET          0xA4
#define        EE_READ                 'E'
#define        EE_WRITE                'e'
#define        SET_OUTPUT              'O'
#define        READ_INPUT              'I'
#define        CONFIG_PORTS            'c'
#define        READ_PORTS              'i'
#define        WRITE_PORTS             'o'
#define        POLL_TAGS               'l'
#define        POLL_KBTAGS             0x90
#define        SET_PROX_TRM_TIME       0xA1
#define        SET_MODULE_ADR          0x91

//      Codes of RWD HITAG1 PERSONALIZATION commands for HOST - RWD communication
//
#define        KEY_INIT_MODE           'K'
#define        READ_CONTROL            'C'
#define        WRITE_CONTROL           'c'
#define        WRITE_SERNUM            's'
#define        READ_EE_DATA            'X'
#define        WRITE_EE_DATA           'Y'

//      Codes of HITAG2 commands for HOST - RWD communication
//
#define        LT_GET_SNR              0x80
#define        LT_HALT_SELECTED        0x81
#define        LT_READ_PAGE            0x82
#define        LT_READ_PAGE_INV        0x83
#define        LT_WRITE_PAGE           0x84
#define        LT_READ_PIT             0x85
#define        LT_READ_PUBLICB         0x9E
#define        LT_READ_CONTROL         0x90
#define        LT_WRITE_CONTROL        0x91
#define        LT_READ_SECRET          'V'
#define        LT_WRITE_SECRET         'W'

//      Codes of PHILIPS commands for HOST - RWD communication
//
#define        READ_PHILIPS            'T'
#define        WRITE_PHILIPS           't'
#define        WRITE_PIT_BLOCK         'u'
#define        WRITE_PIT_SECURITY      'v'
#define        WRITE_PIT_PASSWORD      'w'


//      Macros for using the PC-internal timer (55 ms steps)
//
#define        starttimer_1()          (Counter=3, Timer=TRUE)
#define        starttimer_2()          (Counter=50, Timer=TRUE)
#define        stoptimer()             (Timer=FALSE)
#define        set8259A()              outportb (0x20, 0x20)





//CUST ==================== COMMON  USED  DATATYPES =========================
//CUST
//CUST    COMMON USED DATATYPES for parameter passing in proloc functions
//CUST
//CUST ----------------------------------------------------------------------

typedef              unsigned char        uchar_t;
typedef              unsigned long        ulong_t;
typedef              unsigned char        BYTE_T;
typedef              unsigned int         WORD_T;
typedef              unsigned long        DWORD_T;

//CUST ---------------------------------------------------------------------






//CUST ===================== GLOBAL   VARIABLES =============================
//CUST
//CUST   The GLOBAL VARIABLES below are used to obtain the reply after a call
//CUST   of one of the library functions:
//CUST
//CUST   RWDEot: Signals the completion of communication on the serial inter-
//CUST           face (RWDEot = 1[=TRUE], when data transfer is complete).
//CUST   RWDErr: Reports an error after the communication on the serial
//CUST           interface is complete (RWDErr = 0[=EOK], if no error arised).
//CUST           Possible errormessages are described above in this file.
//CUST   RWDDataLen: Contains the length of data (number of bytes), when data
//CUST               is read from a TAG or RWD.
//CUST
//CUST ----------------------------------------------------------------------

extern               uchar_t              RWDEot;
extern               char                 RWDErr;
extern               uchar_t              RWDDataLen;

//CUST ----------------------------------------------------------------------




//      definition of global variables used in some library-functions
//      DO NOT ACCESS THIS VARAIBLES DIRECTLY!
extern               volatile int         Counter;
extern               volatile BYTE_T      Timer;
extern               BYTE_T               SBuffer[30];  // SendBuffer for SI
extern               BYTE_T               RBuffer[30];
extern               char                 *UPtr;  // For data-passing
extern               char                 *UPtr2; // For data-passing
extern               BYTE_T               pit_command;  // readPit flag

//      definition of global test variables

extern volatile unsigned char serf;  // only for test
					// Code for serial Errors: 1=PC-Statusregister, 2=Timeout,
																	// 3=BCC-Error, 4=RWD-Error
extern BYTE_T drecbuf[200];          // only for test
					// Buffer for received Bytes on the serial COM-Port
extern BYTE_T drecbuf_zeig;          // only for test
					// Pointer to drecbuf and dstatbuf
extern BYTE_T dtrmbuf[200];          // only for test
					// Buffer for transmitted Bytes on the serial COM-Port
extern BYTE_T dtrmbuf_zeig;          // only for test
					// Pointer to dtrmbuf
extern BYTE_T dstatbuf[200];         // only for test
					// Buffer for values of the PC-Statusregister
extern BYTE_T dstatebuf[200];        // only for test
					// Buffer for RecState-value of Interrupt-Routine


//CUST ==================== GENERAL    INFORMATION ==========================
//CUST
//CUST   FUNCTION LIBRARY:
//CUST   -----------------
//CUST
//CUST   Below are the declarations of functions for using HITAG1&MIRO-TAG's.
//CUST   For usage of HITAG2 or PIT's see the headerfiles:
//CUST   PROLBLT6.H or PROLBPH6.H.
//CUST   Each function declaration is preceded by an example of use.
//CUST   For usage of several RWDs on one serial interface (RS 485) see
//CUST   PROLBMU6.H.
//CUST
//CUST   Start and close a proloc session:
//CUST   Start a session by opening HOST - RWD cummunication by serial inter-
//CUST   face with a proloc_open(), and finish it at the end of your program
//CUST   with a proloc_close() function call. This is very important for
//CUST   proper operation during and after a proloc session.
//CUST
//CUST   Return values:
//CUST   Pay attention to the fact that no proloc function replies a return
//CUST   value (except proloc_open). The advantage is, that your HOST (PC) is
//CUST   not blocked during HOST - RWD communication since it is done in
//CUST   background.
//CUST
//CUST   The end of transmission of serial interface commands, errors and
//CUST   length of replied data are reported in the global variables:
//CUST     RWDEot:      Signals the completion of transmission of a command.
//CUST     RWDErr:      EOK(0), if the command was successful.
//CUST                  Negative value, if the command failed.
//CUST                  The errors are listed above in this file.
//CUST     RWDDataLen:  The length of the possibly replied data.
//CUST   See also GLOBAL VARIABLES above in this file.
//CUST
//CUST
//CUST   Example:
//CUST
//CUST   :
//CUST   #include "prolib6.h"    /* for HITAG1&MIRO only                   */
//CUST   #include "prolbph6.h"   /* optional for PIT-TAG's                 */
//CUST   #include "prolblt6.h"   /* optional for HITAG2                    */
//CUST   :
//CUST   main()
//CUST   {
//CUST   int ...
//CUST            :
//CUST      if ( proloc_open( "COM1" ) < 0 ) // possible: "COM1" or "COM2"
//CUST      {
//CUST         printf( "Error on opening proloc-session" );
//CUST         exit( 1 );
//CUST      }
//CUST      :
//CUST
//CUST      proloc_anyFunction( parameter_1, &parameter_2 );
//CUST      while ( !RWDEot );  // Wait until end of transmission of command.
//CUST      if ( RWDErr )       // If an error occured..
//CUST      {
//CUST      	printf("Error: ",RWDErr);
//CUST      }
//CUST      else
//CUST           :
//CUST
//CUST      proloc_close();  //re-installs all old interrupt service routines
//CUST   }
//CUST
//CUST ----------------------------------------------------------------------






/*-BASIC--------------------------function header----------------------------
*
*       proloc_open (char *ComStr)
*                          opens the communication path between HOST and RWD,
*                          by programming the serial interface. Old interrupt
*                          and timer values are stored, to be restored at the
*                          end of a proloc-session by proloc_close().
*
*  (IN) char    *ComStr    This parameter defines the interface name.
*                          Only
*                             "COM1" and
*                             "COM2" are allowed.
*
*       return             EOK(0) is returned on success.
*                          ESERIELL(-1) is returned if it failed.
*
*       for     example:
*               :
*               :
*       if ( proloc_open( "COM1" )<0 )
*       {
*          printf( "open error" );
*          exit( 1 );
*       }
*               :
*               :
---------------------------------------------------------------------------*/
int proloc_open (char *);



/*-BASIC--------------------------function header----------------------------
*
*       proloc_close()     closes the communication path between HOST and RWD.
*                          This command is VERY important at the end of your
*                          program. It re-installs all old interrupt service
*                          routines to prevent your system from hanging.
*
*       for     example:
*               :
*       proloc_open("COM1");
*               :
*               :
*       proloc_close();
*       exit( 0 );
---------------------------------------------------------------------------*/
void    proloc_close (void);



/*-HITAG1--------------------------function header----------------------------
*
*       proloc_GetSnr (DWORD_T *snr, BYTE_T *more)
*                          reads the serial number of a HITAG1 in rf-field.
*
* (OUT) DWORD_T *snr       pointer to the serial number. 4 bytes long.
* (OUT) BYTE_T  *more      indicates that more than one HITAG1 is in RF field
*                             more .... 1  (only provided for long range)
*                             single .. 0
*                          This byte is always 0 with proximity applications!
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3)
*
*
*       for     example:
*               :
*       DWORD_T         Identifier;
*       BYTE_T          more;
*               :
*       proloc_GetSnr (&Identifier, &more);
*       while (!RWDEot);
*       if (RWDErr==EOK)
*          printf ("ID : %08lx other TAG's (1..yes): %3i", Identifier, more);
*       else
*               :
---------------------------------------------------------------------------*/
void   proloc_GetSnr (DWORD_T *, BYTE_T *);



/*-HITAG1------------------------function header-----------------------------
*
*       proloc_GetSnr_Adv (DWORD_T *snr, BYTE_T *more)
*                          reads the serial number of a new-mode capable
*                          HITAG1 in rf-field and sets the transponder
*                          in advanced-mode.
*
* (OUT) DWORD_T *snr       pointer to the serial number. 4 bytes long.
* (OUT) BYTE_T  *more      indicates that more than one HITAG1 is in RF field
*                             more .... 1  (only provided for long range)
*                             single .. 0
*                          This byte is always 0 with proximity applications!
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3)
*
*
*       for     example:
*               :
*       DWORD_T         Identifier;
*       BYTE_T          more;
*               :
*       proloc_GetSnr_Adv (&Identifier, &more);
*       while (!RWDEot);
*       if (RWDErr==EOK)
*          printf ("ID : %08lx other TAG's (1..yes): %3i", Identifier, more);
*       else
*               :
---------------------------------------------------------------------------*/
void proloc_GetSnr_Adv (DWORD_T *, BYTE_T *);



/*-HITAG1--------------------------function header----------------------------
*
*       proloc_SelectSnr (DWORD_T snr, DWORD_T *otp)
*                          selects the TAG with the specified serial number
*                          and returns the otp (configuration page) of the
*                          TAG. If this command was successful the HITAG1 is
*                          selected for read/write accesses.
*
* (IN)  DWORD_T  snr       serial number of the TAG to select. 4 bytes.
* (OUT) DWORD_T *otp       pointer to OTP-page (4 bytes).
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3)
*                                           ECRC(-15)
*
*       for     example:
*               :
*       DWORD_T         Identifier;
*       DWORD_T         otp_page;
*       BYTE_T          more;
*               :
*       proloc_GetSnr (&Identifier, more);
*       while (!RWDEot);
*
*       if ( !RWDErr )
*       {
*         proloc_SelectSnr (Identifier, &otp_page);
*         while (!RWDEot);
*         if (RWDErr==EOK)
*           printf ("OTP-Page: %08lx", otp_page);
*         else
*               :
---------------------------------------------------------------------------*/
void proloc_SelectSnr (DWORD_T, DWORD_T *);




/*-HITAG1--------------------------function header----------------------------
*
*       proloc_SelectLast ()
*                          selects the HITAG1 with that serial number which
*                          was at last accessed by proloc_GetSnr.
*                          If this command was successful the HITAG1 is
*                          selected for read/write accesses.
*                          Different to proloc_SelectSnr this function
*                          returns no OTP - page.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3)
*                                           ECRC(-15)
*
*       for     example:
*               :
*       DWORD_T         Identifier;
*       BYTE_T          more;
*               :
*       proloc_GetSnr (&Identifier, &more);
*       while (!RWDEot);
*
*       if (!RWDErr)
*       {
*          proloc_SelectLast();  // Prepairs the HITAG1 for read/write action
*          while (!RWDEot);
*          if (RWDErr==EOK)
*          printf ("HITAG1 selected");
*               :
*       }
*       else
*               :
---------------------------------------------------------------------------*/
void   proloc_SelectLast (void);



/*-HITAG1-------------------------function header----------------------------
*
*       proloc_HaltSelected ()
*                          sets the selected TAG into HALT - mode. So the
*                          HITAG1 doesn't reply on any kind of proloc-command
*                          until you call proloc_HFReset or put the HITAG1 out
*                          of the rf-field. After a HITAG1 is halted, other
*                          TAGs simultaneously in rf-field can be operated.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), EQUIT(-8)
*
*       for     example:
*               :
*       DWORD_T        Identifier;
*       DWORD_T        otp_page;
*               :
*       proloc_GetSnr (&Identifier);
*       while (!RWDEot);
*
*       if (!RWDErr)
*       {
*          proloc_SelectSnr (Identifier, &opt_page);
*          while ( !RWDEot );
*          if (RWDErr == EOK)
*           {
*                :
*             proloc_HaltSelected ();
*             while (!RWDEot);
*             printf ("HITAG1 halted");
*           }
*        }
*        else
*               :
---------------------------------------------------------------------------*/
void   proloc_HaltSelected (void);



/*-HITAG1-------------------------function header----------------------------
*
*       proloc_ReadPage (BYTE_T crypto, BYTE_T pagenr, char *data)
*                          reads one page from the actual selected HITAG1.
*                          You have to access 'plain'-pages in PLAIN mode,
*                          whereas 'crypto'-pages in CRYPTO mode. For CRYPTO
*                          mode a mutual authentication is mandatory!
*                          If no HITAG1 is selected RWDErr is set to ENOTAG(0).
*
* (IN)  BYTE_T  crypto     defines the access mode
*                             PLAIN ... (0)
*                             CRYPTO .. (1)
* (IN)  BYTE_T  pagenr     defines the page-number for read access.
*                          The range is between page 0 and page 63.
*                          A page is 4 bytes.
* (OUT) char    *data      A pointer to an array which holds at the
*                          read TAG data (4 Bytes).
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3),
*                          ECRYPTO(-9), ECRC(-15).
*               RWDDataLen The number of characters read (4 on success).
*
*       for     example:
*               :
*       DWORD_T        Identifier;
*       DWORD_T        otp_page;
*       BYTE           pagenr;
*       char           DataPtr[4];
*               :
*       proloc_GetSnr (&Identifier);
*       while (!RWDEot);
*       if (!RWDErr)
*       {
*          proloc_SelectLast();
*          while ( !RWDEot );
*          if (RWDErr == EOK)
*           {
*                :
*             proloc_ReadPage (PLAIN, pagenr, DataPtr);   // PLAIN READ
*             while( !RWDEot );                           // ----------
*             if ( RWDErr!=EOK )
*               printf( "error : %02x",RWDErr );
*             else
*             Output( DataPtr, RWDDataLen );
*                :
*                :
*             proloc_MutualAuthent (AUTHENT_KEY_A);       // CRYPTO READ
*             while( !RWDEot );                           // -----------
*             if ( RWDErr == EOK )
*             {
*               proloc_ReadPage (CRYPTO, pagenr, DataPtr);
*               while( !RWDEot );
*               if ( RWDErr!=EOK )
*                 printf( "error : %02x",RWDErr );
*               else
*                 Output( DataPtr, RWDDataLen );
*               :
---------------------------------------------------------------------------*/
void   proloc_ReadPage (BYTE_T, BYTE_T, char *);



/*-HITAG1-------------------------function header----------------------------
*
*       proloc_ReadBlock (BYTE_T crypto, BYTE_T pagenr, char *data)
*                          reads one block (4 pages) from the actual
*                          selected HITAG1. If -pagenr- is not the beginning
*                          of a block, the pages (page = 4 bytes) from
*                          -pagenr- to block-end are read.
*                          You have to access 'plain'-pages in PLAIN mode,
*                          whereas 'crypto'-pages in CRYPTO mode. For CRYPTO
*                          mode a mutual authentication is mandatory!
*
* (IN)  BYTE_T  crypto     defines the access mode.
*                             PLAIN ... (0)
*                             CRYPTO .. (1)
* (IN)  BYTE_T  pagenr     defines the page-number for read access.
*                          The range is from page 0 to page 63.
* (OUT) char    *data      The read data from the selected HITAG1.
*                          (4-16 Bytes depending on page-number)
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3),
*                          ECRYPTO(-9), ECRC(-15).
*               RWDDataLen The real number of characters read (4 - 16)
*
*       for     example:
*               :
*       DWORD_T        Identifier;
*       DWORD_T        otp_page;
*       BYTE           pagenr;
*       char           DataPtr[16];
*               :
*       proloc_GetSnr (&Identifier);
*       while (!RWDEot);
*       if (!RWDErr)
*       {
*          proloc_SelectLast();
*          while ( !RWDEot );
*          if (RWDErr == EOK)
*           {
*                :
*             proloc_ReadBlock (PLAIN, pagenr, DataPtr);   // PLAIN READ
*             while( !RWDEot );                            // ----------
*             if ( RWDErr!=EOK )
*               printf( "error : %02x",RWDErr );
*             else
*             Output( DataPtr, RWDDataLen );
*                :
*                :
*             proloc_MutualAuthent (AUTHENT_KEY_A);       // CRYPTO READ
*             while( !RWDEot );                           // -----------
*             if ( RWDErr == EOK )
*             {
*               proloc_ReadBlock (CRYPTO, pagenr, DataPtr);
*               while( !RWDEot );
*               if ( RWDErr!=EOK )
*                 printf( "error : %02x",RWDErr );
*               else
*                 Output( DataPtr, RWDDataLen );
*               :
---------------------------------------------------------------------------*/
void   proloc_ReadBlock (BYTE_T, BYTE_T, char *);



/*-HITAG1-------------------------function header----------------------------
*
*       proloc_WritePage (BYTE_T crypto, BYTE_T pagenr, char *data)
*                          writes one page (4 bytes) to the actual selected
*                          HITAG1.
*                          You have to access 'plain'-pages in PLAIN mode,
*                          whereas 'crypto'-pages in CRYPTO mode. For CRYPTO
*                          mode a mutual authentication is mandatory!
*
* (IN)  BYTE_T  crypto     defines the access mode.
*                             PLAIN ... (0)
*                             CRYPTO .. (1)
* (IN)  BYTE_T  pagenr     defines the page-number for write access.
*                          The range is between page 0 and page 63.
* (IN)  char    *data      A pointer to an array which holds the
*                          data (4 bytes) to write.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3)
*                          ECRYPTO(-9).
*
*       for     example:
*               :
*       DWORD_T        Identifier;
*       DWORD_T        otp_page;
*       BYTE           pagenr;
*       char           DataPtr[4];
*               :
*       proloc_GetSnr (&Identifier);
*       while (!RWDEot);
*       if (!RWDErr)
*       {
*          proloc_SelectLast();
*          while ( !RWDEot );
*          if (RWDErr == EOK)
*           {
*                :
*             proloc_WritePage (PLAIN, pagenr, DataPtr);   // PLAIN WRITE
*             while( !RWDEot );                            // -----------
*             if ( RWDErr!=EOK )
*               printf( "error : %02x",RWDErr );
*             else
*             Output( DataPtr, RWDDataLen );
*                :
*                :
*             proloc_MutualAuthent (AUTHENT_KEY_B);       // CRYPTO WRITE
*             while( !RWDEot );                           // ------------
*             if ( RWDErr == EOK )
*             {
*               proloc_WritePage (CRYPTO, pagenr, DataPtr);
*               while( !RWDEot );
*               if ( RWDErr!=EOK )
*                 printf( "error : %02x",RWDErr );
*               else
*                 Output( DataPtr, RWDDataLen );
*               :
---------------------------------------------------------------------------*/
void   proloc_WritePage (BYTE_T, BYTE_T, char *);



/*-HITAG1-------------------------function header----------------------------
*
*       proloc_WriteBlock (BYTE_T crypto, BYTE_T pagenr, char *data)
*                          writes one block (4 pages) to the actual
*                          selected HITAG1. If -pagenr- is not the beginning
*                          of a block, the pages (page = 4 bytes) from -pagenr-
*                          to block-end are written.
*                          You have to access 'plain'-pages in PLAIN mode,
*                          whereas 'crypto'-pages in CRYPTO mode. For CRYPTO
*                          mode a mutual authentication is mandatory!
*
* (IN)  BYTE_T  crypto     defines the access mode.
*                             PLAIN ... (0)
*                             CRYPTO .. (1)
* (IN)  BYTE_T  pagenr     defines the page-number for write access.
*                          The range is from page 0 to page 63.
* (IN)  char    *data      A pointer to an array which holds the
*                          data (4-16 bytes) to write.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3)
*                          ECRYPTO(-9).
*
*       for     example:
*               :
*       DWORD_T        Identifier;
*       DWORD_T        otp_page;
*       BYTE           pagenr;
*       char           DataPtr[16];
*               :
*       proloc_GetSnr (&Identifier);
*       while (!RWDEot);
*       if (!RWDErr)
*       {
*          proloc_SelectLast();
*          while ( !RWDEot );
*          if (RWDErr == EOK)
*           {
*                :
*             proloc_WriteBlock (PLAIN, pagenr, DataPtr);   // PLAIN WRITE
*             while( !RWDEot );                             // -----------
*             if ( RWDErr!=EOK )
*               printf( "error : %02x",RWDErr );
*             else
*             Output( DataPtr, RWDDataLen );
*                :
*                :
*             proloc_MutualAuthent (AUTHENT_KEY_B);       // CRYPTO WRITE
*             while( !RWDEot );                           // ------------
*             if ( RWDErr == EOK )
*             {
*               proloc_WriteBlock (CRYPTO, pagenr, DataPtr);
*               while( !RWDEot );
*               if ( RWDErr!=EOK )
*                 printf( "error : %02x",RWDErr );
*               else
*                 Output( DataPtr, RWDDataLen );
*               :
---------------------------------------------------------------------------*/
void   proloc_WriteBlock (BYTE_T, BYTE_T, char *);



/*-HITAG1-------------------------function header----------------------------
*
*       proloc_TagAuthent (BYTE_T keyinfo)
*                          starts a simple authentication process for the
*                          HITAG1. The next command has to be a proloc_GetSnr
*                          or a proloc_HFReset, since no cyphered
*                          communication between RWD and HITAG1 is possible.
*                          This function was established to check if a HITAG1
*                          is member of the same 'family' as the RWD.
*                          To start cyphered communication use MutualAuthent.
*
* (IN)  BYTE_T  keyinfo    specifies which key and logdata is to use.
*                             AUTHENT_KEY_A ... (0)
*                             AUTHENT_KEY_B ... (1)
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1),
*                          EAUTHENT(-7)
*
*       for     example:
*
*       DWORD_T        Identifier;
*               :
*       proloc_GetSnr (&Identifier);
*       while (!RWDEot);
*       if (!RWDErr)
*       {
*          proloc_SelectLast();
*          while ( !RWDEot );
*          if (RWDErr == EOK)
*          {
*                :
*             proloc_TagAuthent (AUTHENT_KEY_B);
*             while( !RWDEot );
*             if ( RWDErr == ENOTAG )
*               printf( "Tag is not authentic",RWDErr );
*             else
*               :
---------------------------------------------------------------------------*/
void   proloc_TagAuthent (BYTE_T);



/*-HITAG1-------------------------function header----------------------------
*
*       proloc_MutualAuthent (BYTE_T keyinfo)
*                          starts the mutual authentication for the RWD and
*                          the HITAG1. After MutualAuthent read and write
*                          commands in cyphered mode are possible.
*
* (IN)  BYTE_T  keyinfo    specifies which key and logdata is to use.
*                             AUTHENT_KEY_A ... (0)
*                             AUTHENT_KEY_B ... (1)
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1),
*                          EAUTHENT(-7)
*
*       for     example:
*
*       DWORD_T        Identifier;
*       DWORD_T        otp_page;
*       BYTE           pagenr;
*       char           DataPtr[4];
*               :
*       proloc_GetSnr (&Identifier);
*       while (!RWDEot);
*       if (!RWDErr)
*       {
*          proloc_SelectLast();
*          while ( !RWDEot );
*          if (RWDErr == EOK)
*           {
*
*             proloc_MutualAuthent (AUTHENT_KEY_A); // MUTUAL AUTHENTICATION
*             while( !RWDEot );                     // ---------------------
*             if ( RWDErr == EOK )
*             {
*               proloc_ReadPage (CRYPTO, pagenr, DataPtr);
*               while( !RWDEot );
*               if ( RWDErr!=EOK )
*                 printf( "error : %02x",RWDErr );
*               else
*                 Output( DataPtr, RWDDataLen );
*               :
---------------------------------------------------------------------------*/
void   proloc_MutualAuthent (BYTE_T);



/*-MIRO--------------------------function header----------------------------
*
*       proloc_ReadMiro (char *data)
*                          Different to the other proloc-functions this
*                          function continuously tries to read data of a
*                          MIRO-TAG (even if no transponder is in rf field),
*                          until the reading is successful or it is
*                          interrupted by proloc_StopCommand.
*
* (OUT)  char    *data     A pointer to an array which holds the read
*                          data (5 Bytes).
*
* (GLOBAL)      RWDEot     gets TRUE(1), when a Miro-TAG is read.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*               RWDDataLen 5 (bytes)
*
*       for     example:
*               :
*       char           DataPtr[5];
*               :
*       proloc_ReadMiro (DataPtr);
*
*       while (1)
*       {
*          while (!RWDEot)
*          {
*             if (kbhit () && getch ()==27)
*             {
*                proloc_StopCommand ();
*                while (!RWDEot);
*                break;
*             }
*          }
*          if (!RWDErr)
*             Output_Data ();
*       }
*               :
---------------------------------------------------------------------------*/
void   proloc_ReadMiro (char *);



/*-RWD---------------------------function header----------------------------
*
*       proloc_GetVersion (char *data)
*                          This function reads the software-version, the
*                          software-date and the serialnumber of the RWD.
*
* (OUT) char    *data      Carries the information of the RWD.
*                          data[0-7]   ... Version Vx.yy.zzz
*                          data[8-15]  ... Date    dd.mm.yy
*                          data[16-26] ... Serialnumber
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*               RWDDataLen 27 (bytes)
*
*       for     example:
*            :
*      char   Version[27];
*
*       proloc_GetVersion (Version);
*       while( !RWDEot );
*       if ( RWDErr==EOK )
*       {
*          printf ("version:      %.8s\n", Version);
*          printf ("date:         %.8s\n", &Version[8]);
*          printf ("serialnumber: %.11s", &Version[16]);
*       }
*       else
*               :
---------------------------------------------------------------------------*/
void  proloc_GetVersion (char *);



/*-RWD---------------------------function header----------------------------
*
*       proloc_Reset()
*                          When command is sent in Standard Mode:
*                           resets basic function of read/write device.
*                           Port Pins of the microcontroller are reset to
*                           an initial state (output pins are set to '0',
*                           input pins are set to '1').
*                          When command is sent in KeyInit Mode:
*                           This only sets the mode to Standard mode.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*
*       proloc_Reset();
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf( "error : %02x",RWDErr );
*       else
*               :
---------------------------------------------------------------------------*/
void  proloc_Reset (void);



/*-RWD---------------------------function header----------------------------
*
*       proloc_HFReset()
*                          switches off the antenna voltage (rf field) for
*                          about 100 ms, if the RWD is confogured as proximity
*                          and for 40 ms, if it is configured as long range
*                          application. HFReset puts all TAGs to idle mode.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*
*       proloc_HFReset();
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf( "error : %02x",RWDErr );
*       else
*               :
---------------------------------------------------------------------------*/
void  proloc_HFReset (void);



/*-RWD---------------------------function header----------------------------
*
*       proloc_StopCommand()
*                          stops the permanent reading mode of the
*                          read/write device, e.g. during ReadMiro or PollTags
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*
*       proloc_RdMiro();
*      	delay(500);
*       if ( !RWDEot )
*          proloc_StopCommand();
*       else
*               :
---------------------------------------------------------------------------*/
void   proloc_StopCommand (void);



/*-RWD---------------------------function header----------------------------
*
*       proloc_SetHFMode (BYTE_T mode)
*                          This function switches the proloc RWD
*                          in proximity mode or in long range mode.
*
* (IN)   BYTE_T mode       byte to decide if RWD should operate in proximity
*                          (INTERNAL_HF) or in long range (EXTERNAL_HF) mode:
*                             INTERNAL_HF .... (0)    internal rf-system
*                             EXTERNAL_HF .... (1)    external rf-system
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*
*       proloc_SetHFMode (EXTERNAL_HF);   // The RWD is configured as long
*       while( !RWDEot );                 // range application.
*       if ( RWDErr!=EOK )
*          printf( "error : %02x",RWDErr );
*       else
*               :
---------------------------------------------------------------------------*/
void  proloc_SetHFMode (BYTE_T);



/*-RWD---------------------------function header----------------------------
*
*       proloc_ReadLRStatus()
*                          This function reads the status of the long range-
*                          reader antenna. If an overload is detected
*                          RWDErr is set to EANTOVERLOAD (-20) else
*                          RWDErr is set to EOK(0).
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1),
*                          EANTOVERLOAD(-20).
*       for     example:
*
*       proloc_ReadLRStatus();
*       while( !RWDEot );
*       if ( RWDErr == EANTOVERLOAD )
*               printf( "Attention: Antenna overload !");
*       else
*               :
---------------------------------------------------------------------------*/
void  proloc_ReadLRStatus (void);



/*-RWD---------------------------function header----------------------------
*
*       proloc_SetPowerDown (BYTE_T mode)
*                          sets or resets the powerdown-mode of the
*                          long range RWD, that means to switch on/off
*                          the antenna current of the long range antenna.
*                          This command has no function on proximity
*                          RWDs.
*
* (IN)  BYTE_T  mode       This parameter switches the rf stage of the long
*                          range RWD on or off:
*                             POWERDOWN MODE .. (0)
*                             ACTIVE MODE   ... (1)
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*
*       proloc_SetPowerDown (OFF);      //   switch power off
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*           printf( "error : %02x",RWDErr );
*       else
*               :
---------------------------------------------------------------------------*/
void  proloc_SetPowerDown (BYTE_T);



/*-RWD---------------------------function header----------------------------
*
*       proloc_StartFFT()
*                          starts the FFT of the long range application.
*                          This function extinguishes rf background noise
*                          (i.e: from computers, monitors) from the comm-
*                          unication signal RWD - TAG and is as often to
*                          use as new rf background noises arise near the
*                          long range antenna.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*                          EQUIT(-8).
*       for     example:
*
*       proloc_StartFFT ();
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf( "error : %02x",RWDErr );
*       else
*               :
---------------------------------------------------------------------------*/
void  proloc_StartFFT (void);


/*-RWD---------------------------function header----------------------------
*
*       proloc_SetBCD (BYTE_T bcd)
*                          adjusts the timing of the RWD to the long range
*                          antenna. This is done, when an antenna and a
*                          RWD are assembled the first time or a new long
*                          range antenna is installed.
*
* (IN)  BYTE_T  bcd        bitclockdata: This parameter is used for the
*                          finetuning of the rong range antenna.
*                          Values from 0x00, 0x10 .. 0xF0 are possible.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*                          EQUIT(-8).
*       for     example:
*
*       proloc_SetBCD (0xD0);
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf( "error : %02x",RWDErr );
*       else
*               :
---------------------------------------------------------------------------*/
void   proloc_SetBCD (BYTE_T);




/*-RWD---------------------------function header----------------------------
*
*       proloc_ReadBCD (BYTE_T *bitclockdata)
*													 Reads the bitclockdata-value
*													 (finetuning value for longrange application)
*
* (OUT) BYTE_T  *bitclockdata
													 This parameter is used for the
*                          finetuning of the rong range antenna.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*                          EQUIT(-8).
*       for     example:
*
*       BYTE_T bitclockdata;
*       proloc_ReadBCD (&bitclockdata);
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf( "error : %02x",RWDErr );
*       else
*          printf( "BCD-value: %02x",bitclockdata );
*        :
---------------------------------------------------------------------------*/
void  proloc_ReadBCD (BYTE_T *);



/*-RWD---------------------------function header----------------------------
*
*       proloc_ReadEEData (BYTE_T addr, BYTE_T bytenmb, char *data)
*                          This function reads a number of bytes from the
*                          internal EEPROM of the RWD. This EEPROM area is
*                          reserved for customer use.
*                    NOTE: This command is different to
*                          proloc_ReadEEPROM, which is a command for
*                          personalization of the RWD.
*
* (IN)  BYTE_T  addr       specifies the start address. Possible 0 to 84.
* (IN)  BYTE_T  bytenmb    specifies the number of bytes to be read.
*                          Maximum 16 bytes.
* (OUT) char    *data      A pointer to an array which holds the read
*                          data.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*                          EE2CHK(-10).
*               RWDDataLen 1 - 16 (bytes)
*
*       for     example:
*               :
*       char   input[16];
*
*       proloc_ReadEEData (0, 16, input);
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf ("error: %d", RWDErr);
*       else
*               :
---------------------------------------------------------------------------*/
void   proloc_ReadEEData (BYTE_T, BYTE_T, char *);



/*-RWD---------------------------function header----------------------------
*
*       proloc_WriteEEData (BYTE_T addr, BYTE_T bytenmb, char *data)
*                          This function writes a number of bytes to the
*                          internal EEPROM of the RWD. This EEPROM area is
*                          reserved for customer use.
*                    NOTE: This command is different to
*                          proloc_WriteEEPROM, which is a command for
*                          personalization of the RWD.
*
* (IN)  BYTE_T  addr       specifies the start address. Possible 0 to 84.
* (IN)  BYTE_T  bytenmb    specifies the number of bytes to be read.
*                          Maximum 16 bytes
* (IN)  char    *data      A pointer to an array which holds the data.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*                          EE2CHK(-10).
*
*       for     example:
*            :
*       char       output[16];
*
*       proloc_WriteEEData (0, 16, output);
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf ("error: %d", RWDErr);
*       else
*               :
---------------------------------------------------------------------------*/
void   proloc_WriteEEData (BYTE_T, BYTE_T, char *);



/*-RWD---------------------------function header----------------------------
*
*       proloc_SetOutput (BYTE_T output)
*                          This function sets or clears outputpins of
*                          the RWD.
*
* (IN)  BYTE_T  output     represents a byte of which the bits are mapped to
*                          portpins of the RWD
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*            :
*
*       proloc_SetOutput (0x03);
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf ("error: %d", RWDErr);
*       else
*               :
---------------------------------------------------------------------------*/
void    proloc_SetOutput (BYTE_T);



/*-RWD---------------------------function header----------------------------
*
*       proloc_ReadInput (BYTE_T *input)
*                          This function reads the status of the
*                          input pins of the RWD.
*
* (OUT) char    *input     represents a byte of which the bits are mapped to
*                          portpins of the RWD
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*               RWDDataLen 1 (byte)
*
*       for     example:
*            :
*       BYTE_T input;
*
*       proloc_ReadInput (&input);
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf ("error: %d", RWDErr);
*       else
*          printf("Input data: %2x", input);
*               :
---------------------------------------------------------------------------*/
void    proloc_ReadInput (BYTE_T *);



/*-RWD---------------------------function header----------------------------
*
*       proloc_ConfigPorts( BYTE_T config )
*                          sets the configuration byte of Port0 on the RWD.
*                          The bits 0 - 7 of -config- correspond with
*                          portpins P0.0 - P0.7.
*
* (IN) BYTE_T   config     is made of 8 bits, witch configure the portpins:
*                             0 ... configure as input
*                             1 ... configure as output
*                          example:
*	                         config = 0xFF ... all portpins are outputs
*                          config = 0x01 ... all are inputs except P0.0
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*               :
*       proloc_ConfigPorts( 0x0F ); // P0.0 - P0.3 ... output
*               :                   // P0.4 - P0.7 ... input
---------------------------------------------------------------------------*/
void  proloc_ConfigPorts (BYTE_T);


/*-RWD---------------------------function header----------------------------
*
*       proloc_ReadPorts (BYTE_T *input)
*                          reads Port0 on the RWD. The bits 0 - 7 in -mode-
*                          correspond with portpins P0.0 - P0.7.
*                          Bit-positions of output-configurated pins are
*                          read as '0'
*
* (OUT) BYTE_T  *input     The bits of -data- correspond to the port-
*                          pins P0.0 - P0.7.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*       BYTE_T input;
*               :
*       proloc_ReadPorts (&input);   // read port0
*       while( !RWDEot );
*       if ( !RWDErr )
*          printf("Port0 - input data: %2x", input);
*               :
---------------------------------------------------------------------------*/
void  proloc_ReadPorts (BYTE_T *);



/*-RWD---------------------------function header----------------------------
*
*       proloc_WritePorts (BYTE_T output, BYTE_T mode)
*                          writes the byte -output- to Port0. The bits 0 - 7
*                          in -data- correspond with portpins P0.0 - P0.7.
*                          The effect on port0 depends on the configuation
*                          of the portpins (in/outputs) and -mode-.
*
* (IN)  BYTE_T  output     bits 0 - 7 of -output- correspond to the portpins
*                          P0.0 - P0.7.
* (IN)  BYTE_T  mode       DIRECT(0)..output is written directly to output-pins
*                          AND   (1)..output is AND-combined to old output-values
*                          OR    (2)..output is OR-combined to old output-values
*                          EXOR  (3)..output is EXOR-combined to old output-values
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*               :
*       proloc_WritePorts (0xFE , AND);  //sets the portpin P0.0 to 0, others
*                                        //unchanged.
*               :
---------------------------------------------------------------------------*/
void  proloc_WritePorts (BYTE_T , BYTE_T);



/*-RWD---------------------------function header----------------------------
*
*       proloc_PollTags (BYTE_T mode, char *data)
*                          polls for different kinds of TAGs, until a TAG
*                          is in rf field. Different to other proloc-commands
*                          it only breakes, if a TAG is in rf field or it is
*                          interrupted by proloc_StopCommand.
*
* (IN)  BYTE_T  mode       this byte is used as a bit-array to switch the
*                          polling for special kinds of TAGs on/off.
* (OUT) char    *data      reply of reader; depends on the kind of TAG
*
* (GLOBAL)      RWDEot     gets TRUE(1), when a TAG is read.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*               RWDDataLen depending on TAG: 4, 5, 16.
*
*       for     example:
*       char           data[16];
*       BYTE_T         mode;
*               :
*       mode = 0x3b;                    // poll-mode
*       proloc_PollTags (mode, data);   // polling is done until a TAG is in
*       while (1)                       // rf-field or you break it
*       {
*           while (!RWDEot)
*           {
*              if (kbhit () && getch ()==27)
*              {
*                 proloc_StopCommand ();
*                 while (!RWDEot);
*                 break;
*               }
*           }
*          if (!RWDErr)
*             Output_Data ();            // Identify TAG and output data
*       }
*               :
---------------------------------------------------------------------------*/
void proloc_PollTags (BYTE_T, char *);



/*-RWD---------------------------function header----------------------------
*
*       proloc_PollKbTags (BYTE_T mode, char *data)
*                          polls once for a selectable transponder (HITAG1
*                          or HITAG2) and reads the keyboard-buffer and the
*                          inputs.
*
* (IN)  BYTE_T  mode       different modes for poll-operation
* (OUT) char    *data      contains at maximum one byte status-information,
*                          4 bytes keyboard-buffer and 4 bytes serial number
*                          of a TAG.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when a TAG or keystroke is detected.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*               RWDDataLen 5 (key or TAG), 9 (key and TAG).
*
*       for     example:
*       char           data[9];
*       BYTE_T         mode;
*               :
*       mode = 0x80;                    // poll HITAG1 & Keybard
*       proloc_PollKbTags (mode, data);
*       while (!RWDEot);
*       if (!RWDErr)
*         Output_Data ();            // Identify TAG and output data
*               :
---------------------------------------------------------------------------*/
void proloc_PollKbTags (BYTE_T, char *);



/*-RWD---------------------------function header-----------------------------
*
*       proloc_SetProxTrmTime (BYTE_T t_0, BYTE_T t_1, BYTE_T t_p)
*                          Command sets the RF-bit-times for a Proximity-
*                          RWD.
*
* (IN)                     the following conversions for T0,T1,TP in
*                          micro-seconds have to be done to get t_0, t_1
*                          and t_p:
*       BYTE_T t_0         t_0=(BYTE_T)(32768-((T0-TP-24)/1.2));
*       BYTE_T t_1         t_1=(BYTE_T)(32768-((T1-TP-24)/1.2));
*       BYTE_T t_p         t_p=(BYTE_T)(32768-((TP-24)/1.2));
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*
*       DWORD_T T0,T1,TP;
*       BYTE_T t_0,t_1,t_p;
*       T0=176;  // 176us
*       T1=224;  // 224us
*       TP=48;   // 48us
*       t_0=(BYTE_T)(32768-((T0-TP-24)/1.2));
*       t_1=(BYTE_T)(32768-((T1-TP-24)/1.2));
*       t_p=(BYTE_T)(32768-((TP-24)/1.2));
*   		proloc_SetProxTrmTime(t_0,t_1,t_p);
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf( "error : %02x",RWDErr );
*       else
*               :
---------------------------------------------------------------------------*/
void  proloc_SetProxTrmTime(BYTE_T,BYTE_T,BYTE_T);



/*-RWD---------------------------function header-----------------------------
*
*       proloc_SetModuleAdr (BYTE_T addr, char *snr)
*                          is used to set addresses of RWD-modules when
*                          multiple RWDs are used on one serial interface.
*                          First parameter -adr- is the new address
*                          of the RWD-module. Parameter 2 -snr- is a string
*                          containing the serialnumber of the RWD.
*                    NOTE: after a call of this function, a special set of
*                          proloc-functions (Proloc_M prefix, see PROLBMU6.H)
*                          is provided to access the RWD!
*
* (IN)  BYTE_T  addr       new address of the RWD.
* (IN)  char    *snr       containing the RWD's serialnumber, 11 bytes long.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*       char           data[11];
*       BYTE_T         addr;
*               :
*       addr = 10;
*       memcpy( data, serialnumber1, 11 );// serialnumber1 is a pointer to
*                                         // the 11 byte long snr of a RWD.
*       proloc_SetModuleAdr (addr, data);  // from now on the RWD is only
*       while( !RWDEot );                 // accessable with address 10.
*                                         // You have to use a special proloc
*               :                         // function set to operate with it.
---------------------------------------------------------------------------*/
void proloc_SetModuleAdr (BYTE_T, char*);



/*-RWD HITAG1 PERS----------------function header----------------------------
*
*       proloc_KeyInitMode (DWORD_T password)
*                          This function starts the KeyInitMode of the
*                          RWD. The right password has to be entered.
*                          In KeyInitMode all personalization issues
*                          for HITAG1 or HITAG2 or PIT are made.
*                    NOTE: If this function was successful you have to
*                          change the BCC-Mode with proloc_SetBCCMode(), since
*                          the block-check-character (BCC) has a different
*                          calculation mode for commands in KeyInitMode.
*                          After KeyInitMode you have to change BCC calcu-
*                          lation back to standard mode.
*
* (IN)  DWORD_T password   the 4 byte password to enter KeyInitMode
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1),
*                          EEWRONGOLD(-11)
*
*       for  example:
*
*       DWORD_T         password;
*               :
*       proloc_KeyInitMode (password);
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf ("error: %d", RWDErr);
*       else
*          proloc_SetBCCMode (INIT_BCC); // BCC-calculation for KeyInitMode
*               :
---------------------------------------------------------------------------*/
void   proloc_KeyInitMode (DWORD_T );



/*-RWD HITAG1 PERS----------------function header----------------------------
*
*       proloc_ReadControl (BYTE_T *data)
*                          This function reads the two control bytes which
*                          control the type of access to HITAG1-
*                          personalization data in the internal EEPROM of
*                          the reader.
*                          RWD has to be in KeyInit Mode.
*
* (OUT) BYTE_T  *data      A pointer to an array which holds the data.
*                             data[0] ... CONTROL_RW
*                             data[1] ... CONTROL_WO
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*               RWDDataLen 2 (bytes)
*
*       for     example:
*                :
*       DWORD_T         password;
*       BYTE_T          control[4];
*
*       proloc_KeyInitMode (password);   // Start KeyInitMode
*       while( !RWDEot );
*       if ( RWDErr == EOK )
*       {
*          proloc_SetBCCMode (INIT_BCC); // BCC-calculation for KeyInitMode
*          proloc_ReadControl (control);
*          while( !RWDEot );
*          if ( RWDErr!=EOK )
*             printf ("error: %d", RWDErr);
*          else
*               :
*       }
*               :
---------------------------------------------------------------------------*/
void   proloc_ReadControl (BYTE_T *);



/*-RWD HITAG1 PERS----------------function header----------------------------
*
*       proloc_WriteControl (BYTE_T control_rw, BYTE_T control_wo)
*                          This function writes the two control bytes which
*                          control the type of access to HITAG1-
*                          personalization data in the internal EEPROM of
*                          the reader.
*                          RWD has to be in KeyInit Mode.
*                    NOTE: BE VERY CAREFUL WHEN WRITING THESE BYTES, since
*                    ===== one time you changed a bit to 0, you may never
*                          can change it back to 1.
*
* (IN)  BYTE_T  control_rw   read/write permission for keys, logdata & password
* (IN)  BYTE_T  control_wo   write-only permission for keys, logdata & password
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*               :
*       DWORD_T         password;
*       BYTE_T          control_rw, control_wo;
*
*               :
*       proloc_KeyInitMode (password);
*       while( !RWDEot );
*       if ( RWDErr == EOK )
*       {
*          proloc_SetBCCMode (INIT_BCC); // BCC-calculation for KeyInitMode
*          proloc_WriteControl (control_rw, control_wo);
*          while( !RWDEot );
*          if ( RWDErr!=EOK )
*             printf ("error: %d", RWDErr);
*          else
*               :
*       }
*               :
---------------------------------------------------------------------------*/
void   proloc_WriteControl (BYTE_T, BYTE_T);



/*-RWD HITAG1 PERS----------------function header----------------------------
*
*       proloc_ReadEEPROM (BYTE_T num, DWORD_T *data)
*                          reads a package of 4 databytes from the EEPROM
*                          of the RWD to get personalization data (keys,
*                          logdata, password).
*                          RWD has to be in KeyInit Mode.
*
* (IN)  BYTE_T  num        specifies the data to be read:
*                             PASSWORD .. (0)
*                             KEY_A ..... (1)     KEY_B ... (2)
*                             LOG_0A .... (3)     LOG_0B .. (4)
*                             LOG_1B .... (5)     LOG_1A .. (6)
* (OUT) DWORD_T *data      replied data depends on -num-. 4 bytes long.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1),
*                          EERDPROT(-13).
*               RWDDataLen 4 (bytes)
*
*       for    example:
*               :
*       DWORD_T         password;
*       DWORD_T         logdata;
*
*       proloc_KeyInitMode (password);
*       while( !RWDEot );
*       if ( RWDErr == EOK )
*       {
*          proloc_SetBCCMode (INIT_BCC); // BCC-calculation for KeyInitMode
*          proloc_ReadEEPROM (LOG_0A, &logdata);
*          while( !RWDEot );
*          if ( RWDErr!=EOK )
*             printf ("error: %d", RWDErr);
*          else
*               :
*       }
*               :
---------------------------------------------------------------------------*/
void   proloc_ReadEEPROM (BYTE_T, DWORD_T *);



/*-RWD HITAG1 PERS----------------function header----------------------------
*
*       proloc_WriteEEPROM (BYTE_T num, DWORD_T old, DWORD_T _new)
*                          writes a package of 4 databytes to the EEPROM
*                          of the RWD to change personalization data (keys,
*                          logdata, password). You have to send the old data
*                          with the new, to prevent accidential overwriting.
*                          RWD has to be in KeyInit Mode.
*                    NOTE: DO NOT CHANGE THIS DATA CARELESSLY, since you
*                          may loose access to personalization data!
*
* (IN)  BYTE_T  num        specifies the data to be written:
*                             PASSWORD .. (0)
*                             KEY_A ..... (1)     KEY_B ... (2)
*                             LOG_0A .... (3)     LOG_0B .. (4)
*                             LOG_1B .... (5)     LOG_1A .. (6)
* (IN)  DWORD_T od         The old value of the personalization data (4 bytes).
* (IN)  DWORD_T nd         The new value of the personalization data (4 bytes).
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*                          EEWRONGOLD(-11), EEWRPROT(-12).
*
*       for    example:
*            :
*       DWORD_T         password;
*       DWORD_T         olddata;
*       DWORD_T         newdata;
*
*       proloc_KeyInitMode (password);
*       while( !RWDEot );
*       if ( RWDErr == EOK )
*       {
*          proloc_SetBCCMode (INIT_BCC); // BCC-calculation for KeyInitMode
*          proloc_WriteEEPROM (LOG_0A, olddata, newdata);
*          while( !RWDEot );
*          if ( RWDErr!=EOK )
*             printf ("error: %d", RWDErr);
*          else
*             :
*       }
*             :
---------------------------------------------------------------------------*/
void   proloc_WriteEEPROM (BYTE_T, DWORD_T, DWORD_T );


/*-RWD HITAG1 PERS----------------function header----------------------------
*
*       proloc_WriteSerNum (char *snr)
*                          writes the serial number to internal EEPROM
*                          of the RWD.
*                          RWD has to be in KeyInit Mode.
*
* (IN)  char    *snr       datastring including snr, 11 bytes long.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*                          EEWRPROT(-12).
*
*       for    example:
*            :
*       DWORD_T         password;
*       char snr[12]="13467912457";
*
*       proloc_KeyInitMode (password);
*       while( !RWDEot );
*       if ( RWDErr == EOK )
*       {
*          proloc_SetBCCMode (INIT_BCC); // BCC-calculation for KeyInitMode
*          proloc_WriteSerNum (snr);
*          while( !RWDEot );
*          if ( RWDErr!=EOK )
*             printf ("error: %d", RWDErr);
*          else
*             :
*       }
*             :
---------------------------------------------------------------------------*/
void   proloc_WriteSerNum (char *);


/*-RWD HITAG1 PERS----------------function header----------------------------
*
*       proloc_SetBCCMode(BYTE_T mode)
*                          This function sets the calculation mode of
*                          BCC for the serial protocol. This has to be done
*                          immediately after KeyInitMode and at the end of
*                          the personalization process (proloc_Reset) since
*                          during personalization a different BCC-calculation
*                          is used.
*
* (IN)  BYTE_T  mode       mode byte:
*                             0 ... NORMAL_BCC    mode for standard BCC calc.
*                             1 ... INIT_BCC      mode for KeyInit BCC calc.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*               :
*       proloc_KeyInitMode (password);
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf ("error: %d", RWDErr);
*       else
*          proloc_SetBCCMode (INIT_BCC); // BCC-calculation for KeyInitMode
*               :
*             // Personalization Data read/write
*               :
*       proloc_Reset();  // leaving KeyInit Mode
*       while( !RWDEot );
*       proloc_SetBCCMode (NORMAL_BCC);  // BCC-calculation for Standard Mode
*               :
---------------------------------------------------------------------------*/
void  proloc_SetBCCMode (BYTE_T);


