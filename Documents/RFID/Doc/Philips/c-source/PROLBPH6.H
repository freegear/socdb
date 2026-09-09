//===========================================================================
//=                                                                         =
//=               PROLOC C-LIBRARY HEADERFILE "prolbph6.h"                  =
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
//CUST   Include this headerfile in your sourcefile, if you want to use
//CUST   PITs (PHILIPS-TAGs).
//CUST   Include PROLIB6.H also since it includes all functions for
//CUST   operation with your read/write-devices (RWDs).
//CUST
//CUST   #include "prolib6.h"    /* general RWD & HITAG1&MIRO functions    */
//CUST   #include "prolbph6.h"   /* optional for PITs                      */
//CUST   #include "prolblt6.h"   /* optional for HITAG2                    */
//CUST   #include "prolbmu6.h"   /* optional for multiple RWD use on RS485 */
//CUST   #include "prolveg6.h"   /* optional for VEGAS-RWD                 */
//CUST
//CUST   (Add PROLIB6.LIB proloc-library to your project)
//CUST
//CUST   IMPORTANT: No proloc-function (except proloc_open) returns a value.
//CUST   ---------  Errormessages, the flag for the end of transmission of
//CUST              serial interface commands and length of replied data are
//CUST              reported in the global variables RWDErr, RWDEot and
//CUST              RWDDataLen. See PROLIB6.H (customer information).
//CUST              No proloc-function allocates memory, it is done by
//CUST              you before function calls.
//CUST
//CUST   PROLBPH6.H contains:
//CUST
//CUST   o  The function library for operation with PITs.
//CUST      Comments for function use and examples.
//CUST
//CUST   For a general overview see PROLIB6.H
//CUST
//CUST ----------------------------------------------------------------------




//CUST =================== FUNCTION-HEADER OVERVIEW =========================
//CUST
//CUST   Overview: The list of commented function prototypes in this file
//CUST   ---------                  (mark function name to search & find)
//CUST
//CUST   PIT:
//CUST         proloc_ReadPit
//CUST         proloc_WritePit
//CUST         proloc_WritePitBlock
//CUST
//CUST   RWD PERSONALIZATION:
//CUST         proloc_WritePitSecurity
//CUST         proloc_WritePitPassword
//CUST
//CUST ======================================================================





/*-PIT---------------------------function header----------------------------
*
*       proloc_ReadPit (BYTE_T blknmb, BYTE_T next, char *data)
*                          This function reads one or more blocks (of 16
*                          16 bytes) from a PIT.
*                          Different to the other proloc-functions this
*                          function continuously tries to read data from a
*                          PIT (even if no transponder is in rf field),
*                          until the reading is successful or it is
*                          interrupted by proloc_StopCommand.
*                    NOTE: When reading several blocks, do no other action
*                          between reading blocks, since new data is conse-
*                          cutively sent to the HOST (PC), even if old data
*                          hasn't been read!
*                          If a block is lost error EPIT (-14) arises.
*
* (IN)  BYTE_T   blknmb    defines the number of consecutive blocks to be read.
* (IN)  BYTE_T   next      On the first call of this function this para-
*                          meter have to be 0 to start reading. After the first
*                          received block of data this parameter have to be 1.
*                          (see example).
* (OUT) char    *data      Pointer to an array which holds the read data
*                          (16 Bytes).
*
* (GLOBAL)      RWDEot     gets TRUE(1), when a PIT is read.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1),
*                          EPIT(-14).
*               RWDDataLen 16 (bytes).
*
*       for     example:
*               :
*       BYTE_T       blknmb;
*       char         DataPtr[MAXTAGSIZE];
*               :
*       proloc_ReadPit (blknmb, 0, DataPtr);
*       do
*       {
*          while (!RWDEot)
*          {
*             if (kbhit () && getch ()==27)
*              {
*                proloc_StopCommand ();
*                while (!RWDEot);
*                return;
*             }
*          }
*          if (!RWDErr)
*          {
*             SaveData( DataPtr, Data );      // lost if it isn't read in time.
*             if (--blknmb && !RWDErr) proloc_ReadPit (0, 1, DataPtr);
*             else break;
*          }
*       } while (1);
*       if (!RWDErr)
*          Output( Data );
*       else
*          printf( "error : %02x",RWDErr );
*                :
---------------------------------------------------------------------------*/
void   proloc_ReadPit (BYTE_T, BYTE_T, char *);



/*-PIT---------------------------function header----------------------------
*
*       proloc_WritePit (BYTE_T byteaddr, BYTE_T bytenmb, char *data)
*                          This function writes a number of bytes to
*                          the PIT.
*                          Different to the other proloc-functions this
*                          function continuously tries to write data to a
*                          PIT (even if no transponder is in rf field),
*                          until the command is successful or it is
*                          interrupted by proloc_StopCommand.
*
* (IN)  BYTE_T  byteaddr   defines the byte-address (0 - 127) of the data
*                          to be written.
* (IN)  BYTE_T  bytenmb    number of bytes to write to the PIT. This
*                          can be a value between 1 and 16.
* (IN)  char    *data      Pointer to an array which holds the data to write
*                          (up to 16 Bytes).
*
* (GLOBAL)      RWDEot     gets TRUE(1), when a PIT is written.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*               :
*       BYTE_T        bytenmb;
*       char          DataPtr[MAXTAGSIZE];
*               :
*       strcpy (DataPtr, "Hello...");
*       proloc_WritePit (bytenmb, 8, DataPtr);
*       while (!RWDEot)
*       {
*          if ( kbhit() && getch() == 27 )
*          {
*             proloc_StopCommand ();
*             while (!RWDEot);
*             break;
*          }
*       }
*       if ( RWDErr!=EOK )
*          printf( "error : %02x",RWDErr );
*       else
*               :
---------------------------------------------------------------------------*/
void   proloc_WritePit (BYTE_T, BYTE_T, char *);



/*-PIT---------------------------function header----------------------------
*
*       proloc_WritePitBlock (BYTE_T blockaddr, BYTE_T bytenmb, char *data)
*                          This function writes bytes to a specific block
*                          on the PIT. There are 8 blocks (block = 16 bytes)
*                          which can be addressed.
*                          Different to the other proloc-functions this
*                          function continuously tries to write data to a
*                          PIT (even if no transponder is in rf field),
*                          until the command is successful or it is
*                          interrupted by proloc_StopCommand.
*
* (IN)  BYTE_T  blkaddr    block number for write access (0- 7).
* (IN)  BYTE_T  bytenmb    number of bytes, which should be written,
*                          starting at the first byte of the block. This
*                          can be a value between 1 and 16.
* (IN)  char    *data      A pointer to an array which holds the data to
*                          write (1 - 16 Bytes).
*
* (GLOBAL)      RWDEot     gets TRUE(1), when a PIT is written.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*               :
*       BYTE_T        blkaddr = 2;
*       char          DataPtr[MAXTAGSIZE];
*               :
*       strcpy (DataPtr, "This is a block.");
*       proloc_WritePitBlock (blkaddr, 16, DataPtr);
*       while (!RWDEot)
*       {
*          if ( kbhit() && getch() == 27 )
*          {
*             proloc_StopCommand ();
*             while (!RWDEot);
*             break;
*          }
*       }
*       if ( RWDErr!=EOK )
*          printf( "error : %02x",RWDErr );
*       else
*               :
---------------------------------------------------------------------------*/
void  proloc_WritePitBlock (BYTE_T, BYTE_T, char *);



/*-PIT---------------------------function header----------------------------
*
*       proloc_WritePitSecurity (BYTE_T mode)
*                          switches the Password-mode for PITs on or off.
*                          This is done in KeyInitMode.
*
* (IN)  BYTE_T  mode       password mode: OFF .. 0
*                                         ON ... 1
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*               :
*       DWORD_T         password;
*               :
*       proloc_KeyInitMode (password);   // Start KeyInitMode
*       while( !RWDEot );
*       if ( RWDErr == EOK )
*       {
*          proloc_SetBCCMode (INIT_BCC); // BCC-calculation for KeyInitMode
*          proloc_WritePitSecurity (ON);
*          while( !RWDEot );
*          if ( RWDErr!=EOK )
*             printf( "error : %02x",RWDErr );
*          else
*               :
*       }
*       else
*               :
---------------------------------------------------------------------------*/
void  proloc_WritePitSecurity (BYTE_T);



/*-PIT---------------------------function header----------------------------
*
*       proloc_WritePitPassword (char *data)
*                          sets the password in the RWD for the password-mode.
*                          This is done in KeyInitMode.
*
* (IN)  char    *data      datastring for password, 7 bytes long;
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       example:
*
*       char            data[7];
*       DWORD_T         password;
*               :
*       proloc_KeyInitMode (password);   // Start KeyInitMode
*       while( !RWDEot );
*       if ( RWDErr == EOK )
*       {
*          proloc_SetBCCMode (INIT_BCC); // BCC-calculation for KeyInitMode
*          data = "funnyPW";
*          proloc_WritePitPassword (data);
*          while( !RWDEot );
*          if ( RWDErr!=EOK )
*             printf( "error : %02x",RWDErr );
*          else
*               :
*       }
*               :
---------------------------------------------------------------------------*/
void  proloc_WritePitPassword (char *);





