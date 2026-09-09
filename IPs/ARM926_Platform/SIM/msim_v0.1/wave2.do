onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/CLK
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/SBUS/SBUS_ReadChannel/RDATAs02mi0
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/SBUS/SBUS_ReadChannel/ARADDRm32si3
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/nFIQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/nIRQ
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/EXTEST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/VINITHI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/BIGENDINIT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/INTEST
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/TAPID
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/HRESETn
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DHCLKEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/SCANENABLE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/IRDMAADDR
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/IRDMACS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/IRDMAEN
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DRDMAADDR
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DRDMACS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DRDMAEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DHGRANT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DHREADY
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DHRESP
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/INITRAM
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DHRDATA
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/IRSIZE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/IRWAIT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/IHCLKEN
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/IRRD
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DRSIZE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DRWAIT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DRRD
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/FIFOFULL
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/ETMEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/IHGRANT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/IHREADY
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/IHRESP
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/IHRDATA
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGSDOUT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/TESTMODE
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGTMS
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGTDI
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGTCKEN
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/CPDIN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGnTRST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGDEWPT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/CHSDE
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/CHSEX
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGIEBKPT
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGEXT
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/EDBGRQ
add wave -noupdate -format Literal -radix hexadecimal /tb/Top/Core/cpu/CPU/CPBURST
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/DBGEN
add wave -noupdate -format Logic -radix hexadecimal /tb/Top/Core/cpu/CPU/CPEN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {867846 ps} 0}
configure wave -namecolwidth 233
configure wave -valuecolwidth 154
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
WaveRestoreZoom {0 ps} {1403291 ps}
