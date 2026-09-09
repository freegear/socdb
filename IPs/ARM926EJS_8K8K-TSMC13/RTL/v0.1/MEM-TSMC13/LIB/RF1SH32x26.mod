/*
 *      CONFIDENTIAL AND PROPRIETARY SOFTWARE/DATA OF ARTISAN COMPONENTS, INC.
 *      
 *      Copyright (c) 2006 Artisan Components, Inc.  All Rights Reserved.
 *      
 *      Use of this Software/Data is subject to the terms and conditions of
 *      the applicable license agreement between Artisan Components, Inc. and
 *      Taiwan Semiconductor Manufacturing Company Ltd..  In addition, this Software/Data
 *      is protected by copyright law and international treaties.
 *      
 *      The copyright notice(s) in this Software/Data does not indicate actual
 *      or intended publication of this Software/Data.
 *      name:			RF-SP-HS Register File Generator
 *           			TSMC CL013G-FSG Process
 *      version:		2003Q4V1
 *      comment:		
 *      configuration:	 -instname RF1SH32x26 -words 32 -bits 26 -frequency 100 -ring_width 2 -mux 2 -drive 4 -write_mask off -wp_size 8 -top_layer met6 -power_type rings -horiz met3 -vert met2 -cust_comment "" -left_bus_delim "[" -right_bus_delim "]" -pwr_gnd_rename "VDD:VDD,GND:VSS" -prefix "" -pin_space 0.0 -name_case upper -check_instname on -diodes on -inside_ring_type GND
 *
 *      Synopsys model for Synchronous Single-Port Register File
 *
 *      Library Name:   aci
 *      Instance Name:  RF1SH32x26
 *      Words:          32
 *      Word Width:     26
 *      Mux:            2
 *      Pipeline:       No
 *
 *      Creation Date:  2006-12-19 09:01:13Z
 *      Version:        2003Q4V1
 *
 *      Verified With: Synopsys Primetime
 *
 *      Modeling Assumptions: This library contains a black box description
 *          for a memory element.  At the library level, a
 *          default_max_transition constraint is set to the maximum
 *          characterized input slew.  Each output has a max_capacitance
 *          constraint set to the highest characterized output load.
 *          Different modes are defined in order to disable false path
 *          during the specific mode activation when doing static timing analysis. 
 *
 *
 *      Modeling Limitations: This stamp does not include power information.
 *          Due to limitations of the stamp modeling, some data reduction was
 *          necessary.  When reducing data, minimum values were chosen for the
 *          fast case corner and maximum values were used for the typical and
 *          best case corners.  It is recommended that critical timing and
 *          setup and hold times be checked at all corners.
 *
 *      Known Bugs: None.
 *
 *      Known Work Arounds: N/A
 *
 */

MODEL
MODEL_VERSION "1.0";
DESIGN "RF1SH32x26";
OUTPUT Q[25:0];
INPUT A[4:0];
INPUT CEN;
INPUT CLK;
INPUT D[25:0];
INPUT WEN;
MODE mem_mode =	Mission  COND(CEN==0),
                Inactive COND(CEN==1);


tch_tas: SETUP(POSEDGE) A CLK MODE(mem_mode=Mission);
tch_tah: HOLD(POSEDGE) A CLK MODE(mem_mode=Mission);
tch_tcs: SETUP(POSEDGE) CEN CLK MODE(mem_mode=Mission);
tch_tch: HOLD(POSEDGE) CEN CLK MODE(mem_mode=Mission);
tch_tds: SETUP(POSEDGE) D CLK MODE(mem_mode=Mission);
tch_tdh: HOLD(POSEDGE) D CLK MODE(mem_mode=Mission);
tch_tws: SETUP(POSEDGE) WEN CLK MODE(mem_mode=Mission);
tch_twh: HOLD(POSEDGE) WEN CLK MODE(mem_mode=Mission);
period_tcyc: PERIOD(POSEDGE) CLK ;
tpw_tckh: WIDTH(POSEDGE) CLK ;
tpw_tckl: WIDTH(NEGEDGE) CLK ;
dly_tya: DELAY(POSEDGE) CLK Q  ;
ENDMODEL
