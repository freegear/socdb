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

# MMC Model(modelsim compiled form) should be compied first
action cp -rp $MOD_PATH/MMC/* work

# CPU
action vcom $RTL_PATH/Tarm/core/alu.vhd
action vcom $RTL_PATH/Tarm/core/clz_unit.vhd
action vcom $RTL_PATH/Tarm/core/cond_check.vhd
action vcom $RTL_PATH/Tarm/core/cpsr_update.vhd
action vcom $RTL_PATH/Tarm/core/data_filter.vhd
action vcom $RTL_PATH/Tarm/core/dmem_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/dmiu.vhd
action vcom $RTL_PATH/Tarm/core/dmou.vhd
action vcom $RTL_PATH/Tarm/core/ff1_32.vhd
action vcom $RTL_PATH/Tarm/core/ff1_4.vhd
action vcom $RTL_PATH/Tarm/core/ff4_32.vhd
action vcom $RTL_PATH/Tarm/core/ff_wb_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/ff_x1_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/ff_x2_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/ff_x2b_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/forward_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/greg.vhd
action vcom $RTL_PATH/Tarm/core/if_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/inst_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/inv1.vhd
action vcom $RTL_PATH/Tarm/core/fadd.vhd
action vcom $RTL_PATH/Tarm/core/csa.vhd
action vcom $RTL_PATH/Tarm/core/mbe.vhd
action vcom $RTL_PATH/Tarm/core/mul.vhd
action vcom $RTL_PATH/Tarm/core/mux2_32.vhd
action vcom $RTL_PATH/Tarm/core/mux2_4.vhd
action vcom $RTL_PATH/Tarm/core/mux3_32.vhd
action vcom $RTL_PATH/Tarm/core/mux3_4.vhd
action vcom $RTL_PATH/Tarm/core/mux4_32.vhd
action vcom $RTL_PATH/Tarm/core/op_filter.vhd
action vcom $RTL_PATH/Tarm/core/pass_wb_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/pass_wb_data.vhd
action vcom $RTL_PATH/Tarm/core/psr.vhd
action vcom $RTL_PATH/Tarm/core/reg_conv.vhd
action vcom $RTL_PATH/Tarm/core/shift.vhd
action vcom $RTL_PATH/Tarm/core/stall_flush_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/wr_backup.vhd
action vcom $RTL_PATH/Tarm/core/toyarm.vhd

action vcom $RTL_PATH/Tarm/cache/cachepkg.vhd
action vcom $RTL_PATH/Tarm/cache/cachereg.vhd
action vcom $RTL_PATH/Tarm/cache/cacheipu.vhd
action vcom $RTL_PATH/Tarm/cache/cachedpu.vhd
action vcom $RTL_PATH/Tarm/cache/cacheic.vhd
action vcom $RTL_PATH/Tarm/cache/cachedc.vhd
action vcom $RTL_PATH/Tarm/cache/cachewb.vhd
action vcom $RTL_PATH/Tarm/cache/cacheahb.vhd
action vcom $RTL_PATH/Tarm/cache/cachectl.vhd
action vcom $RTL_PATH/Tarm/cache/sp128x22m4.vhd
action vcom $RTL_PATH/Tarm/cache/sp128x23m4.vhd
action vcom $RTL_PATH/Tarm/cache/sp512x32m4.vhd
action vcom $RTL_PATH/Tarm/cache/cachemem.vhd

action vcom $RTL_PATH/Tarm/cpu.vhd
action vlog $RTL_PATH/Tarm/tarm_axi.v
action vlog $RTL_PATH/Tarm/tarm_axi_fastclk.v

# BUS
. ./compile_bus.sh

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
DM_INC=../rtl/DM
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
#SDRAM_INC=../rtl/SDRCtrl
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
SDRAM_INC=../rtl/DDRCtrl
action vlog +incdir+$SDRAM_INC $RTL_PATH/DDRCtrl/DDRAi.v
action vlog +incdir+$SDRAM_INC $RTL_PATH/DDRCtrl/DDRBLQ.v
action vlog +incdir+$SDRAM_INC $RTL_PATH/DDRCtrl/DDRBsm.v
action vlog +incdir+$SDRAM_INC $RTL_PATH/DDRCtrl/DDRCas.v
action vlog +incdir+$SDRAM_INC $RTL_PATH/DDRCtrl/DDRCtl.v
action vlog +incdir+$SDRAM_INC $RTL_PATH/DDRCtrl/DDRRas.v
action vlog +incdir+$SDRAM_INC $RTL_PATH/DDRCtrl/DDRRds.v
action vlog +incdir+$SDRAM_INC $RTL_PATH/DDRCtrl/DDRRQ.v
action vlog +incdir+$SDRAM_INC $RTL_PATH/DDRCtrl/DDRSpi.v
action vlog +incdir+$SDRAM_INC $RTL_PATH/DDRCtrl/DDRTop.v
action vlog +incdir+$SDRAM_INC $RTL_PATH/DDRCtrl/DDRWQ.v

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

# I2S Controller
action vlog $RTL_PATH/I2S/I2S_Control.v
action vlog $RTL_PATH/I2S/I2S_DTO.v
action vlog $RTL_PATH/I2S/I2S_ClockMgr.v
action vlog $RTL_PATH/I2S/I2S_Serializer.v
action vlog $RTL_PATH/I2S/I2S_FIFO.v
action vlog $RTL_PATH/I2S/I2S_Top.v

# Etc
action vlog $RTL_PATH/Etc/ClockResetGen.v

# Top
action vlog $RTL_PATH/Top/TestPlatformCore.v
action vcom $RTL_PATH/Etc/hc4094_7seg.vhd
action vlog $RTL_PATH/Top/TestPlatformFPGA.v

# Test Bench Compile
action vlog $MOD_PATH/eprom16bit.v
action vlog $MOD_PATH/ddr.v
action vlog $MOD_PATH/I2S_DAC.v
action vlog tb.v

#vsim -c tb -do "run -all"

