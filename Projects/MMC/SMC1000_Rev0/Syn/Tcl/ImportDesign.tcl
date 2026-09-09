# CPU
analyze -f verilog -lib WORK ../Rtl/80C52/core_top.v
analyze -f verilog -lib WORK ../Rtl/80C52/top/reset_cnt.v
analyze -f verilog -lib WORK ../Rtl/80C52/top/rst_clock.v

# SD Slave
analyze -f verilog -lib WORK ../Rtl/EP560/Ahdlprim.v
analyze -f verilog -lib WORK ../Rtl/EP560/ep560k1.v
analyze -f verilog -lib WORK ../Rtl/EP560/eu_dpramx2.v
analyze -f verilog -lib WORK ../Rtl/EP560/sd_slave.v


# Card Sync  Wapper
analyze -f verilog -lib WORK ../Rtl/CardWrapperSync/cardctrlwrap.v

# MMC Wrapper
analyze -f verilog -lib WORK ../Rtl/MMCWrapper/MMCWrapper.v
analyze -f verilog -lib WORK ../Rtl/MMCWrapper/mmc_parser.v
analyze -f verilog -lib WORK ../Rtl/MMCWrapper/mmcwrapper_regif.v
analyze -f verilog -lib WORK ../Rtl/MMCWrapper/staticregif.v


# Memory Controller
analyze -f verilog -lib WORK ../Rtl/MemCtrl/MemCtrlTop.v
analyze -f verilog -lib WORK ../Rtl/MemCtrl/memchblk.v
analyze -f verilog -lib WORK ../Rtl/MemCtrl/memregif.v
analyze -f verilog -lib WORK ../Rtl/MemCtrl/mmcramif.v

# Memory DMA
analyze -f verilog -lib WORK ../Rtl/RSNAND_DMA/RSNAND_DMATop.v
analyze -f verilog -lib WORK ../Rtl/RSNAND_DMA/RSNAND_DMA.v
analyze -f verilog -lib WORK ../Rtl/RSNAND_DMA/RSNAND_DMAregif.v

# Nand Controller
analyze -f verilog -lib WORK ../Rtl/NandCtrl/NFAPBIF.v
analyze -f verilog -lib WORK ../Rtl/NandCtrl/NFCmdQ.v
analyze -f verilog -lib WORK ../Rtl/NandCtrl/NFCtrl.v
analyze -f verilog -lib WORK ../Rtl/NandCtrl/NFDFIFO.v
analyze -f verilog -lib WORK ../Rtl/NandCtrl/NFRnBFilter.v
analyze -f verilog -lib WORK ../Rtl/NandCtrl/NFTop.v


# RS Encoder
analyze -f verilog -lib WORK ../Rtl/RSEncoder/RSEncoderTop.v
analyze -f verilog -lib WORK ../Rtl/RSEncoder/RSEncoderCtrl.v
analyze -f verilog -lib WORK ../Rtl/RSEncoder/RSEncRegif.v
analyze -f verilog -lib WORK ../Rtl/RSEncoder/RS520_512Encoder.v

# RS Decoder
analyze -f verilog -lib WORK ../Rtl/RSDecoder/RSDecoderTop.v
analyze -f verilog -lib WORK ../Rtl/RSDecoder/RSDecRegif.v
analyze -f verilog -lib WORK ../Rtl/RSDecoder/SYNDCal.v
analyze -f verilog -lib WORK ../Rtl/RSDecoder/MEABlock.v
analyze -f verilog -lib WORK ../Rtl/RSDecoder/CSearch.v
analyze -f verilog -lib WORK ../Rtl/RSDecoder/DecoderCtrl.v

# Etc
analyze -f verilog -lib WORK ../Rtl/Etc/Romconv.v
analyze -f verilog -lib WORK ../Rtl/Etc/addrlatcher.v
analyze -f verilog -lib WORK ../Rtl/Etc/ESFR_MUX_BANK.v
analyze -f verilog -lib WORK ../Rtl/Etc/NandExtMux.v
analyze -f verilog -lib WORK ../Rtl/Etc/NandExtMux.v
analyze -f verilog -lib WORK ../Rtl/Etc/BinMult.v

# Top 
analyze -f verilog -lib WORK ../Rtl/Top/SMC1000Core.v

elaborate $TopDesign -lib WORK
