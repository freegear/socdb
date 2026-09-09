## db_gen.tcl 
## 2004.08.10
## 2004.08.04
#	[+] recognize basename (base from base.tcl) 
#	[c] LIB_DIR <- DIR
## 2003.11.26
# set PREFIX RF2SH
# set SUFFIX _fast_syn.lib
# set LIB_SUFFIX _fast
date
set DB_DIR /Project/sm1312/MEM/DB/
set LIB_DIR /Project/sm1312/MEM/LIB/

proc lib2db { LIB_DIR LIB_FILE DB_DIR } {
	set DB_FILE [ file rootname $LIB_FILE ]
	remove_design -all
	read_lib ${LIB_DIR}$LIB_FILE
	write_lib USERLIB -o ${DB_DIR}${DB_FILE}.db
}
	
foreach LIB_FILE { 
RA1SH1024x32_fast@0C_syn.lib
RA1SH1024x32_slow_syn.lib
RA1SH1024x32_typical_syn.lib
RA1SH16384x16_fast@0C_syn.lib
RA1SH16384x16_slow_syn.lib
RA1SH16384x16_typical_syn.lib
RA1SH16384x32_on_fast@0C_syn.lib
RA1SH16384x32_on_slow_syn.lib
RA1SH16384x32_on_typical_syn.lib
RA1SH256x16_fast@0C_syn.lib
RA1SH256x16_slow_syn.lib
RA1SH256x16_typical_syn.lib
RA1SH512x16_fast@0C_syn.lib
RA1SH512x16_slow_syn.lib
RA1SH512x16_typical_syn.lib
RA1SH512x24_fast@0C_syn.lib
RA1SH512x24_slow_syn.lib
RA1SH512x24_typical_syn.lib
RA1SH512x32_fast@0C_syn.lib
RA1SH512x32_on_fast_syn.lib
RA1SH512x32_on_slow_syn.lib
RA1SH512x32_on_typical_syn.lib
RA1SH512x32_slow_syn.lib
RA1SH512x32_typical_syn.lib
RA2SH256x24_fast@0C_syn.lib
RA2SH256x24_slow_syn.lib
RA2SH256x24_typical_syn.lib
RA2SH256x32_fast@0C_syn.lib
RA2SH256x32_slow_syn.lib
RA2SH256x32_typical_syn.lib
RF1SH128x24_fast@0C_syn.lib
RF1SH128x24_slow_syn.lib
RF1SH128x24_typical_syn.lib
RF1SH16x24_fast@0C_syn.lib
RF1SH16x24_slow_syn.lib
RF1SH16x24_typical_syn.lib
RF1SH16x8_fast@0C_syn.lib
RF1SH16x8_slow_syn.lib
RF1SH16x8_typical_syn.lib
RF1SH256x32_fast@0C_syn.lib
RF1SH256x32_on_fast@0C_syn.lib
RF1SH256x32_on_slow_syn.lib
RF1SH256x32_on_typical_syn.lib
RF1SH256x32_slow_syn.lib
RF1SH256x32_typical_syn.lib
RF1SH32x128_on_fast@0C_syn.lib
RF1SH32x128_on_slow_syn.lib
RF1SH32x128_on_typical_syn.lib
RF1SH32x24_fast@0C_syn.lib
RF1SH32x24_slow_syn.lib
RF1SH32x24_typical_syn.lib
RF1SH32x32_fast@0C_syn.lib
RF1SH32x32_slow_syn.lib
RF1SH32x32_typical_syn.lib
RF1SH32x8_fast@0C_syn.lib
RF1SH32x8_slow_syn.lib
RF1SH32x8_typical_syn.lib
RF1SH64x24_fast@0C_syn.lib
RF1SH64x24_slow_syn.lib
RF1SH64x24_typical_syn.lib
RF1SH8x24_fast@0C_syn.lib
RF1SH8x24_slow_syn.lib
RF1SH8x24_typical_syn.lib
RF2SH16x32_fast@0C_syn.lib
RF2SH16x32_on_fast@0C_syn.lib
RF2SH16x32_on_slow_syn.lib
RF2SH16x32_on_typical_syn.lib
RF2SH16x32_slow_syn.lib
RF2SH16x32_typical_syn.lib
RF2SH32x32_fast@0C_syn.lib
RF2SH32x32_slow_syn.lib
RF2SH32x32_typical_syn.lib
RF2SH32x4_fast@0C_syn.lib
RF2SH32x4_slow_syn.lib
RF2SH32x4_typical_syn.lib
RF2SH64x24_fast@0C_syn.lib
RF2SH64x24_slow_syn.lib
RF2SH64x24_typical_syn.lib
RF2SH64x32_fast@0C_syn.lib
RF2SH64x32_on_fast@0C_syn.lib
RF2SH64x32_on_slow_syn.lib
RF2SH64x32_on_typical_syn.lib
RF2SH64x32_slow_syn.lib
RF2SH64x32_typical_syn.lib
RF2SH64x4_fast@0C_syn.lib
RF2SH64x4_slow_syn.lib
RF2SH64x4_typical_syn.lib
RF2SH8x32_on_fast@0C_syn.lib
RF2SH8x32_on_slow_syn.lib
RF2SH8x32_on_typical_syn.lib
RODSH256x9_fast@0C_syn.lib
RODSH256x9_slow_syn.lib
RODSH256x9_typical_syn.lib
RODSH512x8_fast@0C_syn.lib
RODSH512x8_slow_syn.lib
RODSH512x8_typical_syn.lib
} {
	lib2db $LIB_DIR $LIB_FILE $DB_DIR
}
date
quit
