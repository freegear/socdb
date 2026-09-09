#! /bin/sh
action()
{
  $* || exit 1
}

if [ -e work ]; then
    rm -fr work
fi
vlib work


RTL_PATH=../rtl
MOD_PATH=../model

# CPU
#. ./compile_cpu.sh
action vlog $RTL_PATH/ARMWrap/jtag_sync.v
#action vlog +incdir+$RTL_PATH/ARMWrap $RTL_PATH/ARMWrap/arm926_axi.v

# BUS
. ./compile_bus.sh

# BUS Glue Logic
action vlog $RTL_PATH/AXIGlue/AHB2AXIBridge/AHB2AXIBridge.v
action vlog $RTL_PATH/AXIGlue/AXI2AHBBridge/AXI2AHBBridge.v
action vlog $RTL_PATH/AXIGlue/AXI2APBBridge/AXI2APBBridge_Simple.v
action vlog $RTL_PATH/AXIGlue/AXI2APBBridge/AXI2APBBridge.v
action vlog $RTL_PATH/AXIGlue/AXI2APBBridge/AXI2APBBridge_PREADY.v
action vlog $RTL_PATH/AXIGlue/DefaultSlave/DefaultSlave.v
#action vlog $RTL_PATH/AXIGlue/DSBridge/F2SSlice_Advanced.v
#action vlog $RTL_PATH/AXIGlue/DSBridge/S2FSlice.v

# DMA Ctrl
action vlog $RTL_PATH/DMACtrl/DmacControl.v
action vlog $RTL_PATH/DMACtrl/DmacFifo.v
action vlog $RTL_PATH/DMACtrl/DmacEngine.v
action vlog $RTL_PATH/DMACtrl/DmacChReg.v
action vlog $RTL_PATH/DMACtrl/DmacChRegPOR.v
action vlog $RTL_PATH/DMACtrl/DmacRegFile4Ch.v
action vlog $RTL_PATH/DMACtrl/DmacRegFile4ChPOR.v
action vlog $RTL_PATH/DMACtrl/DmacReqAck4Ch.v
action vlog $RTL_PATH/DMACtrl/Dmac4Ch.v
action vlog $RTL_PATH/DMACtrl/Dmac4ChPOR.v
action vlog $RTL_PATH/DMACtrl/DmacAPBMux.v
action vlog $RTL_PATH/DMACtrl/DmacAXIArbiter.v
action vlog $RTL_PATH/DMACtrl/Dmac2x4Ch.v


# Int SRAM Controller
action vlog $RTL_PATH/IntSRAMCtrl/IntSRAMController.v
# Int SRAM Model
action vlog $MOD_PATH/SSRAM32bit.v
action vlog $MOD_PATH/SSRAM8bit.v

# SMC
SMC_INC=$RTL_PATH/SMC
action vlog +incdir+$SMC_INC $RTL_PATH/SMC/SMC_REG.v
action vlog +incdir+$SMC_INC $RTL_PATH/SMC/SRAM_CTRL.v
action vlog +incdir+$SMC_INC $RTL_PATH/SMC/AXI_ESMC_interface.v
action vlog +incdir+$SMC_INC $RTL_PATH/SMC/SMC_TOP.v


# DDR Controller
DDR_INC=$RTL_PATH/DDRCtrl
action vlog +incdir+$DDR_INC $RTL_PATH/DDRCtrl/DDRAi.v
action vlog +incdir+$DDR_INC $RTL_PATH/DDRCtrl/DDRBLQ.v
action vlog +incdir+$DDR_INC $RTL_PATH/DDRCtrl/DDRBsm.v
action vlog +incdir+$DDR_INC $RTL_PATH/DDRCtrl/DDRCas.v
action vlog +incdir+$DDR_INC $RTL_PATH/DDRCtrl/DDRCtl.v
action vlog +incdir+$DDR_INC $RTL_PATH/DDRCtrl/DDRRas.v
action vlog +incdir+$DDR_INC $RTL_PATH/DDRCtrl/DDRRds.v
action vlog +incdir+$DDR_INC $RTL_PATH/DDRCtrl/DDRRQ.v
action vlog +incdir+$DDR_INC $RTL_PATH/DDRCtrl/DDRSpi.v
action vlog +incdir+$DDR_INC $RTL_PATH/DDRCtrl/DDRTop.v
action vlog +incdir+$DDR_INC $RTL_PATH/DDRCtrl/DDRWQ.v

# GPIO
action vlog $RTL_PATH/GPIO/Gpio.v
action vlog $RTL_PATH/GPIO/Gpio2Ch.v

# UART
action vlog $RTL_PATH/UART/RegBlk.v
action vlog $RTL_PATH/UART/RxBlock.v
action vlog $RTL_PATH/UART/TxBlock.v
action vlog $RTL_PATH/UART/Uart4Ch.v
action vlog $RTL_PATH/UART/UartTop.v
# VIC
action vlog $RTL_PATH/VIC/VIC.v
action vlog $RTL_PATH/VIC/vic_master_arbiter.v
action vlog $RTL_PATH/VIC/vic_slave_arbiter.v

# I2C
action vlog $RTL_PATH/I2CMaster/I2CClkCtrl.v
action vlog $RTL_PATH/I2CMaster/I2CDetect.v
action vlog $RTL_PATH/I2CMaster/I2CLoClk.v
action vlog $RTL_PATH/I2CMaster/I2CRegIF.v
action vlog $RTL_PATH/I2CMaster/I2CShift.v
action vlog $RTL_PATH/I2CMaster/I2CTop.v

# Timer
action vlog $RTL_PATH/Timer/timer_pwm.v
action vlog $RTL_PATH/Timer/Timer4Ch.v
# WDT
action vlog $RTL_PATH/Timer/WatchDog.v

# I2S Controller
action vlog $RTL_PATH/I2S/I2S_Control.v
action vlog $RTL_PATH/I2S/I2S_DTO.v
action vlog $RTL_PATH/I2S/I2S_ClockMgr.v
action vlog $RTL_PATH/I2S/I2S_Serializer.v
action vlog $RTL_PATH/I2S/I2S_Deserializer.v
action vlog $RTL_PATH/I2S/I2S_FIFO_RAM.v
action vlog $RTL_PATH/I2S/I2S_FIFO.v
action vlog $RTL_PATH/I2S/I2S_Top.v

# NAND Flash Controller
action vlog $RTL_PATH/NANDCtrl/NFAPBIF.v
action vlog $RTL_PATH/NANDCtrl/NFBoot.v
action vlog $RTL_PATH/NANDCtrl/NFCmdQ.v
action vlog $RTL_PATH/NANDCtrl/NFCtrl.v
action vlog $RTL_PATH/NANDCtrl/NFDFIFO.v
action vlog $RTL_PATH/NANDCtrl/NFEcc.v
action vlog $RTL_PATH/NANDCtrl/NFEcc16.v
action vlog $RTL_PATH/NANDCtrl/NFEcc8.v
action vlog $RTL_PATH/NANDCtrl/NFRnBFilter.v
action vlog $RTL_PATH/NANDCtrl/NFTop.v

#ResourceShare
action vlog $RTL_PATH/ResourceShare/ResourceShare.v

#SPI
SPI_INC=$RTL_PATH/SPI
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspApbif.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspDataStp.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspIntGen.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspMTxRxCntl.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspNewDMA.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspRxFCntl.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspRxFIFO.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspRxRegFile.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspScaleCntr.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspSTxRxCntl.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspTest.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspTxFCntl.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspTxFIFO.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspTxLJustify.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/SspTxRegFile.v
action vlog +incdir+$SPI_INC $RTL_PATH/SPI/Ssp.v

# Etc
action vlog $RTL_PATH/Etc/ClockResetGen.v
action vlog $RTL_PATH/Etc/SevenSegment.v

# Top
action vlog +incdir+$RTL_PATH/Top $RTL_PATH/Top/ETRI_UWBCore.v
action vlog +incdir+$RTL_PATH/Top $RTL_PATH/Top/ETRI_UWBFPGA.v


# Test Bench Compile
action vlog $MOD_PATH/eprom16bit.v
action vlog $MOD_PATH/ddr.v
action vlog $MOD_PATH/I2S_DAC.v
action vlog $MOD_PATH/xilinx/IDELAY.v
action vlog $MOD_PATH/xilinx/mypll2x.v
action vlog $MOD_PATH/xilinx/glbl.v
action vlog $MOD_PATH/xilinx/BUFG.v
action vlog $MOD_PATH/xilinx/DCM_ADV.v
action vlog $MOD_PATH/xilinx/IBUFG.v

action vlog ./tb.v
vsim -load_elab arm_axi_nodebug.elab glbl tb 

