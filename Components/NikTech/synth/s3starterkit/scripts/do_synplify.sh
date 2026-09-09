#!/usr/bin/bash
#
# Synthesis
# -- floating license can use -batch in front
#
synplify_pro -batch manik_soc.prj -runall -log logfile
#
# Translate step
#
ngdbuild  -intstyle ise -dd _ngo -sd ../../../synth/s3starterkit/scripts -aul -nt timestamp -insert_keep_hierarchy -uc ../../../vhdl/socs/s3starterkit/s3starterkit.ucf -p xc3s200-ft256-5 manik_soc.edn manik_soc.ngd > translate.log
#
# Map step
#
map -intstyle ise -p xc3s200-ft256-5 -cm speed -detail -ignore_keep_hierarchy -pr b -k 4 -c 100 -o manik_soc_map.ncd manik_soc.ngd manik_soc.pcf > map.log
#
# Par step
#
par -w -intstyle ise -ol high -xe n -t 1 manik_soc_map.ncd manik_soc.ncd manik_soc.pcf > par.log
#
# Timing analysis
#
trce -intstyle ise -e 3 -l 3 -s 5 -xml manik_soc manik_soc.ncd -o manik_soc.twr manik_soc.pcf
#
# bitgen Step
#
bitgen -intstyle ise -f manik_soc.ut manik_soc.ncd