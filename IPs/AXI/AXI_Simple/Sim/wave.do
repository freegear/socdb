onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb/ACLK
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/i
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/ACLK
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/ARESETn
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/AWIDm2si
add wave -noupdate -format Literal -radix hexadecimal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/AWADDRm2si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/AWLENm2si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/AWSIZEm2si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/AWBURSTm2si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/AWLOCKm2si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/AWCACHEm2si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/AWPROTm2si
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/AWVALIDm2si
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/AWREADYsi2m
add wave -noupdate -divider permit
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/ACLK
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/ARESETn
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/AREADY
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/LAST
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/AVALID
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/SlaveNum
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/ADDR
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/READY
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/CtlData2datach
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/CtlData2resch
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/CtlData2writech
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/SlaveBuffer
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/SlaveCnt
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/rADDR
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/CNTup
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/CNTdn
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/InMUX
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/U0PermitCtl/rInMUX
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/AWVALIDsi2mi
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/AWREADYmi2si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/SelValid
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/i
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelmi/ACLK
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelmi/ARESETn
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWIDmi2s
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWADDRmi2s
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWLENmi2s
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWSIZEmi2s
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWBURSTmi2s
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWLOCKmi2s
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWCACHEmi2s
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWPROTmi2s
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWVALIDmi2s
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWREADYs2mi
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {133961 ps} 0}
configure wave -namecolwidth 199
configure wave -valuecolwidth 95
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
WaveRestoreZoom {0 ps} {434469 ps}
