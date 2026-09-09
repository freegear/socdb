vlog compile_base.v

vsim work.TBFM_DTSDI002

destroy .wave
view wave

do wave.do

config wave -signalnamewidth 2

run -all