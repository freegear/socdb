#load the simulation database
#vsim a_v8_usb

# Set the default radix to hex
radix hex

# These wave commands were updated to support ModelSim EE 5.1b 
# If you are using ModelSim 4.6 or earlier remove the word "add" from
# the wave command.

# add some usefull signals to the waveform window

# Behavioral host controller signals
add wave -literal /uhost_ctl/test_progress
add wave -literal /uhost_ctl/usb_pid
add wave -literal /uhost_ctl/hc_state

# VUSB SIE and uProc interface signals
add wave -logic /ips1/uxil1/v8/usb/pll/dplus
add wave -logic /ips1/uxil1/v8/usb/pll/dminus
add wave -logic /ips1/uxil1/v8/usb/usb/clk
add wave -logic /ips1/uxil1/v8/usb/usb/clk_en
add wave -logic /ips1/uxil1/v8/usb/usb/usboe
add wave -logic /ips1/uxil1/v8/usb/usb/bus_gnt
add wave -hex /ips1/uxil1/v8/usb/usb/u1/int_enb_rg
add wave -hex /ips1/uxil1/v8/usb/usb/u1/ctl_rg
add wave -literal /ips1/uxil1/v8/usb/usb/u2/*enum
add wave -logic /ips1/uxil1/v8/usb/usb/u2/own

# Some signals from the external SRAM which both the VUSB and V8 will use
add wave -hex /ips1/ur3/addr
add wave -hex /ips1/ur3/data
add wave -logic /ips1/ur3/ce_n
add wave -logic /ips1/ur3/we_n
add wave -logic /ips1/ur3/oe_n

# below are some debug signals in the V8 CPU
add wave -logic /ips1/uxil1/v8/cpu/clk
add wave -logic /ips1/uxil1/v8/cpu/rst
add wave -hex /ips1/uxil1/v8/cpu/pc
add wave -logic /ips1/uxil1/v8/cpu/psr(3)
add wave -hex /ips1/uxil1/v8/cpu/datain
add wave -hex /ips1/uxil1/v8/cpu/r/regfile

# turn on or off whatever host controller simulation 
#      functions that you want to run.  These signals 
#      are set to their default values in host_ctl.vhd.
#force -freeze /uhost_ctl/sof_special_test_enabled false
#force -freeze /uhost_ctl/chapter_9_tests_enabled true
#force -freeze /uhost_ctl/bus_enumeration_target_enabled false
#force -freeze /uhost_ctl/bus_enumeration_hub_enabled false
#force -freeze /uhost_ctl/quick_check_enabled true
#force -freeze /uhost_ctl/checklist_enabled false
#force -freeze /uhost_ctl/terse false
#force -freeze /uhost_ctl/verbose false

# run the simulation.  Depending on what tests are
# enabled in the host controller this value will need
# to be adjusted.

run 62 ms

