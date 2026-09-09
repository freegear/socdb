#! /bin/sh
action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work

RTL_PATH=../../RTL/v0.1
MOD_PATH=../../RTL/model
ARM926EJS_PATH=../../../../../Docs/cpu/ARM926EJS/verilog/ARM926EJS

ARM_MEM_RTL_PATH=../../../ARM926EJS_8K8K-TSMC13/RTL/v0.1
MEMLIB=$ARM_MEM_RTL_PATH/MEM-TSMC13/LIB

# 
action vlog +incdir+$ARM_MEM_RTL_PATH/MAIN_ARM926EJS $ARM926EJS_PATH/ARM926EJSCore_test.v
action vlog +incdir+$ARM_MEM_RTL_PATH/MAIN_ARM926EJS $ARM_MEM_RTL_PATH/MAIN_ARM926EJS/ARM926EJS_8K8K-TSMC13.v
action vlog +incdir+$ARM_MEM_RTL_PATH/MAIN_ARM926EJS $ARM_MEM_RTL_PATH/MAIN_ARM926EJS/ARM926EJS_ram_testbench.v

# cache ram
action vlog $MEMLIB/RA1SH512x32.v
action vlog $MEMLIB/RA1SH512x32_on.v
action vlog $MEMLIB/RF1SH16x24.v
action vlog $MEMLIB/RF1SH64x22.v
action vlog $MEMLIB/RF1SH128X22.v
action vlog $ARM_MEM_RTL_PATH/MAIN_ARM926EJS/DirtyRam8k.v

# mmu ram
action vlog $MEMLIB/RF1SH32x26.v
action vlog $MEMLIB/RF1SH32x30.v
action vlog $MEMLIB/RF1SH32x128_on.v
