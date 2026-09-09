onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /arm_top_tb/HCLOCK
add wave -noupdate -format Logic /arm_top_tb/HRESETn
add wave -noupdate -format Logic /arm_top_tb/clk_ref
add wave -noupdate -format Logic /arm_top_tb/nreset
add wave -noupdate -format Logic /arm_top_tb/npor
add wave -noupdate -divider {master port}
add wave -noupdate -format Logic /arm_top_tb/dut/b2v_inst/masterhclk
add wave -noupdate -format Logic /arm_top_tb/dut/b2v_inst/masterhready
add wave -noupdate -format Logic /arm_top_tb/dut/b2v_inst/masterhgrant
add wave -noupdate -format Literal /arm_top_tb/dut/b2v_inst/masterhresp
add wave -noupdate -format Logic /arm_top_tb/dut/b2v_inst/masterhwrite
add wave -noupdate -format Literal /arm_top_tb/dut/b2v_inst/masterhburst
add wave -noupdate -format Literal /arm_top_tb/dut/b2v_inst/masterhsize
add wave -noupdate -format Literal /arm_top_tb/dut/b2v_inst/masterhtrans
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/masterhaddr
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/masterhrdata
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/masterhwdata
add wave -noupdate -divider {register file}
add wave -noupdate -format Logic /arm_top_tb/dut/b2v_pld_slave/b2v_Register_File/reset
add wave -noupdate -format Logic /arm_top_tb/dut/b2v_pld_slave/b2v_Register_File/clock
add wave -noupdate -format Logic /arm_top_tb/dut/b2v_pld_slave/b2v_Register_File/write
add wave -noupdate -format Literal /arm_top_tb/dut/b2v_pld_slave/b2v_Register_File/address
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_Register_File/result_low
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_Register_File/result_high
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_Register_File/write_data
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_Register_File/operand1
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_Register_File/operand2
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_Register_File/read_data
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_Register_File/operation
add wave -noupdate -divider alu
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_ALU/operand1
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_ALU/operand2
add wave -noupdate -format Literal /arm_top_tb/dut/b2v_pld_slave/b2v_ALU/operation
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_ALU/result_low
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_ALU/result_high
add wave -noupdate -divider {State Machine}
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/ADDRESS_PHASE
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/DATA_PHASE
add wave -noupdate -format Logic /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/HSEL
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/HADDRESS
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/HWDATA
add wave -noupdate -format Logic /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/HWRITE
add wave -noupdate -format Literal /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/HTRANS
add wave -noupdate -format Literal /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/HSIZE
add wave -noupdate -format Literal /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/HBURST
add wave -noupdate -format Logic /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/HRESETn
add wave -noupdate -format Logic /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/HCLOCK
add wave -noupdate -format Literal /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/HRESP
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/HRDATA
add wave -noupdate -format Logic /arm_top_tb/dut/b2v_pld_slave/b2v_Control_Unit/HREADY
add wave -noupdate -divider {GP Registers}
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/lpm_instance/u_epxa10top/u_epxa10/thetiming/theinout/r0
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/lpm_instance/u_epxa10top/u_epxa10/thetiming/theinout/r1
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/lpm_instance/u_epxa10top/u_epxa10/thetiming/theinout/r2
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/lpm_instance/u_epxa10top/u_epxa10/thetiming/theinout/r3
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/lpm_instance/u_epxa10top/u_epxa10/thetiming/theinout/r4
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/lpm_instance/u_epxa10top/u_epxa10/thetiming/theinout/r5
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/lpm_instance/u_epxa10top/u_epxa10/thetiming/theinout/r6
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/lpm_instance/u_epxa10top/u_epxa10/thetiming/theinout/r7
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/lpm_instance/u_epxa10top/u_epxa10/thetiming/theinout/r8
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/lpm_instance/u_epxa10top/u_epxa10/thetiming/theinout/r9
add wave -noupdate -format Literal -radix hexadecimal /arm_top_tb/dut/b2v_inst/lpm_instance/u_epxa10top/u_epxa10/thetiming/theinout/r10
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {2838136 ps}
WaveRestoreZoom {275980894 ps} {278819030 ps}
configure wave -namecolwidth 358
configure wave -valuecolwidth 78
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
