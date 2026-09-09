onerror {resume}
quietly WaveActivateNextPane {} 0
quietly virtual function -install /Atb_ismc -env /Atb_ismc { &{/Atb_ismc/ahb_addr[14], /Atb_ismc/ahb_addr[13], /Atb_ismc/ahb_addr[12], /Atb_ismc/ahb_addr[11], /Atb_ismc/ahb_addr[10], /Atb_ismc/ahb_addr[9], /Atb_ismc/ahb_addr[8], /Atb_ismc/ahb_addr[7], /Atb_ismc/ahb_addr[6], /Atb_ismc/ahb_addr[5], /Atb_ismc/ahb_addr[4], /Atb_ismc/ahb_addr[3], /Atb_ismc/ahb_addr[2] }} addr_wd
add wave -noupdate -format Logic /Atb_ismc/clk
add wave -noupdate -format Logic /Atb_ismc/rstb
add wave -noupdate -format Logic /Atb_ismc/ahb_sel
add wave -noupdate -format Logic /Atb_ismc/ahb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ahb_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/addr_wd
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ahb_size
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ahb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ahb_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/ahb_ready
add wave -noupdate -divider 0
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/sram_csb
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/sram_addr
add wave -noupdate -format Literal -radix hexadecimal -expand /Atb_ismc/sram_wrb
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/sram_din
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/sram_dout
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/sram_oeb
add wave -noupdate -divider iSMC
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/ismc_ahb/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/ismc_ahb/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/ismc_ahb/ahb_sel
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ismc_ahb/ahb_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/ismc_ahb/ahb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ismc_ahb/ahb_size
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ismc_ahb/ahb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ismc_ahb/ahb_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/ismc_ahb/ahb_ready
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/ismc_ahb/sram_csb
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ismc_ahb/sram_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ismc_ahb/sram_wrb
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/ismc_ahb/sram_oeb
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ismc_ahb/sram_dout
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ismc_ahb/sram_din
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/ismc_ahb/ahb_addr_dp
add wave -noupdate -color Violet -format Logic -itemcolor Violet -radix hexadecimal /Atb_ismc/ismc_ahb/cs
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/ismc_ahb/ns
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ismc/ismc_ahb/rd_cmd_new
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ismc/ismc_ahb/rd_cmd
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ismc/ismc_ahb/wr_cmd
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/ismc_ahb/rd_dphase
add wave -noupdate -divider sram
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/inter_sram_24k/Q
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/inter_sram_24k/CLK
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/inter_sram_24k/CEN
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/inter_sram_24k/WEN
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/inter_sram_24k/A
add wave -noupdate -format Literal -radix hexadecimal /Atb_ismc/inter_sram_24k/D
add wave -noupdate -format Logic -radix hexadecimal /Atb_ismc/inter_sram_24k/OEN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5760619 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {5521622 ps} {6138200 ps}
