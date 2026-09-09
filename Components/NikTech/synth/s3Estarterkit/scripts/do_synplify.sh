#!/usr/bin/bash
#
# Synthesis
# -- floating license can use -batch in front
#
synplify_pro -batch manik_soc.prj -runall -log logfile
#
# Translate step
#
ngdbuild -intstyle ise -dd _ngo -nt timestamp -uc ../../../vhdl/socs/s3Estarterkit/s3Estarterkit.ucf -p xc3s500e-fg320-4 manik_soc.edn manik_soc.ngd > translate.log
#
# Map step
#
map -intstyle ise -p xc3s500e-fg320-4 -cm speed -ignore_keep_hierarchy -pr b -k 4 -c 100 -o manik_soc_map.ncd manik_soc.ngd manik_soc.pcf > map.log
#
# Par step
#
par -w -intstyle ise -ol high -t 1 manik_soc_map.ncd manik_soc.ncd manik_soc.pcf > par.log
#
# Timing analysis
#
trce -intstyle ise -e 3 -l 3 -s 4 -xml manik_soc manik_soc.ncd -o manik_soc.twr manik_soc.pcf > trce.log
#
# bitgen Step
#
bitgen -intstyle ise -f manik_soc.ut manik_soc.ncd > bitgen.log