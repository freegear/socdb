onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /arm_top/HCLOCK
add wave -noupdate -format Logic -radix hexadecimal /arm_top/HRESETn
add wave -noupdate -format Logic -radix hexadecimal /arm_top/HSEL
add wave -noupdate -format Logic -radix hexadecimal /arm_top/HGRANT
add wave -noupdate -format Literal -radix hexadecimal /arm_top/\\b2v_inst|lpm_instance|core|core~I_masterhaddr_bus\\
add wave -noupdate -format Literal -radix hexadecimal /arm_top/\\b2v_inst|lpm_instance|core|core~I_masterhtrans_bus\\
add wave -noupdate -format Literal -radix hexadecimal /arm_top/\\b2v_inst|lpm_instance|core|core~I_masterhsize_bus\\
add wave -noupdate -format Literal -radix hexadecimal /arm_top/\\b2v_inst|lpm_instance|core|core~I_masterhburst_bus\\
add wave -noupdate -format Literal -radix hexadecimal /arm_top/\\b2v_inst|lpm_instance|core|core~I_masterhwdata_bus\\
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {629090 ps} 0}
WaveRestoreZoom {13962981 ps} {14001949 ps}
configure wave -namecolwidth 418
configure wave -valuecolwidth 149
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
