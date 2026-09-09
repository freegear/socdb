onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider si_ADDRESS
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelsi/ACLK
add wave -noupdate -format Literal -radix hexadecimal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/AWADDRm2si
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U1WriteChannelsi/AWVALIDm2si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/AWVALIDsi2mi
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/AWREADYmi2si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelsi/SelValid
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/AWVALIDsi2mi
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U1WriteChannelsi/AWVALIDm2si
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U1WriteChannelsi/AWREADYsi2m
add wave -noupdate -color Yellow -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/AWBURSTm2si
add wave -noupdate -divider si_DATA
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/WIDsi2mi
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/WIDm2si
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U1WriteChannelsi/WVALIDm2si
add wave -noupdate -format Literal -radix hexadecimal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/WDATAm2si
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U1WriteChannelsi/WREADYsi2m
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U1WriteChannelsi/WLASTm2si
add wave -noupdate -divider si_RES
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/BIDsi2m
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/CtlData2resch
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/BREADYsi2mi
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U1WriteChannelsi/BREADYm2si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/BRESPsi2m
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/BVALIDmi2si
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U1WriteChannelsi/BVALIDsi2m
add wave -noupdate -divider si_Permit
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/U0PermitCtl/SlaveBuffer
add wave -noupdate -format Literal -radix unsigned /tb/SBUS/U0WriteChannel/U1WriteChannelsi/U0PermitCtl/SlaveCnt
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U1WriteChannelsi/U0PermitCtl/InMUX
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/U0PermitCtl/SlaveNum
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/U0PermitCtl/CtlData2datach
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/U0PermitCtl/CtlData2resch
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U1WriteChannelsi/U0PermitCtl/CtlData2writech
add wave -noupdate -divider mi_ADDRESS
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelmi/ACLK
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWBURSTmi2s
add wave -noupdate -format Literal -radix hexadecimal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWADDRsi12mi
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWVALIDmi2s
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWREADYs2mi
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/AWREADYmi2si
add wave -noupdate -divider mi_DATA
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/WIDsi12mi
add wave -noupdate -format Literal -radix hexadecimal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/WDATAmi2s
add wave -noupdate -format Literal -radix decimal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/CtlData2WrchMux
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelmi/WVALIDmi2s
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelmi/WREADYs2mi
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/WREADYmi2si
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelmi/WLASTmi2s
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/WVALIDsi2mi
add wave -noupdate -divider mi_RES
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/BRESPs2mi
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/BRESPmi2si
add wave -noupdate -format Logic /tb/SBUS/U0WriteChannel/U0WriteChannelmi/BVALIDs2mi
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/BVALIDmi2si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/BIDs2mi
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/U0WriteChannelmi/BIDmi2si
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/BVALIDmi12si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/BVALIDmi22si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/BVALIDmi32si
add wave -noupdate -format Literal /tb/SBUS/U0WriteChannel/BVALIDmi42si
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {155000 ps} 0}
configure wave -namecolwidth 147
configure wave -valuecolwidth 68
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
WaveRestoreZoom {0 ps} {2758584 ps}
