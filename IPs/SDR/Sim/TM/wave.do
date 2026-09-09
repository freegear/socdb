onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/ACLK
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/ARESETn
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/AWID
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/AWADDR
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/AWLEN
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/AWSIZE
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/AWBURST
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/AWVALID
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/AWREADY
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/WID
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/WDATA
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/WSTRB
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/WLAST
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/WVALID
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/WREADY
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/BID
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/BRESP
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/BVALID
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/BREADY
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/ARID
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/ARADDR
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/ARLEN
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/ARSIZE
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/ARBURST
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/ARVALID
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/ARREADY
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/RID
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/RDATA
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/RRESP
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/RLAST
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/RVALID
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/RREADY
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/MEMADDR
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/MEMRDATA
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/MEMCEn
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/MEMWEn
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/MEMWDATA
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/ReadOrWrite
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/State
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/NextState
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/StateIsIDLE
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/StateIsREAD
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/StateIsWRITE
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/StateIsWRITE_RESP
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/FirstREADCycle
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/MuxedAddr
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/MuxedLen
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/MuxedSize
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/MuxedBurst
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/LatchCommandEn
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/Id
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/Len
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/BurstLen
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/Size
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/Burst
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/DecreaseLen
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/IntSRAMController/NextAddrCalcEn
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/PrevAddr
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/Addr
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/IncreasedAddr
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/WrapBoundary
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/IntSRAMController/IncrSize
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/ACLK
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/ARESETn
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/AWID
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/AWADDR
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/AWLEN
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/AWSIZE
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/AWBURST
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/AWVALID
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/AWREADY
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/WID
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/WDATA
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/WSTRB
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/WLAST
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/WVALID
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/WREADY
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/BID
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/BRESP
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/BVALID
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/BREADY
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/ARID
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/ARADDR
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/ARLEN
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/ARSIZE
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/ARBURST
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/ARVALID
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/ARREADY
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/RID
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/RRESP
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/RREADY
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/RVALID
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/RDATA
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/RLAST
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/READErr
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/MEMRDATA
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/MEMWDATA
add wave -noupdate -format Logic -radix hexadecimal /tb_IntSRAMController/MEMCEn
add wave -noupdate -format Literal -radix hexadecimal /tb_IntSRAMController/MEMWEn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {209297 ps} 0} {{Cursor 2} {140878543981 ps} 0} {{Cursor 3} {2650160750 ps} 0} {{Cursor 6} {6079923750 ps} 0}
configure wave -namecolwidth 228
configure wave -valuecolwidth 64
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
WaveRestoreZoom {174476 ps} {288783 ps}
