srcSourceCodeView
srcResizeWindow 6 29 805 501
srcResizeWindow 6 29 804 500
srcResizeWindow 6 29 805 501
srcResizeWindow 6 29 804 500
debImport "-f" "vlog_option" "rc8051RtlTop_compile.v.out"
schCreateWindow -delim "." -win $_nSchema1 -scope "UDIV8x8"
schCloseWindow -win $_nSchema2
srcSetScope -win $_nTrace1 "rc8051RtlTop" -delim "."
schCreateWindow -delim "." -win $_nSchema1 -scope "rc8051RtlTop"
schZoom {-32844} {230609} {234317} {363682} -win $_nSchema3
schZoom {-1891} {260029} {204731} {349998} -win $_nSchema3
schSelect -win $_nSchema3 -inst "U3_cpu"
schSetOptions -win $_nSchema3 -portName on
schSetOptions -win $_nSchema3 -pinName on
schSetOptions -win $_nSchema3 -instName on
schSetOptions -win $_nSchema3 -localNetName on
schSetOptions -win $_nSchema3 -parameterList on
schSetOptions -win $_nSchema3 -highContrastMode on
schZoom {114531} {274728} {164875} {316681} -win $_nSchema3
schZoom {121585} {296621} {147144} {311072} -win $_nSchema3
schZoom {123517} {296992} {140382} {310328} -win $_nSchema3
schSelect -win $_nSchema3 -inst "U3_cpu"
schZoom {125881} {304946} {134794} {307928} -win $_nSchema3
schSelect -win $_nSchema3 -signal "n104,n105,n106,n107,n108,n109,n110,n111"
schSelect -win $_nSchema3 -instport "U3_cpu" "in_xrom_a\[7:0\]"
schPushViewIn -win $_nSchema3
schZoom {16226} {79305} {60057} {110448} -win $_nSchema3
schSelect -win $_nSchema3 -signal "ld_acc_chd"
schZoom {30695} {90513} {41343} {97958} -win $_nSchema3
schZoom {35082} {94053} {39104} {96692} -win $_nSchema3
schChangeDisplayAttr -color ID_YELLOW5
schSelect -win $_nSchema3 -instport "U1_datapath" "ld_acc_chd"
schPushViewIn -win $_nSchema3
schChangeDisplayAttr -color ID_YELLOW5
schZoom {906445} {264900} {1102841} {380805} -win $_nSchema3
schZoom {990054} {297754} {1024408} {335401} -win $_nSchema3
schZoom {994851} {321916} {1001064} {326794} -win $_nSchema3
schSelect -win $_nSchema3 -instport "U1_sfr" "ld_acc_chd"
schPushViewIn -win $_nSchema3
schChangeDisplayAttr -color ID_YELLOW5
schZoom {113721} {-27314} {152409} {22980} -win $_nSchema3
schZoom {119047} {-14279} {143702} {3244} -win $_nSchema3
schZoom {125569} {-6096} {137394} {737} -win $_nSchema3
schSelect -win $_nSchema3 -instport "U2_acc" "ld_acc_chd"
schPushViewIn -win $_nSchema3
schZoom {21090} {-2415} {41124} {9043} -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoom {23270} {33932} {59356} {64186} -win $_nSchema3
schZoom {32030} {42882} {52741} {54607} -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoom {-24595} {-26149} {79125} {31505} -win $_nSchema3
schZoom {-8606} {-11074} {45656} {11128} -win $_nSchema3
schSelect -win $_nSchema3 -signal "ld_acc_chd"
schSelect -win $_nSchema3 -port "ld_acc_chd"
schPopViewUp -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoom {-24267} {-37896} {50158} {3129} -win $_nSchema3
schZoom {-4413} {-22021} {7001} {-14352} -win $_nSchema3
schSelect -win $_nSchema3 -port "ld_acc_chd"
schPopViewUp -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schFit -win $_nSchema3
schZoom {-22948} {71723} {59688} {122164} -win $_nSchema3
schZoom {-243} {94435} {9790} {103741} -win $_nSchema3
schSelect -win $_nSchema3 -port "ld_acc_chd"
schPopViewUp -win $_nSchema3
schFit -win $_nSchema3
schPopViewUp -win $_nSchema3
schPopViewUp -win $_nSchema3
schPopViewUp -win $_nSchema3
schFit -win $_nSchema3
schFit -win $_nSchema3
schZoom {90802} {276806} {150703} {318833} -win $_nSchema3
schZoom {120084} {300491} {135754} {311639} -win $_nSchema3
schZoom {126529} {302276} {133261} {309826} -win $_nSchema3
schSelect -win $_nSchema3 -signal "n104,n105,n106,n107,n108,n109,n110,n111"
schChangeDisplayAttr -color ID_YELLOW5
schSelect -win $_nSchema3 -instport "U3_cpu" "in_xrom_a\[7:0\]"
schPushViewIn -win $_nSchema3
schZoom {28400} {82444} {55277} {99448} -win $_nSchema3
schZoom {33294} {90087} {40893} {95089} -win $_nSchema3
schSelect -win $_nSchema3 -instport "U1_datapath" "in_xrom_a\[7:0\]"
schPushViewIn -win $_nSchema3
schFit -win $_nSchema3
schZoom {705756} {385098} {851712} {524614} -win $_nSchema3
schZoom {715969} {442235} {775835} {499883} -win $_nSchema3
schFit -win $_nSchema3
schFit -win $_nSchema3
schZoom {297939} {366854} {539410} {525687} -win $_nSchema3
schFit -win $_nSchema3
schZoom {720781} {376512} {823809} {490272} -win $_nSchema3
schZoom {736971} {418094} {778553} {440763} -win $_nSchema3
schFit -win $_nSchema3
schFit -win $_nSchema3
schZoom {1155428} {384025} {1249870} {446270} -win $_nSchema3
schFit -win $_nSchema3
schFit -win $_nSchema3
schZoom {1211235} {505296} {1303530} {610470} -win $_nSchema3
schZoom {1227296} {562640} {1274354} {580512} -win $_nSchema3
schFit -win $_nSchema3
schZoom {344087} {406562} {458920} {488125} -win $_nSchema3
schSelect -win $_nSchema3 -inst "U1129"
srcSetScope "rc8051RtlTop.U3_cpu.U1_datapath" -win $_nTrace1
srcSelect -win $_nTrace1 -range {1521 1521 4 4}
srcSetScope -win $_nTrace1 "rc8051RtlTop.U3_cpu.U1_datapath.U1_sfr" -delim "."
schSetScope -win $_nSchema3 -scope "rc8051RtlTop.U3_cpu.U1_datapath.U1_sfr"
schFit -win $_nSchema3 -selected
schFit -win $_nSchema3 -selected
schFit -win $_nSchema3
schFit -win $_nSchema3 -selected
schZoom {101148} {-19577} {161437} {11374} -win $_nSchema3
schZoom {123491} {-11710} {138274} {3073} -win $_nSchema3
schFit -win $_nSchema3 -selected
schFit -win $_nSchema3
srcDeselectAll -win $_nTrace1
srcShowCalling -win $_nTrace1
srcSelect -win $_nTrace1 -range {969 969 4 4}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "U1_sfr" -win $_nTrace1
srcSelect -inst "U1_sfr" -win $_nTrace1
schSetScope -win $_nSchema3 -inst "rc8051RtlTop.U3_cpu.U1_datapath.U1_sfr"
schZoom {981854} {312922} {1018390} {334016} -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoom {852039} {313497} {991147} {395766} -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoomOut -win $_nSchema3
schZoom {-1557938} {-885134} {1599139} {1724139} -win $_nSchema3
schZoom {-81474} {575803} {154572} {830989} -win $_nSchema3
schZoom {-16485} {700276} {33741} {740832} -win $_nSchema3
schZoom {-6890} {717728} {6694} {726652} -win $_nSchema3
schSelect -win $_nSchema3 -port "inc_pc2"
schPopViewUp -win $_nSchema3
schFit -win $_nSchema3 -selected
schZoom {20481} {85850} {48841} {111400} -win $_nSchema3
schSelect -win $_nSchema3 -instport "U1_datapath" "clk"
schPushViewIn -win $_nSchema3
schFit -win $_nSchema3 -selected
schCloseWindow -win $_nSchema3
debExit
