/*****************************************************************************/
/****************** GLOBAL CONSTANTS *****************************************/
/*****************************************************************************/
 

int32 Masks[] = { 0x00, 0x00, 0x00,  0x0f, 0x1f, 0x3f, 0x7f, 
                  0xff, 0x1ff, 0x3ff, 0x3ff, 0xfff,0x1fff,0x3fff,
                  0x7fff,0xffff ,0x1ffff };

int32 masks[14] = { 0x00, 0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f, 0xff, 
                    0x1ff, 0x3ff, 0x7ff, 0xfff, 0x1fff};

unsigned long MASK[] = { 0x00, 0x01, 0x02, 0x04, 0x08,
                         0x10, 0x20, 0x40, 0x80};

int32 DataSize[] =  { 0x0, 0x0, 0x0, 0x0, 0x3, 0x4, 0x5, 0x6, 0x7,
                      0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf };

enum  ssp_prescale { SSP_PRE_1 = 0x02 , SSP_PRE_2 = 0x04 , SSP_PRE_3 = 0x06,
                     SSP_PRE_4 = 0x08 , SSP_PRE_5 = 0x0a , SSP_PRE_6 = 0x0c,
                     SSP_PRE_7 = 0x0e , SSP_PRE_8 = 0x10 , SSP_PRE_9 = 0x12,
                     SSP_PRE_A = 0x14 , SSP_PRE_B = 0x16 , SSP_PRE_C = 0x18,
                     SSP_PRE_D = 0x1a , SSP_PRE_E = 0x1c , SSP_PRE_F = 0x1e
                   } ;

enum ssptb_prescale  { PRE_1 = 0x01 , PRE_2, PRE_3, PRE_4, PRE_5, PRE_6,
                       PRE_7, PRE_8, PRE_9, PRE_A, PRE_B, PRE_C, PRE_D,
                       PRE_E, PRE_F };

static unsigned int ssptb_enable_value ;
static unsigned int ssp_enable_value_scr1 ;
static unsigned int TimeOut ;
static unsigned int RXW_Value ;
static unsigned int WordLength ;
