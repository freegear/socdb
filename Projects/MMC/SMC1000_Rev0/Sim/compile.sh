#! /bin/sh
action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work

RTL_PATH=../Rtl
MOD_PATH=../Model

# CPU
action vlog $RTL_PATH/80C52/core_top.v
action vlog $RTL_PATH/80C52/top/reset_cnt.v
action vlog $RTL_PATH/80C52/top/rst_clock.v

# SD Slave
action vlog $RTL_PATH/EP560/Ahdlprim.v
action vlog $RTL_PATH/EP560/ep560k1.v
action vlog $RTL_PATH/EP560/eu_dpramx2.v
action vlog $RTL_PATH/EP560/sd_slave.v


# Card Sync  Wapper
action vlog $RTL_PATH/CardWrapperSync/cardctrlwrap.v

# MMC Wrapper
action vlog $RTL_PATH/MMCWrapper/MMCWrapper.v
action vlog $RTL_PATH/MMCWrapper/mmc_parser.v
action vlog $RTL_PATH/MMCWrapper/mmcwrapper_regif.v
action vlog $RTL_PATH/MMCWrapper/staticregif.v


# Memory Controller
action vlog $RTL_PATH/MemCtrl/MemCtrlTop.v
action vlog $RTL_PATH/MemCtrl/memchblk.v
action vlog $RTL_PATH/MemCtrl/memregif.v
action vlog $RTL_PATH/MemCtrl/mmcramif.v

# Memory DMA
action vlog $RTL_PATH/RSNAND_DMA/RSNAND_DMATop.v
action vlog $RTL_PATH/RSNAND_DMA/RSNAND_DMA.v
action vlog $RTL_PATH/RSNAND_DMA/RSNAND_DMAregif.v

# Nand Controller
action vlog $RTL_PATH/NandCtrl/NFAPBIF.v
action vlog $RTL_PATH/NandCtrl/NFCmdQ.v
action vlog $RTL_PATH/NandCtrl/NFCtrl.v
action vlog $RTL_PATH/NandCtrl/NFDFIFO.v
action vlog $RTL_PATH/NandCtrl/NFRnBFilter.v
action vlog $RTL_PATH/NandCtrl/NFTop.v


# RS Encoder
action vlog $RTL_PATH/RSEncoder/RSEncoderTop.v
action vlog $RTL_PATH/RSEncoder/RSEncoderCtrl.v
action vlog $RTL_PATH/RSEncoder/RSEncRegif.v
action vlog $RTL_PATH/RSEncoder/RS520_512Encoder.v

# RS Decoder
action vlog $RTL_PATH/RSDecoder/RSDecoderTop.v
action vlog $RTL_PATH/RSDecoder/RSDecRegif.v
action vlog $RTL_PATH/RSDecoder/SYNDCal.v
action vlog $RTL_PATH/RSDecoder/MEABlock.v
action vlog $RTL_PATH/RSDecoder/CSearch.v
action vlog $RTL_PATH/RSDecoder/DecoderCtrl.v


# Seven Segment
action vlog $RTL_PATH/SevenSegment/SevenSegment.v


# Top 
action vlog $RTL_PATH/Top/SMC1000Core.v
action vlog $RTL_PATH/Top/SMC1000FPGATop.v

# Etc
action vlog $RTL_PATH/Etc/Romconv.v
action vlog $RTL_PATH/Etc/addrlatcher.v
action vlog $RTL_PATH/Etc/ESFR_MUX_BANK.v
action vlog $RTL_PATH/Etc/NandExtMux.v
action vlog $RTL_PATH/Etc/BinMult.v

# TSMC 018G libray
action vlog +nospecify $MOD_PATH/tsmc18.v 

# Test Bench Compile
action vlog $MOD_PATH/SSRAM8bit.v
action vlog $MOD_PATH/eprom8bit.v
action vlog $MOD_PATH/eprom16bit.v
action vlog +incdir+../Model +define+x8 +define+V33 +define+G2 ../Model/nand_model_0.v 
action vlog tb.v

#vsim -c tb -do "run -all"

