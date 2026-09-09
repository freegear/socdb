onerror {resume}
quietly WaveActivateNextPane {} 0
quietly virtual function -install /ETRI_UWBFPGA -env /ETRI_UWBFPGA { &{/ETRI_UWBFPGA/arb_gnt_b, /ETRI_UWBFPGA/HostBridge_gnt }} arb_gnt
quietly virtual function -install /ETRI_UWBFPGA -env /ETRI_UWBFPGA { &{/ETRI_UWBFPGA/arb_req_b, /ETRI_UWBFPGA/HostBridge_req }} arb_req
add wave -noupdate -format Literal /ETRI_UWBFPGA/HRESP_M0
add wave -noupdate -format Logic /ETRI_UWBFPGA/PCI_INTAb
add wave -noupdate -format Logic /ETRI_UWBFPGA/PCI_INTBb
add wave -noupdate -format Logic /ETRI_UWBFPGA/PCI_INTCb
add wave -noupdate -format Logic /ETRI_UWBFPGA/PCI_INTDb
add wave -noupdate -format Literal /ETRI_UWBFPGA/arb_gnt_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/HostBridge_gnt
add wave -noupdate -format Literal /ETRI_UWBFPGA/adin
add wave -noupdate -format Literal /ETRI_UWBFPGA/arb_req_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/HostBridge_req
add wave -noupdate -format Logic /ETRI_UWBFPGA/identify_sampleclock
add wave -noupdate -format Literal /ETRI_UWBFPGA/adout
add wave -noupdate -format Literal /ETRI_UWBFPGA/arb_gnt
add wave -noupdate -format Literal /ETRI_UWBFPGA/arb_req
add wave -noupdate -format Literal /ETRI_UWBFPGA/cbein_b
add wave -noupdate -format Literal /ETRI_UWBFPGA/cbeout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/devselin_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/devselout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/framein_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/frameout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/gnt_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/idsel
add wave -noupdate -format Logic /ETRI_UWBFPGA/intaout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/irdyin_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/irdyout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/oe_ad
add wave -noupdate -format Logic /ETRI_UWBFPGA/oe_cbe
add wave -noupdate -format Logic /ETRI_UWBFPGA/oe_devsel
add wave -noupdate -format Logic /ETRI_UWBFPGA/oe_frame
add wave -noupdate -format Logic /ETRI_UWBFPGA/oe_irdy
add wave -noupdate -format Logic /ETRI_UWBFPGA/oe_par
add wave -noupdate -format Logic /ETRI_UWBFPGA/oe_perr
add wave -noupdate -format Logic /ETRI_UWBFPGA/oe_req
add wave -noupdate -format Logic /ETRI_UWBFPGA/oe_stop
add wave -noupdate -format Logic /ETRI_UWBFPGA/oe_trdy
add wave -noupdate -format Logic /ETRI_UWBFPGA/parin
add wave -noupdate -format Logic /ETRI_UWBFPGA/parout
add wave -noupdate -format Logic /ETRI_UWBFPGA/pci_reset
add wave -noupdate -format Logic /ETRI_UWBFPGA/perrin_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/perrout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/reqout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/serrout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/stopin_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/stopout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/trdyin_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/trdyout_b
add wave -noupdate -format Literal /ETRI_UWBFPGA/identify_cycle
add wave -noupdate -format Logic /ETRI_UWBFPGA/identify_sampleclock
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12759 ns} 0}
configure wave -namecolwidth 255
configure wave -valuecolwidth 38
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
update
WaveRestoreZoom {12664 ns} {12920 ns}
