//===========================================================================
//=                                                                         =
//=               PROLOC C-LIBRARY HEADERFILE "prolveg6.h"                  =
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
//CUST   VEGAS-functions.
//CUST   Include PROLIB6.H also since it includes all functions for
//CUST   operation with your read/write-devices (RWDs).
//CUST
//CUST   #include "prolib6.h"    /* general RWD & HITAG1-MIRO functions     */
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
//CUST   PROLVEG6.H contains:
//CUST
//CUST   o  The function library for VEGAS-functions.
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
//CUST   RWD:
//CUST         proloc_GetDspVersion
//CUST
//CUST   HITAG1:
//CUST         proloc_ReadAllPage
//CUST
//CUST ======================================================================


#define        GET_DSP_VERSION         'v'
#define        READ_ALL_PAGE           0x98


/*-RWD---------------------------function header----------------------------
*
*       proloc_GetDspVersion (char *data)
*                          This function reads the version of the DSP
*
* (OUT) char    *data      Carries the information of the DSP.
*                          data[0-15]
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: EOK(0), ESERIELL(-1)
*
*       for     example:
*            :
*      char   Dsp_Version[16];
*
*       proloc_GetDspVersion (Dsp_Version);
*       while( !RWDEot );
*       if ( RWDErr==EOK )
*       {
*          printf ("version:      %.16s\n", DspVersion);
*       }
*       else
*               :
---------------------------------------------------------------------------*/
void proloc_GetDspVersion(char *);




/*-HITAG1-------------------------function header----------------------------
*
*       proloc_ReadAllPage (BYTE_T mode, BYTE_T pagenr, char *data, WORD_T *data_len)
*                          reads one page from all HITAG1-transponders in
*                          the HF-field.
*                          You have to access 'plain'-pages in PLAIN mode,
*                          whereas 'crypto'-pages in CRYPTO mode.
*                          When command is finished RWDErr contains the last
*                          error-condition.
*
* (IN)  BYTE_T  mode       Bit0: 0=use KEY0 for Authentification
*                                1=use KEY1 for Authentification
*                          Bit1: 0=Plain (without Authentification)
*                                1=Crypto (with Authentification)
* (IN)  BYTE_T  pagenr     defines the page number for read access.
*                          The range is between page 0 and page 63.
*                          A page is 4 bytes.
* (OUT) char    *data      A pointer to an array which holds at the
*                          read TAG data (number of transponders * 4 Bytes).
*                          Caution: size of buffer must be dimensioned big
*                          enough by the user
* (OUT) WORD_T *data_len   Pointer to number of data bytes read from
*                          all transponders.
*
* (GLOBAL)      RWDEot     gets TRUE(1), when the command is complete.
*               RWDErr     possible errors: ESERIELL(-1), ENOTAG(-3),
*                          EAUTHENT(-7), EQUIT(-8), ECRYPTO(-9).
*
*       for     example:
*          :
*       BYTE_T         mode
*       BYTE_T         pagenr;
*       char           data[100];
*       WORD_T         data_len;
*          :
*       proloc_HFReset();
*				while (!RWDEot);
*       mode=0;
*       pagenr=32;
*				proloc_ReadAllPage (mode, pagenr, data, &data_len);
*				while (!RWDEot);
*           :
*   		printf("Number of transponders: %d",data_len/4);
*       if (data_len)
*       {
*         Output( data, RWDDataLen );
*       }
*         :
---------------------------------------------------------------------------*/
void proloc_ReadAllPage(BYTE_T, BYTE_T, char *, WORD_T *);


