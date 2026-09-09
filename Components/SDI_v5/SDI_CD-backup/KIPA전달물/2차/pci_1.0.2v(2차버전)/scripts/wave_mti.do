onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /pcim64ahbw_tb/testphase
add wave -noupdate -divider {PCI Bus}
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/clk_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/rstn_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/reqn_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/gntn_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/idsel_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/framen_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/req64n_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/irdyn_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/devseln_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/ack64n_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/trdyn_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/stopn_p
add wave -noupdate -format Literal -radix hexadecimal /pcim64ahbw_tb/UUT/ad_p
add wave -noupdate -format Literal /pcim64ahbw_tb/UUT/cbe_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/par_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/par64_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/perrn_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/serrn_p
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/intan_p
add wave -noupdate -divider {AMBA AHB Bus}
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/hclk
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/hresetn
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/mhbusreq
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/mhgrant
add wave -noupdate -format Literal /pcim64ahbw_tb/UUT/mhtrans
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/mhwrite
add wave -noupdate -format Literal /pcim64ahbw_tb/UUT/mhburst
add wave -noupdate -format Literal /pcim64ahbw_tb/UUT/mhsize
add wave -noupdate -format Literal /pcim64ahbw_tb/UUT/mhprot
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/mhlock
add wave -noupdate -format Logic /pcim64ahbw_tb/UUT/mhready
add wave -noupdate -format Literal /pcim64ahbw_tb/UUT/mhresp
add wave -noupdate -format Literal -radix hexadecimal /pcim64ahbw_tb/UUT/mhaddr
add wave -noupdate -format Literal -radix hexadecimal /pcim64ahbw_tb/UUT/mhwdata
add wave -noupdate -format Literal -radix hexadecimal /pcim64ahbw_tb/UUT/mhrdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29264 ns} 0} {{Cursor 2} {29238 ns} 0}
WaveRestoreZoom {29099 ns} {29757 ns}
configure wave -namecolwidth 304
configure wave -valuecolwidth 121
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
