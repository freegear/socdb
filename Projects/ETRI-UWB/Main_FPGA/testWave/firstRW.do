onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /ETRI_UWBFPGA/dummy
add wave -noupdate -format Logic /ETRI_UWBFPGA/pci_clk
add wave -noupdate -format Logic /ETRI_UWBFPGA/pci_reset
add wave -noupdate -format Literal /ETRI_UWBFPGA/identify_cycle
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /ETRI_UWBFPGA/identify_sampleclock
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HBAR
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HADDR_M1
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HBURST_M1
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/HLOCK_M1
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HRDATA_M1
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HRESP_M1
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HSIZE_M1
add wave -noupdate -color Yellow -format Literal /ETRI_UWBFPGA/Core/HTRANS_M1
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HWDATA_M1
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/HWRITE_M1
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/HREADY_OUT_M1
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HADDR_S2
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HBURST_S2
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/HBUSREQ
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HRDATA_S2
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/HREADY_IN_S2
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/HREADY_OUT_S2
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HRESP_S2
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HSEL_pci
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HSIZE_S2
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HTRANS_S2
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/HWDATA_S2
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/HWRITE_S2
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Logic /ETRI_UWBFPGA/PCI_INTAb
add wave -noupdate -format Logic /ETRI_UWBFPGA/PCI_INTBb
add wave -noupdate -format Logic /ETRI_UWBFPGA/PCI_INTCb
add wave -noupdate -format Logic /ETRI_UWBFPGA/PCI_INTDb
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Literal /ETRI_UWBFPGA/arb_gnt_b
add wave -noupdate -format Literal /ETRI_UWBFPGA/arb_req_b
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/adin
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/adout
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/arb_gnt_b
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/arb_req_b
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/cbein_b
add wave -noupdate -format Literal /ETRI_UWBFPGA/Core/cbeout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/devselin_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/devselout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/framein_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/frameout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/gnt_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/idsel
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/intaout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/irdyin_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/irdyout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/oe_ad
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/oe_cbe
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/oe_devsel
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/oe_frame
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/oe_irdy
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/oe_par
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/oe_perr
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/oe_req
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/oe_stop
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/oe_trdy
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/parin
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/parout
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/perrin_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/perrout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/reqout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/serrout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/stopin_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/stopout_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/trdyin_b
add wave -noupdate -format Logic /ETRI_UWBFPGA/Core/trdyout_b
add wave -noupdate -divider {New Divider}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {82355 ns} 0}
configure wave -namecolwidth 279
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
WaveRestoreZoom {81352 ns} {85032 ns}
