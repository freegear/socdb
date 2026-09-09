onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/scl
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/sda
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/debug
add wave -noupdate -format Literal /TbI2C/i2c_slave_model1/mem_adr
add wave -noupdate -format Literal /TbI2C/i2c_slave_model1/mem_do
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/sta
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/d_sta
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/sto
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/d_sto
add wave -noupdate -format Literal /TbI2C/i2c_slave_model1/sr
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/rw
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/my_adr
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/i2c_reset
add wave -noupdate -format Literal -radix unsigned /TbI2C/i2c_slave_model1/bit_cnt
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/acc_done
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/ld
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/sda_o
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/sda_dly
add wave -noupdate -format Literal /TbI2C/i2c_slave_model1/state
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/tst_sto
add wave -noupdate -format Logic /TbI2C/i2c_slave_model1/tst_sta
add wave -noupdate -format Literal -radix hexadecimal /TbI2C/I2C/PADDR
add wave -noupdate -format Logic /TbI2C/I2C/PENABLE
add wave -noupdate -format Literal -radix hexadecimal /TbI2C/I2C/PRDATA
add wave -noupdate -format Logic /TbI2C/I2C/PSEL
add wave -noupdate -format Literal -radix hexadecimal /TbI2C/I2C/PWDATA
add wave -noupdate -format Logic /TbI2C/I2C/PWRITE
add wave -noupdate -format Logic /TbI2C/I2C/Clk
add wave -noupdate -format Logic /TbI2C/I2C/nRst
add wave -noupdate -format Literal /TbI2C/I2C/I2cInt
add wave -noupdate -format Logic -height 15 {/TbI2C/I2C/I2cInt[1]}
add wave -noupdate -format Logic -height 15 {/TbI2C/I2C/ISCL[1]}
add wave -noupdate -format Logic -height 15 {/TbI2C/I2C/ISDA[1]}
add wave -noupdate -format Literal /TbI2C/I2C/ISCL
add wave -noupdate -format Literal /TbI2C/I2C/ISDA
add wave -noupdate -format Literal /TbI2C/I2C/OSCL
add wave -noupdate -format Literal /TbI2C/I2C/OSDA
add wave -noupdate -format Literal /TbI2C/I2C/OSCL
add wave -noupdate -format Logic /TbI2C/I2C/Clk
add wave -noupdate -format Logic /TbI2C/I2C/nRst
add wave -noupdate -format Literal -radix hexadecimal /TbI2C/I2C/PADDR
add wave -noupdate -format Logic /TbI2C/I2C/PSEL
add wave -noupdate -format Logic /TbI2C/I2C/PENABLE
add wave -noupdate -format Logic /TbI2C/I2C/PWRITE
add wave -noupdate -format Literal -radix hexadecimal /TbI2C/I2C/PWDATA
add wave -noupdate -format Literal -radix hexadecimal /TbI2C/I2C/PRDATA
add wave -noupdate -format Literal /TbI2C/I2C/I2cInt
add wave -noupdate -format Literal /TbI2C/I2C/ISCL
add wave -noupdate -format Literal /TbI2C/I2C/ISDA
add wave -noupdate -format Literal /TbI2C/I2C/OSCL
add wave -noupdate -format Literal /TbI2C/I2C/OSDA
add wave -noupdate -format Logic /TbI2C/I2C/Enab0
add wave -noupdate -format Logic /TbI2C/I2C/GCEnab0
add wave -noupdate -format Logic /TbI2C/I2C/STA0
add wave -noupdate -format Logic /TbI2C/I2C/STP0
add wave -noupdate -format Logic /TbI2C/I2C/IFlg0
add wave -noupdate -format Logic /TbI2C/I2C/AAK0
add wave -noupdate -format Logic /TbI2C/I2C/SoftReset0
add wave -noupdate -format Logic /TbI2C/I2C/Enab1
add wave -noupdate -format Logic /TbI2C/I2C/GCEnab1
add wave -noupdate -format Logic /TbI2C/I2C/STA1
add wave -noupdate -format Logic /TbI2C/I2C/STP1
add wave -noupdate -format Logic /TbI2C/I2C/IFlg1
add wave -noupdate -format Logic /TbI2C/I2C/AAK1
add wave -noupdate -format Logic /TbI2C/I2C/SoftReset1
add wave -noupdate -format Literal /TbI2C/I2C/CCR0
add wave -noupdate -format Literal /TbI2C/I2C/CCR1
add wave -noupdate -format Literal /TbI2C/I2C/SlaveAddr0
add wave -noupdate -format Literal /TbI2C/I2C/SlaveAddr1
add wave -noupdate -format Literal /TbI2C/I2C/ExtendAddr0
add wave -noupdate -format Literal /TbI2C/I2C/ExtendAddr1
add wave -noupdate -format Literal /TbI2C/I2C/WriteData0
add wave -noupdate -format Literal /TbI2C/I2C/WriteData1
add wave -noupdate -format Logic /TbI2C/I2C/SetIFlg0
add wave -noupdate -format Logic /TbI2C/I2C/ClearSTA0
add wave -noupdate -format Logic /TbI2C/I2C/ClearSTP0
add wave -noupdate -format Logic /TbI2C/I2C/SetIFlg1
add wave -noupdate -format Logic /TbI2C/I2C/ClearSTA1
add wave -noupdate -format Logic /TbI2C/I2C/ClearSTP1
add wave -noupdate -format Literal /TbI2C/I2C/Status0
add wave -noupdate -format Literal /TbI2C/I2C/Status1
add wave -noupdate -format Literal /TbI2C/I2C/ReadData0
add wave -noupdate -format Literal /TbI2C/I2C/ReadData1
add wave -noupdate -format Logic /TbI2C/I2C/PSELI2C0
add wave -noupdate -format Logic /TbI2C/I2C/PSELI2C1
add wave -noupdate -format Literal /TbI2C/I2C/PRDATA0
add wave -noupdate -format Literal /TbI2C/I2C/PRDATA1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 5} {13238598690 ps} 0} {{Cursor 2} {340659000 ps} 0}
configure wave -namecolwidth 204
configure wave -valuecolwidth 63
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
WaveRestoreZoom {0 ps} {520542750 ps}
