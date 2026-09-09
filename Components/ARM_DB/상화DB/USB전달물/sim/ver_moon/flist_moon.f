////////////////////////////////////////////////////////////////////////////
// File list for MOON
////////////////////////////////////////////////////////////////////////////

// Test Bench for simulation
./TB_MOON.v

// MOON FPGA TOP
../../RTL/FPGA_TOP/MOON_FPGA_TOP.v
../../RTL/ARM/IntCtrl.v
../../RTL/ARM/AHBDecoder.v
../../RTL/ARM/AHBMuxS2M.v
../../RTL/ARM/Arbiter3.vp
../../RTL/ARM/ArbSchm3.vp
../../RTL/ARM/RetrySlave.vp
../../RTL/ARM/DefaultSlave.vp
../../RTL/ARM/MuxS2M.vp
../../RTL/ARM/Decoder.vp
../../RTL/ARM/Master.v

// MOON TOP
../../RTL/TOP/moon_top.v

// USB
../../RTL/USB/uintr_ctrl.v
../../RTL/USB/ufifo_port2.v
../../RTL/USB/ufinfo_rw.v
../../RTL/USB/utdma_ctrl.v
../../RTL/USB/utxpq_ctrl.v
../../RTL/USB/urdma_ctrl.v
../../RTL/USB/ufifo_port1.v
../../RTL/USB/uctrl_command.v
../../RTL/USB/usb_crc.v
../../RTL/USB/usb_protocol.v
../../RTL/USB/txline_ctrl.v
../../RTL/USB/rxline_ctrl.v
../../RTL/USB/device_sm.v
../../RTL/USB/sie_ctrl.v
../../RTL/USB/sop_detect.v
../../RTL/USB/rx_tranceiver.v
../../RTL/USB/tx_tranceiver.v
../../RTL/USB/eop_detect.v
../../RTL/USB/make_busclk.v
../../RTL/USB/dpll.v
../../RTL/USB/tranceiver.v
../../RTL/USB/usb_reg.v
../../RTL/USB/ureg_dec.v
../../RTL/USB/ureg_ahbif.v
../../RTL/USB/e0rw_ctrl.v
../../RTL/USB/usb_top.v

// DMA
../../RTL/DMA/mdma.v
../../RTL/DMA/mtdma_ctrl.v
../../RTL/DMA/mline_txdib.v
../../RTL/DMA/mrdma_ctrl.v
../../RTL/DMA/mline_rxdib.v
../../RTL/DMA/mballoc_ctrl.v
../../RTL/DMA/dma_arbitor.v
../../RTL/DMA/dma_decoder.v
../../RTL/DMA/dma_regdec.v
../../RTL/DMA/dreg_ahbif.v
../../RTL/DMA/ahb2dma.v

// MACRO
../../RTL/MACRO/busholder.v
../../RTL/MACRO/yfd1_RTL.v
../../RTL/MACRO/DPSRAMBW576x32.v
../../RTL/MACRO/SPSRAMBW192x32.v
../../RTL/MACRO/DPSRAMBW512x32.v
../../RTL/MACRO/SPSRAMBW256x32.v

// SDRAM
../../RTL/ARM/SDRAM.v

////////////////////////////////////////////////////////
// usb host
////////////////////////////////////////////////////////
../../RTL/USB_HOST/host_crc16.v
../../RTL/USB_HOST/host_crc5.v
../../RTL/USB_HOST/host_crc5_pre.v
../../RTL/USB_HOST/host_eop_detect.v
../../RTL/USB_HOST/host_sop_detect.v
../../RTL/USB_HOST/host_rx_sm.v
../../RTL/USB_HOST/host_rx_tranceiver.v
../../RTL/USB_HOST/host_sie.v
../../RTL/USB_HOST/host_top.v
../../RTL/USB_HOST/host_tranceiver.v
../../RTL/USB_HOST/host_tx_sm.v
../../RTL/USB_HOST/host_tx_tranceiver.v
../../RTL/USB_HOST/host_uclk.v
../../RTL/USB_HOST/host_usb_bus_rclk.v
../../RTL/USB_HOST/host_usb_pad.v
