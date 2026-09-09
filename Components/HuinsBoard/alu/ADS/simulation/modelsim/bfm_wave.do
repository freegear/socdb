onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider processor
add wave -noupdate -format Logic /arm_top/b2v_inst/masterhready
add wave -noupdate -format Logic /arm_top/b2v_inst/masterhgrant
add wave -noupdate -format Logic /arm_top/b2v_inst/masterhclk
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_inst/masterhrdata
add wave -noupdate -format Literal /arm_top/b2v_inst/masterhresp
add wave -noupdate -format Logic /arm_top/b2v_inst/masterhwrite
add wave -noupdate -format Logic /arm_top/b2v_inst/masterhlock
add wave -noupdate -format Logic /arm_top/b2v_inst/masterhbusreq
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_inst/masterhaddr
add wave -noupdate -format Literal /arm_top/b2v_inst/masterhtrans
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_inst/masterhwdata
add wave -noupdate -format Literal /arm_top/b2v_inst/masterhburst
add wave -noupdate -format Literal /arm_top/b2v_inst/masterhsize
add wave -noupdate -divider {control unit}
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_pld_slave/b2v_Control_Unit/ADDRESS_PHASE
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_pld_slave/b2v_Control_Unit/DATA_PHASE
add wave -noupdate -format Logic /arm_top/b2v_pld_slave/b2v_Control_Unit/HCLOCK
add wave -noupdate -format Logic /arm_top/b2v_pld_slave/b2v_Control_Unit/HREADY
add wave -noupdate -format Logic /arm_top/b2v_pld_slave/b2v_Control_Unit/HSEL
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_pld_slave/b2v_Control_Unit/HADDRESS
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_pld_slave/b2v_Control_Unit/HWDATA
add wave -noupdate -format Logic /arm_top/b2v_pld_slave/b2v_Control_Unit/HWRITE
add wave -noupdate -format Literal /arm_top/b2v_pld_slave/b2v_Control_Unit/HTRANS
add wave -noupdate -format Literal /arm_top/b2v_pld_slave/b2v_Control_Unit/HSIZE
add wave -noupdate -format Literal /arm_top/b2v_pld_slave/b2v_Control_Unit/HBURST
add wave -noupdate -format Logic /arm_top/b2v_pld_slave/b2v_Control_Unit/HRESETn
add wave -noupdate -format Literal /arm_top/b2v_pld_slave/b2v_Control_Unit/HRESP
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_pld_slave/b2v_Control_Unit/HRDATA
add wave -noupdate -divider reg
add wave -noupdate -format Literal /arm_top/b2v_pld_slave/b2v_Register_File/address
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_pld_slave/b2v_Register_File/write_data
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_pld_slave/b2v_Register_File/result_low
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_pld_slave/b2v_Register_File/result_high
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_pld_slave/b2v_Register_File/operand1
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_pld_slave/b2v_Register_File/operand2
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_pld_slave/b2v_Register_File/operation
add wave -noupdate -format Literal -radix hexadecimal /arm_top/b2v_pld_slave/b2v_Register_File/read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {629090 ps}
WaveRestoreZoom {0 ps} {1988920 ps}
configure wave -namecolwidth 418
configure wave -valuecolwidth 149
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
