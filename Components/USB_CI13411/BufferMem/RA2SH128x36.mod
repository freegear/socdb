/*
 *      CONFIDENTIAL  AND  PROPRIETARY SOFTWARE OF ARTISAN COMPONENTS, INC.
 *      
 *      Copyright (c) 2007  Artisan Components, Inc.  All  Rights Reserved.
 *      
 *      Use of this Software is subject to the terms and conditions  of the
 *      applicable license agreement with Artisan Components, Inc. In addition,
 *      this Software is protected by patents, copyright law and international
 *      treaties.
 *      
 *      The copyright notice(s) in this Software does not indicate actual or
 *      intended publication of this Software.
 *      
 *      name:			SRAM-DP-HS SRAM Generator
 *           			TSMC CL013G Process
 *      version:		2005Q2V1
 *      comment:		
 *      configuration:	 -instname RA2SH128x36 -words 128 -bits 36 -frequency 100 -ring_width 4 -mux 4 -drive 6 -write_mask off -wp_size 8 -top_layer met6 -power_type rings -horiz met3 -vert met2 -cust_comment "" -left_bus_delim "[" -right_bus_delim "]" -pwr_gnd_rename "VDD:VDD,GND:VSS" -prefix "" -pin_space 0.0 -name_case upper -check_instname on -diodes on -inside_ring_type GND
 *
 *      Synopsys model for Synchronous Dual-Port Ram
 *
 *      Library Name:   aci
 *      Instance Name:  RA2SH128x36
 *      Words:          128
 *      Word Width:     36
 *      Mux:            4
 *      Pipeline:       No
 *
 *      Creation Date:  2007-02-06 02:27:03Z
 *      Version:        2005Q2V1
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
DESIGN "RA2SH128x36";
OUTPUT QA[35:0];
INPUT AA[6:0];
INPUT CENA;
INPUT CLKA;
INPUT DA[35:0];
INPUT WENA;
OUTPUT QB[35:0];
INPUT AB[6:0];
INPUT CENB;
INPUT CLKB;
INPUT DB[35:0];
INPUT WENB;
MODE mem_modeA =	MissionA  COND(CENA==0), 
			InactiveA COND(CENA==1);
MODE mem_modeB =	MissionB  COND(CENB==0), 
			InactiveB COND(CENB==1);
tch_tasA: SETUP(POSEDGE) AA CLKA MODE(mem_modeA=MissionA);
tch_tahA: HOLD(POSEDGE) AA CLKA MODE(mem_modeA=MissionA);
tch_tcsA: SETUP(POSEDGE) CENA CLKA MODE(mem_modeA=MissionA);
tch_tchA: HOLD(POSEDGE) CENA CLKA MODE(mem_modeA=MissionA);
tch_tdsA: SETUP(POSEDGE) DA CLKA MODE(mem_modeA=MissionA);
tch_tdhA: HOLD(POSEDGE) DA CLKA MODE(mem_modeA=MissionA);
tch_twsA: SETUP(POSEDGE) WENA CLKA MODE(mem_modeA=MissionA);
tch_twhA: HOLD(POSEDGE) WENA CLKA MODE(mem_modeA=MissionA);
period_tcycA: PERIOD(POSEDGE) CLKA ;
tpw_tckhA: WIDTH(POSEDGE) CLKA ;
tpw_tcklA: WIDTH(NEGEDGE) CLKA ;
tch_tasB: SETUP(POSEDGE) AB CLKB MODE(mem_modeB=MissionB);
tch_tahB: HOLD(POSEDGE) AB CLKB MODE(mem_modeB=MissionB);
tch_tcsB: SETUP(POSEDGE) CENB CLKB MODE(mem_modeB=MissionB);
tch_tchB: HOLD(POSEDGE) CENB CLKB MODE(mem_modeB=MissionB);
tch_tdsB: SETUP(POSEDGE) DB CLKB MODE(mem_modeB=MissionB);
tch_tdhB: HOLD(POSEDGE) DB CLKB MODE(mem_modeB=MissionB);
tch_twsB: SETUP(POSEDGE) WENB CLKB MODE(mem_modeB=MissionB);
tch_twhB: HOLD(POSEDGE) WENB CLKB MODE(mem_modeB=MissionB);
period_tcycB: PERIOD(POSEDGE) CLKB ;
tpw_tckhB: WIDTH(POSEDGE) CLKB ;
tpw_tcklB: WIDTH(NEGEDGE) CLKB ;
tch_tccA: SETUP(POSEDGE) CLKA CLKB ;
tch_tccB: SETUP(POSEDGE) CLKB CLKA ;
dly_tyaA: DELAY(POSEDGE) CLKA QA  ;
dly_tyaB: DELAY(POSEDGE) CLKB QB  ;
ENDMODEL
