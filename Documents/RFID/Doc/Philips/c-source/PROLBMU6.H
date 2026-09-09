//===========================================================================
//=                                                                         =
//=               PROLOC C-LIBRARY HEADERFILE "prolbmu6.h"                  =
//=                                                                         =
//=                      MIKRON Gratkorn Austria                            =
//=                             (c) 1996                                    =
//=                                                                         =
//===========================================================================

//CUST ==================== CUSTOMER   INFORMATION ==========================
//CUST
//CUST   CUSTOMER-INFORMATION:
//CUST   ---------------------
//CUST
//CUST   Include this headerfile in your sourcefile, if you want to utilize
//CUST   the possibility of operating with several RWDs on one serial
//CUST   interface (hardware is provided by the RS-485 bus interface).
//CUST   In this case include "prolbmu6.h" additional to the other proloc-
//CUST   headers in your C-source file.
//CUST
//CUST   #include "prolib6.h"    /* for HITAG1&MIRO only                   */
//CUST   #include "prolbph6.h"   /* optional for PITs                      */
//CUST   #include "prolblt6.h"   /* optional for HITAG2                    */
//CUST   #include "prolbmu6.h"   /* optional for multiple RWD use on RS485 */
//CUST   #include "prolveg6.h"   /* optional for VEGAS-RWD                 */
//CUST
//CUST   (Add PROLIB6.LIB proloc-library to your project)
//CUST
//CUST
//CUST   PROLBMU6.H contains:
//CUST
//CUST   o  A SHORT DOCUMENTATION to explain the addressing feature for
//CUST      RWDs.
//CUST
//CUST   o  The definition of the GLOBAL USED VARIABLE RWDAdr.
//CUST
//CUST   o  The declaration of the function SetModuleAdr which is
//CUST      used to set the addresses of RWDs.
//CUST
//CUST   o  MACRO DEFINES for the whole proloc-library functions to utilize
//CUST      the RWD addressing for your proloc function calls.
//CUST
//CUST   NOTE: This header file is only an extension to the proloc function
//CUST   ===== library (PROLIB6.H). If you want to have basic information
//CUST         over proloc functions see PROLIB6.H.
//CUST
//CUST ----------------------------------------------------------------------




//CUST ====================== SHORT    DOCUMENTATION ========================
//CUST
//CUST   CONCEPT FOR MULTIPLE RWD USE:
//CUST   =============================
//CUST
//CUST
//CUST                          +------------+
//CUST   Host                   |   PC, uC   |
//CUST                          +------------+
//CUST                                 |
//CUST   RS485 Bus    -----+-----------+---------------------+
//CUST   Interface         |           |                     |
//CUST                  +-----+     +-----+               +-----+
//CUST   Readers        | RWD |     | RWD |    . . . .    | RWD |
//CUST                  +-----+     +-----+               +-----+
//CUST
//CUST
//CUST   MIKRON provides a special proloc function set (Proloc_M prefix) for
//CUST   operating with several RWDs on one serial interface. This functions
//CUST   are macro defines (defined below in this file).
//CUST   NOTE: You can find the proloc function desriptions (proloc_ prefix)
//CUST         in the header files (PROLIB6.H, PROLBLT6.H, PROLBPH6.H), while
//CUST         the function macros in here only extent the functionality of
//CUST         the proloc-function library to handle multiple RWD operation.
//CUST   The difference between single mode proloc functions and multiple mode
//CUST   proloc-functions is the prefix, 'proloc_' respectively 'Proloc_M',
//CUST   and the additional 1.parameter which is the RWD address.
//CUST
//CUST   You can choose between two ways of using multiple mode:
//CUST   =======================================================
//CUST
//CUST      1)  Using the Proloc_M function set (macros, defined in this
//CUST          file). This function set is identical to the single mode
//CUST          function set (proloc_ prefix), but with a additional first
//CUST          parameter, which is the RWD address.
//CUST          NOTE: If you are exclusively using addressable RWDs, this
//CUST          ====  way is recommended.
//CUST
//CUST      2)  You want to use an old (not addressable) RWD together with
//CUST          addressable RWDs or want to define your own function set.
//CUST          In this case, you have to read chapter 1) & 2) to get more
//CUST          information over the RWD addressing mechanism.
//CUST
//CUST   1) Using Proloc_M - Function Set:
//CUST   ---------------------------------
//CUST
//CUST   a) First before you can send addressed commands to the RWDs, you
//CUST   have to assign different addresses to the RWDs. This is done by the
//CUST   command proloc_SetModuleAdr( parm1, parm2 ), where parm1 is the
//CUST   address (value from 1 to 255) and parm2 is a pointer to an array
//CUST   which holds the 11 byte long well known serial number of the RWD.
//CUST   NOTE: Do NOT use address 0, since this sets the RWD to single
//CUST   ====  mode!
//CUST
//CUST   b) When all RWDs have unique addresses you can send addressed
//CUST   commands. Use the Proloc_M - function library as defined below
//CUST   in this file. The first parameter is the address of the RWD, except
//CUST   for the functions Proloc_M_open and Proloc_M_close which do set up
//CUST   and close the serial interface communication path and so doesn't
//CUST   address a RWD.
//CUST
//CUST   Example:
//CUST
//CUST   BYTE_T        ser_num[MAX_RWDS][11];
//CUST   BYTE_T        address;
//CUST   DWORD_T       hitag_snr;
//CUST   char          more;
//CUST          :
//CUST   Proloc_M_open("COM2");
//CUST   while( !RWDEot );
//CUST          :
//CUST          :
//CUST   for( address = 1; address <= MAX_RWDS; address++ )
//CUST   {
//CUST      proloc_SetModuleAddress( address, &ser_num[address - 1][0] );
//CUST      while( !RWDEot );
//CUST      if ( RWDErr )
//CUST         break;
//CUST   }
//CUST   if ( RWDErr )
//CUST         :
//CUST   else
//CUST   {
//CUST         :
//CUST      address = rwd1_address;
//CUST      Proloc_M_GetSnr( address, &hitag_snr, &more );
//CUST      while( !RWDEot );
//CUST         :
//CUST   }
//CUST         :
//CUST   Proloc_M_close();
//CUST
//CUST
//CUST   2) Further Explanations:
//CUST   ------------------------
//CUST
//CUST
//CUST   Global variable RWDAdr:
//CUST   -----------------------
//CUST   contains the address of the RWD, to which the proloc-commands should
//CUST   be sent and switches between single/multiple mode automatically.
//CUST   (0) .. single mode:
//CUST      If RWDAdr is set to 0, all proloc-commands are sent without a
//CUST      address identification. This is possible, if only a single RWD,
//CUST      which is configured in single mode, is connected to the serial
//CUST      interface. In this case you can use the normal proloc-commandset
//CUST      from PROLIB6.H.
//CUST   (1 - 255) .. multiple mode:
//CUST      If RWDAdr is set to a value from 1 to 255, all consecutively
//CUST      called proloc-functions are sent with that address assigned to.
//CUST      This header file contains a special proloc-commandset (Proloc_M-
//CUST      prefix) which is equivalent to the normal proloc-commandset, but
//CUST      sends the address of the RWD with every command.
//CUST      NOTE: You should not access RWDAdr directly. Use the special
//CUST      ====  proloc-commandset (prefix "Proloc_M")
//CUST            For issues of compatibility to older proloc versions: Each
//CUST            proloc-command can be send in single mode (RWDAdr = 0) or
//CUST            in multiple mode (RWDAdr is a value from 1 - 255).
//CUST
//CUST   Example for equivalent command calls:
//CUST
//CUST   Proloc_M_GetSnr(adr,&snr,&more);   |  RWDAdr = adr;
//CUST                                      |  proloc_GetSnr(&snr,&more);
//CUST
//CUST   It is seen that you don't need to use the Proloc_M command set, if
//CUST   you set the right RWDAdr before every proloc command, but it is
//CUST   more comfortable and guarantees more code reliability and read-
//CUST   ability when using it.
//CUST   Problems may arise, when using new additional RWDs parallel to your
//CUST   old RWD on one serial interface, since in the source code of your
//CUST   existing programm, after a new added C-code using Proloc_M commands,
//CUST   you have to reset RWDAdr to 0 before a old 'single' proloc command.
//CUST
//CUST   Example:
//CUST                     // new part
//CUST         :
//CUST   Proloc_M_GetSnr( rwd1_address, &snr, &more );
//CUST   while( !RWDEot );
//CUST   if ( !RWDErr )
//CUST   {
//CUST      Proloc_M_SelectLast( rwd1_address );
//CUST      while( !RWDEot );
//CUST   }
//CUST   else
//CUST          :
//CUST                      // old part
//CUST          :
//CUST   RWDAdr = 0;        // NOTE: You have to reset RWDAdr to 0, since
//CUST                      //       otherwise the next proloc command would
//CUST                      //       still be sent to 'rwd1_address'.
//CUST   proloc_GetSnr( &snr, &more );
//CUST   while( !RWDEot );
//CUST
//CUST ----------------------------------------------------------------------




//CUST ====================== GLOBAL    VARIABLE ============================
//CUST
//CUST   The global variable RWDAdr contains the address of that RWD, to
//CUST   which the next proloc-command should be sent to.
//CUST   It is recommended not to change RWDAdr directly!
//CUST   Use the FUNCTION MAKRO DEFINES in this file.
//CUST   See also the SHORT DOCUMENTATION.
//CUST
//CUST   ATTENTION:  The possible values for RWDAdr are 1 - 255.
//CUST   ==========  If RWDAdr is set to 0, the next following command
//CUST               behaves like a 'single' command, that means it is sent
//CUST               without a address attached to. This causes that all
//CUST               RWDs, that have address 0 (= no address) will reply on
//CUST               this command simultanousely on the serial interface.
//CUST               This will cause a jam, if more than one RWD in 'single'
//CUST               mode (address = 0) is connected.
//CUST               See also SHORT DOCUMENTATION.
//CUST ----------------------------------------------------------------------

extern               uchar_t              RWDAdr;

//CUST ----------------------------------------------------------------------

//CUST ====================== FUNCTION    MACROS ============================
//CUST
//CUST   This FUNCTION MACROS make a C-source text replacement to set the
//CUST   global variable RWDAdr before the proloc-command. This macros give
//CUST   you a comfortable way to use RWD addressing feature, as easy as
//CUST   using 'single' function calls.
//CUST   See also the SHORT DOCUMENTATION.
//CUST   NOTE: For general  proloc-function descriptions see the header file
//CUST   ====  PROLIB6.H
//CUST         The difference between 'single' and 'multiple' proloc-commands
//CUST         is only an additional first parameter -adr- and a different
//CUST         function name prefix "Proloc_M" (instead of "proloc_").
//CUST
//CUST ----------------------------------------------------------------------

// The first Proloc_M command is identical to proloc_ command, since
// all readers shall be addressed ...only the reader with the right
// serial number executes this command.
#define   Proloc_M_SetModuleAdr( parm1, parm2) \
					proloc_SetModuleAdr( parm1, parm2 )

#define   Proloc_M_GetSnr( adr, parm1, parm2) \
					RWDAdr = adr; proloc_GetSnr( parm1, parm2 )

#define   Proloc_M_GetSnr_Adv( adr, parm1, parm2) \
					RWDAdr = adr; proloc_GetSnr_Adv( parm1, parm2 )

#define   Proloc_M_SelectSnr( adr, parm1, parm2) \
					RWDAdr = adr; proloc_SelectSnr( parm1, parm2 )

#define   Proloc_M_SelectLast( adr ) \
					RWDAdr = adr; proloc_SelectLast()

#define   Proloc_M_HaltSelected( adr ) \
					RWDAdr = adr; proloc_HaltSelected()

#define   Proloc_M_ReadPage( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_ReadPage( parm1, parm2, parm3 )

#define   Proloc_M_ReadBlock( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_ReadBlock( parm1, parm2, parm3 )

#define   Proloc_M_WritePage( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_WritePage( parm1, parm2, parm3 )

#define   Proloc_M_WriteBlock( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_WriteBlock( parm1, parm2, parm3 )

#define   Proloc_M_TagAuthent( adr, parm1 ) \
					RWDAdr = adr; proloc_TagAuthent( parm1 )

#define   Proloc_M_MutualAuthent( adr, parm1 ) \
					RWDAdr = adr; proloc_MutualAuthent( parm1 )

#define   Proloc_M_ReadMiro( adr, parm1 ) \
					RWDAdr = adr; proloc_ReadMiro( parm1 )

#define   Proloc_M_GetVersion( adr, parm1 ) \
					RWDAdr = adr; proloc_GetVersion( parm1 )

#define   Proloc_M_Reset( adr ) \
					RWDAdr = adr; proloc_Reset()

#define   Proloc_M_HFReset( adr ) \
					RWDAdr = adr; proloc_HFReset()

#define   Proloc_M_StopCommand( adr ) \
					RWDAdr = adr; proloc_StopCommand()

#define   Proloc_M_SetHFMode( adr, parm1 ) \
					RWDAdr = adr; proloc_SetHFMode( parm1 )

#define   Proloc_M_ReadLRStatus( adr ) \
					RWDAdr = adr; proloc_ReadLRStatus()

#define   Proloc_M_SetPowerDown( adr, parm1 ) \
					RWDAdr = adr; proloc_SetPowerDown( parm1 )

#define   Proloc_M_StartFFT( adr ) \
					RWDAdr = adr; proloc_StartFFT()

#define   Proloc_M_ReadBCD( adr, parm1 ) \
					RWDAdr = adr; proloc_ReadBCD( parm1 )

#define   Proloc_M_SetBCD( adr, parm1 ) \
					RWDAdr = adr; proloc_SetBCD( parm1 )

#define   Proloc_M_SetBCDOffset( adr, parm1 ) \
					RWDAdr = adr; proloc_SetBCDOffset( parm1 )

#define   Proloc_M_ReadEEData( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_ReadEEData( parm1, parm2, parm3 )

#define   Proloc_M_WriteEEData( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_WriteEEData( parm1, parm2, parm3 )

#define   Proloc_M_SetOutput( adr, parm1 ) \
					RWDAdr = adr; proloc_SetOutput( parm1 )

#define   Proloc_M_ReadInput( adr, parm1 ) \
					RWDAdr = adr; proloc_ReadInput( parm1 )

#define   Proloc_M_ConfigPorts( adr, parm1 ) \
					RWDAdr = adr; proloc_ConfigPorts( parm1 )

#define   Proloc_M_ReadPorts( adr, parm1 ) \
					RWDAdr = adr; proloc_ReadPorts( parm1 )

#define   Proloc_M_WritePorts( adr, parm1, parm2 ) \
					RWDAdr = adr; proloc_WritePorts( parm1, parm2 )

#define   Proloc_M_SetProxTrmTime( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_SetProxTrmTime( parm1, parm2, parm3 )

#define   Proloc_M_PollTags( adr, parm1, parm2 ) \
					RWDAdr = adr; proloc_PollTags( parm1, parm2 )

#define   Proloc_M_PollKbTags( adr, parm1, parm2 ) \
					RWDAdr = adr; proloc_PollKbTags( parm1, parm2 )

#define   Proloc_M_KeyInitMode( adr, parm1 ) \
					RWDAdr = adr; proloc_KeyInitMode( parm1 )

#define   Proloc_M_ReadControl( adr, parm1 ) \
					RWDAdr = adr; proloc_ReadControl( parm1 )

#define   Proloc_M_WriteControl( adr, parm1, parm2 ) \
					RWDAdr = adr; proloc_WriteControl( parm1, parm2 )

#define   Proloc_M_ReadEEPROM( adr, parm1, parm2 ) \
					RWDAdr = adr; proloc_ReadEEPROM( parm1, parm2 )

#define   Proloc_M_WriteEEPROM( adr, parm1, parm2 ) \
					RWDAdr = adr; proloc_WriteEEPROM( parm1, parm2 )

#define   Proloc_M_WriteSerNum( adr, parm1 ) \
					RWDAdr = adr; proloc_WriteSerNum( parm1 )

#define   Proloc_M_GetSnr_LT( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_GetSnr_LT( parm1, parm2, parm3 )

#define   Proloc_M_GetSnrReset_LT( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_GetSnrReset_LT( parm1, parm2, parm3 )

#define   Proloc_M_HaltSelected_LT( adr ) \
					RWDAdr = adr; proloc_HaltSelected_LT()

#define   Proloc_M_ReadPage_LT( adr, parm1, parm2 ) \
					RWDAdr = adr; proloc_ReadPage_LT( parm1, parm2 )

#define   Proloc_M_ReadPageInv_LT( adr, parm1, parm2 ) \
					RWDAdr = adr; proloc_ReadPageInv_LT( parm1, parm2 )

#define   Proloc_M_WritePage_LT( adr, parm1, parm2 ) \
					RWDAdr = adr; proloc_WritePage_LT( parm1, parm2 )

#define   Proloc_M_ReadPit_LT( adr, parm1 ) \
					RWDAdr = adr; proloc_ReadPit_LT( parm1 )

#define   Proloc_M_ReadPublicB_LT( adr, parm1 ) \
					RWDAdr = adr; proloc_ReadPublicB_LT( parm1 )

#define   Proloc_M_ReadControl_LT( adr, parm1 ) \
					RWDAdr = adr; proloc_ReadControl_LT( parm1 )

#define   Proloc_M_WriteControl_LT( adr, parm1 ) \
					RWDAdr = adr; proloc_WriteControl_LT( parm1 )

#define   Proloc_M_ReadSecret_LT( adr, parm1, parm2 ) \
					RWDAdr = adr; proloc_ReadSecret_LT( parm1, parm2 )

#define   Proloc_M_WriteSecret_LT( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_WriteSecret_LT( parm1, parm2, parm3 )

#define   Proloc_M_ReadPit( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_ReadPit( parm1, parm2, parm3 )

#define   Proloc_M_WritePit( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_WritePit( parm1, parm2, parm3 )

#define   Proloc_M_WritePitBlock( adr, parm1, parm2, parm3 ) \
					RWDAdr = adr; proloc_WritePitBlock( parm1, parm2, parm3 )

#define   Proloc_M_WritePitSecurity( adr, parm1 ) \
					RWDAdr = adr; proloc_WritePitSecurity( parm1 )

#define   Proloc_M_WritePitPassword( adr, parm1 ) \
					RWDAdr = adr; proloc_WritePitPassword( parm1 )

#define   Proloc_M_ReadAllPage( adr, parm1, parm2, parm3, parm4 ) \
					RWDAdr = adr; proloc_ReadAllPage( parm1, parm2, parm3, parm4 )

#define   Proloc_M_GetDspVersion( adr, parm1 ) \
					RWDAdr = adr; proloc_GetDspVersion( parm1 )


