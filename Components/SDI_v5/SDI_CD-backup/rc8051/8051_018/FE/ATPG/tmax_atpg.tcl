read netlist /user/cklee/PRJ/8051_018/FE/SCAN/SCAN_DB/rc8051RtlTop_scan.v.out


read netlist  ./ATPG_LIB/tsmc18.v
read netlist  ./ATPG_LIB/tpz973g.v
read netlist  ./ATPG_LIB/SPSRAM256X8.v

run build_model rc8051RtlTop
run drc ./../SCAN/SCAN_DB/rc8051RtlTop_scan.spf

add faults -all
Report Faults rc8051RtlTop -class AU
remove faults -all


remove faults -retain_sample 10
add faults -all

#//set atpg -capture_cycle 4
run atpg 


remove faults -all
add faults -all
run atpg -auto 
 
write patterns rc8051RtlTop.stil -format stil
write patterns rc8051RtlTop_serial.v -format verilog  -serial  //# serial   : multi clock

quit
