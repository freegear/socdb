#!/usr/bin/bash
#
# Synthesis step
#
mkdir ./xst
mkdir ./xst/projnav.tmp
xst  -intstyle ise -ifn manik_soc.xst -ofn manik_soc.syr > synth.log
#
# Translate step
#
ngdbuild -intstyle ise -dd _ngo -aul -nt timestamp -insert_keep_hierarchy -uc ../../../vhdl/socs/MemecS2ELCKit/MemecS2ELCKit.ucf -p xc2s300e-fg456-6 manik_soc.ngc manik_soc.ngd > translate.log
#
# Map Step
#
map -intstyle ise -p xc2s300e-fg456-6 -timing -cm speed -pr b -k 4 -tx on -o manik_soc_map.ncd manik_soc.ngd manik_soc.pcf > map.log
#
# Par step
#
par -w -intstyle ise -ol high -t 1 manik_soc_map.ncd manik_soc.ncd manik_soc.pcf > par.log
#
# Timing analysis
#
trce -intstyle ise -e 3 -l 3 -s 6 -xml manik_soc manik_soc.ncd -o manik_soc.twr manik_soc.pcf
#
# Bitstream generateion
#
bitgen -intstyle ise -f manik_soc.ut manik_soc.ncd > bitgen.log

