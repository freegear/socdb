#include <stdio.h>
#include <stdlib.h> /* for exit */
#include <string.h>
#include <assert.h>

//#define SIMPLE_4xSAMPLE
#define FILTER_ENABLE
//#define GAMMA_ENABLE

//#define RTL_DEBUG
//#include "sine_table.c"
#include "sine_table2.c"

#ifdef GAMMA_ENABLE
#include "GCT.c"
#endif

#define VIDEO_NTSC  0
#define VIDEO_NTSCJ 001
#define VIDEO_NTSC4 010
#define VIDEO_PAL   011
#define VIDEO_PALNc 100
#define VIDEO_PALN  101
#define VIDEO_MPAL  110

#define INPUT_RGB   0
#define INPUT_Ycbcr 1

#define ENABLE      1
#define DISABLE     0

#define START_BURST_UP 2
#define START_BURST_DOWN 3

#define TYPE_UP     0
#define TYPE_DOWN   1

#define SUBGEN_ADDR_STEP_NTSC 0x21F07C1F
#define SUBGEN_ADDR_STEP_PAL  0x2A098ACB

#define PHASE_180             0x80000000
#define PHASE_0               0x00000000
#define PHASE_135             0x60000000
#define PHASE_225             0xA0000000  
#define PHASE_1               0x00B60B60  

#define LOW_LEVEL   0
#define HIGH_LEVEL  1

#define HSYNC_LOW_NTSC   16
#define HSYNC_LOW_PAL    16

#define YSCALE_NTSC     605 
#define USCALE_NTSC     516
#define VSCALE_NTSC     718

#define YSCALE_NTSCJ    654 
#define USCALE_NTSCJ    558
#define VSCALE_NTSCJ    787

#define YSCALE_PAL     640 
#define USCALE_PAL     546
#define VSCALE_PAL     770

#define scale_bit_resolution 8
#define scale_round 128

#define BLANK_VALUE_NTSC    240
#define BLANK_VALUE_PAL     252

#define BLANK_VALUE_C       512

#define BLACK_VALUE_NTSC    282
#define BLACK_VALUE_PAL     252  
//WorkBook 4.Timingcounterblock.4.i
#define TOTAL_PIXEL_NTSC        1716
#define TOTAL_PIXEL_PAL         1728
#define TOTAL_PIXEL_SQ_NTSC     1560
#define TOTAL_PIXEL_SQ_PAL      1888

#define TOTAL_LINE_NTSC         525
#define TOTAL_LINE_PAL          625
#define TOTAL_DISPLAY_LINE_NTSC 480
#define TOTAL_DISPLAY_LINE_PAL  576

#define TOTAL_LINE_NTSC_NOINTER         262
#define TOTAL_LINE_PAL_NOINTER          312
#define TOTAL_DISPLAY_LINE_NTSC_NOINTER 240
#define TOTAL_DISPLAY_LINE_PAL_NOINTER  288

#define CHANGE_FIELDS0_NTSC     525
#define CHANGE_FIELDS1_NTSC     263

#define CHANGE_FIELDS0_NTSC_NOINTER     252

#define CHANGE_FIELDS0_PAL      625     
#define CHANGE_FIELDS1_PAL      313

#define CHANGE_FIELDS0_PAL_NOINTER      312     

#define ACTIVE_TOTAL_PIXEL_NTSC     1440 /* Active 720 Lines */
#define ACTIVE_TOTAL_PIXEL_PAL      1440 /* Active 720 Lines */
#define ACTIVE_TOTAL_PIXEL_SQ_NTSC  1280 /* Active 640 Lines */
#define ACTIVE_TOTAL_PIXEL_SQ_PAL   1536 /* Active 768 Lines */

#define ACTIVE_TOTAL_PIXEL_NTSC_RGB     2160 /* Active 720 Lines */
#define ACTIVE_TOTAL_PIXEL_PAL_RGB      2160 /* Active 720 Lines */
#define ACTIVE_TOTAL_PIXEL_SQ_NTSC_RGB  1920 /* Active 640 Lines */
#define ACTIVE_TOTAL_PIXEL_SQ_PAL_RGB   2304 /* Active 768 Lines */

#define BURST_MAX_NTSC          112
#define BURST_MAX_PAL           117

#define HSYNC_START_NTSC        16*2    
#define HSYNC_WIDTH_NTSC        125    
#define BURST_START_NTSC        170
#define BURST_WIDTH_NTSC        66
#define COLOR_START_NTSC        276        
#define HSYNC_SLOPE_NTSC        4
#define BURST_SLOPE_NTSC        8

#define HSYNC_START_SQ_NTSC     22*2    
#define HSYNC_WIDTH_SQ_NTSC     121    
#define BURST_START_SQ_NTSC     168
#define BURST_WIDTH_SQ_NTSC     66
#define COLOR_START_SQ_NTSC     280        
#define HSYNC_SLOPE_SQ_NTSC     4
#define BLANK_VALUE_7_5         42

#define HSYNC_START_PAL         12*2
#define HSYNC_WIDTH_PAL         133
#define BURST_START_PAL         170
#define BURST_WIDTH_PAL         66
#define COLOR_START_PAL         288
#define HSYNC_SLOPE_PAL         7
#define BURST_SLOPE_PAL         8

#define HSYNC_START_SQ_PAL      21*2
#define HSYNC_WIDTH_SQ_PAL      144
#define BURST_START_SQ_PAL      202
#define BURST_WIDTH_SQ_PAL      72
#define COLOR_START_SQ_PAL      352
#define HSYNC_SLOPE_SQ_PAL      7
#define BURST_SLOPE_SQ_PAL      8
#define BLANK_VALUE_0           0

/* Equalizing area 0~3 */
#define EQUALIZING_AREA0_START_NTSC     523
#define EQUALIZING_AREA0_END_NTSC       525
#define EQUALIZING_AREA1_START_NTSC     4
#define EQUALIZING_AREA1_END_NTSC       6
#define EQUALIZING_AREA2_START_NTSC     261
#define EQUALIZING_AREA2_END_NTSC       262
#define EQUALIZING_AREA3_START_NTSC     267
#define EQUALIZING_AREA3_END_NTSC       268

#define EQUALIZING_AREA0_START_NTSC_NOINTER     260
#define EQUALIZING_AREA0_END_NTSC_NOINTER       262
#define EQUALIZING_AREA1_START_NTSC_NOINTER     4
#define EQUALIZING_AREA1_END_NTSC_NOINTER       6

#define EQUALIZING_AREA0_START_PAL      624      
#define EQUALIZING_AREA0_END_PAL        625 
#define EQUALIZING_AREA1_START_PAL      4
#define EQUALIZING_AREA1_END_PAL        5
#define EQUALIZING_AREA2_START_PAL      311
#define EQUALIZING_AREA2_END_PAL        312
#define EQUALIZING_AREA3_START_PAL      316
#define EQUALIZING_AREA3_END_PAL        317

#define EQUALIZING_AREA0_START_PAL_NOINTER      311      
#define EQUALIZING_AREA0_END_PAL_NOINTER        312 
#define EQUALIZING_AREA1_START_PAL_NOINTER      4
#define EQUALIZING_AREA1_END_PAL_NOINTER        5

#define EQUALIZING_AREA0_START_MPAL     523
#define EQUALIZING_AREA0_END_MPAL       525
#define EQUALIZING_AREA1_START_MPAL     4
#define EQUALIZING_AREA1_END_MPAL       6
#define EQUALIZING_AREA2_START_MPAL     261
#define EQUALIZING_AREA2_END_MPAL       262
#define EQUALIZING_AREA3_START_MPAL     267
#define EQUALIZING_AREA3_END_MPAL       268


/* Serration area 0~1 */
#define SERRATION_AREA0_START_NTSC      1
#define SERRATION_AREA0_END_NTSC        3
#define SERRATION_AREA1_START_NTSC      264
#define SERRATION_AREA1_END_NTSC        265

#define SERRATION_AREA0_START_NTSC_NOINTER      1
#define SERRATION_AREA0_END_NTSC_NOINTER        3

#define SERRATION_AREA0_START_PAL       1
#define SERRATION_AREA0_END_PAL         2
#define SERRATION_AREA1_START_PAL       314 
#define SERRATION_AREA1_END_PAL         315

#define SERRATION_AREA0_START_PAL_NOINTER       1
#define SERRATION_AREA0_END_PAL_NOINTER         2

#define SERRATION_AREA0_START_MPAL      1
#define SERRATION_AREA0_END_MPAL        3
#define SERRATION_AREA1_START_MPAL      264 
#define SERRATION_AREA1_END_MPAL        265


/* Serration and Equalizing area 0  include active video*/
#define SERREQ_AREA0_NTSC               260
#define SERREQ_AREA0_PAL                623

#define SERREQ_AREA0_MPAL               260

/* Serration and Equalizing area 1 non-active video*/
#define SERREQ_AREA1_NTSC               266
#define SERREQ_AREA1_PAL                3

#define SERREQ_AREA1_NTSC               266

#define SERREQ_AREA1_PAL_NOINTER        3

#define SERREQ_AREA1_MPAL               266

/* Equalizing and Serration area */
#define EQSERR_AREA0_NTSC               263
#define EQSERR_AREA0_PAL                313

#define EQSERR_AREA0_MPAL               263

/* Equalizing and blank area */
#define EQBLANK_AREA0_NTSC              269
#define EQBLANK_AREA0_PAL               318

#define EQBLANK_AREA0_MPAL              269

#define TOTAL_FIELDS_NTSC  1;//4*??;
#define TOTAL_FIELDS_PAL   1;//8*??;

    
/* burst disable area field 1 ~ field 8 */
#define BURST_AREA1_START_NTSC      1
#define BURST_AREA1_END_NTSC        6
#define BURST_AREA2_START_NTSC      261
#define BURST_AREA2_END_NTSC        269
#define BURST_AREA3_START_NTSC      523
#define BURST_AREA3_END_NTSC        525

#define BURST_AREA1_START_NTSC_NOINTER      1
#define BURST_AREA1_END_NTSC_NOINTER        6
#define BURST_AREA2_START_NTSC_NOINTER      260
#define BURST_AREA2_END_NTSC_NOINTER        262

#define BURST_AREA1_START_PAL0      1
#define BURST_AREA1_END_PAL0        6
#define BURST_AREA2_START_PAL0      310
#define BURST_AREA2_END_PAL0        318
#define BURST_AREA3_START_PAL0      623
#define BURST_AREA3_END_PAL0        625 

#define BURST_AREA1_START_PAL1      1
#define BURST_AREA1_END_PAL1        5
#define BURST_AREA2_START_PAL1      311
#define BURST_AREA2_END_PAL1        319
#define BURST_AREA3_START_PAL1      622
#define BURST_AREA3_END_PAL1        625 

#define BURST_AREA1_START_PAL0_NOINTER      1
#define BURST_AREA1_END_PAL0_NOINTER        6
#define BURST_AREA2_START_PAL0_NOINTER      311
#define BURST_AREA2_END_PAL0_NOINTER        312

#define BURST_AREA1_START_MPAL0      1
#define BURST_AREA1_END_MPAL0        8
#define BURST_AREA2_START_MPAL0      260
#define BURST_AREA2_END_MPAL0        270
#define BURST_AREA3_START_MPAL0      523
#define BURST_AREA3_END_MPAL0        525 

#define BURST_AREA1_START_MPAL1      1
#define BURST_AREA1_END_MPAL1        7
#define BURST_AREA2_START_MPAL1      259
#define BURST_AREA2_END_MPAL1        269
#define BURST_AREA3_START_MPAL1      522
#define BURST_AREA3_END_MPAL1        525 


/* Active video area */
#define ACTIVE_FIELD1_START_NTSC    20
#define ACTIVE_FIELD1_END_NTSC      259
#define ACTIVE_FIELD2_START_NTSC    283
#define ACTIVE_FIELD2_END_NTSC      522

#define ACTIVE_FIELD1_START_NTSC_NOINTER   23
#define ACTIVE_FIELD1_END_NTSC_NOINTER     259

#define ACTIVE_FIELD1_START_PAL    23
#define ACTIVE_FIELD1_END_PAL      310
#define ACTIVE_FIELD2_START_PAL    336
#define ACTIVE_FIELD2_END_PAL      623

#define ACTIVE_FIELD1_START_PAL_NOINTER   23
#define ACTIVE_FIELD1_END_PAL_NOINTER     310

FILE *ofp_Y;
FILE *ofp_C;
FILE *ofp_TEST_U;
FILE *ofp_TEST_V;
FILE *ofp_Composite;

FILE *ofp_Sim8bitOut;

FILE *ofp_mode2_HSYNC;
FILE *ofp_mode2_BLANK;
FILE *ofp_mode2_VSYNC;

FILE *ofp_mode2_RGB;


#ifdef RTL_DEBUG
FILE *ofp_U;
FILE *ofp_V;
FILE *ofp_SIN;
FILE *ofp_COS;

FILE *ofp_MUL_USIN;
FILE *ofp_MUL_VCOS;
FILE *ofp_ADD;

FILE *ofp_Yout;
FILE *ofp_Uout;
FILE *ofp_Vout;
#endif

typedef struct _reg_tpye
{

//input data pointer
	unsigned char *BT601;
	unsigned char *RGB;
//output file pointer
	FILE *out_c_fp;
	FILE *out_y_fp;
	FILE *out_com_fp;

//Fields counter
    int F_COUNTER;

//Output control register / Reg0 
	int OUT_MODE;	/* 
                    For setting up the ENCODE mode
                        000 :: NTSC M <- support
                        011 :: PAL(B, D, G, H and I) <- support
                    */

    int INPUT_MODE;  /* rgb | ycbcr mode */

    int EN_INTERLACE;
    int EN_SQPIXEL;
    int EN_DAC2;
    int EN_DAC1;
    int EN_DAC0;

//Internal control register / Reg1 
    int LUMA_DELAY;
    int CHRO_DELAY;
    int EN_COLORBAR;
    int EN_REST_SCH;

//Internal control register / Reg1-1
    int HSYNC_WID;
    int BURST_WID;

//Internal & interface control register / Reg2
    int LUMA_FILTER_SEL;
    int CHRO_FILTER_SEL;
    int MASTER_SLAVE_SEL;
    int INTERMODE_SEL;

//Internal & interface control register / Reg2-1
    int INTER_HSYNC_WIDTH;
    int RISING_F_DELAY;
    int FALLING_F_DELAY;

    int SUB_PHASE;
    int SUB_REQ;

	/* buffer */
    int Y[TOTAL_PIXEL_SQ_PAL];
    int C[TOTAL_PIXEL_SQ_PAL];
    int COM[TOTAL_PIXEL_SQ_PAL];

    int TEST_C[TOTAL_PIXEL_SQ_PAL];

    /* SIN COS buffer */
	short SIN_BUFF[TOTAL_PIXEL_SQ_PAL];
	short COS_BUFF[TOTAL_PIXEL_SQ_PAL];

	short TEST_SIN_BUFF[TOTAL_PIXEL_SQ_PAL];
	short TEST_COS_BUFF[TOTAL_PIXEL_SQ_PAL];

	unsigned short ADDRESS_BUFF[TOTAL_PIXEL_SQ_PAL];
	short TEST_ADDRESS_BUFF[TOTAL_PIXEL_SQ_PAL];

    int SUBGEN_ADDR; // 11bits 
    int SUBGEN_ADDR_STEP;

//Internal parameter setting
    int TOTAL_LINE; //total line number of NTSC or PAL
                    // NTSC = 525 interlace 262 non-interlace
                    // PAL  = 625 interlace 312 non-interlace
    
    int TOTAL_DISPLAY_LINE;
    int TOTAL_FIELDS;
    int TOTAL_PIXEL;
    int ACTIVE_TOTAL_PIXEL;
                    // NTSC = 720*2 normal
                    // NTSC = 640*2 square 
                    // PAL  = 720*2 normal
                    // PAL  = 768*2 square 
    
    int CHANGE_FIELDS0; 
    int CHANGE_FIELDS1;
                    //change filed H_COUNTER number

    int BURST_MAX;
    int HSYNC_START;
    int HSYNC_WIDTH;
    int BURST_START;
    int BURST_WIDTH;
    int COLOR_START;
    int HSYNC_SLOPE;
    int BURST_SLOPE;

    /* Equalizing area 0~3 */
    int EQUALIZING_AREA0_START;
    int EQUALIZING_AREA0_END;
    int EQUALIZING_AREA1_START;
    int EQUALIZING_AREA1_END;
    int EQUALIZING_AREA2_START;
    int EQUALIZING_AREA2_END;
    int EQUALIZING_AREA3_START;
    int EQUALIZING_AREA3_END;

    /* Serration area 0~1 */
    int SERRATION_AREA0_START;
    int SERRATION_AREA0_END;
    int SERRATION_AREA1_START;
    int SERRATION_AREA1_END;

    /* Serration and Equalizing area 0  include active video*/
    int SERREQ_AREA0;

    /* Serration and Equalizing area 1 non-active video*/
    int SERREQ_AREA1;

    /* Equalizing area */
    int EQSERR_AREA0;

    /* Equalizing and blank area */
    int EQBLANK_AREA0;

    int BLANK_VALUE;
    int BLACK_VALUE;
    int HSYNC_LOW;

	int YSCALE, USCALE, VSCALE;	/* scaling coeff. */

} reg_type;

unsigned int OutValue_Y = 0;
unsigned int OutFileValue_Y = 0;
unsigned int OutCnt_Y = 0;

void output_Y(reg_type *encoder_reg)
{
    char OutFile[100];
    int i;

    if(OutCnt_Y == 5)
    {
        OutValue_Y = 0;
        OutCnt_Y = 0;
        fclose(ofp_Y);
    }

    if(OutCnt_Y == 0)
    {
        if(OutFileValue_Y >= (int)(encoder_reg->TOTAL_LINE/5))
            OutFileValue_Y = 0;

        sprintf(OutFile, "./OUT_Y/Y_%03d_F%d.out", OutFileValue_Y*5, encoder_reg->F_COUNTER);
	    ofp_Y = fopen(OutFile, "w");
        OutFileValue_Y++;
    }

    for(i = 0; encoder_reg->TOTAL_PIXEL > i; i++)
    {
        char value;
	    fprintf(ofp_Y, "%d %d\n", OutValue_Y , encoder_reg->Y[i]);
        value = (char)(encoder_reg->Y[i]>>2 & 0xff);
	    fwrite(&value, sizeof(char), 1, encoder_reg->out_y_fp);
        OutValue_Y++;
    }
    OutCnt_Y++;
}

unsigned int OutValue_COM = 0;
unsigned int OutFileValue_COM = 0;
unsigned int OutCnt_COM = 0;

//Simulation test output counter
unsigned int  TEST_C=0;
unsigned char Mem[4];
unsigned char jj =0;

//debug test
int H_COUNTER=1;

void output_COM(reg_type *encoder_reg)
{
    char OutFile[100];
    int i;

    if(OutCnt_COM >= 5)
    {
        OutCnt_COM = 0;
        OutValue_COM = 0;
        fclose(ofp_Composite);
    }

    if(OutValue_COM == 0)
    {
        if(OutFileValue_COM >= (int)(encoder_reg->TOTAL_LINE/5))
            OutFileValue_COM = 0;

        sprintf(OutFile, "./OUT/COM_%03d_F%d.out", OutFileValue_COM*5, encoder_reg->F_COUNTER);
	    ofp_Composite = fopen(OutFile, "w");
        OutFileValue_COM++;
    }

    for(i = 0; encoder_reg->TOTAL_PIXEL > i; i++)
    {
        char value;
	    fprintf(ofp_Composite, "%d %d\n", OutValue_COM , encoder_reg->COM[i]);

        //8bit output for fpga test
        value = (char)(encoder_reg->COM[i]>>2 & 0xff);

	    fwrite(&value, sizeof(char), 1, encoder_reg->out_com_fp);
        OutValue_COM++;

        if(TEST_C >= 3)
        {
            Mem[TEST_C] = encoder_reg->COM[i]>>2;
            //Mem[TEST_C] = jj++;
	        fprintf(ofp_Sim8bitOut, "%02x%02x%02x%02x\n", Mem[3], Mem[2], Mem[1], Mem[0]);
            TEST_C = 0;
        }
        else
        {
            Mem[TEST_C] = encoder_reg->COM[i]>>2;
            //Mem[TEST_C] = jj++;
            TEST_C++;
        }


    }
    OutCnt_COM++;

}


unsigned int OutValue_C = 0;
unsigned int OutFileValue_C = 0;
unsigned int OutCnt_C = 0;

void output_C(reg_type *encoder_reg)
{

    char OutFile[100];
    char OutFileU[100];
    char OutFileV[100];
    int i;

    if(OutCnt_C >= 5)
    {
        OutValue_C = 0;
        OutCnt_C = 0;
        fclose(ofp_C);

        fclose(ofp_TEST_U);
        fclose(ofp_TEST_V);
    }

    if(OutCnt_C == 0)
    {
        if(OutFileValue_C >= (int)(encoder_reg->TOTAL_LINE/5))
            OutFileValue_C = 0;

        sprintf(OutFile, "./OUT_C/C_%03d_F%d.out", 
                OutFileValue_C*5, encoder_reg->F_COUNTER);
	    ofp_C = fopen(OutFile, "w");


        /*TEST______________________________________*/
        sprintf(OutFileU, "./OUT_C/DIFF_%03d_F%d.out", 
                OutFileValue_C*5, encoder_reg->F_COUNTER);
        sprintf(OutFileV, "./OUT_C/V_%03d_F%d.out", 
                OutFileValue_C*5, encoder_reg->F_COUNTER);

	    ofp_TEST_U = fopen(OutFileU, "w");
	    ofp_TEST_V = fopen(OutFileV, "w");
        /*___________________________________________*/


        OutFileValue_C++;
    }

    for(i = 0; encoder_reg->TOTAL_PIXEL > i; i++)
    {
        short value;
	    fprintf(ofp_C, "%d %d \n", OutValue_C , encoder_reg->C[i]);

        /*TEST______________________________________*/
	    fprintf(ofp_TEST_U, "%d %d\n", 
                OutValue_C, encoder_reg->TEST_ADDRESS_BUFF[i]);
	    fprintf(ofp_TEST_V, "%d %d\n", 
                OutValue_C , encoder_reg->COS_BUFF[i]);
        /*___________________________________________*/

        value = (short)encoder_reg->C[i];
	    fwrite(&value, sizeof(short), 1, encoder_reg->out_c_fp);
        OutValue_C++;
    }
    OutCnt_C++;
}

void BLANK_CHRO_GEN(reg_type *encoder_reg)
{
    int P_COUNTER = 0;
    int i = 0;
    for(P_COUNTER = 0; encoder_reg->TOTAL_PIXEL > P_COUNTER; P_COUNTER++)
    {
        encoder_reg->COM[P_COUNTER] = encoder_reg->Y[P_COUNTER];
        encoder_reg->C[P_COUNTER]   = BLANK_VALUE_C;
    }
    output_C(encoder_reg);
    output_COM(encoder_reg);
}

void CHRO_GEN(reg_type *encoder_reg)
{
    int P_COUNTER = 0;
    int i = 0;
    for(P_COUNTER = 0; encoder_reg->TOTAL_PIXEL > P_COUNTER; P_COUNTER++)
    {
        encoder_reg->COM[P_COUNTER] = encoder_reg->C[P_COUNTER] + encoder_reg->Y[P_COUNTER];
        encoder_reg->C[P_COUNTER] += 512;
    }
    output_C(encoder_reg);
    output_COM(encoder_reg);
}

void LUMA_GEN(reg_type *encoder_reg)
{
    output_Y(encoder_reg);
}

int HSYNC_SLOP_CNT = 0;
int HSYNC_LEVEL;
void HSYNC(reg_type *encoder_reg, int SIG, int PIXEL)
{
    int temp_step = (encoder_reg->BLANK_VALUE - encoder_reg->HSYNC_LOW) / encoder_reg->HSYNC_SLOPE ;

    /* High to Low level */
    if(SIG == LOW_LEVEL && HSYNC_SLOP_CNT == encoder_reg->HSYNC_SLOPE)
    {
        HSYNC_SLOP_CNT  = encoder_reg->HSYNC_SLOPE;
        HSYNC_LEVEL     = encoder_reg->HSYNC_LOW;
        encoder_reg->Y[PIXEL] = HSYNC_LEVEL;
    }
    else if(SIG == LOW_LEVEL && HSYNC_SLOP_CNT == 0)
    {
        HSYNC_SLOP_CNT++;
        HSYNC_LEVEL           = encoder_reg->BLANK_VALUE;
        encoder_reg->Y[PIXEL] = HSYNC_LEVEL;
    }
    else if(SIG == LOW_LEVEL && HSYNC_SLOP_CNT != 0)
    {
        HSYNC_SLOP_CNT++;
        HSYNC_LEVEL           = HSYNC_LEVEL - temp_step;
        if(HSYNC_LEVEL < encoder_reg->HSYNC_LOW)
        {
            HSYNC_LEVEL = encoder_reg->HSYNC_LOW;
            HSYNC_SLOP_CNT = encoder_reg->HSYNC_SLOPE;
        }
        encoder_reg->Y[PIXEL] = HSYNC_LEVEL;
    }


    /* Low to High level */
    if(SIG == HIGH_LEVEL && HSYNC_SLOP_CNT == 0)
    {
        HSYNC_SLOP_CNT = 0;
        HSYNC_LEVEL    = encoder_reg->BLANK_VALUE;
        encoder_reg->Y[PIXEL] = HSYNC_LEVEL;
    }
    else if(SIG == HIGH_LEVEL && HSYNC_SLOP_CNT == encoder_reg->HSYNC_SLOPE)
    {
        HSYNC_SLOP_CNT--;
        HSYNC_LEVEL           = encoder_reg->HSYNC_LOW;
        encoder_reg->Y[PIXEL] = HSYNC_LEVEL;
    }
    else if(SIG == HIGH_LEVEL && HSYNC_SLOP_CNT != 0)
    {
        HSYNC_SLOP_CNT--;
        HSYNC_LEVEL           = HSYNC_LEVEL + temp_step;
        if(HSYNC_LEVEL > encoder_reg->BLANK_VALUE)
        {
            HSYNC_LEVEL     = encoder_reg->BLANK_VALUE;
            HSYNC_SLOP_CNT  = 0;
        }
        encoder_reg->Y[PIXEL] = HSYNC_LEVEL;
    }

}

void SERRATION_GEN(reg_type *encoder_reg, int H_COUNTER)
{
    int P_COUNTER = 0;
    for(P_COUNTER = 0; encoder_reg->TOTAL_PIXEL > P_COUNTER; P_COUNTER++)
    {

        if(P_COUNTER >= 0 && 
           encoder_reg->HSYNC_START > P_COUNTER)
        {
            encoder_reg->Y[P_COUNTER] = encoder_reg->BLANK_VALUE;
        }
        else if((encoder_reg->HSYNC_START <= P_COUNTER)  &&
               ((encoder_reg->TOTAL_PIXEL/2 - encoder_reg->HSYNC_WIDTH) > P_COUNTER))
        {
            HSYNC(encoder_reg, LOW_LEVEL, P_COUNTER);
        }
        else if(((P_COUNTER >= ((encoder_reg->TOTAL_PIXEL/2)+encoder_reg->HSYNC_START)) && 
                ((encoder_reg->TOTAL_PIXEL - encoder_reg->HSYNC_WIDTH) > P_COUNTER)))
        {
           HSYNC(encoder_reg, LOW_LEVEL, P_COUNTER);
        }
        else
           HSYNC(encoder_reg, HIGH_LEVEL, P_COUNTER);


        //Testbnech input generation
        if(P_COUNTER >= 0 && encoder_reg->HSYNC_START > P_COUNTER ) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_START <= P_COUNTER) && 
                ((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) > P_COUNTER))) {

            //odd field start point
            if(H_COUNTER == 1){

	            fprintf(ofp_mode2_HSYNC, "0\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "0\n");
	            fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
            } else {
	            fprintf(ofp_mode2_HSYNC, "0\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	            fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
            }

        /*
        } else if(((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) <= P_COUNTER) && 
                ((encoder_reg->COLOR_START) > P_COUNTER)) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
        */
        } else {
	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
        }

    }

}

void EQBLANK_GEN(reg_type *encoder_reg)
{
    int P_COUNTER = 0;
    for(P_COUNTER = 0; encoder_reg->TOTAL_PIXEL > P_COUNTER; P_COUNTER++)
    {
        
        if(P_COUNTER >= 0 && 
           encoder_reg->HSYNC_START > P_COUNTER)
        {
            encoder_reg->Y[P_COUNTER] = encoder_reg->BLANK_VALUE;
        }
        else if(((encoder_reg->HSYNC_START <= P_COUNTER)  
             && ((encoder_reg->HSYNC_WIDTH/2) > P_COUNTER)))
            HSYNC(encoder_reg, LOW_LEVEL, P_COUNTER);
        else
           HSYNC(encoder_reg, HIGH_LEVEL, P_COUNTER);


        //Testbnech input generation
        if(P_COUNTER >= 0 && encoder_reg->HSYNC_START > P_COUNTER) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_START <= P_COUNTER) && 
                ((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) > P_COUNTER))) {

	        fprintf(ofp_mode2_HSYNC, "0\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) <= P_COUNTER) && 
                ((encoder_reg->COLOR_START) > P_COUNTER)) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
        } else {
	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
        }

    }
}

void EQSERR_GEN(reg_type *encoder_reg)
{
    int P_COUNTER = 0;
    for(P_COUNTER = 0; encoder_reg->TOTAL_PIXEL > P_COUNTER; P_COUNTER++)
    {
        
        if(P_COUNTER >= 0 && 
           encoder_reg->HSYNC_START > P_COUNTER)
        {
            encoder_reg->Y[P_COUNTER] = encoder_reg->BLANK_VALUE;
        }
        else if(((encoder_reg->HSYNC_START <= P_COUNTER) 
             && ((encoder_reg->HSYNC_WIDTH/2) > P_COUNTER)))
            HSYNC(encoder_reg, LOW_LEVEL, P_COUNTER);
        else if(((P_COUNTER >= (encoder_reg->TOTAL_PIXEL/2)) && ((encoder_reg->TOTAL_PIXEL - encoder_reg->HSYNC_WIDTH) > P_COUNTER)))
           HSYNC(encoder_reg, LOW_LEVEL, P_COUNTER);
        else
           HSYNC(encoder_reg, HIGH_LEVEL, P_COUNTER);


        //Testbnech input generation
        if(P_COUNTER >= 0 && encoder_reg->HSYNC_START > P_COUNTER) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_START <= P_COUNTER) && 
                ((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) > P_COUNTER))) {

	        fprintf(ofp_mode2_HSYNC, "0\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((P_COUNTER >= (encoder_reg->TOTAL_PIXEL/2+encoder_reg->HSYNC_START)) && 
                  ((encoder_reg->TOTAL_PIXEL/2+encoder_reg->HSYNC_START + encoder_reg->HSYNC_WIDTH) > P_COUNTER))) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "0\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else {
	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
        }


        /*
        //Testbnech input generation
        if(P_COUNTER >= 0 && encoder_reg->HSYNC_START > P_COUNTER) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_START <= P_COUNTER) && 
                  ((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) > P_COUNTER))) {

	        fprintf(ofp_mode2_HSYNC, "0\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((P_COUNTER >= (encoder_reg->TOTAL_PIXEL/2+encoder_reg->HSYNC_START)) && 
                  ((encoder_reg->TOTAL_PIXEL - encoder_reg->HSYNC_WIDTH) > P_COUNTER))) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "0\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) <= P_COUNTER) && 
                ((encoder_reg->COLOR_START) > P_COUNTER)) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
        }
        */

    }
}

void SERREQ_GEN_ACTIVE_DIS(reg_type *encoder_reg, short *Y, short *ROutput, short *GOutput, short *BOutput)
{
    int P_COUNTER = 0;
    int i = 0;
    int TB_RGB = 0;
    for(P_COUNTER = 0; encoder_reg->TOTAL_PIXEL > P_COUNTER; P_COUNTER++)
    {

        if(P_COUNTER >= 0 && 
           encoder_reg->HSYNC_START > P_COUNTER)
        {
            encoder_reg->Y[P_COUNTER] = encoder_reg->BLANK_VALUE;
        }
        else if(((encoder_reg->HSYNC_START <= P_COUNTER) && 
                ((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) > P_COUNTER)))
        {
           HSYNC(encoder_reg, LOW_LEVEL, P_COUNTER);
        }
        else if(((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) <= P_COUNTER) && 
                ((encoder_reg->COLOR_START) > P_COUNTER))
        {
           HSYNC(encoder_reg, HIGH_LEVEL, P_COUNTER);
        }
        else if(((P_COUNTER >= encoder_reg->COLOR_START) && 
                ((encoder_reg->TOTAL_PIXEL/2) > P_COUNTER)))
        {
            encoder_reg->Y[P_COUNTER] = Y[i++] + encoder_reg->BLACK_VALUE;
        }
        else if(((P_COUNTER >= (encoder_reg->TOTAL_PIXEL/2)) && 
                ((encoder_reg->TOTAL_PIXEL/2)+(encoder_reg->HSYNC_WIDTH/2) > P_COUNTER)))
        {
            HSYNC(encoder_reg, LOW_LEVEL, P_COUNTER);
            encoder_reg->C[P_COUNTER] = 0;
        }
        else
        {
            HSYNC(encoder_reg, HIGH_LEVEL, P_COUNTER);
            encoder_reg->C[P_COUNTER] = 0;
        }


        //Testbnech input generation
        if(P_COUNTER >= 0 && encoder_reg->HSYNC_START > P_COUNTER) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_START <= P_COUNTER) && 
                ((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) > P_COUNTER))) {

	        fprintf(ofp_mode2_HSYNC, "0\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) <= P_COUNTER) && 
                ((encoder_reg->COLOR_START) > P_COUNTER)) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((P_COUNTER >= encoder_reg->COLOR_START) && 
                  ((encoder_reg->TOTAL_PIXEL/2) > P_COUNTER))) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "1\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", ROutput[TB_RGB/2], GOutput[TB_RGB/2], BOutput[TB_RGB/2]);
            TB_RGB++;

        } else if(((P_COUNTER >= (encoder_reg->TOTAL_PIXEL/2)) && 
                ((encoder_reg->TOTAL_PIXEL/2)+(encoder_reg->HSYNC_WIDTH/2) > P_COUNTER))) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else {
	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
        }


    }
}

void SERREQ_GEN(reg_type *encoder_reg)
{
    int P_COUNTER = 0;
    for(P_COUNTER = 0; encoder_reg->TOTAL_PIXEL > P_COUNTER; P_COUNTER++)
    {
        if(P_COUNTER >= 0 && encoder_reg->HSYNC_START > P_COUNTER)
            encoder_reg->Y[P_COUNTER] = encoder_reg->BLANK_VALUE;
        if(((P_COUNTER >= encoder_reg->HSYNC_START) && ((encoder_reg->TOTAL_PIXEL/2 - encoder_reg->HSYNC_WIDTH) > P_COUNTER)))
        {
            HSYNC(encoder_reg, LOW_LEVEL, P_COUNTER);
        }
        else if(
                ((P_COUNTER >= ((encoder_reg->TOTAL_PIXEL/2)+encoder_reg->HSYNC_START)) 
                 && ((encoder_reg->TOTAL_PIXEL/2)+(encoder_reg->HSYNC_WIDTH/2) > P_COUNTER))
               )
        {
           HSYNC(encoder_reg, LOW_LEVEL, P_COUNTER);
        }
        else
           HSYNC(encoder_reg, HIGH_LEVEL, P_COUNTER);


        //Testbnech input generation
        if(P_COUNTER >= 0 && encoder_reg->HSYNC_START > P_COUNTER) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_START <= P_COUNTER) && 
                ((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) > P_COUNTER))) {

	        fprintf(ofp_mode2_HSYNC, "0\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) <= P_COUNTER) && 
                ((encoder_reg->COLOR_START) > P_COUNTER)) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
        } else {
	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
        }
    }
}

void EQUALIZING_GEN(reg_type *encoder_reg)
{
    int P_COUNTER = 0;
    for(P_COUNTER = 0; encoder_reg->TOTAL_PIXEL > P_COUNTER; P_COUNTER++)
    {
        if(P_COUNTER >= 0 && encoder_reg->HSYNC_START > P_COUNTER)
        {
            encoder_reg->Y[P_COUNTER] = encoder_reg->BLANK_VALUE;

        }
        else if(((P_COUNTER >= encoder_reg->HSYNC_START) && ((encoder_reg->HSYNC_WIDTH/2) > P_COUNTER)))
        {
            HSYNC(encoder_reg, LOW_LEVEL, P_COUNTER);
        }
        else if(
                ((P_COUNTER >= ((encoder_reg->TOTAL_PIXEL/2)+encoder_reg->HSYNC_START)) 
                  && ((encoder_reg->TOTAL_PIXEL/2)+(encoder_reg->HSYNC_WIDTH/2) > P_COUNTER))
               )
        {
           HSYNC(encoder_reg, LOW_LEVEL, P_COUNTER);
        }
        else
           HSYNC(encoder_reg, HIGH_LEVEL, P_COUNTER);


        //Testbnech input generation
        if(P_COUNTER >= 0 && encoder_reg->HSYNC_START > P_COUNTER) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_START <= P_COUNTER) && 
                ((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) > P_COUNTER))) {

	        fprintf(ofp_mode2_HSYNC, "0\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        /*
        } else if(((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) <= P_COUNTER) && 
                ((encoder_reg->COLOR_START) > P_COUNTER)) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
        */
        } else {
	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
        }
            

    }
}


void NORMAL_HSYNC_GEN(reg_type *encoder_reg, short *Y, int DISPLAY_TYPE, short *ROutput, short *GOutput, short *BOutput)
{
    int P_COUNTER;
    int i, TB_RGB;

    i = 0;
    TB_RGB = 0;
    for(P_COUNTER = 0; encoder_reg->TOTAL_PIXEL > P_COUNTER; P_COUNTER++)
    {
        if(P_COUNTER >= 0 && encoder_reg->HSYNC_START > P_COUNTER)
        {
            encoder_reg->Y[P_COUNTER] = encoder_reg->BLANK_VALUE;
        }
        else if(((encoder_reg->HSYNC_START <= P_COUNTER) && 
                ((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) > P_COUNTER)))
        {
           HSYNC(encoder_reg, LOW_LEVEL, P_COUNTER);
        }
        else if(((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) <= P_COUNTER) && 
                ((encoder_reg->COLOR_START) > P_COUNTER))
        {
           HSYNC(encoder_reg, HIGH_LEVEL, P_COUNTER);
        }
        else if((encoder_reg->COLOR_START <= P_COUNTER) && 
               (encoder_reg->TOTAL_PIXEL > P_COUNTER))
        {
            /* display area */
            if(DISPLAY_TYPE == ENABLE)
            {
                encoder_reg->Y[P_COUNTER] = Y[i++] + encoder_reg->BLACK_VALUE;
            }
            else
            {
                encoder_reg->Y[P_COUNTER] = encoder_reg->BLANK_VALUE;
            }
        }


        //Testbnech input generation
        if(P_COUNTER >= 0 && encoder_reg->HSYNC_START > P_COUNTER) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_START <= P_COUNTER) && 
                ((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) > P_COUNTER))) {

	        fprintf(ofp_mode2_HSYNC, "0\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((encoder_reg->HSYNC_WIDTH+encoder_reg->HSYNC_START) <= P_COUNTER) && 
                ((encoder_reg->COLOR_START) > P_COUNTER)) {

	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);

        } else if(((P_COUNTER >= encoder_reg->COLOR_START) && 
                  ((encoder_reg->TOTAL_PIXEL) > P_COUNTER))) {

            /* display area */
            if(DISPLAY_TYPE == ENABLE) {
	            fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "1\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	            fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", ROutput[TB_RGB/2], GOutput[TB_RGB/2], BOutput[TB_RGB/2]);
                TB_RGB++;
            } else {
	            fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	            fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
            }
        } else {
	        fprintf(ofp_mode2_HSYNC, "1\n"); fprintf(ofp_mode2_BLANK, "0\n"); fprintf(ofp_mode2_VSYNC, "1\n");
	        fprintf(ofp_mode2_RGB, "%02x%02x%02x\n", 0, 0, 0);
        }

    }
}


int ACTIVE_VIDEO_ENABLE_CHK(reg_type *encoder_reg, int H_COUNTER)
{
    if(encoder_reg->OUT_MODE == VIDEO_NTSC && encoder_reg->EN_INTERLACE == ENABLE)
    {
        if(ACTIVE_FIELD1_START_NTSC <= H_COUNTER && ACTIVE_FIELD1_END_NTSC >= H_COUNTER)
            return ENABLE;
        if(ACTIVE_FIELD2_START_NTSC <= H_COUNTER && ACTIVE_FIELD2_END_NTSC >= H_COUNTER)
            return ENABLE;
        else 
            return DISABLE;

    } else if(encoder_reg->OUT_MODE == VIDEO_PAL && encoder_reg->EN_INTERLACE == ENABLE) {

        if(ACTIVE_FIELD1_START_PAL <= H_COUNTER && ACTIVE_FIELD1_END_PAL >= H_COUNTER)
            return ENABLE;
        if(ACTIVE_FIELD2_START_PAL <= H_COUNTER && ACTIVE_FIELD2_END_PAL >= H_COUNTER)
            return ENABLE;
        else 
            return DISABLE;

    } else if(encoder_reg->OUT_MODE == VIDEO_MPAL && encoder_reg->EN_INTERLACE == ENABLE) {
        if(ACTIVE_FIELD1_START_NTSC <= H_COUNTER && ACTIVE_FIELD1_END_NTSC >= H_COUNTER)
            return ENABLE;
        if(ACTIVE_FIELD2_START_NTSC <= H_COUNTER && ACTIVE_FIELD2_END_NTSC >= H_COUNTER)
            return ENABLE;
        else 
            return DISABLE;

    } else if(encoder_reg->OUT_MODE == VIDEO_NTSC && encoder_reg->EN_INTERLACE == DISABLE) {

        if(ACTIVE_FIELD1_START_NTSC_NOINTER <= H_COUNTER && 
           ACTIVE_FIELD1_END_NTSC_NOINTER   >= H_COUNTER)
            return ENABLE;
        else 
            return DISABLE;

    } else if(encoder_reg->OUT_MODE == VIDEO_PAL && encoder_reg->EN_INTERLACE == DISABLE) {

        if(ACTIVE_FIELD1_START_PAL_NOINTER <= H_COUNTER && 
           ACTIVE_FIELD1_END_PAL_NOINTER   >= H_COUNTER)
            return ENABLE;
        else 
            return DISABLE;
    }

    return DISABLE;
}



int BURST_ENABLE_CHK(reg_type *encoder_reg, int H_COUNTER)
{
    if(encoder_reg->OUT_MODE == VIDEO_NTSC && encoder_reg->EN_INTERLACE == ENABLE)
    {
        /* Area 0,1 */
        if(BURST_AREA1_START_NTSC <= H_COUNTER && BURST_AREA1_END_NTSC >= H_COUNTER)
            return DISABLE;
        else if(BURST_AREA2_START_NTSC <= H_COUNTER && BURST_AREA2_END_NTSC >= H_COUNTER)
            return DISABLE;
        else if(BURST_AREA3_START_NTSC <= H_COUNTER && BURST_AREA3_END_NTSC >= H_COUNTER)
            return DISABLE;
        else
            return ENABLE;

    } else if(encoder_reg->OUT_MODE == VIDEO_NTSC && encoder_reg->EN_INTERLACE == DISABLE) {

        /* Area 0,1 */
        if(BURST_AREA1_START_NTSC_NOINTER <= H_COUNTER && BURST_AREA1_END_NTSC_NOINTER >= H_COUNTER)
            return DISABLE;
        else if(BURST_AREA2_START_NTSC_NOINTER <= H_COUNTER && BURST_AREA2_END_NTSC_NOINTER >= H_COUNTER)
            return DISABLE;
        else
            return ENABLE;

    } else if(encoder_reg->OUT_MODE == VIDEO_PAL && encoder_reg->EN_INTERLACE == ENABLE) {

        if(encoder_reg->F_COUNTER == 1 || encoder_reg->F_COUNTER == 2 || 
           encoder_reg->F_COUNTER == 5 || encoder_reg->F_COUNTER == 6) 
        {
            if(BURST_AREA1_START_PAL0 <= H_COUNTER && BURST_AREA1_END_PAL0 >= H_COUNTER)
                return DISABLE;
            else if(BURST_AREA2_START_PAL0 <= H_COUNTER && BURST_AREA2_END_PAL0 >= H_COUNTER)
                return DISABLE;
            else if(BURST_AREA3_START_PAL0 <= H_COUNTER && BURST_AREA3_END_PAL0 >= H_COUNTER)
                return DISABLE;
            else
                return ENABLE;
        }
        else
        {
            if(BURST_AREA1_START_PAL1 <= H_COUNTER && BURST_AREA1_END_PAL1 >= H_COUNTER)
                return DISABLE;
            else if(BURST_AREA2_START_PAL1 <= H_COUNTER && BURST_AREA2_END_PAL1 >= H_COUNTER)
                return DISABLE;
            else if(BURST_AREA3_START_PAL1 <= H_COUNTER && BURST_AREA3_END_PAL1 >= H_COUNTER)
                return DISABLE;
            else
                return ENABLE;
        }

    } else if(encoder_reg->OUT_MODE == VIDEO_PAL && encoder_reg->EN_INTERLACE == DISABLE) {

        if(BURST_AREA1_START_PAL0_NOINTER <= H_COUNTER && BURST_AREA1_END_PAL0_NOINTER >= H_COUNTER)
            return DISABLE;
        else if(BURST_AREA2_START_PAL0_NOINTER <= H_COUNTER && BURST_AREA2_END_PAL0_NOINTER >= H_COUNTER)
            return DISABLE;
        else
            return ENABLE;

    } else if(encoder_reg->OUT_MODE == VIDEO_MPAL && encoder_reg->EN_INTERLACE == ENABLE) {

        if(encoder_reg->F_COUNTER == 1 || encoder_reg->F_COUNTER == 2 || 
           encoder_reg->F_COUNTER == 5 || encoder_reg->F_COUNTER == 6) 
        {
            if(BURST_AREA1_START_MPAL0 <= H_COUNTER && BURST_AREA1_END_MPAL0 >= H_COUNTER)
                return DISABLE;
            else if(BURST_AREA2_START_MPAL0 <= H_COUNTER && BURST_AREA2_END_MPAL0 >= H_COUNTER)
                return DISABLE;
            else if(BURST_AREA3_START_MPAL0 <= H_COUNTER && BURST_AREA3_END_MPAL0 >= H_COUNTER)
                return DISABLE;
            else
                return ENABLE;
        }
        else
        {
            if(BURST_AREA1_START_MPAL1 <= H_COUNTER && BURST_AREA1_END_MPAL1 >= H_COUNTER)
                return DISABLE;
            else if(BURST_AREA2_START_MPAL1 <= H_COUNTER && BURST_AREA2_END_MPAL1 >= H_COUNTER)
                return DISABLE;
            else if(BURST_AREA3_START_MPAL1 <= H_COUNTER && BURST_AREA3_END_MPAL1 >= H_COUNTER)
                return DISABLE;
            else
                return ENABLE;
        }
    } else if(encoder_reg->OUT_MODE == VIDEO_MPAL && encoder_reg->EN_INTERLACE == DISABLE) {
        return ENABLE;
    }
}

short Sine(short phase)
{
	int index;
	short value;

	phase &= 0x07ff;

#if 0
	value = sine_table[phase];
#else
	if(phase & 0x0100) {

        if(phase == 0x100)
		    index = 0x00ff;
        else if(phase == 0x300)
		    index = 0x00ff;
        else if(phase == 0x500)
		    index = 0x00ff;
        else if(phase == 0x700)
		    index = 0x00ff;
        else
		    index = (0x0ff-(phase & 0x00ff))&0x00ff;

    } else
		index = phase & 0x00ff;

	switch(phase>>8)
	{
	case 0:
		value = sine_table[index];
		break;
	case 1:
		value = cosine_table[index];
		break;
	case 2:
		value = cosine_table[index];
		break;
	case 3:
		value = sine_table[index];
		break;
	case 4:
		value = -sine_table[index];
		break;
	case 5:
		value = -cosine_table[index];
		break;
	case 6:
		value = -cosine_table[index];
		break;
	case 7:
		value = -sine_table[index];
		break;
	}
#endif
	return value;
}

short Cosine(short phase)
{
	int index;
	short value;

	phase &= 0x07ff;

#if 0
	value = cosine_table[phase];
#else
	if(phase & 0x0100)
        if(phase == 0x100)
		    index = 0x00ff;
        else if(phase == 0x300)
		    index = 0x00ff;
        else if(phase == 0x500)
		    index = 0x00ff;
        else if(phase == 0x700)
		    index = 0x00ff;
        else
		    index = (0x0ff-(phase & 0x00ff))&0x00ff;

	else
		index = phase & 0x00ff;

	switch(phase>>8)
	{
	case 0:
		value = cosine_table[index];
		break;
	case 1:
		value = sine_table[index];
		break;
	case 2:
		value = -sine_table[index];
		break;
	case 3:
		value = -cosine_table[index];
		break;
	case 4:
		value = -cosine_table[index];
		break;
	case 5:
		value = -sine_table[index];
		break;
	case 6:
		value = sine_table[index];
		break;
	case 7:
		value = cosine_table[index];
		break;
	}
#endif

	return value;
}


void SINCOS_GEN(reg_type *encoder_reg)
{
    int     i;
    for(i = 0; (encoder_reg->TOTAL_PIXEL)> i; i++) 
    {
        encoder_reg->SIN_BUFF[i] = Sine(encoder_reg->ADDRESS_BUFF[i]);
        encoder_reg->COS_BUFF[i] = Cosine(encoder_reg->ADDRESS_BUFF[i]);

        encoder_reg->TEST_SIN_BUFF[i] = Sine(encoder_reg->TEST_ADDRESS_BUFF[i]);
        encoder_reg->TEST_COS_BUFF[i] = Cosine(encoder_reg->TEST_ADDRESS_BUFF[i]);

        //TEST burst phase check
        if(encoder_reg->ADDRESS_BUFF[i] >= encoder_reg->TEST_ADDRESS_BUFF[i])
        {
            encoder_reg->TEST_ADDRESS_BUFF[i] = 
                        encoder_reg->ADDRESS_BUFF[i] -
                        encoder_reg->TEST_ADDRESS_BUFF[i];
        }
        else
        {
            encoder_reg->TEST_ADDRESS_BUFF[i] = 
                        (encoder_reg->ADDRESS_BUFF[i] + 2048) -
                        encoder_reg->TEST_ADDRESS_BUFF[i];
        }

    }
}


static void ChromaLPF2(short *output, short *input, int len)
{


int i, j, index, out;
int FLENGTH = len;
#if 0
const int FORDER = 20;
const float B[20] = {
    0.003549377434, 0.006440139841,  0.01135565061,   0.0177133102,  0.02520038933,
    0.03325941041,  0.04114945233,  0.04804453626,  0.05316222459,  0.05589038134,
    0.05589038134,  0.05316222459,  0.04804453626,  0.04114945233,  0.03325941041,
    0.02520038933,   0.0177133102,  0.01135565061, 0.006440139841, 0.003549377434
    };
    long coeff[20];

#else
const int FORDER = 49;
const float B[49] = {
   0.001576254959, 0.001465928741, 0.002105412539, 0.002890594536, 0.003829329042,
   0.004928966984, 0.006189640146, 0.007609878667, 0.009181416593,  0.01089189295,
    0.01272156835,  0.01464877464,  0.01664506458,  0.01867995784,  0.02071690559,
    0.02271927521,  0.02464720421,  0.02646329254,  0.02812818624,  0.02960577048,
     0.0308628846,  0.03187377751,  0.03261231631,  0.03306123614,  0.03321453556,
    0.03306123614,  0.03261231631,  0.03187377751,   0.0308628846,  0.02960577048,
    0.02812818624,  0.02646329254,  0.02464720421,  0.02271927521,  0.02071690559,
    0.01867995784,  0.01664506458,  0.01464877464,  0.01272156835,  0.01089189295,
   0.009181416593, 0.007609878667, 0.006189640146, 0.004928966984, 0.003829329042,
   0.002890594536, 0.002105412539, 0.001465928741, 0.001576254959
};
    long coeff[49];
#endif


    for(i = 0; i<FORDER; i++)
        coeff[i] =(long)(B[i] * 2048); //11bits

	for(i = 0; i < FLENGTH; i++)
	{
		out = 0;
		for(j = 0; j < FORDER; j++)
		{
			index = i+j;
			if(index >= ((FORDER-1)>>1) && index < (FLENGTH+((FORDER-1)>>1)))
				out += (coeff[FORDER-1-j])*input[index - ((FORDER-1)>>1)];
			else if(index < ((FORDER-1)>>1))	        /* out of range */
				out += (coeff[FORDER-1-j])*0;
			else if(index >= (FLENGTH+((FORDER-1)>>1)))	/* out of range */
				out += (coeff[FORDER-1-j])*0;
		}
		output[i] = (out>>11);
	}	

}


static void ChromaLPF(short *output, short *input)
{
	int i, j, index;
#define FLENGTH 1440
/* equiripple 1.3Mhz FIR filter */
#define FORDER 25
const short coeff[FORDER] = {
     -353,   -347,   -407,   -362,   -161,    224,    795,   1515,   2315,
     3096,   3755,   4194,   4349,   4194,   3755,   3096,   2315,   1515,
      795,    224,   -161,   -362,   -407,   -347,   -353
};	/* 15 fractional part */
	int out;

	for(i = 0; i < FLENGTH; i++)
	{
		out = 0;
		for(j = 0; j < FORDER; j++)
		{
			index = i+j;
#if 0
			if(index >= ((FORDER-1)>>1) && index < (FLENGTH+((FORDER-1)>>1)))
				out += (coeff[FORDER-1-j]>>4)*input[index - ((FORDER-1)>>1)];
			else if(index < ((FORDER-1)>>1))
				out += (coeff[FORDER-1-j]>>4)*input[0];
			else if(index >= (FLENGTH+((FORDER-1)>>1)))
				out += (coeff[FORDER-1-j]>>4)*input[FLENGTH-1];
#else
			if(index >= ((FORDER-1)>>1) && index < (FLENGTH+((FORDER-1)>>1)))
				out += (coeff[FORDER-1-j]>>4)*input[index - ((FORDER-1)>>1)];
			else if(index < ((FORDER-1)>>1))	/* out of range */
				out += (coeff[FORDER-1-j]>>4)*0;
			else if(index >= (FLENGTH+((FORDER-1)>>1)))	/* out of range */
				out += (coeff[FORDER-1-j]>>4)*0;
#endif
		}
		output[i] = (out>>11);
	}	
#undef FORDER
#undef FLENGTH
}

static void LumaLPF2(short *output, short *input, int len)
{

    int FLENGTH = len;
	int i, j, index, out;
    const int FORDER = 20;
    const float B[20] = {
        -0.0009765625,   0.0263671875,    0.056640625,   0.0615234375,    0.013671875,
        -0.0576171875,  -0.0732421875,   0.0263671875,     0.20703125,      0.3515625,
            0.3515625,     0.20703125,   0.0263671875,  -0.0732421875,  -0.0576171875,
          0.013671875,   0.0615234375,    0.056640625,   0.0263671875,  -0.0009765625
    };

    long coeff[20];
    for(i = 0; i<FORDER; i++)
        coeff[i] =(long)(B[i] * 2048); //11bits

	for(i = 0; i < FLENGTH; i++)
	{
		out = 0;
		for(j = 0; j < FORDER; j++)
		{
			index = i+j;
			if(index >= ((FORDER-1)>>1) && index < (FLENGTH+((FORDER-1)>>1)))
				out += (coeff[FORDER-1-j])*input[index - ((FORDER-1)>>1)];
			else if(index < ((FORDER-1)>>1))	        /* out of range */
				out += (coeff[FORDER-1-j])*0;
			else if(index >= (FLENGTH+((FORDER-1)>>1)))	/* out of range */
				out += (coeff[FORDER-1-j])*0;
		}
		output[i] = (out>>11);
	}	

}


static void LumaLPF(short *output, short *input)
{
	int i, j, index;
#define FLENGTH 1440
/* equiripple 6 Mhz FIR filter */
#define FORDER 17
const short coeff[FORDER] = {
     -123,   -497,    445,   1133,   -672,  -2819,    873,  10194,  15436,
    10194,    873,  -2819,   -672,   1133,    445,   -497,   -123
};	/* 15 fractional part */
	int out;

	for(i = 0; i < FLENGTH; i++)
	{
		out = 0;
		for(j = 0; j < FORDER; j++)
		{
			index = i+j;
#if 0
			if(index >= ((FORDER-1)>>1) && index < (FLENGTH+((FORDER-1)>>1)))
				out += (coeff[FORDER-1-j]>>4)*input[index - ((FORDER-1)>>1)];
			else if(index < ((FORDER-1)>>1))
				out += (coeff[FORDER-1-j]>>4)*input[0];
			else if(index >= (FLENGTH+((FORDER-1)>>1)))
				out += (coeff[FORDER-1-j]>>4)*input[FLENGTH-1];
#else
			if(index >= ((FORDER-1)>>1) && index < (FLENGTH+((FORDER-1)>>1)))
				out += (coeff[FORDER-1-j]>>4)*input[index - ((FORDER-1)>>1)];
			else if(index < ((FORDER-1)>>1))	/* out of range */
				out += (coeff[FORDER-1-j]>>4)*0;
			else if(index >= (FLENGTH+((FORDER-1)>>1)))	/* out of range */
				out += (coeff[FORDER-1-j]>>4)*0;
#endif
		}
		output[i] = (out>>11);
	}	
#undef FORDER
#undef FLENGTH
}


void CONV_RGB2YUV(reg_type *encoder_reg, short *RInput, short *GInput, short *BInput, 
                                         short *Y, short *U, short *V, 
                                         short *ROutput, short *GOutput, short *BOutput)
{
    /* gammar correct */
	int i, k=0;
    int j =0;

    /*
    short TempY[encoder_reg->ACTIVE_TOTAL_PIXEL];
    short TempU[encoder_reg->ACTIVE_TOTAL_PIXEL];
    short TempV[encoder_reg->ACTIVE_TOTAL_PIXEL];
    */
    short TempY[2000];
    short TempU[2000];
    short TempV[2000];

    i = 0;

#ifdef GAMMA_ENABLE
	for(i = 0; (encoder_reg->ACTIVE_TOTAL_PIXEL/3) >= i; i++)
    {
        short value;
        if(RInput[i] < 5)  RInput[i] = (short)((4.5 * RInput[i])/256);
        else {
            if(RInput[i] > 255) RInput[i] = 255;
            value = RInput[i]; 
            RInput[i] = (((256+25)*E045[value])/256 - 25);
            //for R, G, B ¡Ã 0.018
            //R¢¥ = 1.099 R^0.45 - 0.099
            //G¢¥ = 1.099 G^0.45 - 0.099
            //B¢¥ = 1.099 B^0.45 - 0.099

            //TestBench input
            ROutput[i] = RInput[i];

        }

        if(GInput[i] < 5)  GInput[i] = (short)((4.5 * GInput[i])/256);
        else {
            if(GInput[i] > 255) GInput[i] = 255;
            value = GInput[i]; 
            GInput[i] = (((256+25)*E045[value])/256 - 25);

            //TestBench input
            GOutput[i] = GInput[i];

        }

        if(BInput[i] < 5)  BInput[i] = (short)((4.5 * BInput[i])/256);
        else {
            if(BInput[i] > 255) BInput[i] = 255;
            value = BInput[i]; 
            BInput[i] = (((256+25)*E045[value])/256 - 25);

            //TestBench input
            BOutput[i] = BInput[i];
        }

    }
#else
	for(i = 0; (encoder_reg->ACTIVE_TOTAL_PIXEL/3) > i; i++)
    {
        //TestBench input
        ROutput[i] = RInput[i];
        GOutput[i] = GInput[i];
        BOutput[i] = BInput[i];
    }
#endif

    /* YUV equation */
	for(i = 0; i < encoder_reg->ACTIVE_TOTAL_PIXEL/3; i++)
    {
        /* NTSC
        155(R) + 304(G) + 59(B)
        -76(R) - 150(G) + 226(B)
        319(R) - 267(G) - 52(B) 
        */

        /* NTSC-J */
        
        /* PAL
        164(R) + 322(G) + 62(B)
        -81(R) - 159(G) + 240(B)
        337(R) - 282(G) - 55(B)
        */
        if(encoder_reg->OUT_MODE == VIDEO_NTSC || encoder_reg->OUT_MODE == VIDEO_MPAL) {
            TempY[k] = ((155*RInput[i]) + (304*GInput[i]) + ( 59*BInput[i]) +scale_round)>>scale_bit_resolution;
            TempU[k] = ((-76*RInput[i]) - (150*GInput[i]) + (226*BInput[i]) +scale_round)>>scale_bit_resolution;
            TempV[k] = ((319*RInput[i]) - (267*GInput[i]) - ( 52*BInput[i]) +scale_round)>>scale_bit_resolution;
        } else if(encoder_reg->OUT_MODE == VIDEO_PAL) {
            TempY[k] = ((164*RInput[i]) + (322*GInput[i]) + ( 62*BInput[i]) +scale_round)>>scale_bit_resolution;
            TempU[k] = ((-81*RInput[i]) - (159*GInput[i]) + (240*BInput[i]) +scale_round)>>scale_bit_resolution;
            TempV[k] = ((337*RInput[i]) - (282*GInput[i]) - ( 55*BInput[i]) +scale_round)>>scale_bit_resolution;
        }
        k=k+2;
    }
    k=1;
    j=0;
#ifndef SIMPLE_4xSAMPLE

	for(i = 0; i < encoder_reg->ACTIVE_TOTAL_PIXEL/3; i++)
    {
        TempY[k] = (TempY[k-1] + TempY[j])/2;
        TempU[k] = (TempU[k-1] + TempU[j])/2;
        TempV[k] = (TempV[k-1] + TempV[j])/2;

        k=k+2;
        j=j+2;
    }

#ifdef FILTER_ENABLE
	LumaLPF(Y, TempY);
	ChromaLPF(U, TempU);
	ChromaLPF(V, TempV);
	//LumaLPF2(Y, TempY, (encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2);
	//ChromaLPF2(U, TempU, (encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2);
	//ChromaLPF2(V, TempV, (encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2);
#   ifdef RTL_DEBUG
	for(i = 0; i < (encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2; i++) {

	    fprintf(ofp_Yout , "%03x\n", TempY[i] & 0x3ff);
	    fprintf(ofp_Uout , "%03x\n", TempU[i] & 0x3ff);
	    fprintf(ofp_Vout , "%03x\n", TempV[i] & 0x3ff);
    }
#   endif

#else
	memcpy(Y, TempY, sizeof(short)*(encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2);
	memcpy(U, TempU, sizeof(short)*(encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2);
	memcpy(V, TempV, sizeof(short)*(encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2);
#endif

#else
	for(i = 0; i < encoder_reg->ACTIVE_TOTAL_PIXEL/3; i++)
    {
        TempY[k] = TempY[j];
        TempU[k] = TempU[j];
        TempV[k] = TempV[j];

        k=k+2;
        j=j+2;
    }

#ifdef FILTER_ENABLE
	LumaLPF(Y, TempY);
	ChromaLPF(U, TempU);
	ChromaLPF(V, TempV);
	//LumaLPF2(Y, TempY, (encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2);
	//ChromaLPF2(U, TempU, (encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2);
	//ChromaLPF2(V, TempV, (encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2);

#   ifdef RTL_DEBUG
	for(i = 0; i < (encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2; i++) {

	    fprintf(ofp_Yout , "%03x\n", TempY[i] & 0x3ff);
	    fprintf(ofp_Uout , "%03x\n", TempU[i] & 0x3ff);
	    fprintf(ofp_Vout , "%03x\n", TempV[i] & 0x3ff);
    }
#   endif

#else
	memcpy(Y, TempY, sizeof(short)*(encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2);
	memcpy(U, TempU, sizeof(short)*(encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2);
	memcpy(V, TempV, sizeof(short)*(encoder_reg->ACTIVE_TOTAL_PIXEL/3)*2);
#endif

#endif

}

int VALID_YCbCr = 0;
void CONV_YCbCr2YUV(reg_type *encoder_reg, short *LumInput, short *CrInput, 
                    short *CbInput, short *Y, short *U, short *V)
{
	int i, k=0;
    short TempY[encoder_reg->ACTIVE_TOTAL_PIXEL];
    short TempU[encoder_reg->ACTIVE_TOTAL_PIXEL];
    short TempV[encoder_reg->ACTIVE_TOTAL_PIXEL];

	for(i = 0; i < encoder_reg->ACTIVE_TOTAL_PIXEL; i+=2)
    {
        //Limited value
        if(LumInput[k] < 16)  LumInput[k] = 16;
        if(LumInput[k] > 235) LumInput[k] = 235;

		TempY[i]   = ((LumInput[k++]-16)*encoder_reg->YSCALE+scale_round)>>scale_bit_resolution;
    }

    k=0;
	for(i = 0; i < encoder_reg->ACTIVE_TOTAL_PIXEL; i+=4)
    {
        //Limited value
        if(CrInput[k] < 16)  CrInput[k] = 16;
        if(CrInput[k] > 240) CrInput[k] = 240;
        if(CbInput[k] < 16)  CbInput[k] = 16;
        if(CbInput[k] > 240) CbInput[k] = 240;

		TempU[i]   = (((CbInput[k]-128)*encoder_reg->USCALE)+scale_round)>>scale_bit_resolution;
		TempV[i]   = (((CrInput[k]-128)*encoder_reg->VSCALE)+scale_round)>>scale_bit_resolution;
        k++;
    }

#ifndef SIMPLE_4xSAMPLE
	for(i = 1; i < encoder_reg->ACTIVE_TOTAL_PIXEL; i+=2)
    {
		TempY[i]   = (int)((TempY[i-1]*0.5) + (TempY[i+1]*.5)) & 0x3FF;
    }

    for(i = 0; i < encoder_reg->ACTIVE_TOTAL_PIXEL; i+=4)
    {
		TempU[i+1]   = (int)((TempU[i] * 0.75) + (TempU[i+4] * 0.25));// & 0x3FF;
		TempU[i+2]   = (int)((TempU[i] * 0.5)  + (TempU[i+4] * 0.5));// & 0x3FF;
		TempU[i+3]   = (int)((TempU[i] * 0.25) + (TempU[i+4] * 0.75));// & 0x3FF;

		TempV[i+1]   = (int)((TempV[i] * 0.75) + (TempV[i+4] * 0.25));// & 0x3FF;
		TempV[i+2]   = (int)((TempV[i] * 0.5)  + (TempV[i+4] * 0.5));// & 0x3FF;
		TempV[i+3]   = (int)((TempV[i] * 0.25) + (TempV[i+4] * 0.75));// & 0x3FF;
    }

#ifdef FILTER_ENABLE
	LumaLPF(Y, TempY);
	ChromaLPF(U, TempU);
	ChromaLPF(V, TempV);
	//ChromaLPF2(U, TempU, (encoder_reg->ACTIVE_TOTAL_PIXEL));
	//ChromaLPF2(V, TempV, (encoder_reg->ACTIVE_TOTAL_PIXEL));
#else
	memcpy(Y, TempY, sizeof(short)*encoder_reg->ACTIVE_TOTAL_PIXEL);
	memcpy(U, TempU, sizeof(short)*encoder_reg->ACTIVE_TOTAL_PIXEL);
	memcpy(V, TempV, sizeof(short)*encoder_reg->ACTIVE_TOTAL_PIXEL);
#endif

#else

	for(i = 1; i < encoder_reg->ACTIVE_TOTAL_PIXEL; i+=2)
    {
		TempY[i]   = TempY[i-1] & 0x3FF;
    }

    for(i = 0; i < encoder_reg->ACTIVE_TOTAL_PIXEL; i+=4)
    {
		TempU[i+1]   = TempU[i];// & 0x3FF;
		TempU[i+2]   = TempU[i];// & 0x3FF;
		TempU[i+3]   = TempU[i];// & 0x3FF;

		TempV[i+1]   = TempV[i];// & 0x3FF;
		TempV[i+2]   = TempV[i];// & 0x3FF;
		TempV[i+3]   = TempV[i];// & 0x3FF;
    }

#ifdef FILTER_ENABLE
	LumaLPF(Y, TempY);
	ChromaLPF(U, TempU);
	ChromaLPF(V, TempV);
	//ChromaLPF2(U, TempU, encoder_reg->ACTIVE_TOTAL_PIXEL);
	//ChromaLPF2(V, TempV, encoder_reg->ACTIVE_TOTAL_PIXEL);
#else
	memcpy(Y, TempY, sizeof(short)*encoder_reg->ACTIVE_TOTAL_PIXEL);
	memcpy(U, TempU, sizeof(short)*encoder_reg->ACTIVE_TOTAL_PIXEL);
	memcpy(V, TempV, sizeof(short)*encoder_reg->ACTIVE_TOTAL_PIXEL);
#endif

#endif

}

int PHASE_TYPE_CHK(reg_type *encoder_reg, int H_COUNTER)
{
    if(encoder_reg->OUT_MODE == VIDEO_NTSC) 
    {
        if(encoder_reg->F_COUNTER == 1 || encoder_reg->F_COUNTER == 2) 
        {
            if(H_COUNTER & 0x1)   // odd number
                return TYPE_DOWN;
            else
                return TYPE_UP;   // even number
        }
        else if(encoder_reg->F_COUNTER == 3 ||encoder_reg->F_COUNTER == 4) 
        {
            if(H_COUNTER & 0x1)   // odd number
                return TYPE_UP;
            else
                return TYPE_DOWN; // enve number
        }

    } else if(encoder_reg->OUT_MODE == VIDEO_PAL && encoder_reg->EN_INTERLACE == ENABLE) {

        if(encoder_reg->F_COUNTER == 1 || encoder_reg->F_COUNTER == 2 ||
           encoder_reg->F_COUNTER == 5 || encoder_reg->F_COUNTER == 6) 
        {
            if(H_COUNTER & 0x1) // odd number
                return TYPE_UP;
            else                // enve number
                return TYPE_DOWN;
        }
        else if(encoder_reg->F_COUNTER == 3 || encoder_reg->F_COUNTER == 4 ||
                encoder_reg->F_COUNTER == 7 || encoder_reg->F_COUNTER == 8) 
        {
            if(H_COUNTER & 0x1) // odd number
                return TYPE_DOWN;
            else                // even number
                return TYPE_UP;
        }

    } else if(encoder_reg->OUT_MODE == VIDEO_MPAL && encoder_reg->EN_INTERLACE == ENABLE) {

        if(encoder_reg->F_COUNTER == 1 || encoder_reg->F_COUNTER == 2 ||
           encoder_reg->F_COUNTER == 5 || encoder_reg->F_COUNTER == 6) 
        {
            if(H_COUNTER & 0x1) // odd number
                return TYPE_UP;
            else                // enve number
                return TYPE_DOWN;
        }
        else if(encoder_reg->F_COUNTER == 3 || encoder_reg->F_COUNTER == 4 ||
                encoder_reg->F_COUNTER == 7 || encoder_reg->F_COUNTER == 8) 
        {
            if(H_COUNTER & 0x1) // odd number
                return TYPE_DOWN;
            else                // even number
                return TYPE_UP;
        }

    } else if(encoder_reg->OUT_MODE == VIDEO_PAL && encoder_reg->EN_INTERLACE == DISABLE) {
        if(H_COUNTER & 0x1) // odd number
            return TYPE_UP;
        else                // enve number
            return TYPE_DOWN;
    }
}

/* initial sub carrier address */
int F_COUNTER = 0;
void SUB_ADDR_GEN(reg_type *encoder_reg, int H_COUNTER)
{
    int     i;
    int     BURST_TYPE;
    unsigned long     ADDR;
    int     TYPE;
    int     TOTLINE;
    int     INCPERLINE;
    
    TYPE        = PHASE_TYPE_CHK(encoder_reg, H_COUNTER);
    TOTLINE     = (F_COUNTER * (encoder_reg->TOTAL_LINE)) + (H_COUNTER-1);
    INCPERLINE  = encoder_reg->TOTAL_PIXEL * encoder_reg->SUBGEN_ADDR_STEP;
    ADDR        = TOTLINE * INCPERLINE + (PHASE_1 * 0);  // adjust phase

    for(i = 0; encoder_reg->TOTAL_PIXEL > i; i++)
    {

        ADDR = ADDR + encoder_reg->SUBGEN_ADDR_STEP;

        //for TEST
        encoder_reg->TEST_ADDRESS_BUFF[i] = (ADDR >> 21) & 0x7FF;


        /* burst area modified */
        if(i >= encoder_reg->BURST_START - 10 &&  // Make margin address +- 5
           i <= (encoder_reg->BURST_START+encoder_reg->BURST_WIDTH + 15))
        {
            if(TYPE ==  TYPE_UP)
            {
                if(encoder_reg->OUT_MODE == VIDEO_NTSC)
                    encoder_reg->ADDRESS_BUFF[i] = ((ADDR+ PHASE_180) >> 21) & 0x7FF;
                else
                    encoder_reg->ADDRESS_BUFF[i] = ((ADDR+ PHASE_135) >> 21) & 0x7FF;
            }
            else if(TYPE == TYPE_DOWN)
            {
                if(encoder_reg->OUT_MODE == VIDEO_NTSC)
                    encoder_reg->ADDRESS_BUFF[i] = ((ADDR+ PHASE_180) >> 21) & 0x7FF;
                else
                    encoder_reg->ADDRESS_BUFF[i] = ((ADDR+ PHASE_225) >> 21) & 0x7FF;
            }
        }
        else
        {
            encoder_reg->ADDRESS_BUFF[i] = (ADDR >> 21) & 0x7FF;
        }
    }
}


int MULX(short U, short BUFF)
{

    int value;

    if(BUFF < 0 && U < 0 )
        value = ((-U*(-BUFF)));
    else if(BUFF < 0 && U >0 )
        value = -((U*(-BUFF)));
    else if(BUFF > 0 && U <0 )
        value = -((-U*(BUFF)));
    else
        value = (U*BUFF);


    return value; // output is 20bits valide
}


// burst envelop and U & V filled
void UV_GEN(reg_type *encoder_reg, short *U, short *V, int TYPE, int DISPLAY_TYPE, int H_COUNTER) 
{
    int i,j,k;
    int BURST_SLOPE_STEP;
    int BURST_ENVELOP =0;
    int BURST_CHK_ENABLE = BURST_ENABLE_CHK(encoder_reg, H_COUNTER);


    BURST_SLOPE_STEP = encoder_reg->BURST_MAX / encoder_reg->BURST_SLOPE;

    for(i=0;encoder_reg->BURST_START>i;i++)
	    encoder_reg->C[i] = 0;

    for(i=encoder_reg->BURST_START ; encoder_reg->COLOR_START  > i ; i++)
    {
        int BURST_ENABLE;

        // ENVELOP generation///////////////////////////////////////////////
        if((i >= encoder_reg->BURST_START) 
                && (i < (encoder_reg->BURST_WIDTH + encoder_reg->BURST_START)) 
                && (BURST_CHK_ENABLE == ENABLE))
            BURST_ENABLE = ENABLE;
        else
            BURST_ENABLE = DISABLE;

        if(BURST_ENVELOP < encoder_reg->BURST_MAX && BURST_ENABLE == ENABLE)
        {
            BURST_ENVELOP = BURST_ENVELOP + BURST_SLOPE_STEP;
            if(BURST_ENVELOP > encoder_reg->BURST_MAX)
                BURST_ENVELOP = encoder_reg->BURST_MAX;
        }

        if(BURST_ENVELOP > 0 && BURST_ENABLE == DISABLE)
        {
            BURST_ENVELOP = BURST_ENVELOP - BURST_SLOPE_STEP;
            if(BURST_ENVELOP < 0)
                BURST_ENVELOP = 0;
        }

		if(encoder_reg->SIN_BUFF[i] < 0)
			encoder_reg->C[i] = (-(BURST_ENVELOP*(-encoder_reg->SIN_BUFF[i])));
		else
			encoder_reg->C[i] = (BURST_ENVELOP*encoder_reg->SIN_BUFF[i]);

	    encoder_reg->C[i] = ((encoder_reg->C[i]+256) / 512); // 19bits --> 10bits

    }

    k= 0;

    if(DISPLAY_TYPE == ENABLE || H_COUNTER == encoder_reg->SERREQ_AREA0)
    {

        for( ; encoder_reg->TOTAL_PIXEL > i ; i++)
        {

#if 1 // if 0 --> color killer and remain burst signal test
      // if 1 --> normal 


            // C generation///////////////////////////////////////////////////
            encoder_reg->C[i] =  (MULX(U[k], encoder_reg->SIN_BUFF[i]))>>9;
#   ifdef RTL_DEBUG
	        fprintf(ofp_U, "%03x\n", U[k] & 0x3ff);
	        fprintf(ofp_V, "%03x\n", V[k] & 0x3ff);
	        fprintf(ofp_SIN, "%03x\n", encoder_reg->SIN_BUFF[i] & 0x7ff);
	        fprintf(ofp_COS, "%03x\n", encoder_reg->COS_BUFF[i] & 0x7ff);
	        fprintf(ofp_MUL_USIN, "%03x\n", encoder_reg->C[i] & 0x3ff);

            
#   endif
    
            if(encoder_reg->OUT_MODE == VIDEO_PAL || encoder_reg->OUT_MODE == VIDEO_MPAL)
            {
                if(TYPE == TYPE_UP)
                {
                    encoder_reg->C[i] += (MULX(V[k], encoder_reg->COS_BUFF[i]))>>9;
                }
                else
                {
                    encoder_reg->C[i] -= (MULX(V[k], encoder_reg->COS_BUFF[i]))>>9;
                }
            }
            else
            {
                encoder_reg->C[i] += (MULX(V[k], encoder_reg->COS_BUFF[i]))>>9;
#   ifdef RTL_DEBUG
	            fprintf(ofp_MUL_VCOS, "%03x\n", ((MULX(V[k], encoder_reg->COS_BUFF[i]))>>9) & 0x3ff);
	            fprintf(ofp_ADD, "%03x\n", encoder_reg->C[i] & 0x3ff);
#   endif
            }
    
            k++;
            ///////////////////////////////////////////////////////////////////

#else
	        encoder_reg->C[i] = 0;
#endif
        }
    }
    else
    {
        for( ; encoder_reg->TOTAL_PIXEL > i ; i++)
        {
	        encoder_reg->C[i] = 0;
        }
    }
}

void normal_area(reg_type *encoder_reg, int H_COUNTER, int VsyncEnable)
{
	short LumInput[720];
	short CbInput[720/2], CrInput[720/2];
    short RInput[720], GInput[720], BInput[720];
    short ROutput[720], GOutput[720], BOutput[720];
	short Y[encoder_reg->ACTIVE_TOTAL_PIXEL], U[encoder_reg->ACTIVE_TOTAL_PIXEL], V[encoder_reg->ACTIVE_TOTAL_PIXEL];
    int i,j;
    int BURST_TYPE;
    int DISPLAY_TYPE;

    int Start_i, End_i;
    int k=0;
    
    if(VALID_YCbCr >= encoder_reg->TOTAL_DISPLAY_LINE)
        VALID_YCbCr = 0;

    Start_i = VALID_YCbCr     * encoder_reg->ACTIVE_TOTAL_PIXEL;
    End_i   = (VALID_YCbCr+1) * encoder_reg->ACTIVE_TOTAL_PIXEL;

    /* Disaplay area define */
    DISPLAY_TYPE = ACTIVE_VIDEO_ENABLE_CHK(encoder_reg, H_COUNTER);

    /* YCbCr format conversion */
    if(VsyncEnable == DISABLE && encoder_reg->INPUT_MODE == INPUT_Ycbcr)
    {
        if(DISPLAY_TYPE == ENABLE)
        {
	        for(i = Start_i; i < End_i; i+=4)
	        {
		        CbInput[k/4]        = encoder_reg->BT601[i];
		        LumInput[(k/4)*2]   = encoder_reg->BT601[i+1];
		        CrInput[k/4]        = encoder_reg->BT601[i+2];
		        LumInput[((k/4))*2+1] = encoder_reg->BT601[i+3];
                k+=4;
	        }
            CONV_YCbCr2YUV(encoder_reg, LumInput, CrInput, CbInput, Y, U, V);
            VALID_YCbCr++;
        }
        else if(H_COUNTER == encoder_reg->SERREQ_AREA0)
        {
            Start_i = (VALID_YCbCr-1)   * encoder_reg->ACTIVE_TOTAL_PIXEL;
            End_i   = (VALID_YCbCr)     * encoder_reg->ACTIVE_TOTAL_PIXEL;

	        for(i = Start_i; i < End_i; i+=4)
	        {
		        CbInput[k/4]        = encoder_reg->BT601[i];
		        LumInput[(k/4)*2]   = encoder_reg->BT601[i+1];
		        CrInput[k/4]        = encoder_reg->BT601[i+2];
		        LumInput[((k/4))*2+1] = encoder_reg->BT601[i+3];
                k+=4;
	        }
            CONV_YCbCr2YUV(encoder_reg, LumInput, CrInput, CbInput, Y, U, V);
        }
    }
    /* RGB format conversion */
    else if(VsyncEnable == DISABLE && encoder_reg->INPUT_MODE == INPUT_RGB)
    {
        if(DISPLAY_TYPE == ENABLE)
        {
	        for(i = Start_i; i < End_i; i+=3)
	        {
		        RInput[k] = encoder_reg->RGB[i];
		        GInput[k] = encoder_reg->RGB[i+1];
		        BInput[k] = encoder_reg->RGB[i+2];
                k++;
	        }
            CONV_RGB2YUV(encoder_reg, RInput, GInput, BInput, Y, U, V, ROutput, GOutput, BOutput);
            VALID_YCbCr++;
        }
        else if(H_COUNTER == encoder_reg->SERREQ_AREA0)
        {
            Start_i = (VALID_YCbCr-1)* encoder_reg->ACTIVE_TOTAL_PIXEL;
            End_i   = (VALID_YCbCr)  * encoder_reg->ACTIVE_TOTAL_PIXEL;

	        for(i = Start_i; i < End_i; i+=4)
	        {
		        RInput[k] = encoder_reg->RGB[i];
		        GInput[k] = encoder_reg->RGB[i+1];
		        BInput[k] = encoder_reg->RGB[i+2];
                k++;
	        }
            CONV_RGB2YUV(encoder_reg, RInput, GInput, BInput, Y, U, V, ROutput, GOutput, BOutput);
        }
    }

    if(VsyncEnable == DISABLE)
    {
        BURST_TYPE   = PHASE_TYPE_CHK(encoder_reg, H_COUNTER);

        SUB_ADDR_GEN(encoder_reg, H_COUNTER);
        SINCOS_GEN(encoder_reg);
        
        // burst envelop and U & V filled
        UV_GEN(encoder_reg, U, V, BURST_TYPE, DISPLAY_TYPE, H_COUNTER); 

        /* process */
        if(H_COUNTER == encoder_reg->SERREQ_AREA0)
            SERREQ_GEN_ACTIVE_DIS(encoder_reg, Y, ROutput, GOutput, BOutput);
        else
            NORMAL_HSYNC_GEN(encoder_reg, Y, DISPLAY_TYPE, ROutput, GOutput, BOutput);

        LUMA_GEN(encoder_reg);
        CHRO_GEN(encoder_reg);
    }
}

int vsync_detect(reg_type *encoder_reg, int H_COUNTER)
{
    /* Equalizing generation */
    if(
            (
                H_COUNTER >= encoder_reg->EQUALIZING_AREA0_START &&
                H_COUNTER <= encoder_reg->EQUALIZING_AREA0_END  
            ) ||
            (
                H_COUNTER >= encoder_reg->EQUALIZING_AREA1_START &&
                H_COUNTER <= encoder_reg->EQUALIZING_AREA1_END  
            ) ||
            (
                H_COUNTER >= encoder_reg->EQUALIZING_AREA2_START &&
                H_COUNTER <= encoder_reg->EQUALIZING_AREA2_END  
            ) ||
            (
                H_COUNTER >= encoder_reg->EQUALIZING_AREA3_START &&
                H_COUNTER <= encoder_reg->EQUALIZING_AREA3_END  
            )
      )
    {
        EQUALIZING_GEN(encoder_reg);
        LUMA_GEN(encoder_reg);
        BLANK_CHRO_GEN(encoder_reg);
        return ENABLE;
    }

    /* Serration generation */
    else if(
            (
                H_COUNTER >= encoder_reg->SERRATION_AREA0_START &&
                H_COUNTER <= encoder_reg->SERRATION_AREA0_END
            ) ||
            (
                H_COUNTER >= encoder_reg->SERRATION_AREA1_START &&
                H_COUNTER <= encoder_reg->SERRATION_AREA1_END
            )
      )
    {
        SERRATION_GEN(encoder_reg, H_COUNTER);
        LUMA_GEN(encoder_reg);
        BLANK_CHRO_GEN(encoder_reg);
        return ENABLE;
    }

    /* Serration & Equalizing non-active video generation */
    else if(H_COUNTER == encoder_reg->SERREQ_AREA1)
    {
        SERREQ_GEN(encoder_reg);
        LUMA_GEN(encoder_reg);
        BLANK_CHRO_GEN(encoder_reg);
        return ENABLE;
    }

    /* Equalizing & Serration non-active video generation */
    else if(H_COUNTER == encoder_reg->EQSERR_AREA0)
    {
        EQSERR_GEN(encoder_reg);
        LUMA_GEN(encoder_reg);
        BLANK_CHRO_GEN(encoder_reg);
        return ENABLE;
    }


    /* Equalizing & Blank non-active video generation */
    else if(H_COUNTER == encoder_reg->EQBLANK_AREA0)
    {
        EQBLANK_GEN(encoder_reg);
        LUMA_GEN(encoder_reg);
        BLANK_CHRO_GEN(encoder_reg);
        return ENABLE;
    }
    else
        return DISABLE;
}


void encoder(reg_type *encoder_reg)
{
    //int H_COUNTER = 1;
    int VsyncArea = 0;
    int EndCnt = 0;

    encoder_reg->F_COUNTER = 1;
    while(1)
    {
        /* vsync area detect process */
        VsyncArea = vsync_detect(encoder_reg, H_COUNTER);
        
        /* burst & HSYNC & color signal process */
        normal_area(encoder_reg, H_COUNTER, VsyncArea);

        if(H_COUNTER == encoder_reg->TOTAL_LINE) 
        {
            F_COUNTER++;
            H_COUNTER = 1;
        }
        else
        {
            H_COUNTER++;
        }

        /* Fields */
        if(EndCnt  >= encoder_reg->TOTAL_FIELDS) 
        {
            printf("make %d set of NTSC(4fields) or PAL(8fields)\n", EndCnt);
            break; 
        }
        else
        {
            if(H_COUNTER == encoder_reg->CHANGE_FIELDS0)
                encoder_reg->F_COUNTER++;

            if(H_COUNTER == encoder_reg->CHANGE_FIELDS1 && encoder_reg->EN_INTERLACE == ENABLE)
                encoder_reg->F_COUNTER++;

            if(encoder_reg->F_COUNTER >8 && encoder_reg->OUT_MODE == VIDEO_PAL)
            {
                encoder_reg->F_COUNTER = 1;
                EndCnt++;
            }

            if(encoder_reg->F_COUNTER >8 && encoder_reg->OUT_MODE == VIDEO_MPAL)
            {
                encoder_reg->F_COUNTER = 1;
                EndCnt++;
            }

            if(encoder_reg->F_COUNTER >4 && encoder_reg->OUT_MODE == VIDEO_NTSC)
            {
                encoder_reg->F_COUNTER = 1;
                EndCnt++;
            }
        }
    }

}

void init_process_encoder(reg_type *encoder_reg)
{

/* NTSC mode */
    if(encoder_reg->OUT_MODE == VIDEO_NTSC  || encoder_reg->OUT_MODE == VIDEO_NTSCJ ||
       encoder_reg->OUT_MODE == VIDEO_NTSC4 
       && encoder_reg->EN_INTERLACE == ENABLE) {


        /* NTSC-J mode */
        if(encoder_reg->OUT_MODE == VIDEO_NTSCJ)  
            encoder_reg->BLACK_VALUE  = BLANK_VALUE_NTSC;
        else
            encoder_reg->BLACK_VALUE  = BLACK_VALUE_NTSC;

        encoder_reg->BLANK_VALUE  = BLANK_VALUE_NTSC;
        encoder_reg->HSYNC_LOW    = HSYNC_LOW_NTSC;

        /* NTSC-J mode */
        if(encoder_reg->OUT_MODE == VIDEO_NTSCJ)  {
	        encoder_reg->YSCALE =   YSCALE_NTSCJ;
            encoder_reg->USCALE =   USCALE_NTSCJ;
            encoder_reg->VSCALE =   VSCALE_NTSCJ;
        } else {
	        encoder_reg->YSCALE =   YSCALE_NTSC;
            encoder_reg->USCALE =   USCALE_NTSC;
            encoder_reg->VSCALE =   VSCALE_NTSC;
        }

        /* NTSC-4.43 */
        if(encoder_reg->OUT_MODE == VIDEO_NTSC4) 
            encoder_reg->SUBGEN_ADDR_STEP = SUBGEN_ADDR_STEP_PAL; //4.43Mhz
        else
            encoder_reg->SUBGEN_ADDR_STEP = SUBGEN_ADDR_STEP_NTSC;//3.57Mhz

        encoder_reg->TOTAL_FIELDS     = TOTAL_FIELDS_NTSC;

        encoder_reg->TOTAL_LINE       = TOTAL_LINE_NTSC; 
                    //total line number of NTSC or PAL
                    // NTSC = 525 interlace 262 non-interlace
                    // PAL  = 625 interlace 312 non-interlace
    
        encoder_reg->TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_NTSC;
        encoder_reg->CHANGE_FIELDS0     = CHANGE_FIELDS0_NTSC; 
        encoder_reg->CHANGE_FIELDS1     = CHANGE_FIELDS1_NTSC;


        if((encoder_reg->INPUT_MODE == INPUT_RGB) && (encoder_reg->EN_SQPIXEL == DISABLE))
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_NTSC_RGB;
        else if((encoder_reg->INPUT_MODE == INPUT_Ycbcr) && (encoder_reg->EN_SQPIXEL == DISABLE))
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_NTSC;
        else if((encoder_reg->INPUT_MODE == INPUT_RGB) && (encoder_reg->EN_SQPIXEL == ENABLE))
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_SQ_NTSC_RGB;
        else if((encoder_reg->INPUT_MODE == INPUT_Ycbcr) && (encoder_reg->EN_SQPIXEL == ENABLE))
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_SQ_NTSC;

                    // YCbCr foramt/////////
                    // NTSC = 720*2 normal
                    // NTSC = 640*2 square 
                    // PAL  = 720*2 normal
                    // PAL  = 768*2 square 
                    
                    // RGB foramt/////////
                    // NTSC = 720*3 normal
                    // NTSC = 640*3 square 
                    // PAL  = 720*3 normal
                    // PAL  = 768*3 square 

        if(encoder_reg->EN_SQPIXEL == DISABLE) {
            /* Normal mode */
            encoder_reg->TOTAL_PIXEL = TOTAL_PIXEL_NTSC;
            encoder_reg->BURST_MAX      =   BURST_MAX_NTSC;
            encoder_reg->HSYNC_START    =   HSYNC_START_NTSC;
            encoder_reg->HSYNC_WIDTH    =   HSYNC_WIDTH_NTSC;
            encoder_reg->BURST_START    =   BURST_START_NTSC;
            encoder_reg->BURST_WIDTH    =   BURST_WIDTH_NTSC;
            encoder_reg->COLOR_START    =   COLOR_START_NTSC;
            encoder_reg->HSYNC_SLOPE    =   HSYNC_SLOPE_NTSC;
            encoder_reg->BURST_SLOPE    =   BURST_SLOPE_NTSC;
            encoder_reg->BLANK_VALUE    =   BLANK_VALUE_NTSC;
        
        } else {
            /* Square mode */
            encoder_reg->TOTAL_PIXEL = TOTAL_PIXEL_SQ_NTSC;
            encoder_reg->BURST_MAX      =   BURST_MAX_NTSC;
            encoder_reg->HSYNC_START    =   HSYNC_START_SQ_NTSC;
            encoder_reg->HSYNC_WIDTH    =   HSYNC_WIDTH_SQ_NTSC;
            encoder_reg->BURST_START    =   BURST_START_SQ_NTSC;
            encoder_reg->BURST_WIDTH    =   BURST_WIDTH_SQ_NTSC;
            encoder_reg->COLOR_START    =   COLOR_START_SQ_NTSC;
            encoder_reg->HSYNC_SLOPE    =   HSYNC_SLOPE_SQ_NTSC;
            encoder_reg->BURST_SLOPE    =   BURST_SLOPE_NTSC;
            encoder_reg->BLANK_VALUE    =   BLANK_VALUE_NTSC;
        }

    /* Equalizing area 0~3 */
        encoder_reg->EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_NTSC;
        encoder_reg->EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_NTSC;
        encoder_reg->EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_NTSC;
        encoder_reg->EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_NTSC;
        encoder_reg->EQUALIZING_AREA2_START = EQUALIZING_AREA2_START_NTSC;
        encoder_reg->EQUALIZING_AREA2_END   = EQUALIZING_AREA2_END_NTSC;
        encoder_reg->EQUALIZING_AREA3_START = EQUALIZING_AREA3_START_NTSC;
        encoder_reg->EQUALIZING_AREA3_END   = EQUALIZING_AREA3_END_NTSC;

    /* Serration area 0~1 */
        encoder_reg->SERRATION_AREA0_START  = SERRATION_AREA0_START_NTSC;
        encoder_reg->SERRATION_AREA0_END    = SERRATION_AREA0_END_NTSC;
        encoder_reg->SERRATION_AREA1_START  = SERRATION_AREA1_START_NTSC;
        encoder_reg->SERRATION_AREA1_END    = SERRATION_AREA1_END_NTSC;

    /* Serration and Equalizing area 0  include active video*/
        encoder_reg->SERREQ_AREA0           = SERREQ_AREA0_NTSC;

    /* Serration and Equalizing area 1 non-active video*/
        encoder_reg->SERREQ_AREA1           = SERREQ_AREA1_NTSC;

    /* Equalizing area */
        encoder_reg->EQSERR_AREA0           = EQSERR_AREA0_NTSC;

    /* Equalizing and blank area */
        encoder_reg->EQBLANK_AREA0          = EQBLANK_AREA0_NTSC;

    /* re-setting Video mode */
        encoder_reg->OUT_MODE = VIDEO_NTSC;

    } else if(encoder_reg->OUT_MODE == VIDEO_NTSC && encoder_reg->EN_INTERLACE == DISABLE) {

        encoder_reg->BLANK_VALUE  = BLANK_VALUE_NTSC;
        encoder_reg->BLACK_VALUE  = BLACK_VALUE_NTSC;
        encoder_reg->HSYNC_LOW    = HSYNC_LOW_NTSC;

	    encoder_reg->YSCALE =   YSCALE_NTSC;
        encoder_reg->USCALE =   USCALE_NTSC;
        encoder_reg->VSCALE =   VSCALE_NTSC;

        encoder_reg->SUBGEN_ADDR_STEP = SUBGEN_ADDR_STEP_NTSC;
        encoder_reg->TOTAL_FIELDS     = TOTAL_FIELDS_NTSC;
        encoder_reg->TOTAL_LINE       = TOTAL_LINE_NTSC_NOINTER; 
                    //total line number of NTSC or PAL
                    // NTSC = 525 interlace 262 non-interlace
                    // PAL  = 625 interlace 312 non-interlace
    
        encoder_reg->TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_NTSC_NOINTER;
        encoder_reg->CHANGE_FIELDS0 = CHANGE_FIELDS0_NTSC_NOINTER; 
        encoder_reg->CHANGE_FIELDS1 = CHANGE_FIELDS1_NTSC; //not used

        encoder_reg->TOTAL_PIXEL = TOTAL_PIXEL_NTSC;

        if(encoder_reg->INPUT_MODE == INPUT_RGB)
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_NTSC_RGB;
        else
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_NTSC;
                    // YCbCr foramt/////////
                    // NTSC = 720*2 normal
                    // NTSC = 640*2 square 
                    // PAL  = 720*2 normal
                    // PAL  = 768*2 square 
                    
                    // RGB foramt/////////
                    // NTSC = 720*3 normal
                    // NTSC = 640*3 square 
                    // PAL  = 720*3 normal
                    // PAL  = 768*3 square 

        encoder_reg->BURST_MAX      =   BURST_MAX_NTSC;
        encoder_reg->HSYNC_START    =   HSYNC_START_NTSC;
        encoder_reg->HSYNC_WIDTH    =   HSYNC_WIDTH_NTSC;
        encoder_reg->BURST_START    =   BURST_START_NTSC;
        encoder_reg->BURST_WIDTH    =   BURST_WIDTH_NTSC;
        encoder_reg->COLOR_START    =   COLOR_START_NTSC;
        encoder_reg->HSYNC_SLOPE    =   HSYNC_SLOPE_NTSC;
        encoder_reg->BURST_SLOPE    =   BURST_SLOPE_NTSC;
        encoder_reg->BLANK_VALUE    =   BLANK_VALUE_NTSC;


    /* Equalizing area 0~3 */
        encoder_reg->EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_NTSC_NOINTER;
        encoder_reg->EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_NTSC_NOINTER;
        encoder_reg->EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_NTSC_NOINTER;
        encoder_reg->EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_NTSC_NOINTER;

    /* Serration area 0~1 */
        encoder_reg->SERRATION_AREA0_START  = SERRATION_AREA0_START_NTSC_NOINTER;
        encoder_reg->SERRATION_AREA0_END    = SERRATION_AREA0_END_NTSC_NOINTER;

    /* Serration and Equalizing area 0  include active video*/

    /* Serration and Equalizing area 1 non-active video*/

    /* Equalizing area */

    /* Equalizing and blank area */

/* PAL mode */
    } else if(encoder_reg->OUT_MODE == VIDEO_PALNc || encoder_reg->OUT_MODE == VIDEO_PALN ||
              encoder_reg->OUT_MODE == VIDEO_PAL   && encoder_reg->EN_INTERLACE == ENABLE) {

        /* PAL-N mode */
        if(encoder_reg->OUT_MODE == VIDEO_PALN)
            encoder_reg->BLACK_VALUE  = BLACK_VALUE_NTSC;
        else
            encoder_reg->BLACK_VALUE  = BLACK_VALUE_PAL;

        encoder_reg->BLANK_VALUE  = BLANK_VALUE_PAL;
        encoder_reg->HSYNC_LOW    = HSYNC_LOW_PAL;

	    encoder_reg->YSCALE =   YSCALE_PAL;
        encoder_reg->USCALE =   USCALE_PAL;
        encoder_reg->VSCALE =   VSCALE_PAL;

        /* PAL-Nc mode */
        if(encoder_reg->OUT_MODE == VIDEO_PALNc)
            encoder_reg->SUBGEN_ADDR_STEP = SUBGEN_ADDR_STEP_NTSC; //3.5Mhz
        else
            encoder_reg->SUBGEN_ADDR_STEP = SUBGEN_ADDR_STEP_PAL;  //4.32Mhz

        encoder_reg->TOTAL_FIELDS = TOTAL_FIELDS_PAL;
        encoder_reg->TOTAL_LINE = TOTAL_LINE_PAL; 
                    //total line number of NTSC or PAL
                    // NTSC = 525 interlace 262 non-interlace
                    // PAL  = 625 interlace 312 non-interlace
    
        encoder_reg->TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_PAL;
        encoder_reg->CHANGE_FIELDS0 = CHANGE_FIELDS0_PAL; 
        encoder_reg->CHANGE_FIELDS1 = CHANGE_FIELDS1_PAL;


        if     ((encoder_reg->INPUT_MODE == INPUT_RGB)   && (encoder_reg->EN_SQPIXEL == DISABLE))
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_PAL_RGB;
        else if((encoder_reg->INPUT_MODE == INPUT_Ycbcr) && (encoder_reg->EN_SQPIXEL == DISABLE))
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_PAL;
        else if((encoder_reg->INPUT_MODE == INPUT_RGB)   && (encoder_reg->EN_SQPIXEL == ENABLE))
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_SQ_PAL_RGB;
        else if((encoder_reg->INPUT_MODE == INPUT_Ycbcr) && (encoder_reg->EN_SQPIXEL == ENABLE))
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_SQ_PAL;
                    // YCbCr foramt/////////
                    // NTSC = 720*2 normal
                    // NTSC = 640*2 square 
                    // PAL  = 720*2 normal
                    // PAL  = 768*2 square 
                    
                    // RGB foramt/////////
                    // NTSC = 720*3 normal
                    // NTSC = 640*3 square 
                    // PAL  = 720*3 normal
                    // PAL  = 768*3 square 

        if(encoder_reg->EN_SQPIXEL == DISABLE) {
            encoder_reg->TOTAL_PIXEL = TOTAL_PIXEL_PAL;
            encoder_reg->BURST_MAX      =   BURST_MAX_PAL;
            encoder_reg->HSYNC_START    =   HSYNC_START_PAL;
            encoder_reg->HSYNC_WIDTH    =   HSYNC_WIDTH_PAL;
            encoder_reg->BURST_START    =   BURST_START_PAL;
            encoder_reg->BURST_WIDTH    =   BURST_WIDTH_PAL;
            encoder_reg->COLOR_START    =   COLOR_START_PAL;
            encoder_reg->HSYNC_SLOPE    =   HSYNC_SLOPE_PAL;
            encoder_reg->BURST_SLOPE    =   BURST_SLOPE_PAL;
            encoder_reg->BLANK_VALUE    =   BLANK_VALUE_PAL;
        } else {
            encoder_reg->TOTAL_PIXEL = TOTAL_PIXEL_SQ_PAL;
            encoder_reg->BURST_MAX      =   BURST_MAX_PAL;
            encoder_reg->HSYNC_START    =   HSYNC_START_SQ_PAL;
            encoder_reg->HSYNC_WIDTH    =   HSYNC_WIDTH_SQ_PAL;
            encoder_reg->BURST_START    =   BURST_START_SQ_PAL;
            encoder_reg->BURST_WIDTH    =   BURST_WIDTH_SQ_PAL;
            encoder_reg->COLOR_START    =   COLOR_START_SQ_PAL;
            encoder_reg->HSYNC_SLOPE    =   HSYNC_SLOPE_SQ_PAL;
            encoder_reg->BURST_SLOPE    =   BURST_SLOPE_SQ_PAL;
            encoder_reg->BLANK_VALUE    =   BLANK_VALUE_PAL;
        }

    /* Equalizing area 0~3 */
        encoder_reg->EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_PAL;
        encoder_reg->EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_PAL;
        encoder_reg->EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_PAL;
        encoder_reg->EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_PAL;
        encoder_reg->EQUALIZING_AREA2_START = EQUALIZING_AREA2_START_PAL;
        encoder_reg->EQUALIZING_AREA2_END   = EQUALIZING_AREA2_END_PAL;
        encoder_reg->EQUALIZING_AREA3_START = EQUALIZING_AREA3_START_PAL;
        encoder_reg->EQUALIZING_AREA3_END   = EQUALIZING_AREA3_END_PAL;

    /* Serration area 0~1 */
        encoder_reg->SERRATION_AREA0_START  = SERRATION_AREA0_START_PAL;
        encoder_reg->SERRATION_AREA0_END    = SERRATION_AREA0_END_PAL;
        encoder_reg->SERRATION_AREA1_START  = SERRATION_AREA1_START_PAL;
        encoder_reg->SERRATION_AREA1_END    = SERRATION_AREA1_END_PAL;

    /* Serration and Equalizing area 0  include active video*/
        encoder_reg->SERREQ_AREA0           = SERREQ_AREA0_PAL;

    /* Serration and Equalizing area 1 non-active video*/
        encoder_reg->SERREQ_AREA1           = SERREQ_AREA1_PAL;

    /* Equalizing area */
        encoder_reg->EQSERR_AREA0           = EQSERR_AREA0_PAL;

    /* Equalizing and blank area */
        encoder_reg->EQBLANK_AREA0          = EQBLANK_AREA0_PAL;

    /* re-setting Video mode */
        encoder_reg->OUT_MODE = VIDEO_PAL;

    } else if(encoder_reg->OUT_MODE == VIDEO_PAL && encoder_reg->EN_INTERLACE == DISABLE) {

        encoder_reg->BLANK_VALUE  = BLANK_VALUE_PAL;
        encoder_reg->BLACK_VALUE  = BLACK_VALUE_PAL;
        encoder_reg->HSYNC_LOW    = HSYNC_LOW_PAL;

	    encoder_reg->YSCALE =   YSCALE_PAL;
        encoder_reg->USCALE =   USCALE_PAL;
        encoder_reg->VSCALE =   VSCALE_PAL;

        encoder_reg->SUBGEN_ADDR_STEP = SUBGEN_ADDR_STEP_PAL;
        encoder_reg->TOTAL_FIELDS = TOTAL_FIELDS_PAL;
        encoder_reg->TOTAL_LINE = TOTAL_LINE_PAL_NOINTER; 
                    //total line number of NTSC or PAL
                    // NTSC = 525 interlace 262 non-interlace
                    // PAL  = 625 interlace 312 non-interlace
    
        encoder_reg->TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_PAL_NOINTER;
        encoder_reg->CHANGE_FIELDS0 = CHANGE_FIELDS0_PAL_NOINTER; 

        encoder_reg->TOTAL_PIXEL = TOTAL_PIXEL_PAL;

        if(encoder_reg->INPUT_MODE == INPUT_RGB)
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_PAL_RGB;
        else
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_PAL;
                    // YCbCr foramt/////////
                    // NTSC = 720*2 normal
                    // NTSC = 640*2 square 
                    // PAL  = 720*2 normal
                    // PAL  = 768*2 square 
                    
                    // RGB foramt/////////
                    // NTSC = 720*3 normal
                    // NTSC = 640*3 square 
                    // PAL  = 720*3 normal
                    // PAL  = 768*3 square 

        encoder_reg->BURST_MAX      =   BURST_MAX_PAL;
        encoder_reg->HSYNC_START    =   HSYNC_START_PAL;
        encoder_reg->HSYNC_WIDTH    =   HSYNC_WIDTH_PAL;
        encoder_reg->BURST_START    =   BURST_START_PAL;
        encoder_reg->BURST_WIDTH    =   BURST_WIDTH_PAL;
        encoder_reg->COLOR_START    =   COLOR_START_PAL;
        encoder_reg->HSYNC_SLOPE    =   HSYNC_SLOPE_PAL;
        encoder_reg->BURST_SLOPE    =   BURST_SLOPE_PAL;
        encoder_reg->BLANK_VALUE    =   BLANK_VALUE_PAL;

    /* Equalizing area 0~3 */
        encoder_reg->EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_PAL_NOINTER;
        encoder_reg->EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_PAL_NOINTER;
        encoder_reg->EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_PAL_NOINTER;
        encoder_reg->EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_PAL_NOINTER;

    /* Serration area 0~1 */
        encoder_reg->SERRATION_AREA0_START  = SERRATION_AREA0_START_PAL_NOINTER;
        encoder_reg->SERRATION_AREA0_END    = SERRATION_AREA0_END_PAL_NOINTER;

    /* Serration and Equalizing area 0  include active video*/


    /* Serration and Equalizing area 1 non-active video*/
        encoder_reg->SERREQ_AREA1           = SERREQ_AREA1_PAL_NOINTER;

    /* Equalizing area */

    /* Equalizing and blank area */

    } else if(encoder_reg->OUT_MODE == VIDEO_MPAL && encoder_reg->EN_INTERLACE == ENABLE) {

        encoder_reg->BLANK_VALUE  = BLANK_VALUE_NTSC;
        encoder_reg->BLACK_VALUE  = BLACK_VALUE_NTSC;
        encoder_reg->HSYNC_LOW    = HSYNC_LOW_NTSC;

	    encoder_reg->YSCALE =   YSCALE_NTSC;
        encoder_reg->USCALE =   USCALE_NTSC;
        encoder_reg->VSCALE =   VSCALE_NTSC;

        encoder_reg->SUBGEN_ADDR_STEP = SUBGEN_ADDR_STEP_NTSC;
        encoder_reg->TOTAL_FIELDS     = TOTAL_FIELDS_NTSC;
        encoder_reg->TOTAL_LINE       = TOTAL_LINE_NTSC; 
                    //total line number of NTSC or PAL
                    // NTSC = 525 interlace 262 non-interlace
                    // PAL  = 625 interlace 312 non-interlace
    
        encoder_reg->TOTAL_DISPLAY_LINE = TOTAL_DISPLAY_LINE_NTSC;
        encoder_reg->CHANGE_FIELDS0     = CHANGE_FIELDS0_NTSC; 
        encoder_reg->CHANGE_FIELDS1     = CHANGE_FIELDS1_NTSC;

        encoder_reg->TOTAL_PIXEL = TOTAL_PIXEL_PAL;

        if(encoder_reg->INPUT_MODE == INPUT_RGB)
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_PAL_RGB;
        else
            encoder_reg->ACTIVE_TOTAL_PIXEL = ACTIVE_TOTAL_PIXEL_PAL;
                    // YCbCr foramt/////////
                    // NTSC = 720*2 normal
                    // NTSC = 640*2 square 
                    // PAL  = 720*2 normal
                    // PAL  = 768*2 square 
                    
                    // RGB foramt/////////
                    // NTSC = 720*3 normal
                    // NTSC = 640*3 square 
                    // PAL  = 720*3 normal
                    // PAL  = 768*3 square 

        encoder_reg->BURST_MAX      =   BURST_MAX_PAL;
        encoder_reg->HSYNC_START    =   HSYNC_START_PAL;
        encoder_reg->HSYNC_WIDTH    =   HSYNC_WIDTH_PAL;
        encoder_reg->BURST_START    =   BURST_START_PAL;
        encoder_reg->BURST_WIDTH    =   BURST_WIDTH_PAL;
        encoder_reg->COLOR_START    =   COLOR_START_PAL;
        encoder_reg->HSYNC_SLOPE    =   HSYNC_SLOPE_PAL;
        encoder_reg->BURST_SLOPE    =   BURST_SLOPE_PAL;


    /* Equalizing area 0~3 */
        encoder_reg->EQUALIZING_AREA0_START = EQUALIZING_AREA0_START_MPAL;
        encoder_reg->EQUALIZING_AREA0_END   = EQUALIZING_AREA0_END_MPAL;
        encoder_reg->EQUALIZING_AREA1_START = EQUALIZING_AREA1_START_MPAL;
        encoder_reg->EQUALIZING_AREA1_END   = EQUALIZING_AREA1_END_MPAL;
        encoder_reg->EQUALIZING_AREA2_START = EQUALIZING_AREA2_START_MPAL;
        encoder_reg->EQUALIZING_AREA2_END   = EQUALIZING_AREA2_END_MPAL;
        encoder_reg->EQUALIZING_AREA3_START = EQUALIZING_AREA3_START_MPAL;
        encoder_reg->EQUALIZING_AREA3_END   = EQUALIZING_AREA3_END_MPAL;

    /* Serration area 0~1 */
        encoder_reg->SERRATION_AREA0_START  = SERRATION_AREA0_START_MPAL;
        encoder_reg->SERRATION_AREA0_END    = SERRATION_AREA0_END_MPAL;
        encoder_reg->SERRATION_AREA1_START  = SERRATION_AREA1_START_MPAL;
        encoder_reg->SERRATION_AREA1_END    = SERRATION_AREA1_END_MPAL;

    /* Serration and Equalizing area 0  include active video*/
        encoder_reg->SERREQ_AREA0           = SERREQ_AREA0_MPAL;

    /* Serration and Equalizing area 1 non-active video*/
        encoder_reg->SERREQ_AREA1           = SERREQ_AREA1_MPAL;

    /* Equalizing area */
        encoder_reg->EQSERR_AREA0           = EQSERR_AREA0_MPAL;

    /* Equalizing and blank area */
        encoder_reg->EQBLANK_AREA0          = EQBLANK_AREA0_MPAL;

    }
}

int main(int argc, char *argv[])
{
	int i;
	unsigned char BT601[720*3*TOTAL_LINE_PAL];	/* maximum */
	int readsize;
	FILE *fp;
	reg_type encoder_reg;

    char *Out_C_filename = "./OUT/out_c.out";
    char *Out_Y_filename = "./OUT/out_y.out";
    char *Out_COM_filename = "./OUT/out_com.out";

    ofp_Sim8bitOut  = fopen("./OUT/OUT8bit", "w");

    ofp_mode2_HSYNC = fopen("./Tb/mode2/HSYNC.in", "w");
    ofp_mode2_BLANK = fopen("./Tb/mode2/BLANK.in", "w");
    ofp_mode2_VSYNC = fopen("./Tb/mode2/VSYNC.in", "w");
    ofp_mode2_RGB   = fopen("./Tb/mode2/RGB.in", "w");


#ifdef RTL_DEBUG
    ofp_U = fopen("./Tb/U.in", "w");
    ofp_V = fopen("./Tb/V.in", "w");
    ofp_SIN = fopen("./Tb/SIN.in", "w");
    ofp_COS = fopen("./Tb/COS.in", "w");

    ofp_MUL_USIN = fopen("./Tb/USIN.in", "w"); 
    ofp_MUL_VCOS = fopen("./Tb/VSIN.in", "w");
    ofp_ADD = fopen("./Tb/ADD.in", "w");

    ofp_Yout = fopen("./Tb/Yout.in", "w");
    ofp_Uout = fopen("./Tb/Uout.in", "w");
    ofp_Vout = fopen("./Tb/Vout.in", "w");
#endif


	if(argc != 5)
	{
		fprintf(stderr, "Usage:%s {ntsc|ntscj|ntsc4|pal|palN|palNc|mpal|noninterntsc|noninterpal} {rgb|ycbcr} {square|normal} inputfile\n", argv[0]);
		exit(1);
	}

	if(!strcasecmp(argv[1], "ntsc")) {
		encoder_reg.OUT_MODE = VIDEO_NTSC;
        encoder_reg.EN_INTERLACE = ENABLE;
    } else if(!strcasecmp(argv[1], "ntscj")) {
		encoder_reg.OUT_MODE = VIDEO_NTSCJ;
        encoder_reg.EN_INTERLACE = ENABLE;
    } else if(!strcasecmp(argv[1], "ntsc4")) {
		encoder_reg.OUT_MODE = VIDEO_NTSC4;
        encoder_reg.EN_INTERLACE = ENABLE;
    } else if(!strcasecmp(argv[1], "palN")) {
		encoder_reg.OUT_MODE = VIDEO_PALN;
        encoder_reg.EN_INTERLACE = ENABLE;
    } else if(!strcasecmp(argv[1], "palNc")) {
		encoder_reg.OUT_MODE = VIDEO_PALNc;
        encoder_reg.EN_INTERLACE = ENABLE;
	} else if(!strcasecmp(argv[1], "pal")) {
		encoder_reg.OUT_MODE = VIDEO_PAL;
        encoder_reg.EN_INTERLACE = ENABLE;
	} else if(!strcasecmp(argv[1], "mpal")) {
		encoder_reg.OUT_MODE = VIDEO_MPAL;
        encoder_reg.EN_INTERLACE = ENABLE;
	} else if(!strcasecmp(argv[1], "noninterntsc")) {
		encoder_reg.OUT_MODE = VIDEO_NTSC;
        encoder_reg.EN_INTERLACE = DISABLE;
	} else if(!strcasecmp(argv[1], "noninterpal")) {
		encoder_reg.OUT_MODE = VIDEO_PAL;
        encoder_reg.EN_INTERLACE = DISABLE;
	} else {
		fprintf(stderr, "Usage:%s {ntsc|ntscj|ntsc4|pal|palN|palNc|mpal|noninterntsc|noninterpal} {rgb|ycbcr} {square|normal} inputfile\n", argv[0]);
		exit(1);
	}

    if(!strcasecmp(argv[2], "rgb"))
	{
		encoder_reg.INPUT_MODE = INPUT_RGB;
	}
    else if(!strcasecmp(argv[2], "ycbcr"))
	{
		encoder_reg.INPUT_MODE = INPUT_Ycbcr;
	}
	else
	{
		fprintf(stderr, "Usage:%s {ntsc|ntscj|ntsc4|pal|palN|palNc|mpal|noninterntsc|noninterpal} {rgb|ycbcr} {square|normal} inputfile\n", argv[0]);
		exit(1);
	}

    if(!strcasecmp(argv[3], "square"))
		encoder_reg.EN_SQPIXEL = ENABLE;
    else if(!strcasecmp(argv[3], "normal"))
		encoder_reg.EN_SQPIXEL = DISABLE;
	else
	{
		fprintf(stderr, "Usage:%s {ntsc|ntscj|ntsc4|pal|palN|palNc|mpal|noninterntsc|noninterpal} {rgb|ycbcr} {square|normal} inputfile\n", argv[0]);
		exit(1);
	}

    /* NTSC */
	if((encoder_reg.OUT_MODE   == VIDEO_NTSC) &&
	   (encoder_reg.INPUT_MODE == INPUT_RGB)  && encoder_reg.EN_SQPIXEL == DISABLE) {
		readsize = ACTIVE_TOTAL_PIXEL_NTSC_RGB * TOTAL_DISPLAY_LINE_NTSC;

    } else if((encoder_reg.OUT_MODE  == VIDEO_NTSC) &&
	       (encoder_reg.INPUT_MODE == INPUT_Ycbcr)  && encoder_reg.EN_SQPIXEL == DISABLE) {
		readsize = TOTAL_PIXEL_NTSC * TOTAL_LINE_NTSC ;

    } else if((encoder_reg.OUT_MODE   == VIDEO_NTSC) &&
	   (encoder_reg.INPUT_MODE == INPUT_RGB)  && encoder_reg.EN_SQPIXEL == ENABLE) {
		readsize = ACTIVE_TOTAL_PIXEL_SQ_NTSC_RGB * TOTAL_DISPLAY_LINE_NTSC;

    } else if((encoder_reg.OUT_MODE  == VIDEO_NTSC) &&
	       (encoder_reg.INPUT_MODE == INPUT_Ycbcr)  && encoder_reg.EN_SQPIXEL == ENABLE) {
		readsize = TOTAL_PIXEL_SQ_NTSC * TOTAL_LINE_NTSC ;

    /* NTSC-J */
    } else if((encoder_reg.OUT_MODE   == VIDEO_NTSCJ) &&
	   (encoder_reg.INPUT_MODE == INPUT_RGB)) {
		readsize = ACTIVE_TOTAL_PIXEL_NTSC_RGB * TOTAL_DISPLAY_LINE_NTSC;

    } else if((encoder_reg.OUT_MODE  == VIDEO_NTSCJ) &&
	       (encoder_reg.INPUT_MODE == INPUT_Ycbcr)) {
		readsize = TOTAL_PIXEL_NTSC * TOTAL_LINE_NTSC ;

    /* NTSC-4.43 */
    } else if((encoder_reg.OUT_MODE   == VIDEO_NTSC4) &&
	   (encoder_reg.INPUT_MODE == INPUT_RGB)) {
		readsize = ACTIVE_TOTAL_PIXEL_NTSC_RGB * TOTAL_DISPLAY_LINE_NTSC;

    } else if((encoder_reg.OUT_MODE  == VIDEO_NTSC4) &&
	       (encoder_reg.INPUT_MODE == INPUT_Ycbcr)) {
		readsize = TOTAL_PIXEL_NTSC * TOTAL_LINE_NTSC ;

    /* PAL */
    } else if((encoder_reg.OUT_MODE  == VIDEO_PAL)  &&
	          (encoder_reg.INPUT_MODE == INPUT_RGB) && encoder_reg.EN_SQPIXEL == DISABLE){
		readsize = ACTIVE_TOTAL_PIXEL_PAL_RGB * TOTAL_DISPLAY_LINE_PAL;

    } else if((encoder_reg.OUT_MODE  == VIDEO_PAL) &&
	       (encoder_reg.INPUT_MODE == INPUT_Ycbcr) && encoder_reg.EN_SQPIXEL == DISABLE){
		readsize = TOTAL_PIXEL_PAL * TOTAL_LINE_PAL ;

    } else if((encoder_reg.OUT_MODE  == VIDEO_PAL)  &&
	          (encoder_reg.INPUT_MODE == INPUT_RGB) && encoder_reg.EN_SQPIXEL == ENABLE){
		readsize = ACTIVE_TOTAL_PIXEL_SQ_PAL_RGB * TOTAL_DISPLAY_LINE_PAL;

    } else if((encoder_reg.OUT_MODE  == VIDEO_PAL) &&
	       (encoder_reg.INPUT_MODE == INPUT_Ycbcr) && encoder_reg.EN_SQPIXEL == ENABLE){
		readsize = TOTAL_PIXEL_SQ_PAL * TOTAL_LINE_PAL ;

    /* PAL Nc */
    } else if((encoder_reg.OUT_MODE  == VIDEO_PALNc) &&
	       (encoder_reg.INPUT_MODE == INPUT_RGB)) {
		readsize = ACTIVE_TOTAL_PIXEL_PAL_RGB * TOTAL_DISPLAY_LINE_PAL;

    } else if((encoder_reg.OUT_MODE  == VIDEO_PALNc) &&
	       (encoder_reg.INPUT_MODE == INPUT_Ycbcr)) {
		readsize = TOTAL_PIXEL_PAL * TOTAL_LINE_PAL ;

    /* PAL N */
    } else if((encoder_reg.OUT_MODE  == VIDEO_PALN) &&
	       (encoder_reg.INPUT_MODE == INPUT_RGB)) {
		readsize = ACTIVE_TOTAL_PIXEL_PAL_RGB * TOTAL_DISPLAY_LINE_PAL;

    } else if((encoder_reg.OUT_MODE  == VIDEO_PALN) &&
	       (encoder_reg.INPUT_MODE == INPUT_Ycbcr)) {
		readsize = TOTAL_PIXEL_PAL * TOTAL_LINE_PAL ;

    /* M-PAL */
    } else if((encoder_reg.OUT_MODE   == VIDEO_MPAL) &&
	        (encoder_reg.INPUT_MODE == INPUT_RGB)) {
		readsize = ACTIVE_TOTAL_PIXEL_NTSC_RGB * TOTAL_DISPLAY_LINE_NTSC;

    } else if((encoder_reg.OUT_MODE  == VIDEO_MPAL) &&
	       (encoder_reg.INPUT_MODE == INPUT_Ycbcr)) {
		readsize = TOTAL_PIXEL_NTSC * TOTAL_LINE_NTSC ;
    }

    printf("filename [%s] type [%s] %d \n", argv[4], argv[2], readsize);

	fp = fopen(argv[4], "rb");
	if(fp == NULL)
	{
		fprintf(stderr, "Cannot open file(%s)\n", argv[4]);
		exit(1);
	}

    if(encoder_reg.INPUT_MODE == INPUT_Ycbcr)
    {
	    fread(BT601, readsize, 1, fp);
	    fclose(fp);
	    encoder_reg.BT601 = BT601;
    }
    else
    {
	    fread(BT601, readsize, 1, fp);
	    fclose(fp);
        encoder_reg.RGB = BT601;
    }


	encoder_reg.out_c_fp    = fopen(Out_C_filename, "w"); 
	encoder_reg.out_y_fp    = fopen(Out_Y_filename, "w");
	encoder_reg.out_com_fp  = fopen(Out_COM_filename, "w");

	init_process_encoder(&encoder_reg);
    encoder(&encoder_reg);

    fclose(encoder_reg.out_c_fp);
    fclose(encoder_reg.out_y_fp);
    fclose(encoder_reg.out_com_fp);


    fclose(ofp_Y);
    fclose(ofp_C);
    fclose(ofp_TEST_U);
    fclose(ofp_TEST_V);

    fclose(ofp_Sim8bitOut);
    fclose(ofp_mode2_HSYNC);
    fclose(ofp_mode2_BLANK);
    fclose(ofp_mode2_VSYNC);
    fclose(ofp_mode2_RGB);

#ifdef RTL_DEBUG
    fclose(ofp_U);
    fclose(ofp_V);
    fclose(ofp_SIN);
    fclose(ofp_COS);

    fclose(ofp_MUL_USIN);
    fclose(ofp_MUL_VCOS);
    fclose(ofp_ADD);

    fclose(ofp_Yout);
    fclose(ofp_Uout);
    fclose(ofp_Vout);
#endif

	return 0;
}
