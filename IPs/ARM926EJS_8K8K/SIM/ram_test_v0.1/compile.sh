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

ARM_MEM_RTL_PATH=../../../ARM926EJS_8K8K/RTL/v0.1
MEMLIB=$ARM_MEM_RTL_PATH/MEM/LIB

# 
action vlog +incdir+$ARM_MEM_RTL_PATH/MAIN_ARM926EJS $ARM926EJS_PATH/ARM926EJSCore_test.v
action vlog +incdir+$ARM_MEM_RTL_PATH/MAIN_ARM926EJS $ARM_MEM_RTL_PATH/MAIN_ARM926EJS/ARM926EJS_8K8K.v
action vlog +incdir+$ARM_MEM_RTL_PATH/MAIN_ARM926EJS $ARM_MEM_RTL_PATH/MAIN_ARM926EJS/ARM926EJS_ram_testbench.v

# cache ram
action vlog $MEMLIB/DDataRam8k.v
action vlog $MEMLIB/DataRamPrim.v
action vlog $MEMLIB/DirtyRamPrim.v
action vlog $MEMLIB/ITagRam8k.v
action vlog $MEMLIB/DTagRam8k.v
action vlog $MEMLIB/DirtyRam8k.v
action vlog $MEMLIB/IDataRam8k.v
action vlog $MEMLIB/ValidRam4k.v

# mmu ram
action vlog $MEMLIB/MMURam30.v
action vlog $MEMLIB/MMURam26.v
