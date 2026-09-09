vlib work

# CPU
#. ./compile_cpu.sh
 vlog ../rtl/ARMWrap/jtag_sync.v
#vlog +incdir+../rtl/ARMWrap ../rtl/ARMWrap/arm926_axi.v

# BUS
 vlog ../rtl/AXIBUS/ReadChannel/AHB0_ReqCnt.v
 vlog ../rtl/AXIBUS/ReadChannel/AHB1_ReqCnt.v
 vlog ../rtl/AXIBUS/ReadChannel/DDR_ReqCnt.v
 vlog ../rtl/AXIBUS/ReadChannel/APB0_ReqCnt.v
 vlog ../rtl/AXIBUS/ReadChannel/APB1_ReqCnt.v
 vlog ../rtl/AXIBUS/ReadChannel/SMC_ReqCnt.v
 vlog ../rtl/AXIBUS/ReadChannel/SSRAM_ReqCnt.v
 vlog ../rtl/AXIBUS/ReadChannel/default_ReqCnt.v
 vlog ../rtl/AXIBUS/ReadChannel/AHB0_LockCtlRdmi.v
 vlog ../rtl/AXIBUS/ReadChannel/AHB1_LockCtlRdmi.v
 vlog ../rtl/AXIBUS/ReadChannel/DDR_LockCtlRdmi.v
 vlog ../rtl/AXIBUS/ReadChannel/APB0_LockCtlRdmi.v
 vlog ../rtl/AXIBUS/ReadChannel/APB1_LockCtlRdmi.v
 vlog ../rtl/AXIBUS/ReadChannel/SMC_LockCtlRdmi.v
 vlog ../rtl/AXIBUS/ReadChannel/SSRAM_LockCtlRdmi.v
 vlog ../rtl/AXIBUS/ReadChannel/default_LockCtlRdmi.v
 vlog ../rtl/AXIBUS/ReadChannel/AHB0_ReadChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/AHB1_ReadChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/DDR_ReadChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/APB0_ReadChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/APB1_ReadChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/SMC_ReadChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/SSRAM_ReadChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/default_ReadChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/ARMD_ReadChannelsi.v
 vlog ../rtl/AXIBUS/ReadChannel/RDCH_ARMD_PermitCtl.v
 vlog ../rtl/AXIBUS/ReadChannel/ARMI_ReadChannelsi.v
 vlog ../rtl/AXIBUS/ReadChannel/RDCH_ARMI_PermitCtl.v
 vlog ../rtl/AXIBUS/ReadChannel/DMAC_ReadChannelsi.v
 vlog ../rtl/AXIBUS/ReadChannel/RDCH_DMAC_PermitCtl.v
 vlog ../rtl/AXIBUS/ReadChannel/MAC_ReadChannelsi.v
 vlog ../rtl/AXIBUS/ReadChannel/RDCH_MAC_PermitCtl.v
 vlog ../rtl/AXIBUS/ReadChannel/PCI_ReadChannelsi.v
 vlog ../rtl/AXIBUS/ReadChannel/RDCH_PCI_PermitCtl.v
 vlog ../rtl/AXIBUS/ReadChannel/TOP/ReadChannel.v
 vlog ../rtl/AXIBUS/WriteChannel/AHB0_ReqInter.v
 vlog ../rtl/AXIBUS/WriteChannel/AHB1_ReqInter.v
 vlog ../rtl/AXIBUS/WriteChannel/DDR_ReqInter.v
 vlog ../rtl/AXIBUS/WriteChannel/APB0_ReqInter.v
 vlog ../rtl/AXIBUS/WriteChannel/APB1_ReqInter.v
 vlog ../rtl/AXIBUS/WriteChannel/SMC_ReqInter.v
 vlog ../rtl/AXIBUS/WriteChannel/SSRAM_ReqInter.v
 vlog ../rtl/AXIBUS/WriteChannel/default_ReqInter.v
 vlog ../rtl/AXIBUS/WriteChannel/AHB0_LockCtlWrmi.v
 vlog ../rtl/AXIBUS/WriteChannel/AHB1_LockCtlWrmi.v
 vlog ../rtl/AXIBUS/WriteChannel/DDR_LockCtlWrmi.v
 vlog ../rtl/AXIBUS/WriteChannel/APB0_LockCtlWrmi.v
 vlog ../rtl/AXIBUS/WriteChannel/APB1_LockCtlWrmi.v
 vlog ../rtl/AXIBUS/WriteChannel/SMC_LockCtlWrmi.v
 vlog ../rtl/AXIBUS/WriteChannel/SSRAM_LockCtlWrmi.v
 vlog ../rtl/AXIBUS/WriteChannel/default_LockCtlWrmi.v
 vlog ../rtl/AXIBUS/WriteChannel/AHB0_WriteChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/AHB1_WriteChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/DDR_WriteChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/APB0_WriteChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/APB1_WriteChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/SMC_WriteChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/SSRAM_WriteChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/default_WriteChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/ARMD_WriteChannelsi.v
 vlog ../rtl/AXIBUS/WriteChannel/WRCH_ARMD_PermitCtl.v
 vlog ../rtl/AXIBUS/WriteChannel/DMAC_WriteChannelsi.v
 vlog ../rtl/AXIBUS/WriteChannel/WRCH_DMAC_PermitCtl.v
 vlog ../rtl/AXIBUS/WriteChannel/MAC_WriteChannelsi.v
 vlog ../rtl/AXIBUS/WriteChannel/WRCH_MAC_PermitCtl.v
 vlog ../rtl/AXIBUS/WriteChannel/PCI_WriteChannelsi.v
 vlog ../rtl/AXIBUS/WriteChannel/WRCH_PCI_PermitCtl.v
 vlog ../rtl/AXIBUS/WriteChannel/TOP/WriteChannel.v
 vlog ../rtl/AXIBUS/WriteChannel/ARMD_RS_WriteChannelsi.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/ARMD_AWSIm2si_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/ARMD_WDSIm2si_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/ARMD_WRSIm2si_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/ARMD_AWSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/ARMD_WDSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/ARMD_WRSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/ARMD_RS_ReadChannelsi.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/ARMD_ARSIm2si_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/ARMD_RDSIm2si_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/ARMD_ARSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/ARMD_RDSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/ARMI_RS_ReadChannelsi.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/ARMI_ARSIm2si_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/ARMI_RDSIm2si_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/ARMI_ARSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/ARMI_RDSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/DMAC_RS_WriteChannelsi.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/DMAC_AWSIm2si_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/DMAC_WDSIm2si_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/DMAC_WRSIm2si_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/DMAC_RS_ReadChannelsi.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/DMAC_ARSIm2si_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/DMAC_RDSIm2si_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/MAC_RS_WriteChannelsi.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/MAC_AWSIm2si_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/MAC_WDSIm2si_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/MAC_WRSIm2si_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/MAC_AWSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/MAC_WDSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/MAC_WRSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/MAC_RS_ReadChannelsi.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/MAC_ARSIm2si_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/MAC_RDSIm2si_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/MAC_ARSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/MAC_RDSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/PCI_RS_WriteChannelsi.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/PCI_AWSIm2si_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/PCI_WDSIm2si_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/PCI_WRSIm2si_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/PCI_AWSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/PCI_WDSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/PCI_WRSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/PCI_RS_ReadChannelsi.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/PCI_ARSIm2si_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/PCI_RDSIm2si_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/PCI_ARSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/PCI_RDSIsi2mi_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/AHB0_RS_WriteChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/AHB0_RS_ReadChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/AHB0_AWMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/AHB0_WDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/AHB0_WRMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/AHB0_ARMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/AHB0_RDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/AHB1_RS_WriteChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/AHB1_RS_ReadChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/AHB1_AWMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/AHB1_WDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/AHB1_WRMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/AHB1_ARMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/AHB1_RDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/DDR_RS_WriteChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/DDR_RS_ReadChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/DDR_AWMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/DDR_WDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/DDR_WRMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/DDR_ARMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/DDR_RDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/APB0_RS_WriteChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/APB0_RS_ReadChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/APB0_AWMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/APB0_WDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/APB0_WRMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/APB0_ARMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/APB0_RDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/APB1_RS_WriteChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/APB1_RS_ReadChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/APB1_AWMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/APB1_WDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/APB1_WRMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/APB1_ARMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/APB1_RDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/SMC_RS_WriteChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/SMC_RS_ReadChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/SMC_AWMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/SMC_WDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/SMC_WRMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/SMC_ARMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/SMC_RDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/SSRAM_RS_WriteChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/SSRAM_RS_ReadChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/SSRAM_AWMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/SSRAM_WDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/SSRAM_WRMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/SSRAM_ARMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/SSRAM_RDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/default_RS_WriteChannelmi.v
 vlog ../rtl/AXIBUS/ReadChannel/default_RS_ReadChannelmi.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/default_AWMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/default_WDMImi2s_registered.v
 vlog ../rtl/AXIBUS/WriteChannel/RegisterSlice/default_WRMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/default_ARMImi2s_registered.v
 vlog ../rtl/AXIBUS/ReadChannel/RegisterSlice/default_RDMImi2s_registered.v
 vlog ../rtl/AXIBUS/TOP/SBUS.v
 

# BUS Glue Logic
 vlog ../rtl/AXIGlue/AHB2AXIBridge/AHB2AXIBridge.v
 vlog ../rtl/AXIGlue/AXI2AHBBridge/AXI2AHBBridge.v
 vlog ../rtl/AXIGlue/AXI2APBBridge/AXI2APBBridge_Simple.v
 vlog ../rtl/AXIGlue/AXI2APBBridge/AXI2APBBridge.v
 vlog ../rtl/AXIGlue/AXI2APBBridge/AXI2APBBridge_PREADY.v
 vlog ../rtl/AXIGlue/DefaultSlave/DefaultSlave.v
# vlog ../rtl/AXIGlue/DSBridge/F2SSlice_Advanced.v
# vlog ../rtl/AXIGlue/DSBridge/S2FSlice.v

# DMA Ctrl
 vlog ../rtl/DMACtrl/DmacControl.v
 vlog ../rtl/DMACtrl/DmacFifo.v
 vlog ../rtl/DMACtrl/DmacEngine.v
 vlog ../rtl/DMACtrl/DmacChReg.v
 vlog ../rtl/DMACtrl/DmacChRegPOR.v
 vlog ../rtl/DMACtrl/DmacRegFile4Ch.v
 vlog ../rtl/DMACtrl/DmacRegFile4ChPOR.v
 vlog ../rtl/DMACtrl/DmacReqAck4Ch.v
 vlog ../rtl/DMACtrl/Dmac4Ch.v
 vlog ../rtl/DMACtrl/Dmac4ChPOR.v
 vlog ../rtl/DMACtrl/DmacAPBMux.v
 vlog ../rtl/DMACtrl/DmacAXIArbiter.v
 vlog ../rtl/DMACtrl/Dmac2x4Ch.v


# Int SRAM Controller
 vlog ../rtl/IntSRAMCtrl/IntSRAMController.v
# Int SRAM Model
 vlog ../model/SSRAM32bit.v
 vlog ../model/SSRAM8bit.v

# SMC
 vlog +incdir+../rtl/SMC ../rtl/SMC/SMC_REG.v
 vlog +incdir+../rtl/SMC ../rtl/SMC/SRAM_CTRL.v
 vlog +incdir+../rtl/SMC ../rtl/SMC/AXI_ESMC_interface.v
 vlog +incdir+../rtl/SMC ../rtl/SMC/SMC_TOP.v


# DDR Controller
 vlog +incdir+../rtl/DDRCtrl ../rtl/DDRCtrl/DDRAi.v
 vlog +incdir+../rtl/DDRCtrl ../rtl/DDRCtrl/DDRBLQ.v
 vlog +incdir+../rtl/DDRCtrl ../rtl/DDRCtrl/DDRBsm.v
 vlog +incdir+../rtl/DDRCtrl ../rtl/DDRCtrl/DDRCas.v
 vlog +incdir+../rtl/DDRCtrl ../rtl/DDRCtrl/DDRCtl.v
 vlog +incdir+../rtl/DDRCtrl ../rtl/DDRCtrl/DDRRas.v
 vlog +incdir+../rtl/DDRCtrl ../rtl/DDRCtrl/DDRRds.v
 vlog +incdir+../rtl/DDRCtrl ../rtl/DDRCtrl/DDRRQ.v
 vlog +incdir+../rtl/DDRCtrl ../rtl/DDRCtrl/DDRSpi.v
 vlog +incdir+../rtl/DDRCtrl ../rtl/DDRCtrl/DDRTop.v
 vlog +incdir+../rtl/DDRCtrl ../rtl/DDRCtrl/DDRWQ.v

# GPIO
 vlog ../rtl/GPIO/Gpio.v
 vlog ../rtl/GPIO/Gpio2Ch.v

# UART
 vlog ../rtl/UART/RegBlk.v
 vlog ../rtl/UART/RxBlock.v
 vlog ../rtl/UART/TxBlock.v
 vlog ../rtl/UART/Uart4Ch.v
 vlog ../rtl/UART/UartTop.v
# VIC
 vlog ../rtl/VIC/VIC.v
 vlog ../rtl/VIC/vic_master_arbiter.v
 vlog ../rtl/VIC/vic_slave_arbiter.v

# I2C
 vlog ../rtl/I2CMaster/I2CClkCtrl.v
 vlog ../rtl/I2CMaster/I2CDetect.v
 vlog ../rtl/I2CMaster/I2CLoClk.v
 vlog ../rtl/I2CMaster/I2CRegIF.v
 vlog ../rtl/I2CMaster/I2CShift.v
 vlog ../rtl/I2CMaster/I2CTop.v

# Timer
 vlog ../rtl/Timer/timer_pwm.v
 vlog ../rtl/Timer/Timer4Ch.v
# WDT
 vlog ../rtl/Timer/WatchDog.v

# I2S Controller
 vlog ../rtl/I2S/I2S_Control.v
 vlog ../rtl/I2S/I2S_DTO.v
 vlog ../rtl/I2S/I2S_ClockMgr.v
 vlog ../rtl/I2S/I2S_Serializer.v
 vlog ../rtl/I2S/I2S_Deserializer.v
 vlog ../rtl/I2S/I2S_FIFO_RAM.v
 vlog ../rtl/I2S/I2S_FIFO.v
 vlog ../rtl/I2S/I2S_Top.v

# NAND Flash Controller
 vlog ../rtl/NANDCtrl/NFAPBIF.v
 vlog ../rtl/NANDCtrl/NFBoot.v
 vlog ../rtl/NANDCtrl/NFCmdQ.v
 vlog ../rtl/NANDCtrl/NFCtrl.v
 vlog ../rtl/NANDCtrl/NFDFIFO.v
 vlog ../rtl/NANDCtrl/NFEcc.v
 vlog ../rtl/NANDCtrl/NFEcc16.v
 vlog ../rtl/NANDCtrl/NFEcc8.v
 vlog ../rtl/NANDCtrl/NFRnBFilter.v
 vlog ../rtl/NANDCtrl/NFTop.v

#ResourceShare
 vlog ../rtl/ResourceShare/ResourceShare.v

#SPI
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspApbif.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspDataStp.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspIntGen.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspMTxRxCntl.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspNewDMA.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspRxFCntl.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspRxFIFO.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspRxRegFile.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspScaleCntr.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspSTxRxCntl.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspTest.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspTxFCntl.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspTxFIFO.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspTxLJustify.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/SspTxRegFile.v
 vlog +incdir+../rtl/SPI ../rtl/SPI/Ssp.v

# Etc
 vlog ../rtl/Etc/ClockResetGen.v
 vlog ../rtl/Etc/SevenSegment.v

# Top
 vlog +incdir+../rtl/Top ../rtl/Top/ETRI_UWBCore.v
 vlog +incdir+../rtl/Top ../rtl/Top/ETRI_UWBFPGA.v


# Test Bench Compile
 vlog ../model/eprom16bit.v
 vlog ../model/ddr.v
 vlog ../model/I2S_DAC.v
 vlog ../model/xilinx/IDELAY.v

 vlog ./tb.v

#vsim -load_elab arm_axi_nodebug.elab 

