/****************************************************************************************
*
*   Disclaimer   This software code and all associated documentation, comments or other 
*  of Warranty:  information (collectively "Software") is provided "AS IS" without 
*                warranty of any kind. MICRON TECHNOLOGY, INC. ("MTI") EXPRESSLY 
*                DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
*                TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMIED WARRANTIES 
*                OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. MTI DOES NOT 
*                WARRANT THAT THE SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE 
*                OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. 
*                FURTHERMORE, MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
*                THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS, 
*                ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT OF USE 
*                OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO EVENT SHALL MTI, 
*                ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, 
*                INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR SPECIAL DAMAGES (INCLUDING, 
*                WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, 
*                OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE 
*                THE SOFTWARE, EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
*                DAMAGES. Because some jurisdictions prohibit the exclusion or 
*                limitation of liability for consequential or incidental damages, the 
*                above limitation may not apply to you.
*
*                Copyright 2003 Micron Technology, Inc. All rights reserved.
*
****************************************************************************************/
 

`ifdef x8
    parameter tRC_min      =      30;
    parameter tRP_min      =      15;
    parameter tRPRE_max    =      25;
    parameter tRR_min      =      20;
    parameter tWC_min      =      30;
    parameter tWP_min      =      15;
    parameter tCEA_max     =      23;
    parameter tCLS_min     =      10;
    parameter tCLH_min     =      05;
    parameter tCS_min      =      15;
    parameter tCH_min      =      05;
    parameter tDS_min      =      10;
    parameter tDH_min      =      05;
    parameter tALS_min     =      10;
    parameter tALH_min     =      05;
    parameter tAR_min      =      10;
    parameter tDCBSYR1_min =       0;
    parameter tDCBSYR1_max =    2500;
    parameter tDCBSYR2_min =    2500;
    parameter tDCBSYR2_max =   25000;
    parameter tOH_min      =      15;
    parameter tREA_max     =      18;
    parameter tREH_min     =      10;
    parameter tRHZ_max     =      30;
    parameter tRPRE1_max   =   25000;
    parameter tR_max       =   25000;
    parameter tRST_read    =    5000;
    parameter tRST_prog    =   10000;
    parameter tRST_erase   =  500000;
    parameter tWB_max      =     100;  
    parameter tWH_min      =      10;  
    parameter tWHR_min     =      60;  
`else                          //    Timing Parameters for 3.3Volt x16 and 1.8Volt NAND parts
    parameter tRC_min      =      50;
    parameter tRP_min      =      25;
    parameter tRPRE_max    =      25;
    parameter tRR_min      =      20;
    parameter tWC_min      =      45;
    parameter tWP_min      =      25;
    parameter tCEA_max     =      45;
    parameter tCLS_min     =      25;
    parameter tCLH_min     =      10;
    parameter tCS_min      =      35;
    parameter tCH_min      =      10;
    parameter tDS_min      =      20;
    parameter tDH_min      =      10;
    parameter tALS_min     =      25;
    parameter tALH_min     =      10;
    parameter tAR_min      =      10;
    parameter tDCBSYR1_min =       0;
    parameter tDCBSYR1_max =    2500;
    parameter tDCBSYR2_min =    2500;
    parameter tDCBSYR2_max =   25000;
    parameter tOH_min      =      15;
    parameter tREA_max     =      30;
    parameter tREH_min     =      15;
    parameter tRHZ_max     =      30;
    parameter tRPRE1_max   =   25000;
    parameter tR_max       =   25000;
    parameter tRST_read    =    5000;
    parameter tRST_prog    =   10000;
    parameter tRST_erase   =  500000;
    parameter tWB_max      =     100;  
    parameter tWH_min      =      15;  
    parameter tWHR_min     =      60;  
`endif 

// parameters for all devices
    parameter num_page  =     64;
    parameter page_bits =      6;  // 2^6=64
    parameter tBERS_min    = 2000000;
    parameter tBERS_max    = 3000000;
    parameter tCBSY_min    =    3000;
    parameter tCBSY_max    =  700000;
    parameter tPROG_typ    =  300000;
    parameter tPROG_max    =  700000;

`ifdef x8
    parameter col_bits  =     12;
    parameter data_bits =      8;
    parameter num_col   =   2112;
`else 
    parameter col_bits  =     12; //NOT A BUG - Makes the implimentation of the model easier.
    parameter data_bits =     16;
    parameter num_col   =   1056;
`endif


`ifdef G2
    parameter row_bits  =     17;
    parameter blck_bits =     11;  // 2^11*Byte=2048 2G
`else `ifdef G4
    parameter row_bits  =     18;
    parameter blck_bits =     12;  // 2^11*Word=4096 for 4G
`else `ifdef G8
    parameter row_bits  =     18;
    parameter blck_bits =     12;  // 2^11*Word=4096 for 4G x 2 die = 8G
`endif `endif `endif

`ifdef FullMem   // Only do this if you require the full memmory size.
`ifdef G2
    parameter num_row   = 131072;  // PagesXBlocks = 64x2048  for 2G
`else `ifdef G4
    parameter num_row   = 262144;  // PagesXBlocks = 64x4096  for 4G
`else `ifdef G8
    parameter num_row   = 524288;  // PagesXBlocks = 64x4096  for 4G
`endif `endif `endif
`else
    parameter num_row   =   1024;  // PagesXBlocks = 64x16, 16 Blocks for fast sim load
`endif

parameter MLC = 1'b0;

