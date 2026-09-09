#! /bin/sh
action()
{
  $* || exit 1
}

#if [ -e work ]; then
#	rm -fr work
#fi
#vlib work

RTL_PATH=../rtl
ARM926_PATH=~/ARM/ARM926
ARM926_OPT="+incdir+$RTL_PATH/ARMWrap +incdir+$ARM926_PATH/ARM9EJS +incdir+$ARM926_PATH/ETM9 +incdir+$ARM926_PATH/CP15 +incdir+$ARM926_PATH/tbench"
# CPU
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsJDec.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsJInBuf.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsJNullPtr.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsJStack.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsClkBlk.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsWRegDecoder.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsREG.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsFwd.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsRegC.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsIMM.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsIPipe.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsISyncr.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsMASeq.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsMainSeq.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsMem.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsPSR.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsPipeCtl.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsRegFwd.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsShALUADec.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsShALUTDec.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsShALUSeq.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsShALUCtl.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsWRegDec.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsMulCtl.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsCoreCtl.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsLU.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsSat.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsAU.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsArmShifter.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsShifter.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsSatTimes2.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsCLZ.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsExecute.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsRam3r2wSDff.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsRegBank.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsMulDP.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsCoreDP.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsWptctl.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsDbgCommsctl.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsICEctl.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsTapScanctl.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsDbgctl.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsWptdp.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsDbgCommsdp.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsICEdp.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsTapScandp.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsDbgdp.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsDbg.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsAGU.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsJArrayBndChk.v
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/ARM9EJS.v

# Log related
action vlog $ARM926_OPT $ARM926_PATH/ARM9EJS/a9ejsLogStatus.v
action vlog $ARM926_OPT $ARM926_PATH/modelgen/disass/bin/disass.v

# BIU directory
action vlog $ARM926_OPT $ARM926_PATH/BIU/a926ejsBIU.v
action vlog $ARM926_OPT $ARM926_PATH/BIU/a926ejsDBIU.v
action vlog $ARM926_OPT $ARM926_PATH/BIU/a926ejsIBIU.v

# CP15 directory
action vlog $ARM926_OPT $ARM926_PATH/CP15/a926ejsCP15.v
action vlog $ARM926_OPT $ARM926_PATH/CP15/a926ejsCPctl.v
action vlog $ARM926_OPT $ARM926_PATH/CP15/a926ejsCPdp.v
action vlog $ARM926_OPT $ARM926_PATH/CP15/a926ejsCPjtag.v
action vlog $ARM926_OPT $ARM926_PATH/CP15/a926ejsCPheader.v

# DExt directory
action vlog $ARM926_OPT $ARM926_PATH/DExt/a926ejsDExtAddrFifo.v
action vlog $ARM926_OPT $ARM926_PATH/DExt/a926ejsDExtDataFifo.v
action vlog $ARM926_OPT $ARM926_PATH/DExt/a926ejsDExtWB.v
action vlog $ARM926_OPT $ARM926_PATH/DExt/a926ejsDExt.v

# ETMIF directory
action vlog $ARM926_OPT $ARM926_PATH/ETMIF/a926ejsETMIF.v

# IExt directory
action vlog $ARM926_OPT $ARM926_PATH/IExt/a926ejsIExtFifo.v
action vlog $ARM926_OPT $ARM926_PATH/IExt/a926ejsIExt.v

# Cache directory
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926CacheBiuIntf.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926CacheDataIntf.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926CacheDirtyIntf.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926CacheEWB.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926CacheFB.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926CachePWB.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926CacheRGen.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926CacheTagIntf.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926CacheUTag.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926CacheValidIntf.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926DataCache.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926InstrCache.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926DCache.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926ICache.v
action vlog $ARM926_OPT $ARM926_PATH/Cache/a926CacheRamGasket.v

# MMU directory
action vlog $ARM926_OPT $ARM926_PATH/MMU/a926ejsMMU.v
action vlog $ARM926_OPT $ARM926_PATH/MMU/a926ejsUTLB.v
action vlog $ARM926_OPT $ARM926_PATH/MMU/a926ejsUTLBentry.v
action vlog $ARM926_OPT $ARM926_PATH/MMU/a926ejsMRAM.v
action vlog $ARM926_OPT $ARM926_PATH/MMU/a926ejsRAM.v

# TCM directory
action vlog $ARM926_OPT $ARM926_PATH/TCM/a926ejsTCM.v
action vlog $ARM926_OPT $ARM926_PATH/TCM/a926ejsTCMCtrl.v
action vlog $ARM926_OPT $ARM926_PATH/TCM/a926ejsTCMWB.v
action vlog $ARM926_OPT $ARM926_PATH/TCM/PartialTestCell.v
action vlog $ARM926_OPT $ARM926_PATH/TCM/PartialTestCell18.v

# a926dffs directory
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffnrx1.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrnx1.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrnx2.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrnx3.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrnx32.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrnx4.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrnx5.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrnx6.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrnx8.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrx1.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrx2.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrx3.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrx32.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrx4.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrx5.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffrx8.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffsnx1.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffsnx32.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffsx1.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffsx32.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffx1.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffx11.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffx12.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffx2.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffx20.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffx22.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffx3.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffx32.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffx4.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffx5.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffx6.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926dffx9.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx1.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx10.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx12.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx15.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx75.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx16.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx18.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx19.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx2.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx20.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx21.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx22.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx23.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx27.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx3.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx30.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx32.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx34.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx4.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx48.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx5.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx6.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx7.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx8.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrnx9.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx1.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx10.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx16.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx18.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx2.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx21.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx22.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx27.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx3.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx30.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx32.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx4.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx5.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx6.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx7.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffrx8.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffsnx1.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffsnx2.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffsnx3.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffsnx32.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffsx1.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffsx3.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffsx32.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx1.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx10.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx11.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx112.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx12.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx16.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx2.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx20.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx22.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx26.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx27.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx28.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx3.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx30.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx31.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx32.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx37.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx38.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx4.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx5.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx56.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx7.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx77.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx8.v
action vlog $ARM926_OPT $ARM926_PATH/a926dffs/a926gdffx9.v

# ARM926EJS directory
action vlog $ARM926_OPT $ARM926_PATH/ARM926EJS/dummy_buffer.v
action vlog $ARM926_OPT $ARM926_PATH/ARM926EJS/a926ejsClkBlk.v
action vlog $ARM926_OPT $ARM926_PATH/ARM926EJS/a926ejsDRoute.v
action vlog $ARM926_OPT $ARM926_PATH/ARM926EJS/a926ejsIRoute.v
action vlog $ARM926_OPT $ARM926_PATH/ARM926EJS/a926ejsSysCtl.v
action vlog $ARM926_OPT $ARM926_PATH/ARM926EJS/a926ejsFCSE.v
action vlog $ARM926_OPT $ARM926_PATH/ARM926EJS/ARM9EJSwrap.v
action vlog $ARM926_OPT $ARM926_PATH/ARM926EJS/a926ejsClkGate.v
action vlog $ARM926_OPT $ARM926_PATH/ARM926EJS/TestWrapper.v
action vlog $ARM926_OPT $ARM926_PATH/ARM926EJS/a926ejsSysDebug.v
action vlog $ARM926_OPT $ARM926_PATH/ARM926EJS/ARM926EJSCore.v

# GTECH library
action vlog $ARM926_OPT $ARM926_PATH/DW_equiv/DW_GTECH_equiv.v

# my own files
#action vlog $ARM926_OPT $RTL_PATH/ARMWrap/a926ejsRAM.v
#action vlog $ARM926_OPT $RTL_PATH/ARMWrap/a926ejsSysDebug.v

action vlog $ARM926_OPT $RTL_PATH/ARMWrap/DataRam8k.v
action vlog $ARM926_OPT $RTL_PATH/ARMWrap/DataRamPrim.v
action vlog $ARM926_OPT $RTL_PATH/ARMWrap/DirtyRam8k.v
action vlog $ARM926_OPT $RTL_PATH/ARMWrap/DirtyRamPrim.v
action vlog $ARM926_OPT $RTL_PATH/ARMWrap/DataTagRam8k.v
action vlog $ARM926_OPT $RTL_PATH/ARMWrap/InstTagRam8k.v
action vlog $ARM926_OPT $RTL_PATH/ARMWrap/ValidRam8k.v
action vlog $ARM926_OPT $RTL_PATH/ARMWrap/ARM926EJS_8K8K.v

