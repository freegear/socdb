onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Interface
add wave -noupdate -format Logic /tb_adc_control/PCLK
add wave -noupdate -format Logic /tb_adc_control/PRESETn
add wave -noupdate -format Literal -radix hexadecimal /tb_adc_control/PADDR
add wave -noupdate -format Literal -radix hexadecimal /tb_adc_control/PWDATA
add wave -noupdate -format Literal /tb_adc_control/PRDATA
add wave -noupdate -format Logic /tb_adc_control/PENABLE
add wave -noupdate -format Logic /tb_adc_control/PSEL
add wave -noupdate -format Logic /tb_adc_control/PWRITE
add wave -noupdate -format Logic /tb_adc_control/CLK_ADCCLK
add wave -noupdate -divider Reg.
add wave -noupdate -color Tan -format Logic /tb_adc_control/U0_top_adc/U0_adc_LTR9200/SOC
add wave -noupdate -color Sienna -format Logic /tb_adc_control/U0_top_adc/U0_adc_control/ADEN
add wave -noupdate -format Logic /tb_adc_control/U0_top_adc/U0_adc_control/READ_START
add wave -noupdate -format Logic /tb_adc_control/U0_top_adc/U0_adc_control/STBY
add wave -noupdate -format Literal -radix unsigned /tb_adc_control/U0_top_adc/U0_adc_control/ASEL
add wave -noupdate -format Logic /tb_adc_control/U0_top_adc/U0_adc_control/EN_INTb
add wave -noupdate -format Logic /tb_adc_control/U0_top_adc/U0_adc_control/FLAG
add wave -noupdate -format Logic /tb_adc_control/INT_ADC
add wave -noupdate -divider ADC
add wave -noupdate -format Logic /tb_adc_control/U0_top_adc/U0_adc_LTR9200/AD_CLK
add wave -noupdate -color Tan -format Logic /tb_adc_control/U0_top_adc/U0_adc_LTR9200/SOC
add wave -noupdate -format Literal -radix unsigned /tb_adc_control/U0_top_adc/U0_adc_LTR9200/Conv_Cnt
add wave -noupdate -format Literal /tb_adc_control/U0_top_adc/U0_adc_LTR9200/Cycle_Time
add wave -noupdate -format Literal /tb_adc_control/U0_top_adc/U0_adc_LTR9200/DOUT
add wave -noupdate -format Logic /tb_adc_control/U0_top_adc/U0_adc_LTR9200/EOC
add wave -noupdate -divider CONTROL
add wave -noupdate -format Literal -radix hexadecimal /tb_adc_control/PADDR
add wave -noupdate -format Logic /tb_adc_control/U0_top_adc/U0_adc_control/PCLK
add wave -noupdate -format Literal -radix unsigned /tb_adc_control/U0_top_adc/U0_adc_control/ADC_STATE
add wave -noupdate -format Literal /tb_adc_control/U0_top_adc/U0_adc_control/rADCDAT
add wave -noupdate -format Literal /tb_adc_control/U0_top_adc/U0_adc_control/PRDATA
add wave -noupdate -format Literal /tb_adc_control/PRDATA
add wave -noupdate -format Logic /tb_adc_control/U0_top_adc/U0_adc_control/CLK_ADCCLK_M
add wave -noupdate -format Literal /tb_adc_control/U0_top_adc/U0_adc_control/adcclk_count
add wave -noupdate -format Literal -radix unsigned /tb_adc_control/U0_top_adc/U0_adc_LTR9200/AD_O_nude
add wave -noupdate -format Literal -radix unsigned /tb_adc_control/U0_top_adc/U0_adc_LTR9200/ASEL
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9755000 ps} 0} {{Cursor 2} {1334859 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue right
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {9604765 ps} {9905235 ps}
