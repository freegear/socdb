//===========================================================================
//=                                                                         =
//=               PROLOC C-LIBRARY HEADERFILE "prolblt6.h"                  =
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
//CUST   HITAG2-products.
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
//CUST   PROLBLT6.H contains:
//CUST
//CUST   o  The function library for operation with HITAG2.
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
//CUST   HITAG2:
//CUST         proloc_GetSnr_LT
//CUST         proloc_GetSnrReset_LT
//CUST         proloc_HaltSelected_LT
//CUST         proloc_ReadPage_LT
//CUST         proloc_ReadPageInv_LT
//CUST         proloc_WritePage_LT
//CUST         proloc_ReadPit_LT
//CUST         proloc_ReadPublicB_LT
//CUST
//CUST   RWD:
//CUST         proloc_SetBCDOffset
//CUST
//CUST   RWD PERSONALIZATION FOR HITAG2:
//CUST         proloc_ReadControl_LT
//CUST         proloc_WriteControl_LT
//CUST         proloc_ReadSecret_LT
//CUST         proloc_WriteSecret_LT
//CUST
//CUST ======================================================================




/*-HITAG2-------------------------function header----------------------------
*
*       proloc_GetSnr_LT (BYTE_T mode, DWORD_T *snr, BYTE_T *config)
*                          reads the serial number and the configuration byte
*                          of the selected HITAG2. Selection is the
*                          main task of this function, which means that the
*                          TAG is set to a mode for subsequent read/write
*                          commands.
*
* (IN)  BYTE_T  mode       Sets the security-mode
*                          You can choose between
*                             PASSWORD ... (0)
*                             CRYPTO ..... (1)
* (OUT) DWORD_T *snr       Pointer to serial number of the TAG.
* (OUT) BYTE_T  *config    Pointer to the TAG's configuration byte.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3)
*                          EPWDRWD(-5), EPWDTAG(-6).
*       for     example:
*               :
*       DWORD_T         Identifier;
*       BYTE_T          config;
*               :
*       proloc_GetSnr_LT (CRYPTO, &Identifier, &config);
*       while (!RWDEot);
*       if (RWDErr==EOK)
*          printf ("ID : %08lx   Config: %02x", Identifier, config);
*       else
*              :
---------------------------------------------------------------------------*/
void proloc_GetSnr_LT (BYTE_T, DWORD_T *, BYTE_T *);




/*-HITAG2-------------------------function header----------------------------
*
*       proloc_GetSnrReset_LT (BYTE_T mode, DWORD_T *snr, BYTE_T *config)
*                          reads the serial number and the configuration byte
*                          of a selected HITAG2 in read-only mode.
*                    NOTE: You are not able to select a HITAG2, which is in
*                    ===== read-only mode, with the command
*                          proloc_GetSnr_LT!
*                          Selection is the main task of this function,
*                          which means that the TAG is set to a mode
*                          for subsequent read/write commands.
*
* (IN)  BYTE_T  mode       Sets the security-mode.
*                          You can choose between
*                             PASSWORD ... (0)
*                             CRYPTO(1) .. (1)
* (OUT) DWORD_T *snr       Pointer to serial number of the TAG.
* (OUT) BYTE_T  *config    Pointer to the TAG's configuration byte.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3)
*                          EPWDRWD(-5), EPWDTAG(-6).
*       for     example:
*               :
*       DWORD_T         Identifier;
*       BYTE_T          config;
*               :
*       proloc_GetSnrReset_LT (CRYPTO, &Identifier, &config);
*       while (!RWDEot);                  // Select a HITAG2 in read-only mode
*       if (RWDErr==EOK)
*          printf ("ID : %08lx   Config: %02x", Identifier, config);
*       else
*              :
---------------------------------------------------------------------------*/
void    proloc_GetSnrReset_LT (BYTE_T ,DWORD_T *, BYTE_T *);



/*-HITAG2-------------------------function header----------------------------
*
*       proloc_HaltSelected_LT ( void )
*                          sets the selected HITAG2 into HALT-Mode.
*                          Thus the TAG doesn't answer to any commands until
*                          a proloc_HFReset is made or the TAG is put out
*                          of rf-field.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*                          EQUIT(-8).
*       for     example:
*               :
*       DWORD_T         Identifier;
*       BYTE_T          TAG_mode;
*       BYTE_T          config;
*       char            DataPtr[4];
*               :
*       proloc_GetSnr_LT (TAG_mode, &Identifier, &config);
*       while (!RWDEot);
*       if (!RWDErr)
*       {
*                :
*          proloc_ReadPage_LT( 5, DataPtr );  //Read page 5
*          while(!RWDEot);
*          if ( RWDErr == EOK )
*            printf( "data : %s", DataPtr );
*                :
*                :
*          proloc_HaltSelected_LT ();
*          while (!RWDEot);
*             if (!RWDErr)
*             {
*                printf ("TAG halted.....");
*             }
*             else
*                :
*       }
*       else
*          :
---------------------------------------------------------------------------*/
void    proloc_HaltSelected_LT ( void );



/*-HITAG2----------------------function header-------------------------------
*
*       proloc_ReadPage_LT (BYTE_T pagenr, char *data)
*                          reads one page (4 bytes) from the actually selected
*                          HITAG2.
*
* (IN)  BYTE_T  pagenr     Defines the page-number which shall be read.
*                          The range is from page 0 to 7.
* (OUT) char    *data      A pointer to an array which holds the read
*                          data (4 Bytes).
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3)
*               RWDDataLen 4 (bytes).
*
*       for     example:
*               :
*       DWORD_T         Identifier;
*       BYTE_T          TAG_mode;
*       BYTE_T          config;
*       char            DataPtr[4];
*               :
*       proloc_GetSnr_LT (TAG_mode, &Identifier, &config);
*       while (!RWDEot);
*       if (!RWDErr)
*       {
*               :
*         proloc_ReadPage_LT( 5, DataPtr );  //Read page 5
*         while(!RWDEot);
*         if ( RWDErr == EOK )
*           printf( "data : %s", DataPtr );
*         else
*               :
---------------------------------------------------------------------------*/
void    proloc_ReadPage_LT (BYTE_T, char *);



/*-HITAG2------------------------function header-----------------------------
*
*       proloc_ReadPageInv_LT (BYTE_T pagenr, char *data)
*                          reads the bit-inverted content of one page (4 bytes)
*                          from the actually selected HITAG2.
*                          This function is used together with
*                          proloc_ReadPage_LT for highest data security.
*
* (IN)  BYTE_T  pagenr     Defines the page-number which shall be read.
*                          The range is from page 0 to 7.
* (OUT) char    *data      A pointer to an array which holds the read
*                          data (4 Bytes).
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3)
*               RWDDataLen 4 (bytes).
*
*       for     example:
*               :
*       DWORD_T         Identifier;
*       BYTE_T          TAG_mode;
*       BYTE_T          config;
*       char            DataPtr[4];
*               :
*       proloc_GetSnr_LT (TAG_mode, &Identifier, &config);
*       while (!RWDEot);
*       if (!RWDErr)
*       {
*                :
*          proloc_ReadPageInv_LT( 5, DataPtr );  //Read page 5
*          while(!RWDEot);
*          if ( RWDErr == EOK )
*            printf( "Bit-inverse data : %s", DataPtr );
*          else
*            printf( "error : %02x",RWDErr );
*                :
---------------------------------------------------------------------------*/
void    proloc_ReadPageInv_LT (BYTE_T , char *);



/*-HITAG2------------------------function header------------------------------
*
*       proloc_WritePage_LT (BYTE_T pagenr, char *data)
*                          writes one page (4 byte) to the selected
*                          HITAG2.
*                          ATTENTION: To check if WritePage_LT was successful
*                          it is important that the directly next command
*                          ReadPage_LT returns "no error" and the right data.
*                          Otherwise you have to repeat WritePage_LT.
*
* (IN)  BYTE_T  pagenr     Defines page-number for write-access.
*                          The range is from page 0 to 7.
* (IN)  char    *data      A pointer to an array which holds the
*                          data (4 Bytes) to write.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1), ENOTAG(-3)
*                          ETIMEOUT(-4).
*
*       for     example:
*               :
*       DWORD_T         Identifier;
*       BYTE_T          TAG_mode;
*       BYTE_T          config;
*       char            DataPtr[4];
*               :
*       proloc_GetSnr_LT (TAG_mode, &Identifier, &config);
*       while (!RWDEot);
*       if (!RWDErr)
*       {
*         proloc_WritePage_LT (pagenr, DataPtr);
*         while( !RWDEot );
*         if ( RWDErr!=EOK )
*            printf( "error : %02x",RWDErr );
*         else
*            :
---------------------------------------------------------------------------*/
void    proloc_WritePage_LT (BYTE_T , char *);



/*-HITAG2------------------------function header----------------------------
*
*       proloc_ReadPit_LT (char *data)
*                          reads a block (16 bytes) of the HITAG2
*                          which is in PIT(Philips)- mode.
*                          Different to the other proloc-functions this
*                          function continuously tries to read data of a
*                          TAG (even if no transponder is in rf field),
*                          until the reading is successful or it is
*                          interrupted by calling proloc_StopCommand.
*
* (OUT) char    *data      A pointer to an array which holds the read data
*                          (16 Bytes).
*
* (GLOBAL)      RWDEot     gets TRUE(1), when a HITAG2(PIT-mode) is read.
*               RWDErr     possible errors: EOK(0)
*               RWDDataLen 16 (bytes).
*
*      for     example:
*               :
*      char          DataPtr[16];
*               :
*      proloc_ReadPit (&DataPtr);
*      while (!RWDEot)
*      {
*        if (kbhit () && getch ()==27)
*        {
*           proloc_StopCommand ();
*           while (!RWDEot);
*           break;
*        }
*     }
*     if (!RWDErr)
*     {
*        Output_Data ();
*     }
*        :
---------------------------------------------------------------------------*/
void    proloc_ReadPit_LT (char *);



/*-HITAG2-------------------------function header----------------------------
*
*       proloc_ReadPublicB_LT (char *data)
*                          reads a block (16 bytes) from the a HITAG2-
*                          transponder in PublicB-mode (4kBaud).
*                          The data represent an 128-bit-stream and have to
*                          be prepared afterwards for subsequent treatment.
*                          Different to the other proloc-functions this
*                          function continuously tries to read data of a
*                          TAG (even if no transponder is in rf field),
*                          until the reading is successful or it is
*                          interrupted by calling proloc_StopCommand.
*
* (OUT)  char  *data       datastring, 16 bytes long
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*               RWDDataLen 16 (bytes).
*
*      for     example:
*               :
*      char          DataPtr[16];
*               :
*      proloc_ReadPublicB_LT (&DataPtr);
*      while (!RWDEot)
*      {
*        if (kbhit () && getch ()==27)
*        {
*           proloc_StopCommand ();
*           while (!RWDEot);
*           break;
*        }
*     }
*     if (!RWDErr)
*     {
*        Output_Data ();
*     }
*        :
---------------------------------------------------------------------------*/
void	proloc_ReadPublicB_LT (char *);



/*-RWD---------------------------function header----------------------------
*
*       proloc_SetBCDOffset (BYTE_T bcd_offset)
*                          adjusts the offset of the BCD-value for HITAG2-
*                          transponders.
*
* (IN)  BYTE_T  bcd_offset  Offset for bitclockdata.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)

*       for     example:
*
*       proloc_SetBCDOffset (0x05);
*       while( !RWDEot );
*       if ( RWDErr!=EOK )
*          printf( "error : %02x",RWDErr );
*       else
*               :
---------------------------------------------------------------------------*/
void   proloc_SetBCDOffset (BYTE_T);



/*-HITAG2 RWD PERS---------------function header----------------------------
*
*       proloc_ReadControl_LT (BYTE_T *data)
*                          This function reads the control byte CONTROL_LT
*                          from the EEPROM of the reader.
*                          RWD has to be in KeyInit Mode.
*
* (OUT) BYTE_T  *data      A pointer to a byte which holds the data.
*                             data ... Control_LT
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*               RWDDataLen 1 (byte)
*
*       for     example:
*            :
*       DWORD_T       password;
*       BYTE_T        control;
*
*       proloc_KeyInitMode (password);
*       while( !RWDEot );
*       if ( RWDErr == EOK )
*       {
*          proloc_ReadControl (&control);
*          while( !RWDEot );
*          if ( RWDErr != EOK )
*             printf ("error: %d", RWDErr);
*          else
*            :
*       }
*            :
---------------------------------------------------------------------------*/
void      proloc_ReadControl_LT (BYTE_T *);



/*-HITAG2 RWD PERS---------------function header----------------------------
*
*       proloc_WriteControl_LT (BYTE_T control_lt)
*                          This function writes the control byte CONTROL_LT
*                          into the EEPROM of the reader.
*                          RWD has to be in KeyInit Mode.
*                    NOTE: BE VERY CAREFUL WHEN WRITING THIS BYTE, since
*                    ===== one time you changed a bit to 0, you never can
*                          change it back to 1.
*
* (IN)  BYTE_T  control_lt New value for CONTROL_LT.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*            :
*       DWORD_T       password;
*       BYTE_T        control_lt;
*            :
*       proloc_KeyInitMode (password);
*       while( !RWDEot );
*       if ( RWDErr == EOK )
*       {
*          proloc_WriteControl (control_lt);
*          while( !RWDEot );
*          if ( RWDErr!=EOK )
*             printf ("error: %d", RWDErr);
*          else
*            :
*       }
*            :
---------------------------------------------------------------------------*/
void proloc_WriteControl_LT (BYTE_T);



/*-HITAG2 RWD PERS---------------function header----------------------------
*
*       proloc_ReadSecret_LT (BYTE_T num, DWORD_T *data)
*                          reads a package of 4 databytes from the EEPROM
*                          of the RWD to get personalization data (key,
*                          password).
*                          RWD has to be in KeyInit Mode.
*
* (IN)  BYTE_T  num        num defines the page to write:
*                             KEY_LOW ........ (0)
*                             KEY_HIGH ....... (1)
*                             PASSWORD_TAG ... (2)
*                             PASSWORD_RWD ... (3)
* (OUT) DWORD_T *data      replied datastring, 4 bytes long.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1),
*                          EERDPROT(-13).
*               RWDDataLen 4 (bytes).
*
*       for     example:
*               :
*       DWORD_T         password;
*       DWORD_T         DataPtr;
*               :
*       proloc_KeyInitMode (password);
*       while( !RWDEot );
*       if ( RWDErr == EOK )
*       {
*          proloc_ReadSecret_LT ( PASSWORD_TAG, &DataPtr);
*          while( !RWDEot );
*          if ( RWDErr!=EOK )
*             printf( "error : %02x",RWDErr );
*          else
*            :
*        }
*            :
---------------------------------------------------------------------------*/
void proloc_ReadSecret_LT (BYTE_T, DWORD_T *);



/*-HITAG2 RWD PERS----------------function header----------------------------
*
*       proloc_WriteSecret_LT (BYTE_T num, DWORD_T od, DWORD_T nd)
*                          writes a package of 4 databytes to the EEPROM
*                          of the RWD to change personalization data (key,
*                          password). You have to send the old data
*                          with the new, to prevent accidential overwriting.
*                          RWD has to be in KeyInit Mode.
*                    NOTE: DO NOT CHANGE THIS DATA CARELESSLY, since you
*                          may loose access to personalization data!
*
* (IN)  BYTE_T  num        num defines the page to write:
*                             KEY_LOW ........ (0)
*                             KEY_HIGH ....... (1)
*                             PASSWORD_TAG ... (2)
*                             PASSWORD_RWD ... (3)
* (IN)  DWORD_T od         old data, 4 bytes long.
* (IN)  DWORD_T nd         new data, 4 bytes long.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1),
*                          EEWRPROT(-12), EEWRONGOLD(-11).
*
*       for     example:
*               :
*       DWORD_T         password;
*       DWORD_T         Data_old_low;
*       DWORD_T         Data_new_low;
*       DWORD_T         Data_old_high;
*       DWORD_T         Data_new_high;
*               :
*       proloc_KeyInitMode (password);
*       while( !RWDEot );
*       if ( RWDErr == EOK )
*       {
*          proloc_WriteSecret_LT (KEY_LOW, Data_old_low, Data_new_low);
*          while( !RWDEot );
*          if ( RWDErr!=EOK )
*          {
*             printf( "error : %02x",RWDErr );
*              :
*          }
*          else
*          {
*            proloc_WriteSecret_LT (KEY_HIGH, Data_old_high, Data_new_high);
*            while( !RWDEot );
*              :
*          }
*       }
*             :
---------------------------------------------------------------------------*/
void proloc_WriteSecret_LT (BYTE_T, DWORD_T, DWORD_T );



