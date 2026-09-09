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
RTL_PATH2=../../RTL/v0.2
MOD_PATH=../../RTL/model
ARM_MEM_RTL_PATH=../../../ARM926EJS_8K8K-TSMC13/RTL/v0.1

ARM_MEM_RTL_PATH2=../../../ARM926EJS_8K8K-TSMC13/RTL/v0.2
MAIN_ARM926=$ARM_MEM_RTL_PATH2/MAIN_ARM926EJS

# MMC Model(modelsim compiled form) should be compied first
action cp -rp $MOD_PATH/MMC/* work


action vlog +incdir+$RTL_PATH2/Top+$MAIN_ARM926 $RTL_PATH2/Top/jtag_md.v


# CPU
./compile_cpu.sh 


action vlog +incdir+$MAIN_ARM926 $RTL_PATH2/ARMWrap/arm926_axi.v

# BUS
./compile_bus.sh 

# BUS Glue Logic
action vlog $RTL_PATH/AXIGlue/AHB2AXIBridge/AHB2AXIBridge.v
action vlog $RTL_PATH/AXIGlue/AXI2APBBridge/AXI2APBBridge_Simple.v
action vlog $RTL_PATH/AXIGlue/AXI2APBBridge/AXI2APBBridge.v
action vlog $RTL_PATH/AXIGlue/DefaultSlave/DefaultSlave.v
action vlog $RTL_PATH/AXIGlue/DSBridge/F2SSlice_Advanced.v
action vlog $RTL_PATH/AXIGlue/DSBridge/S2FSlice.v

# DMA Ctrl
action vlog $RTL_PATH/DMACtrl/DmacControl.v
action vlog $RTL_PATH/DMACtrl/DmacFifo.v
action vlog $RTL_PATH/DMACtrl/DmacEngine.v
action vlog $RTL_PATH/DMACtrl/DmacChReg.v
action vlog $RTL_PATH/DMACtrl/DmacRegFile4Ch.v
action vlog $RTL_PATH/DMACtrl/DmacReqAck4Ch.v
action vlog $RTL_PATH/DMACtrl/Dmac4Ch.v
action vlog $RTL_PATH/DMACtrl/DmacAPBMux.v
action vlog $RTL_PATH/DMACtrl/DmacAXIArbiter.v
action vlog $RTL_PATH/DMACtrl/Dmac2x4Ch.v

# Int SRAM Controller
action vlog $RTL_PATH/IntSRAMCtrl/IntSRAMController.v
# Int SRAM Model
action vlog $MOD_PATH/SSRAM32bit.v
action vlog $MOD_PATH/SSRAM8bit.v

# SMC
action vlog $RTL_PATH/SMC/SMC_REG.v
action vlog $RTL_PATH/SMC/SRAM_CTRL.v
action vlog $RTL_PATH/SMC/AXI_ESMC_interface.v
action vlog $RTL_PATH/SMC/SMC_TOP.v

# Display Controller
DM_INC=../../RTL/v0.1/DM
action vlog +incdir+$DM_INC $RTL_PATH/DM/CursorDma.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/CursorPlane.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/DmaBLQ.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/DmARIf.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/DmRDmaArb.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/DmReg.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/DmTop.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/GraphicDma.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/GraphicPlane.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/LcdOutMux.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/LcdReg.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/LcdSyncSysClk.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/LcdTG.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/MixerFIFO.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/PaletteMem.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/PlaneGamma.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/PlaneMixer.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/ScFIFO16x32.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/ScFIFO2048x16.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/ScFIFO32x32.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/ScFIFO64x32.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/ScFIFO.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/VideoCSC.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/VideoDma.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/VideoFC.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/VideoPlane.v
action vlog +incdir+$DM_INC $RTL_PATH/DM/VScInF.v

# SDRAM Controller
#SDRAM_INC=../../RTL/v0.1/SDRCtrl
#action vlog +incdir+$SDRAM_INC $RTL_PATH/SDRCtrl/SDRTop.v
#action vlog +incdir+$SDRAM_INC $RTL_PATH/SDRCtrl/SDRRDS.v
#action vlog +incdir+$SDRAM_INC $RTL_PATH/SDRCtrl/SDRAi.v
#action vlog +incdir+$SDRAM_INC $RTL_PATH/SDRCtrl/SDRBLQ.v
#action vlog +incdir+$SDRAM_INC $RTL_PATH/SDRCtrl/SDRWQ.v
#action vlog +incdir+$SDRAM_INC $RTL_PATH/SDRCtrl/SDRRQ.v
#action vlog +incdir+$SDRAM_INC $RTL_PATH/SDRCtrl/SDRCtl.v
#action vlog +incdir+$SDRAM_INC $RTL_PATH/SDRCtrl/SDRBsm.v
#action vlog +incdir+$SDRAM_INC $RTL_PATH/SDRCtrl/SDRRas.v
#action vlog +incdir+$SDRAM_INC $RTL_PATH/SDRCtrl/SDRCas.v
DDRAM_INC=../../RTL/v0.1/DDRCtrl
action vlog +incdir+$DDRAM_INC $RTL_PATH/DDRCtrl/DDRAi.v
action vlog +incdir+$DDRAM_INC $RTL_PATH/DDRCtrl/DDRBLQ.v
action vlog +incdir+$DDRAM_INC $RTL_PATH/DDRCtrl/DDRBsm.v
action vlog +incdir+$DDRAM_INC $RTL_PATH/DDRCtrl/DDRCas.v
action vlog +incdir+$DDRAM_INC $RTL_PATH/DDRCtrl/DDRCtl.v
action vlog +incdir+$DDRAM_INC $RTL_PATH/DDRCtrl/DDRRas.v
action vlog +incdir+$DDRAM_INC $RTL_PATH/DDRCtrl/DDRRds.v
action vlog +incdir+$DDRAM_INC $RTL_PATH/DDRCtrl/DDRRQ.v
action vlog +incdir+$DDRAM_INC $RTL_PATH/DDRCtrl/DDRSpi.v
action vlog +incdir+$DDRAM_INC $RTL_PATH/DDRCtrl/DDRTop.v
action vlog +incdir+$DDRAM_INC $RTL_PATH/DDRCtrl/DDRWQ.v

# GPIO
action vlog $RTL_PATH/GPIO/Gpio.v

# UART
action vlog $RTL_PATH/UART/UartRegBlock.v
action vlog $RTL_PATH/UART/UartSynctoUCLK.v
action vlog $RTL_PATH/UART/UartSynctoPCLK.v
action vlog $RTL_PATH/UART/UartBaudCntr.v
action vlog $RTL_PATH/UART/UartApbif.v
action vlog $RTL_PATH/UART/UartModem.v
action vlog $RTL_PATH/UART/UartIrDA.v
action vlog $RTL_PATH/UART/UartRXFCntl.v
action vlog $RTL_PATH/UART/UartRXRegFile.v
action vlog $RTL_PATH/UART/UartRXFIFO.v
action vlog $RTL_PATH/UART/UartDataStp.v
action vlog $RTL_PATH/UART/UartRXParShft.v
action vlog $RTL_PATH/UART/UartRXCntl.v
action vlog $RTL_PATH/UART/UartReceive.v
action vlog $RTL_PATH/UART/UartTest.v
action vlog $RTL_PATH/UART/UartTXCntl.v
action vlog $RTL_PATH/UART/UartTXFCntl.v
action vlog $RTL_PATH/UART/UartTXRegFile.v
action vlog $RTL_PATH/UART/UartTXFIFO.v
action vlog $RTL_PATH/UART/UartDMA.v
action vlog $RTL_PATH/UART/UartInterrupt.v
action vlog $RTL_PATH/UART/Uart.v

# VIC
action vlog $RTL_PATH/VIC/APB_vic.v
action vlog $RTL_PATH/VIC/vic_master_arbiter.v
action vlog $RTL_PATH/VIC/vic_slave_arbiter.v

# MMC
action vlog $RTL_PATH/MMC/mmc_APBRegisterIF.v
action vlog $RTL_PATH/MMC/mmc_ClkSync.v
action vlog $RTL_PATH/MMC/mmc_CommandControl.v
action vlog $RTL_PATH/MMC/mmc_DataControl.v
action vlog $RTL_PATH/MMC/mmc_FeedBackSync.v
action vlog $RTL_PATH/MMC/mmc_Fifo.v
action vlog $RTL_PATH/MMC/mmc_FifoDmaCtr.v
action vlog $RTL_PATH/MMC/mmc_Prescaler.v
action vlog $RTL_PATH/MMC/mmc_RegUpd.v
action vlog $RTL_PATH/MMC/MMCTop.v

# I2C
action vlog $RTL_PATH/I2C/BTransCtl.v
action vlog $RTL_PATH/I2C/I2cBusFlt.v
action vlog $RTL_PATH/I2C/I2cCore.v
action vlog $RTL_PATH/I2C/I2cIOShft.v
action vlog $RTL_PATH/I2C/I2C.v
action vlog $RTL_PATH/I2C/SMCtl.v
action vlog $RTL_PATH/I2C/StopCtl.v
action vlog $RTL_PATH/I2C/I2cBusDet.v
action vlog $RTL_PATH/I2C/I2cClkDiv.v
action vlog $RTL_PATH/I2C/I2cCtl.v
action vlog $RTL_PATH/I2C/I2cReg.v
action vlog $RTL_PATH/I2C/SclCtl.v
action vlog $RTL_PATH/I2C/StartCtl.v

# Timer
action vlog $RTL_PATH/Timer/timer_pwm.v

# Etc
action vlog $RTL_PATH/Etc/ClockResetGen.v

action vcom $RTL_PATH/Etc/hc4094_7seg.vhd

# Top
action vlog +incdir+$MAIN_ARM926 $RTL_PATH2/Top/TestPlatformCore.v
action vlog +incdir+$RTL_PATH2/Top+$MAIN_ARM926 $RTL_PATH2/Top/TestPlatformFPGA.v

# Test Bench Compile
action vlog $MOD_PATH/eprom16bit.v
action vlog $MOD_PATH/ddr.v

action vlog +incdir+$RTL_PATH2/Top+$MAIN_ARM926 $RTL_PATH2/Top/tb.v


