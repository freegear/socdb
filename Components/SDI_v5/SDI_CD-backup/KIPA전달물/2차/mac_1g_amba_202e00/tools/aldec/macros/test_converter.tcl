set root    d:/designs/mac_1g_amba/ver_202/mac_1g_amba_202e00
set logpath $root/tools/aldec/log
foreach testgroup {d32_sc} {

# ------------------------------------------------------------------- #
# List of tests
# ------------------------------------------------------------------- #
set tpath $root/tests/$testgroup
cd $tpath
set tlist [glob *]

# ------------------------------------------------------------------- #
# Main loop
# ------------------------------------------------------------------- #

  foreach tname $tlist {
    set glist "-GTESTNAME=\"$tname\" -GTESTPATH=\"$tpath\""
    puts "testing $tpath/$tname"
    file copy -force d:/arbstim.txt  $tpath/$tname/arbstim.txt
    file copy -force d:/generic.txt  $tpath/$tname/generic.txt
    # ----------------------------------------------------------------- #
    # If test exist run simulation
    # ----------------------------------------------------------------- #
    if {[file exists $tpath/$tname/time.txt] == 1 &&
        [file exists $tpath/$tname/generic.txt] == 1} {
      eval vsim -t ns $glist -lib MAC_1G_AMBA_LIB APBCONV
      eval run 10 ns
      endsim
    }
  }
}
