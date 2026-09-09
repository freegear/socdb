onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/CLK
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/RESETn
add wave -noupdate -divider ROM
add wave -noupdate -format Logic -radix hexadecimal /tb/prom/oeb
add wave -noupdate -format Logic -radix hexadecimal /tb/prom/csb
add wave -noupdate -format Literal -radix hexadecimal /tb/prom/addr
add wave -noupdate -format Literal -radix hexadecimal /tb/prom/romdata
add wave -noupdate -divider AHB
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HTRANS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HWRITE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HSIZE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HBL
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HBURST
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HPROT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HWDATA
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HRDATA
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HREADY_IN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HREADY_OUT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HRESP
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HSEL
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HMASTLOCK
add wave -noupdate -divider {AXI Read}
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARADDR
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARLEN
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARSIZE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARBURST
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARLOCK
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARCACHE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARPROT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARVALID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ARREADY
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/RDATA
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/RRESP
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/RLAST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/RVALID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/RREADY
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /tb/Top/Core/cpu/RVALID_2_ARMI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/BVALID
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/BRESP
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/WREADY
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWREADY
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HSIZE_r
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/Len
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HBL_r
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/BurstLen
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HTRANS_r
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HADDR_lower_r
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HADDR_r
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/CommandLatchEn
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HPROT_r
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HMASTLOCK_r
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/WrapBurst
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HTRANS_VALID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/StateIsWRITE_RESP
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/StateIsWRITE
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ErrorDetected_1d
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/StateIsREAD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/StateIsIDLE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/NextState
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/State
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/NewCommandArrived
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/HBURST2Len
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/DecreaseLen
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/ErrorDetected
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/BREADY
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/WVALID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/WLAST
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/WSTRB
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/WDATA
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWVALID
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWPROT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWCACHE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWLOCK
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWBURST
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWSIZE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWLEN
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/IAHB2AXI/AWADDR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1816911 ps} 0}
configure wave -namecolwidth 223
configure wave -valuecolwidth 80
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
WaveRestoreZoom {308506 ps} {3336730 ps}
