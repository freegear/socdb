#ifndef __disk_h__
#define __disk_h__
/*******************************************************************************
** File          : $HeadURL$ 
** Author        : $Author$
** Project       : HSCTRL 
** Instances     : 
** Creation date : 
********************************************************************************
********************************************************************************
** ChipIdea Microelectronica - IPCS
** TECMAIA, Rua Eng. Frederico Ulrich, n 2650
** 4470-920 MOREIRA MAIA
** Portugal
** Tel: +351 229471010
** Fax: +351 229471011
** e_mail: chipidea.com
********************************************************************************
** ISO 9001:2000 - Certified Company
** (C) 2005 Copyright Chipidea(R)
** Chipidea(R) - Microelectronica, S.A. reserves the right to make changes to
** the information contained herein without notice. No liability shall be
** incurred as a result of its use or application.
********************************************************************************
** Modification history:
** $Date$
** $Revision$
*******************************************************************************
*** Description:      
***  This file contains the USB Disk example application specific defines.
***                                                               
**************************************************************************
**END*********************************************************/

#define  USB_DCBWSIGNATURE       (0x43425355)
#define  USB_DCSWSIGNATURE       (0x53425355)
#define  USB_CBW_DIRECTION_BIT   (0x80)

/* USB 1.1 Setup Packet */
typedef struct setup_struct {
   smtUint8      REQUESTTYPE;
   smtUint8      REQUEST;
   smtUint16     VALUE;
   smtUint16     INDEX;
   smtUint16     LENGTH;
} SETUP_STRUCT, *SETUP_STRUCT_PTR;

/* USB Command Block Wrapper */
//typedef USB_Uncached struct cbw_struct {
typedef struct cbw_struct {
   smtUint32  DCBWSIGNATURE;
   smtUint32  DCBWTAG;
   smtUint32  DCBWDATALENGTH;
   smtUint8    BMCBWFLAGS;
   /* 4 MSBs bits reserved */
   smtUint8    BCBWCBLUN;
   /* 3 MSB reserved */
   smtUint8    BCBWCBLENGTH;
   smtUint8    CBWCB[16];
} CBW_STRUCT, *CBW_STRUCT_PTR;

/* USB Command Status Wrapper */
typedef volatile struct csw_struct {
   smtUint32  DCSWSIGNATURE;
   smtUint32  DCSWTAG;
   smtUint32  DCSWDATARESIDUE;
   smtUint8    BCSWSTATUS;
} CSW_STRUCT, *CSW_STRUCT_PTR;

/* USB Mass storage Request Sense Command */
typedef struct mass_storage_request_sense {
   smtUint8    OPCODE;
   smtUint8    LUN;
   smtUint8    RESERVED2;
   smtUint8    RESERVED3;
   smtUint8    ALLOCATION_LENGTH;
   smtUint8    RESERVED4[7];
} MASS_STORAGE_REQUEST_SENSE_STRUCT, *MASS_STORAGE_REQUEST_SENSE_PTR;


/* USB Mass storage Inquiry Command */
typedef struct mass_storage_inquiry {
   smtUint8    OPCODE;
   smtUint8    LUN;
   smtUint8    PAGE_CODE;
   smtUint8    RESERVED1;
   smtUint8    ALLOCATION_LENGTH;
   smtUint8    RESERVED2[7];
} MASS_STORAGE_INQUIRY_STRUCT, *MASS_STORAGE_INQUIRY_PTR;


typedef struct mass_storage_request_sense_data {
   smtUint8    ERROR;
   smtUint8    RESERVED1;
   smtUint8    SENSEKEY;
   smtUint8    INFO[4];
   smtUint8    ASL;
   smtUint8    RESERVED2[4];
   smtUint8    ASC;
   smtUint8    ASCQ;
   smtUint8    RESERVED3[4];
} MASS_STORAGE_REQUEST_SENSE_DATA_STRUCT, *MASS_STORAGE_REQUEST_SENSE_DATA_STRUCT_PTR;
   
   
/* USB Mass storage READ CAPACITY Data */
typedef struct mass_storage_read_capacity {
   smtUint8    LAST_LOGICAL_BLOCK_ADDRESS[4];
   smtUint8    BLOCK_LENGTH_IN_BYTES[4];
} MASS_STORAGE_READ_CAPACITY_STRUCT, *MASS_STORAGE_READ_CAPACITY_STRUCT_PTR;

/* USB Mass storage Device information */
typedef struct mass_storage_device_info {
   smtUint8    PERIPHERAL_DEVICE_TYPE;    /* Bits 0-4. All other bits reserved */
   smtUint8    RMB;                       /* Bit 7. All other bits reserved */
   smtUint8    ANSI_ECMA_ISO_VERSION;     /* ANSI: bits 0-2, ECMA: bits 3-5, 
                                       ** ISO: bits 6-7 
                                       */
   smtUint8    RESPONSE_DATA_FORMAT;      /* bits 0-3. All other bits reserved */
   smtUint8    ADDITIONAL_LENGTH;         /* For UFI device: always set to 0x1F */
   smtUint8    RESERVED1[3];
   smtUint8    VENDOR_INFORMATION[8];
   smtUint8    PRODUCT_ID[16];
   smtUint8    PRODUCT_REVISION_LEVEL[4];
} MASS_STORAGE_DEVICE_INFO_STRUCT, *MASS_STORAGE_DEVICE_INFO_PTR;

#define USB_MIN(a,b)              ((a) < (b) ? (a) : (b))      

#define BUFFERSIZE            (2048)

#define EP_TEMP_BUFFERSIZE	  (32)
#define MASS_STORAGE_INTERFACE (0)

#endif
/* EOF */