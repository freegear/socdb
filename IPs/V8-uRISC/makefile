################################################################################
#                                                                              #
#        Makefile for the VAutomation Inc. Universal Serial Bus (USB)          #
#        Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED         #
#                                                                              #
################################################################################
#
#
# -- Revision: $Name: REV9911b $
#
# This file is a UNIX Makefile.  It is assumed that the reader has some
# experience with Makefiles. See the man pages for more info on make.
# This makefile primarily supports the following CAE tools:
# Exemplar Logic Synthesis (Galileo V3.1.1)
# Model Technology VHDL simulator (VSIM 4.3e)
# Feel free to modify this file to support your particular CAE tool set.

# USAGE:
# Make mti	; Create a Model Technology simulation database.
# Make xnf      ; Create a Xilinx XNF files.
# Make lca      ; Create a placed and routed Xilinx implementation.
# Make mcs      ; Create the Xchecker download file.
# Make asic     ; Run the Synopsys synthesis script.

# Once the desired database has been created, it is assumed that you know 
# how to enter the appropriate CAE tool to use the database.

# The Demonstration Kit is a self running simulation. You do not need to
# provide any stimulus. Simply type Make sim (or make mti). Then enter the
# simulator and run for 20 ms. This will run most of the simulation.
# Included in the Demonstration Kit is a Viewlogic .cmd file and a mti .do file
# which will add signals of interest to the waveform list.

################################ READ ME FIRST #################################  
# You must first setup the appropriate .ini file for the CAE tools 
# you will be using.
# For MTI:
#	Nothing specific needed here.
# For Exemplar:
#	Nothing specific needed here.
# For Synopsys:
#	Nothing specific needed here.
################################################################################

################################################################################
# The SUFFIXES variable in a makefile informs make about the types
# of suffixes to look for.
# In this case we are telling make that .vhd, .lis, .xnf and .rpt
# are important suffixes and we'll tell it what to do with them later.
################################################################################
.SUFFIXES : $(SUFFIXES) .vhd .xnf .rpt 

# SYNOPT can be used for additional synthesis options such as max_delay
# It is left blank by default.
SYNOPT=

# Altera synthesis variables
#ENCODING=binary
#EXT=tdf
#OUTFMT=AHDL
#TECHNOLOGY=flex
#MODGEN_LIB=flex

# Xilinx synthesis variables
ENCODING=binary
EXT=xnf
OUTFMT=XNF
TECHNOLOGY=xi4e
MODGEN_LIB=xi4
PARTTYPE=4013epq208

# LSI
#TECHNOLOGY=lsi100
#OUTFMT=VHDL
#EXT=net

# Chip Express 
#TECHNOLOGY=qyh400
#OUTFMT=VHDL
#EXT=net

# The ANALYZE variable is the command used to "analyze" or compile your
# design for simulation. Replace it with the CAE tool command of choice.
# Note that we are using the 1993 version of VHDL!
# For MTI:
#ANALYZE=vcom -93 -work work
ANALYZE=vcom -work work
# for Mentor QHDLLite VHDL
#ANALYZE=qvhcom -work work
# for Mentor QHDLLite Verilog
#ANALYZE=qvlcom -work work
# for Viewlogic
#ANALYZE=analyze -libfile vsslib.ini -dbg 0 -src

# The MAKE_LIB variable is the command to used to initialize a VHDL library
# for MTI:
MAKE_LIB=vlib
# for Mentor QHDLLite VHDL
#MAKE_LIB=qhlib
# for Mentor QHDLLite Verilog
#MAKE_LIB=qvlib
# for others it is generally not needed
#MAKE_LIB=""

# The L variable is needed so make can figure out what files are
# out of date and need to be recompiled. L is usually the path
# down the current "work" directory.
# For MTI:
L=work/

# The R variable is also needed by make. It simply picks a file
# in the "work" directory which will have it's date stamp compared
# with the source file. This is usually a file created by the analyzer.
# For MTI:
# Used for mti versions before 4.6 and for Mentor QHDL and QHDLLite
#R=/_parsed.vhd
# Used for mti 4.6 and later
R=/_primary.dat

# The HDL variable is "vhd" for vhdl and "v" for Verilog.
HDL=vhd

# The LANG variable should be vhdl for vhdl and verilog for verilog
LANG=vhdl

# The ASM variable is the command used to "assemble" the assembly language
# code that runs on the processor that that is being run in the testbench.
ASM=./v8asm

# We rely on the dependency list to find all of the other targets.
# make sure the required library dirrectories are pressent
v8_lib:
	mkdir -p v8_lib 

pcb_lib:
	mkdir -p pcb_lib 

software:
	mkdir -p software 

./software/src:
	mkdir -p software/src

./software/bin: software
	mkdir -p software/bin

./software/include: software
	mkdir -p software/include

./software/lib: software
	mkdir -p software/lib

# Make sure there is a MTI "work" directory. Create one if it's not there.
work :
	$(MAKE_LIB) work

# Create  the a MTI simulation database
mti	: sim

sim	: work v8_lib pcb_lib software ./software/src ./software/bin ./software/include \
	./software/lib $(L)testbnch$(R) ips1_trm.dat ram128k8.hex \
	startup.do bistrom.hex

hdl: 	$(L)testbnch$(R)

# Create the Intel hex files of the software
hex	: bistrom.hex ram128k8.hex ips1_trm.dat

# Create a Xilinx Netlist
xnf 	: xilv8usb.xnf

# Create a Xilinx XL architecture implementation.
xl	: xilv8usb_pr.ncd

# Create a Xilinx EX architecture comfiguraton prom files
prom	: xv8vusb1.mcs

# Run the Synopsys Design Compiler script.
asic : 	vusb.net

altera : a10k240.pof

# The format of a MAKEFILE is as follows:

# target : dependency
# [tab] command to update target if older than dependency
#
# Note that the [tab] is VERY important!
# When a target is checked against it's dependency, the dependency first
# becomes a target and checked to see if there are any other dependencies.
# Thus, MAKE is recursive and will check all dependencies.

# Below are the simulation dependcies:
# Setup MTI compile commands
$(L)cfg_usb$(R) : cfg_usb.$(HDL)
	$(ANALYZE) cfg_usb.$(HDL)

$(L)dpllnrzi$(R) : dpllnrzi.$(HDL) $(L)cfg_usb$(R)
	$(ANALYZE) dpllnrzi.$(HDL)

$(L)resistor$(R) : resistor.$(HDL) 
	$(ANALYZE) resistor.$(HDL)

$(L)proc_pkg$(R) : proc_pkg.$(HDL) 
	$(ANALYZE) proc_pkg.$(HDL)

$(L)tx_logic$(R) : tx_logic.$(HDL) 
	$(ANALYZE) tx_logic.$(HDL)

$(L)up_int$(R) : up_int.$(HDL) $(L)fifo8xn$(R) $(L)cfg_usb$(R)
	$(ANALYZE) up_int.$(HDL)

$(L)fifo8xn$(R) : fifo8xn.$(HDL)
	$(ANALYZE) fifo8xn.$(HDL)

$(L)usb_sie$(R) : usb_sie.$(HDL) $(L)cfg_usb$(R)
	$(ANALYZE) usb_sie.$(HDL)

$(L)vusb$(R) : vusb.$(HDL) $(L)up_int$(R) $(L)usb_sie$(R) $(L)fifo8xn$(R)
	$(ANALYZE) vusb.$(HDL)

$(L)vusb_top$(R) : vusb_top.$(HDL) $(L)vusb$(R) $(L)dpllnrzi$(R) $(L)bufgls$(R)
	$(ANALYZE) vusb_top.$(HDL)

$(L)host_ctl$(R) : host_ctl.$(HDL) $(L)usbconna$(R) $(L)cfg_usb$(R)
	$(ANALYZE) host_ctl.$(HDL)

$(L)vpc_term$(R) : $(L)dsub9$(R) ./pcb_lib/vpc_term.$(HDL)
	$(ANALYZE) ./pcb_lib/vpc_term.$(HDL)

$(L)testbnch$(R) : testbnch.$(HDL) $(L)ips_pcb$(R) $(L)host_ctl$(R) $(L)vjtagtst$(R) \
	$(L)vpc_term$(R) $(L)res1206$(R)
	$(ANALYZE) testbnch.$(HDL)

################ V8 IPS Test Bench Simulation Files ####################
$(L)ips_pcb$(R) : ./v8_lib/ips_pcb.$(HDL) $(L)xil240hq$(R) $(L)a10k240$(R) $(L)ram128k8$(R) \
	$(L)seeprom$(R) $(L)bt829$(R) $(L)ad1846$(R) $(L)ssm2135$(R) $(L)ti21lv03$(R) \
	$(L)usbp11$(R) $(L)max241e$(R) $(L)osc$(R) $(L)osc50$(R) $(L)xc17128$(R) $(L)xchecker$(R) \
	$(L)hdr10$(R) $(L)swdip8$(R) $(L)pwr_5v$(R) $(L)usbadual$(R) $(L)usbconnb$(R) \
	$(L)fw_conn$(R) $(L)mic$(R) $(L)phone$(R) $(L)rca$(R) $(L)dsub9$(R) $(L)dsub25$(R) \
	$(L)mii$(R) $(L)tfds3000$(R) $(L)xtal$(R) $(L)res1206$(R) $(L)open1206$(R) $(L)sres1206$(R) \
	$(L)cap_tant$(R) $(L)cap_2pin$(R) $(L)cap1206$(R) $(L)led10$(R) $(L)fuse$(R) $(L)fet$(R) \
	$(L)spst$(R) $(L)ldo_reg$(R) $(L)plcc20th$(R) $(L)zeroohm$(R) $(L)hdr20$(R)
	$(ANALYZE) ./v8_lib/ips_pcb.$(HDL)

$(L)v8_top$(R) : ./v8_lib/v8_top.$(HDL) $(L)v8_alu$(R) $(L)v8_regs$(R) $(L)v8_addr$(R) \
	$(L)op_dcd$(R)
	$(ANALYZE) ./v8_lib/v8_top.$(HDL)

$(L)op_dcd$(R) : ./v8_lib/op_dcd.$(HDL)
	$(ANALYZE) ./v8_lib/op_dcd.$(HDL)

$(L)v8_alu$(R) : ./v8_lib/v8_alu.$(HDL)
	$(ANALYZE) ./v8_lib/v8_alu.$(HDL)

$(L)v8_pkg$(R) : ./v8_lib/v8_pkg.$(HDL)
	$(ANALYZE) ./v8_lib/v8_pkg.$(HDL)

$(L)v8_regs$(R) : ./v8_lib/v8_regs.$(HDL) $(L)ram16x1d$(R)
	$(ANALYZE) ./v8_lib/v8_regs.$(HDL)

$(L)v8_addr$(R) : ./v8_lib/v8_addr.$(HDL)
	$(ANALYZE) ./v8_lib/v8_addr.$(HDL)

$(L)vuart$(R) : ./v8_lib/vuart.$(HDL)
	$(ANALYZE) ./v8_lib/vuart.$(HDL)

$(L)vtimer$(R) : ./v8_lib/vtimer.$(HDL)
	$(ANALYZE) ./v8_lib/vtimer.$(HDL)

$(L)vjtag$(R) : ./v8_lib/vjtag.$(HDL)
	$(ANALYZE) ./v8_lib/vjtag.$(HDL)

$(L)vjtagtst$(R) : ./v8_lib/vjtagtst.$(HDL)
	$(ANALYZE) ./v8_lib/vjtagtst.$(HDL)

$(L)v8_deice$(R) : ./v8_lib/v8_deice.$(HDL) $(L)vjtag$(R)
	$(ANALYZE) ./v8_lib/v8_deice.$(HDL)

$(L)v1284$(R) : ./v8_lib/v1284.$(HDL) $(L)vpio$(R)
	$(ANALYZE) ./v8_lib/v1284.$(HDL)

$(L)vpio$(R) : ./v8_lib/vpio.$(HDL)
	$(ANALYZE) ./v8_lib/vpio.$(HDL)

$(L)clk_ctl$(R) : ./v8_lib/clk_ctl.$(HDL)
	$(ANALYZE) ./v8_lib/clk_ctl.$(HDL)

$(L)pwr_save$(R) : ./v8_lib/pwr_save.$(HDL)
	$(ANALYZE) ./v8_lib/pwr_save.$(HDL)

$(L)writeio2$(R) : ./v8_lib/writeio2.$(HDL)
	$(ANALYZE) ./v8_lib/writeio2.$(HDL)

$(L)bistrom$(R) : ./v8_lib/bistrom.$(HDL) $(L)v8_pkg$(R)
	$(ANALYZE) ./v8_lib/bistrom.$(HDL)

# Simulation support files the V8 IPS PCB 
$(L)osc$(R) : ./pcb_lib/osc.$(HDL)
	$(ANALYZE) ./pcb_lib/osc.$(HDL)

$(L)osc50$(R) : ./pcb_lib/osc50.$(HDL)
	$(ANALYZE) ./pcb_lib/osc50.$(HDL)

$(L)osc100$(R) : ./pcb_lib/osc100.$(HDL)
	$(ANALYZE) ./pcb_lib/osc100.$(HDL)

$(L)spst$(R) : ./pcb_lib/spst.$(HDL)
	$(ANALYZE) ./pcb_lib/spst.$(HDL)

$(L)open1206$(R) : ./pcb_lib/open1206.$(HDL)
	$(ANALYZE) ./pcb_lib/open1206.$(HDL)

$(L)res1206$(R) : ./pcb_lib/res1206.$(HDL)
	$(ANALYZE) ./pcb_lib/res1206.$(HDL)

$(L)sres1206$(R) : ./pcb_lib/sres1206.$(HDL)
	$(ANALYZE) ./pcb_lib/sres1206.$(HDL)

$(L)cap_tant$(R) : ./pcb_lib/cap_tant.$(HDL)
	$(ANALYZE) ./pcb_lib/cap_tant.$(HDL)

$(L)cap_2pin$(R) : ./pcb_lib/cap_2pin.$(HDL)
	$(ANALYZE) ./pcb_lib/cap_2pin.$(HDL)

$(L)cap1206$(R) : ./pcb_lib/cap1206.$(HDL)
	$(ANALYZE) ./pcb_lib/cap1206.$(HDL)

$(L)xchecker$(R) : ./pcb_lib/xchecker.$(HDL)
	$(ANALYZE) ./pcb_lib/xchecker.$(HDL)

$(L)ad1846$(R) : ./pcb_lib/ad1846.$(HDL)
	$(ANALYZE) ./pcb_lib/ad1846.$(HDL)

$(L)bt829$(R) : ./pcb_lib/bt829.$(HDL)
	$(ANALYZE) ./pcb_lib/bt829.$(HDL)

$(L)ti21lv03$(R) : ./pcb_lib/ti21lv03.$(HDL)
	$(ANALYZE) ./pcb_lib/ti21lv03.$(HDL)

$(L)ldo_reg$(R) : ./pcb_lib/ldo_reg.$(HDL)
	$(ANALYZE) ./pcb_lib/ldo_reg.$(HDL)

$(L)pwr_5v$(R) : ./pcb_lib/pwr_5v.$(HDL)
	$(ANALYZE) ./pcb_lib/pwr_5v.$(HDL)

$(L)hdr10$(R) : ./pcb_lib/hdr10.$(HDL)
	$(ANALYZE) ./pcb_lib/hdr10.$(HDL)

$(L)usbadual$(R) : ./pcb_lib/usbadual.$(HDL) $(L)con_pin$(R)
	$(ANALYZE) ./pcb_lib/usbadual.$(HDL)

$(L)hdr40$(R) : ./pcb_lib/hdr40.$(HDL)
	$(ANALYZE) ./pcb_lib/hdr40.$(HDL)

$(L)hdr20$(R) : ./pcb_lib/hdr20.$(HDL)
	$(ANALYZE) ./pcb_lib/hdr20.$(HDL)

$(L)hp1810$(R) : ./pcb_lib/hp1810.$(HDL)
	$(ANALYZE) ./pcb_lib/hp1810.$(HDL)

$(L)max241e$(R) : ./pcb_lib/max241e.$(HDL)
	$(ANALYZE) ./pcb_lib/max241e.$(HDL)

$(L)mii$(R) : ./pcb_lib/mii.$(HDL) $(L)con_pin$(R)
	$(ANALYZE) ./pcb_lib/mii.$(HDL)

$(L)rca$(R) : ./pcb_lib/rca.$(HDL)
	$(ANALYZE) ./pcb_lib/rca.$(HDL)

$(L)ram128k8$(R) : ./pcb_lib/ram128k8.$(HDL) $(L)v8_pkg$(R)
	$(ANALYZE) ./pcb_lib/ram128k8.$(HDL)

$(L)seeprom$(R) : ./pcb_lib/seeprom.$(HDL) $(L)v8_pkg$(R)
	$(ANALYZE) ./pcb_lib/seeprom.$(HDL)

$(L)swdip8$(R) : ./pcb_lib/swdip8.$(HDL)
	$(ANALYZE) ./pcb_lib/swdip8.$(HDL)

$(L)led$(R) : ./pcb_lib/led.$(HDL)
	$(ANALYZE) ./pcb_lib/led.$(HDL)

$(L)xtal$(R) : ./pcb_lib/xtal.$(HDL)
	$(ANALYZE) ./pcb_lib/xtal.$(HDL)

$(L)zeroohm$(R) : ./pcb_lib/zeroohm.$(HDL)
	$(ANALYZE) ./pcb_lib/zeroohm.$(HDL)

$(L)xc17128$(R) : ./pcb_lib/xc17128.$(HDL)
	$(ANALYZE) ./pcb_lib/xc17128.$(HDL)

$(L)din96$(R) : ./pcb_lib/din96.$(HDL)
	$(ANALYZE) ./pcb_lib/din96.$(HDL)


$(L)usbp11$(R) : ./pcb_lib/usbp11.$(HDL)
	$(ANALYZE) ./pcb_lib/usbp11.$(HDL)

$(L)ssm2135$(R) : ./pcb_lib/ssm2135.$(HDL)
	$(ANALYZE) ./pcb_lib/ssm2135.$(HDL)

$(L)tfds3000$(R) : ./pcb_lib/tfds3000.$(HDL)
	$(ANALYZE) ./pcb_lib/tfds3000.$(HDL)

$(L)tsb11c01$(R) : ./pcb_lib/tsb11c01.$(HDL)
	$(ANALYZE) ./pcb_lib/tsb11c01.$(HDL)

$(L)at1241mf$(R) : ./pcb_lib/at1241mf.$(HDL)
	$(ANALYZE) ./pcb_lib/at1241mf.$(HDL)

$(L)lm2574$(R) : ./pcb_lib/lm2574.$(HDL)
	$(ANALYZE) ./pcb_lib/lm2574.$(HDL)

$(L)mic$(R) : ./pcb_lib/mic.$(HDL)
	$(ANALYZE) ./pcb_lib/mic.$(HDL)

$(L)induct$(R) : ./pcb_lib/induct.$(HDL)
	$(ANALYZE) ./pcb_lib/induct.$(HDL)

$(L)fet$(R) : ./pcb_lib/fet.$(HDL)
	$(ANALYZE) ./pcb_lib/fet.$(HDL)

$(L)usbconna$(R) : ./pcb_lib/usbconna.$(HDL) $(L)con_pin$(R)
	$(ANALYZE) ./pcb_lib/usbconna.$(HDL)

$(L)usbconnb$(R) : ./pcb_lib/usbconnb.$(HDL) $(L)con_pin$(R)
	$(ANALYZE) ./pcb_lib/usbconnb.$(HDL)

$(L)pwr_conn$(R) : ./pcb_lib/pwr_conn.$(HDL)
	$(ANALYZE) ./pcb_lib/pwr_conn.$(HDL)

$(L)fw_conn$(R) : ./pcb_lib/fw_conn.$(HDL) $(L)con_pin$(R)
	$(ANALYZE) ./pcb_lib/fw_conn.$(HDL)

$(L)con_pin$(R) : ./pcb_lib/con_pin.$(HDL)
	$(ANALYZE) ./pcb_lib/con_pin.$(HDL)

$(L)dsub9$(R) : ./pcb_lib/dsub9.$(HDL) $(L)con_pin$(R)
	$(ANALYZE) ./pcb_lib/dsub9.$(HDL)

$(L)dsub25$(R) : ./pcb_lib/dsub25.$(HDL) $(L)con_pin$(R)
	$(ANALYZE) ./pcb_lib/dsub25.$(HDL)

$(L)plcc20th$(R) : ./pcb_lib/plcc20th.$(HDL)
	$(ANALYZE) ./pcb_lib/plcc20th.$(HDL)

$(L)phone$(R) : ./pcb_lib/phone.$(HDL)
	$(ANALYZE) ./pcb_lib/phone.$(HDL)

$(L)fuse$(R) : ./pcb_lib/fuse.$(HDL)
	$(ANALYZE) ./pcb_lib/fuse.$(HDL)

$(L)led10$(R) : ./pcb_lib/led10.$(HDL)
	$(ANALYZE) ./pcb_lib/led10.$(HDL)

$(L)a10k240$(R) : ./v8_lib/a10k240.$(HDL) $(L)cfg_usb$(R) \
	$(L)asic_v8$(R) $(L)global$(R)
	$(ANALYZE) ./v8_lib/a10k240.$(HDL)

$(L)xil240hq$(R) : ./v8_lib/xil240hq.$(HDL) $(L)cfg_usb$(R) $(L)asic_v8$(R) $(L)bufgls$(R)
	$(ANALYZE) ./v8_lib/xil240hq.$(HDL)

$(L)asic_v8$(R) : ./v8_lib/asic_v8.$(HDL) $(L)v8_top$(R) $(L)bistrom$(R) \
	$(L)vuart$(R) $(L)v8_deice$(R) $(L)vtimer$(R) $(L)v1284$(R) \
	$(L)vusb_top$(R) $(L)clk_ctl$(R) $(L)pwr_save$(R)
	$(ANALYZE) ./v8_lib/asic_v8.$(HDL)

$(L)bufgls$(R) : ./v8_lib/xil_io.$(HDL)
	$(ANALYZE) ./v8_lib/xil_io.$(HDL)

$(L)ipad$(R) : ./v8_lib/xil_io.$(HDL)
	$(ANALYZE) ./v8_lib/xil_io.$(HDL)

$(L)obuft$(R) : ./v8_lib/xil_io.$(HDL)
	$(ANALYZE) ./v8_lib/xil_io.$(HDL)

$(L)ram16x1d$(R) : ./v8_lib/xil_io.$(HDL)
	$(ANALYZE) ./v8_lib/xil_io.$(HDL)

$(L)global$(R) : ./v8_lib/xil_io.$(HDL)
	$(ANALYZE) ./v8_lib/xil_io.$(HDL)

########## V8 IPS Test Bench Software ################################

./software/%.ihx : ./software/%.asm ./software/v8asm.syn  ./software/v8asm.exe \
		  ./software/v8asm
	(cd software ; ./v8asm $*)

./software/bistrom.ihx : ./software/bistrom.asm ./software/bist.asm \
	./software/i2c.asm  ./software/boot.asm \
	./software/v8asm.syn ./software/v8asm.exe ./software/v8asm
	(cd software ; ./v8asm bistrom)
	(cd ./software ; rm -f bistrom_hw.asm; cp bistrom.asm bistrom_hw.asm; ./v8asm -dWANT_HARDWARE=1 bistrom_hw.asm)

bistrom.hex : ./software/bistrom.ihx
	rm -f bistrom.hex
	cp  ./software/bistrom.ihx bistrom.hex

bistrom_hw.hex : ./software/bistrom.ihx
	rm -f bistrom_hw.hex
	cp  ./software/bistrom_hw.ihx bistrom_hw.hex

# C code source make directives
CV8 = null_list
$(CV8):
	echo "The HI TECH (TM)  V8 C compiler must be purchased separately,"
	echo "and installed in the software/bin directory.  Contact VAutomation"
	echo "at 603-882-2282 for more details."
./software/usb_c.hex : $(CV8) ./software/v8dis.exe $(V8_C)
	rm -f ./software/usb_c.hex
	rm -f ./software/usb_c.asm
	rm -f ./software/usb_c.lst
	rm -f ./software/usb_chw.hex
	rm -f ./software/usb_chw.asm
	rm -f ./software/usb_chw.lst
	(cd software/src ; \
		set HTC_ERR_FORMAT='%%f(%%l) : error %%c : %%s' ; \
		set HTC_WARN_FORMAT='%%f(%%l) : warning %%c : %%s' ; \
		../bin/cv8 < usb.in)
	(cd software/src ; ../v8dis v8_demo.hex > usb_c.lst)
	cp ./software/src/v8_demo.hex ./software/usb_c.hex
	cp ./software/src/v8_demo.sym ./software/usb_c.sym
	cp ./software/src/map ./software/usb_c.map
	(cd software/src ; \
		set HTC_ERR_FORMAT='%%f(%%l) : error %%c : %%s' ; \
		set HTC_WARN_FORMAT='%%f(%%l) : warning %%c : %%s' ; \
		../bin/cv8 < usb_hw.in)
	(cd software/src ; ../v8dis v8_demo.hex > usb_chw.lst)
	cp ./software/src/v8_demo.hex ./software/usb_chw.hex
	cp ./software/src/v8_demo.sym ./software/usb_chw.sym
	cp ./software/src/map ./software/usb_chw.map
	(cd software; v8dis usb_c.hex > usb_c.lst)
	(cd software; v8dis -a usb_c.hex > usb_c.asm)
	(cd software; v8dis usb_chw.hex > usb_chw.lst)
	(cd software; v8dis -a usb_chw.hex > usb_chw.asm)

# Uncomment these lines if you are using the C compiler for target applications.
#ram128k8.hex : ./software/usb_c.hex
#	rm -f $@ ; cp ./software/usb_c.hex $@

# Uncomment these lines if you using the assembly code output of the C 
# compiler for target applications
ram128k8.hex : ./software/usb_c.ihx
	rm -f $@ ; cp ./software/usb_c.ihx $@

./software/usb_c.ihx: ./software/usb_c.asm ./software/usb_chw.asm \
	./software/v8asm.syn ./software/v8asm.exe ./software/v8asm
	(cd ./software ; ./v8asm -l usb_c.asm)
	(cd ./software ; ./v8asm -l usb_chw.asm)

./software/host_c.ihx: ./software/host_c.asm ./software/host_chw.asm \
	./software/v8asm.syn ./software/v8asm.exe ./software/v8asm
	(cd ./software ; ./v8asm -l host_c.asm)
	(cd ./software ; ./v8asm -l host_chw.asm)

ips1_trm.dat : 
	echo "@65000" > ips1_trm.dat


########## VUSB Synopsys DC shell script ################################
# Below are the dependencies to synthesize the vusb  and the dpllnrzi as two
# stand alone blocks for inclusion into your asic
# We rely on the dependency list to find all of the other targets.

vusb.net : vusb.dc dpllnrzi.$(HDL) vusb.$(HDL) cfg_usb.$(HDL) \
		up_int.$(HDL) usb_sie.$(HDL) fifo8xn.$(HDL)
	dc_shell -f vusb.dc

########## V8 with VUSB Gallileo script ################################
# Below are the dependencies to synthesize the vusb as a periferal to a V8
# in xilinx devices.
# We rely on the dependency list to find all of the other targets.

# Run ROM Builder to create a hard ROM netlist with relative placement.
bistrom.xnf : bistrom_hw.hex rombldr rombldr.exe rombldr.txt
	rombldr bistrom_hw.hex > bistrom.xnf

# This a generic gc is for Galileo - V4.2.1 
%.xnf : %.$(HDL) 
	gc '$*.$(HDL)' \
	$*.xnf -INPUT_FORMAT=$(LANG) \
	-SOURCE=$(TECHNOLOGY) \
	-TARGET=$(TECHNOLOGY) -OUTPUT_FORMAT=XNF \
	-EFFORT=quick \
	-nocomplex_ios -part=4062xlHQ240 -process=3 -nocontrol \
	-notimespec_generate \
	-NOINFER_GLOBAL_SR -noxlx_fast_slew -nomap_global_bufs \
	-select_modgen=fast -wire_table=4036ex-3_avg \
	-MACRO -area -encoding=binary \
	-maxdly=62 -max_frequency=16 

xilv8usb.xnf : v8_lib xil_cfg.$(HDL) ./v8_lib/xil240hq.$(HDL) ./v8_lib/clk_ctl.$(HDL) \
	./v8_lib/asic_v8.$(HDL) ./v8_lib/v8_top.$(HDL) ./v8_lib/v8_addr.$(HDL) \
	./v8_lib/v8_alu.$(HDL) ./v8_lib/v8_regs.$(HDL) ./v8_lib/op_dcd.$(HDL) \
	./v8_lib/vuart.$(HDL) ./v8_lib/vjtag.$(HDL) ./v8_lib/vtimer.$(HDL) \
	./v8_lib/v1284.$(HDL) ./v8_lib/vpio.$(HDL) ./v8_lib/v8_deice.$(HDL) \
	cfg_usb.$(HDL) vusb_top.$(HDL) dpllnrzi.$(HDL) vusb.$(HDL) \
	up_int.$(HDL) usb_sie.$(HDL) fifo8xn.$(HDL) 
	sed -e 's/clk_usb 	: INOUT.*$$/clk_usb       : IN std_logic;/' \
            -e 's/tck         : INOUT.*$$/tck          : IN std_logic;/' \
            -e '/tck_buf1/d' \
            -e '/tck_buf2/s/tck_in/tck/' \
            -e '/tck_buf3/d' \
            ./v8_lib/xil240hq.$(HDL) > temp.$(HDL)
	gc './v8_lib/clk_ctl.$(HDL) ./v8_lib/pwr_save.$(HDL) ./v8_lib/v8_alu.$(HDL) ./v8_lib/op_dcd.$(HDL) ./v8_lib/v8_addr.$(HDL) ./v8_lib/v8_regs.$(HDL) ./v8_lib/v8_top.$(HDL) ./v8_lib/asic_v8.$(HDL) ./v8_lib/vuart.$(HDL) ./v8_lib/vjtag.$(HDL) ./v8_lib/v8_deice.$(HDL) ./v8_lib/vtimer.$(HDL) ./v8_lib/v1284.$(HDL) ./v8_lib/vpio.$(HDL) cfg_usb.$(HDL) vusb_top.$(HDL) dpllnrzi.$(HDL) vusb.$(HDL) up_int.$(HDL) usb_sie.$(HDL) fifo8xn.$(HDL) temp.$(HDL) xil_cfg.$(HDL)' \
	temp.xnf -INPUT_FORMAT=$(LANG) \
	-SOURCE=$(TECHNOLOGY) \
	-TARGET=$(TECHNOLOGY) -OUTPUT_FORMAT=XNF \
	-EFFORT=quick \
	-nocomplex_ios -part=4062xlHQ240 -process=3 -nocontrol \
	-notimespec_generate \
	-NOINFER_GLOBAL_SR -noxlx_fast_slew -nomap_global_bufs \
	-select_modgen=fast -wire_table=4036ex-3_avg \
	-CHIP -area -encoding=binary -maxarea=1900 \
	-maxdly=62 -max_frequency=16 \
	-entity=xil_cfg
#	-set_var partition_size=8000 \
#	-entity=xil240hq 
#	-noopt=ibuf -noopt=bufgls -noopt=obuft \
#	-noopt=bistrom -noopt=ramd \
#	-noopt=ipad -noopt=obuft_ng -save_all \
	rm -f xilv8usb.xnf
	sed -e 's/xil_cfg_//g' -e 's/obuft_ng/obuft/g' \
	-e 's/I, tck_dup0/I, GND0/g' temp.xnf > xilv8usb.xnf

xillsusb.xnf : v8_lib xil_cfg.$(HDL) ./v8_lib/xil240hq.$(HDL) ./v8_lib/clk_ctl.$(HDL) \
	./v8_lib/asic_v8.$(HDL) ./v8_lib/v8_top.$(HDL) ./v8_lib/v8_addr.$(HDL) \
	./v8_lib/v8_alu.$(HDL) ./v8_lib/v8_regs.$(HDL) ./v8_lib/op_dcd.$(HDL) \
	./v8_lib/vuart.$(HDL) ./v8_lib/vjtag.$(HDL) ./v8_lib/vtimer.$(HDL) \
	./v8_lib/v1284.$(HDL) ./v8_lib/vpio.$(HDL) ./v8_lib/v8_deice.$(HDL) \
	cfg_usb.$(HDL) vusb_top.$(HDL) dpllnrzi.$(HDL) vusb.$(HDL) \
	up_int.$(HDL) usb_sie.$(HDL) fifo8xn.$(HDL) 
	sed -e 's/clk_usb 	: INOUT.*$$/clk_usb       : IN std_logic;/' \
            -e 's/tck         : INOUT.*$$/tck          : IN std_logic;/' \
            -e '/tck_buf1/d' \
            -e '/tck_buf2/s/tck_in/tck/' \
            -e '/tck_buf3/d' \
            ./v8_lib/xil240hq.$(HDL) > temp.$(HDL)
	gc './v8_lib/clk_ctl.$(HDL) ./v8_lib/pwr_save.$(HDL) ./v8_lib/v8_alu.$(HDL) ./v8_lib/op_dcd.$(HDL) ./v8_lib/v8_addr.$(HDL) ./v8_lib/v8_regs.$(HDL) ./v8_lib/v8_top.$(HDL) ./v8_lib/asic_v8.$(HDL) ./v8_lib/vuart.$(HDL) ./v8_lib/vjtag.$(HDL) ./v8_lib/v8_deice.$(HDL) ./v8_lib/vtimer.$(HDL) ./v8_lib/v1284.$(HDL) ./v8_lib/vpio.$(HDL) cfg_usb.$(HDL) vusb_top.$(HDL) dpllnrzi.$(HDL) vusb.$(HDL) up_int.$(HDL) usb_sie.$(HDL) fifo8xn.$(HDL) temp.$(HDL) xil_cfg.$(HDL)' \
	temp.xnf -INPUT_FORMAT=$(LANG) \
	-SOURCE=$(TECHNOLOGY) \
	-TARGET=$(TECHNOLOGY) -OUTPUT_FORMAT=XNF \
	-EFFORT=quick \
	-nocomplex_ios -part=4062xlHQ240 -process=3 -nocontrol \
	-notimespec_generate \
	-NOINFER_GLOBAL_SR -noxlx_fast_slew -nomap_global_bufs \
	-select_modgen=fast -wire_table=4036ex-3_avg \
	-CHIP -area -encoding=binary -maxarea=1900 \
	-maxdly=62 -max_frequency=16 \
	-entity=xil_ls_cfg
#	-set_var partition_size=8000 \
#	-entity=xil240hq 
#	-noopt=ibuf -noopt=bufgls -noopt=obuft \
#	-noopt=bistrom -noopt=ramd \
#	-noopt=ipad -noopt=obuft_ng -save_all \
	rm -f xillsusb.xnf
	sed -e 's/xil_ls_cfg_//g' -e 's/obuft_ng/obuft/g' \
	-e 's/I, tck_dup0/I, GND0/g' temp.xnf > xillsusb.xnf

a10k240.edf : v8_lib alt_cfg.$(HDL) ./v8_lib/a10k240.$(HDL) \
	./v8_lib/clk_ctl.$(HDL) ./v8_lib/pwr_save.$(HDL) \
	./v8_lib/asic_v8.$(HDL) ./v8_lib/v8_top.$(HDL) ./v8_lib/v8_addr.$(HDL) \
	./v8_lib/v8_alu.$(HDL) ./v8_lib/v8_regs.$(HDL) ./v8_lib/op_dcd.$(HDL) \
	./v8_lib/alt_cfg_bistrom.$(HDL)  ./v8_lib/vuart.$(HDL) \
	./v8_lib/vjtag.$(HDL) ./v8_lib/vtimer.$(HDL) \
	./v8_lib/v1284.$(HDL) ./v8_lib/vpio.$(HDL) ./v8_lib/v8_deice.$(HDL) \
	cfg_usb.$(HDL) vusb_top.$(HDL) vusb.$(HDL) \
	up_int.$(HDL) usb_sie.$(HDL) fifo8xn.$(HDL) 
	rm -f alt_cfg_bistrom.$(HDL)
	cp ./v8_lib/alt_cfg_bistrom.$(HDL) .
	gc './v8_lib/clk_ctl.$(HDL) ./v8_lib/pwr_save.$(HDL) ./v8_lib/v8_alu.$(HDL) ./v8_lib/op_dcd.$(HDL) ./v8_lib/v8_addr.$(HDL) ./v8_lib/v8_regs.$(HDL) ./v8_lib/v8_top.$(HDL) ./v8_lib/asic_v8.$(HDL) ./v8_lib/vuart.$(HDL) ./v8_lib/vjtag.$(HDL) ./v8_lib/v8_deice.$(HDL) ./v8_lib/vtimer.$(HDL) ./v8_lib/v1284.$(HDL) ./v8_lib/vpio.$(HDL) cfg_usb.$(HDL) vusb_top.$(HDL) vusb.$(HDL) up_int.$(HDL) usb_sie.$(HDL) fifo8xn.$(HDL) ./v8_lib/a10k240.$(HDL) alt_cfg.$(HDL)' \
	a10k240.edf -INPUT_FORMAT=$(LANG) \
	-SOURCE=flex10 \
	-TARGET=flex10 -OUTPUT_FORMAT=edif \
	-EFFORT=quick \
	-nocomplex_ios -nocontrol -noacf \
	-set_var -partition_size=8000 \
	-select_modgen=fast \
	-CHIP -area -encoding=binary \
	-max_frequency=16 \
	-entity=alt_cfg

a10k240_ls.edf : v8_lib alt_cfg.$(HDL) ./v8_lib/a10k240.$(HDL) \
	./v8_lib/clk_ctl.$(HDL) ./v8_lib/pwr_save.$(HDL) \
	./v8_lib/asic_v8.$(HDL) ./v8_lib/v8_top.$(HDL) ./v8_lib/v8_addr.$(HDL) \
	./v8_lib/v8_alu.$(HDL) ./v8_lib/v8_regs.$(HDL) ./v8_lib/op_dcd.$(HDL) \
	./v8_lib/alt_cfg_bistrom.$(HDL)  ./v8_lib/vuart.$(HDL) \
	./v8_lib/vjtag.$(HDL) ./v8_lib/vtimer.$(HDL) \
	./v8_lib/v1284.$(HDL) ./v8_lib/vpio.$(HDL) ./v8_lib/v8_deice.$(HDL) \
	cfg_usb.$(HDL) vusb_top.$(HDL) vusb.$(HDL) \
	up_int.$(HDL) usb_sie.$(HDL) fifo8xn.$(HDL) 
	rm -f alt_cfg_bistrom.$(HDL)
	cp ./v8_lib/alt_cfg_bistrom.$(HDL) .
	gc './v8_lib/clk_ctl.$(HDL) ./v8_lib/pwr_save.$(HDL) ./v8_lib/v8_alu.$(HDL) ./v8_lib/op_dcd.$(HDL) ./v8_lib/v8_addr.$(HDL) ./v8_lib/v8_regs.$(HDL) ./v8_lib/v8_top.$(HDL) ./v8_lib/asic_v8.$(HDL) ./v8_lib/vuart.$(HDL) ./v8_lib/vjtag.$(HDL) ./v8_lib/v8_deice.$(HDL) ./v8_lib/vtimer.$(HDL) ./v8_lib/v1284.$(HDL) ./v8_lib/vpio.$(HDL) cfg_usb.$(HDL) vusb_top.$(HDL) vusb.$(HDL) up_int.$(HDL) usb_sie.$(HDL) fifo8xn.$(HDL) ./v8_lib/a10k240.$(HDL) alt_cfg.$(HDL)' \
	a10k240_ls.edf -INPUT_FORMAT=$(LANG) \
	-SOURCE=flex10 \
	-TARGET=flex10 -OUTPUT_FORMAT=edif \
	-EFFORT=quick \
	-nocomplex_ios -nocontrol -noacf \
	-set_var -partition_size=8000 \
	-select_modgen=fast \
	-CHIP -area -encoding=binary \
	-max_frequency=16 \
	-entity=alt_ls_cfg

dpllnrzi.edf : dpllnrzi.$(HDL) 
	gc 'dpllnrzi.$(HDL)' \
	dpllnrzi.edf -INPUT_FORMAT=$(LANG) \
	-MODGEN=flex10 \
	-SOURCE=flex10 \
	-TARGET=flex10 -OUTPUT_FORMAT=edif \
	-EFFORT=quick \
	-nocomplex_ios -nocontrol -noacf \
	-set_var -partition_size=8000 \
	-select_modgen=fast \
	-MACRO -area -encoding=binary \
	-max_frequency=48 

a10k240.pof : a10k240.edf a10k240.acf dpllnrzi.edf \
		alt_cfg_bistrom.vhd ./software/bistrom.ihx
	maxplus2 -compile a10k240

####################Xilinx xl build################################
xilv8usb.ncd : xilv8usb.xnf  xilv8usb.ucf bistrom.xnf
#	ngdbuild -p 4062xlhq240-3 xilv8usb.xnf -uc xilv8usb.ucf
	ngdbuild -p 4062xl-3-hq240 xilv8usb.xnf -uc xilv8usb.ucf
#	map -p 4062xlhq240-3 -c 95 -cm balanced xilv8usb
#	map -p 4062xlhq240-3
	map -p xc4062xl-3-hq240 xilv8usb.ngd -o xilv8usb.ncd xilv8usb.pcf

xilv8usb_pr.ncd : xilv8usb.ncd
	nice -10 par -l 5 -i 2 -d 2 -w xilv8usb.ncd xilv8usb_pr.ncd xilv8usb.pcf
	trce -v 100 xilv8usb_pr xilv8usb.pcf
	bitgen -w xilv8usb_pr

xillsusb.ncd : xillsusb.xnf  xilv8usb.ucf bistrom.xnf
#	ngdbuild -p 4062xlhq240-3 xillsusb.xnf -uc xilv8usb.ucf
	ngdbuild -p 4062xl-3-hq240 xillsusb.xnf -uc xilv8usb.ucf
#	map -p 4062xlhq240-3 -c 95 -cm balanced xillsusb
#	map -p 4062xlhq240-3 xillsusb
	map -p xc4062xl-3-hq240 xillsusb.ngd -o xillsusb.ncd xillsusb.pcf

xillsusb_pr.ncd : xillsusb.ncd
	nice -10 par -l 5 -i 2 -d 2 -w xillsusb.ncd xillsusb_pr.ncd xillsusb.pcf
	trce -v 100 xillsusb_pr xillsusb.pcf
	bitgen -w xillsusb_pr

# To burn proms you need to split the bit file into 4 256Kbit devices.
xv8vusb1.mcs : xilv8usb_pr.ncd
	promgen -p mcs -s 32 32 32 32 32 32 -o xv8vusb1.mcs xv8vusb2.mcs \
	xv8vusb3.mcs xv8vusb4.mcs xv8vusb5.mcs xv8vusb6.mcs -u 0 xilv8usb_pr.bit

# the next line will create a back annotated netlist
#	ngdanno xilv8usb_pr.ncd
# now we can create a vhdl simulation gate level netlist.
#	ngd2vhdl -a -w xilv8usb_pr.nga


clean :
	rm -f *.lis
	rm -f *.log
	rm -f *.rpt
	rm -f *.wav
