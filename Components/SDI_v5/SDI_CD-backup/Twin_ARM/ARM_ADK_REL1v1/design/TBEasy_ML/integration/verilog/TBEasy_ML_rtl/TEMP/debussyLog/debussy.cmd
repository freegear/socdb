srcSourceCodeView
srcResizeWindow 6 30 805 501
srcResizeWindow 6 30 804 500
srcResizeWindow 6 30 805 501
srcResizeWindow 6 30 804 500
debImport "-f" "deb_option"
srcViewImportLogFile
wvCreateWindow
wvResizeWindow -win $_nWave3 960 332
wvCloseWindow -win $_nWave3
srcSetScope -win $_nTrace1 "Arbiter3" -delim "."
schCreateWindow -delim "." -win $_nSchema1 -scope "Arbiter3"
schZoom {3816} {5819} {52267} {35654} -win $_nSchema4
schSetOptions -win $_nSchema4 -portName on
schSetOptions -win $_nSchema4 -pinName on
schSetOptions -win $_nSchema4 -instName on
schSetOptions -win $_nSchema4 -localNetName on
schSetOptions -win $_nSchema4 -parameterList on
schSetOptions -win $_nSchema4 -highContrastMode on
schZoom {6853} {5514} {39142} {35502} -win $_nSchema4
schSelect -win $_nSchema4 -inst "Arbiter3:Always15:666:676:Reg"
schPushViewIn -win $_nSchema4
srcCloseWindow -win $_nTrace5
schSelect -win $_nSchema4 -inst "Arbiter3:Always13:620:646:Combo"
schPushViewIn -win $_nSchema4
srcCloseWindow -win $_nTrace6
schSelect -win $_nSchema4 -signal "Split1"
schDeselectAll -win $_nSchema4
srcDeselectAll -win $_nTrace2
schSelect -win $_nSchema4 -inst "uArbSchm3"
schSelect -win $_nSchema4 -inst "uArbSchm3"
schZoomOut -win $_nSchema4
schZoomOut -win $_nSchema4
srcDeselectAll -win $_nTrace2
srcDeselectAll -win $_nTrace2
srcDeselectAll -win $_nTrace2
srcDeselectAll -win $_nTrace2
srcSelect -win $_nTrace2 -range {398 398 1 17}
srcDeselectAll -win $_nTrace2
srcDeselectAll -win $_nTrace2
srcSelect -win $_nTrace2 -range {226 226 8 12}
srcDeselectAll -win $_nTrace2
srcDeselectAll -win $_nTrace2
srcSelect -win $_nTrace2 -range {249 249 6 8}
srcDeselectAll -win $_nTrace2
srcSelect -win $_nTrace2 -range {249 265 1 9}
srcDeselectAll -win $_nTrace2
srcSelect -win $_nTrace2 -range {595 595}
srcDeselectAll -win $_nTrace2
srcDeselectAll -win $_nTrace2
srcDeselectAll -win $_nTrace2
srcSelect -win $_nTrace2 -range {604 604 19 19}
srcDeselectAll -win $_nTrace2
srcSelect -win $_nTrace2 -range {625 625 7 8}
srcDeselectAll -win $_nTrace2
srcSelect -win $_nTrace2 -range {628 648}
srcDeselectAll -win $_nTrace2
srcResizeWindow 2 8 1268 962
debReload
srcSelect -win $_nTrace1 -range {31 31 3 3}
srcDeselectAll -win $_nTrace1
srcResizeWindow 203 176 804 500
srcResizeWindow 2 8 1268 962
debReload
srcSelect -win $_nTrace1 -range {31 31 3 3}
schCloseWindow -win $_nSchema4
srcResizeWindow 203 176 804 500
srcCloseWindow -win $_nTrace2
srcSetScope -win $_nTrace1 "MuxM2S" -delim "."
srcSetScope -win $_nTrace1 "FileReader" -delim "."
srcSetScope -win $_nTrace1 "EgMaster" -delim "."
schCreateWindow -delim "." -win $_nSchema1 -scope "EgMaster"
schSelect -win $_nSchema7 -inst "uLite2AHB"
schPushViewIn -win $_nSchema7
schSelect -win $_nSchema7 -inst "uLite2AHB"
schPushViewIn -win $_nSchema7
schSelect -win $_nSchema7 -inst "uLite2AHB"
schPushViewIn -win $_nSchema7
schSelect -win $_nSchema7 -inst "uLite2AHB"
schPushViewIn -win $_nSchema7
schSelect -win $_nSchema7 -inst "uLite2AHB"
schPushViewIn -win $_nSchema7
schSelect -win $_nSchema7 -inst "uEgMasterCore"
schPushViewIn -win $_nSchema7
schPopViewUp -win $_nSchema7
schSelect -win $_nSchema7 -inst "uLite2AHB"
schSelect -win $_nSchema7 -inst "uLite2AHB"
schSelect -win $_nSchema7 -inst "uLite2AHB"
schPushViewIn -win $_nSchema7
schSelect -win $_nSchema7 -inst "uLite2AHB"
schPushViewIn -win $_nSchema7
schSelect -win $_nSchema7 -inst "uLite2AHB"
schPushViewIn -win $_nSchema7
schSelect -win $_nSchema7 -inst "uLite2AHB"
schPushViewIn -win $_nSchema7
schSelect -win $_nSchema7 -inst "uLite2AHB"
schPushViewIn -win $_nSchema7
schZoom {13912} {439} {28217} {15195} -win $_nSchema7
schZoom {17043} {3018} {27095} {8974} -win $_nSchema7
srcSetScope -win $_nTrace1 "EgMaster.uEgMasterCore" -delim "."
schSetScope -win $_nSchema7 -scope "EgMaster.uEgMasterCore"
srcResizeWindow 2 8 1268 962
srcSetScope -win $_nTrace1 "EgMaster" -delim "."
srcSetScope -win $_nTrace1 "EgMaster" -delim "."
srcSetScope -win $_nTrace1 "EgMaster.uLite2AHB" -delim "."
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {174 175}
srcSetScope -win $_nTrace1 "EgMaster.uEgMasterCore" -delim "."
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcShowCalling -win $_nTrace1
srcSelect -win $_nTrace1 -range {156 156 2 2}
srcDeselectAll -win $_nTrace1
srcSetScope -win $_nTrace1 "EgMaster" -delim "."
srcSetScope -win $_nTrace1 "EgMaster" -delim "."
srcSetScope -win $_nTrace1 "TBEasy_ML" -delim "."
srcSetScope -win $_nTrace1 "TBEasy_ML.uEASY_ML" -delim "."
srcSetScope -win $_nTrace1 "TBEasy_ML.uEASY_ML" -delim "."
srcSetScope -win $_nTrace1 "TBEasy_ML.uEASY_ML.uDmac" -delim "."
srcSetScope -win $_nTrace1 "TBEasy_ML" -delim "."
schCreateWindow -delim "." -win $_nSchema7 -scope "TBEasy_ML"
schSetOptions -win $_nSchema8 -portName on
schSetOptions -win $_nSchema8 -pinName on
schSetOptions -win $_nSchema8 -instName on
schSetOptions -win $_nSchema8 -localNetName on
schSetOptions -win $_nSchema8 -parameterList on
schSetOptions -win $_nSchema8 -highContrastMode on
schSelect -win $_nSchema8 -inst "uEASY_ML"
schSelect -win $_nSchema8 -inst "uEASY_ML"
schPushViewIn -win $_nSchema8
schSelect -win $_nSchema8 -inst "uBusMatrix"
schPushViewIn -win $_nSchema8
schSelect -win $_nSchema8 -inst "uOutputstage1"
schChangeDisplayAttr -color ID_RED2
schSelectAll -win $_nSchema8 -inst
schSelectAll -win $_nSchema8 -inst
schSelectAll -win $_nSchema8 -inst
schChangeDisplayAttr -default
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schFit -win $_nSchema8
schFit -win $_nSchema8
schFit -win $_nSchema8
schFit -win $_nSchema8
schFit -win $_nSchema8
schFit -win $_nSchema8
schFit -win $_nSchema8
schZoom {35084} {11775} {64236} {44287} -win $_nSchema8
schZoom {45076} {21250} {61121} {38633} -win $_nSchema8
schFit -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schDeselectAll -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schDeselectAll -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schSelect -win $_nSchema8 -signal "nTRST"
schDeselectAll -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schLastView -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schFit -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schSelect -win $_nSchema8 -signal "XCLKIN"
schSelect -win $_nSchema8 -signal "XCLKIN"
schSelect -win $_nSchema8 -signal "XCLKIN"
schFocusConnection -win $_nSchema8
schDeselectAll -win $_nSchema8
srcDeselectAll -win $_nTrace1
schZoomIn -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schZoomIn -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -signal "XCLKIN"
schFocusConnection -win $_nSchema8
schSelect -win $_nSchema8 -signal "XCLKIN"
schChangeDisplayAttr -color ID_RED5
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "nReset"
schSelect -win $_nSchema8 -signal "nReset"
schChangeDisplayAttr -color ID_RED6
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -inst "uEASY_ML"
schPushViewIn -win $_nSchema8
schZoomIn -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schSelect -win $_nSchema8 -instport "uEASY_ML" "GPIN\[7:0\]"
schZoomOut -win $_nSchema8
schCloseWindow -win $_nSchema7
schZoomOut -win $_nSchema8
schSelect -win $_nSchema8 -inst "uEASY_ML"
schPushViewIn -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schSelect -win $_nSchema8 -instpin "uDmac" "HADDRM\[31:0\]"
schSelect -win $_nSchema8 -instpin "uDmac" "HADDRM\[31:0\]"
schSelect -win $_nSchema8 -signal "HADDRS1\[31:0\]"
schChangeDisplayAttr -color ID_RED5
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HWDATAS1\[31:0\]"
schChangeDisplayAttr -color ID_RED5
schSelect -win $_nSchema8 -signal "HSIZES1\[2:0\]"
schChangeDisplayAttr -color ID_RED5
schSelect -win $_nSchema8 -instpin "uDmac" "HPROTM\[3:0\]"
schSelect -win $_nSchema8 -signal "HPROPS1"
schSelect -win $_nSchema8 -signal "HPROPS1"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HPROPS1"
schChangeDisplayAttr -color ID_RED5
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HWRITES1"
schChangeDisplayAttr -color ID_RED5
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HMASTLOCKS1"
schChangeDisplayAttr -color ID_RED5
schSelect -win $_nSchema8 -signal "HTRANSS1\[1:0\]"
schChangeDisplayAttr -color ID_RED5
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HBURSTS1\[2:0\]"
schChangeDisplayAttr -color ID_RED6
schChangeDisplayAttr -color ID_RED5
schSelect -win $_nSchema8 -signal "HRDATAdmac\[31:0\]"
schChangeDisplayAttr -color ID_RED5
schSelect -win $_nSchema8 -signal "TieOffHi1"
schChangeDisplayAttr -color ID_RED5
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HRESPS1\[1:0\]"
schChangeDisplayAttr -color ID_RED5
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HBUSREQDMACM"
schChangeDisplayAttr -color ID_RED5
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HGRANTDMACM"
schChangeDisplayAttr -color ID_RED5
schSelect -win $_nSchema8 -signal "TieOffHi1"
schSelect -win $_nSchema8 -signal "TieOffHi1"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "TieOffHi1"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "TieOffHi1"
schDeselectAll -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomIn -win $_nSchema8
schPanLeft -win $_nSchema8
schZoomIn -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -inst "uDmac"
schDeselectAll -win $_nSchema8
schPanUp -win $_nSchema8
schSelect -win $_nSchema8 -signal "SMDATAOUT\[31:0\]"
schPanRight -win $_nSchema8
schZoomIn -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "TieOffHi1"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "TieOffHi1"
schSelect -win $_nSchema8 -signal "TieOffHi1"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HREADYmtrxS1"
schChangeDisplayAttr -color ID_YELLOW5
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HREADYmtrxS1"
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -inst "uBusMatrix"
schSelect -win $_nSchema8 -inst "uBusMatrix"
schSelect -win $_nSchema8 -inst "uBusMatrix"
schDeselectAll -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schSelect -win $_nSchema8 -signal "HADDRS1\[31:0\]"
schSelect -win $_nSchema8 -signal "HWRITES1"
schSelect -win $_nSchema8 -signal "HSIZES1\[2:0\]"
schSelect -win $_nSchema8 -signal "HMASTLOCKS1"
schSelect -win $_nSchema8 -signal "HBURSTS1\[2:0\]"
schSelect -win $_nSchema8 -signal "HWRITES1"
schSelect -win $_nSchema8 -signal "HTRANSS1\[1:0\]"
schSelect -win $_nSchema8 -signal "HWDATAS1\[31:0\]"
schSelect -win $_nSchema8 -signal "HRDATAS1\[31:0\]"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HRDATAS1\[31:0\]"
schChangeDisplayAttr -color ID_RED5
schSelect -win $_nSchema8 -signal "HRDATAS1\[31:0\]"
schSelect -win $_nSchema8 -signal "HRDATAS1\[31:0\]"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HREADYmtrxS1"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -inst "EASY_ML:SigTap15:478:478:Combo"
schSelect -win $_nSchema8 -inst "EASY_ML:SigTap15:478:478:Combo"
schSelect -win $_nSchema8 -instpin "EASY_ML:SigTap15:478:478:Combo" "O0"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -inst "EASY_ML:SigTap15:478:478:Combo"
schSelect -win $_nSchema8 -inst "EASY_ML:SigTap15:478:478:Combo"
schPushViewIn -win $_nSchema8
schSelect -win $_nSchema8 -inst "EASY_ML:SigTap15:478:478:Combo"
srcCloseWindow -win $_nTrace9
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HREADYmtrxS1"
schSelect -win $_nSchema8 -signal "HREADYmtrxS1"
schSelect -win $_nSchema8 -signal "HREADYmtrxS1"
schSelect -win $_nSchema8 -signal "HREADYS1"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HRESPS1\[1:0\]"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HREADYmtrxS1"
schSelect -win $_nSchema8 -signal "HREADYS1"
schDeselectAll -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schSelect -win $_nSchema8 -signal "HREADYS1"
schPanLeft -win $_nSchema8
schSelect -win $_nSchema8 -inst "uBusMatrix"
schPushViewIn -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schZoomIn -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schZoomIn -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schSelect -win $_nSchema8 -inst "uInputStage1"
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schZoomIn -win $_nSchema8
schPanDown -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schDeselectAll -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schSelect -win $_nSchema8 -signal "HSIZES1\[2:0\]"
schDeselectAll -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schZoomIn -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schSelect -win $_nSchema8 -inst "uInputStage1"
schDeselectAll -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schSelect -win $_nSchema8 -signal "HREADYS1"
schChangeDisplayAttr -color ID_YELLOW5
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -inst "uBusMatrix"
schPushViewIn -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schSelect -win $_nSchema8 -inst "uMatrixDecode0"
schPushViewIn -win $_nSchema8
schSelect -win $_nSchema8 -inst "MatrixDecode:Always0:135:142:Combo"
schSelect -win $_nSchema8 -inst "MatrixDecode:Always0:135:142:Combo"
schPushViewIn -win $_nSchema8
srcCloseWindow -win $_nTrace10
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -inst "MatrixDecode:Always3:186:195:RegCombo"
schSelect -win $_nSchema8 -inst "MatrixDecode:Always3:186:195:RegCombo"
schPushViewIn -win $_nSchema8
srcCloseWindow -win $_nTrace11
schSelect -win $_nSchema8 -inst "MatrixDecode:Always5:210:221:Combo"
schSelect -win $_nSchema8 -inst "MatrixDecode:Always5:210:221:Combo"
schSelect -win $_nSchema8 -inst "MatrixDecode:Always5:210:221:Combo"
schPushViewIn -win $_nSchema8
srcCloseWindow -win $_nTrace12
schDeselectAll -win $_nSchema8
schLastView -win $_nSchema8
schPopViewUp -win $_nSchema8
debReload
srcSelect -win $_nTrace1 -range {26 26 3 3}
srcResizeWindow 203 176 804 500
srcResizeWindow 2 8 1268 962
srcDeselectAll -win $_nTrace1
wvCreateWindow
wvResizeWindow -win $_nWave13 960 332
wvCloseWindow -win $_nWave13
srcSetScope -win $_nTrace1 "TBEasy_ML" -delim "."
srcSetScope -win $_nTrace1 "TBEasy_ML" -delim "."
srcCreateWindow
schCreateWindow -delim "." -win $_nSchema8 -scope "TBEasy_ML"
schSelect -win $_nSchema15 -inst "uEASY_ML"
schPushViewIn -win $_nSchema15
schZoomOut -win $_nSchema15
schZoomIn -win $_nSchema15
schZoomIn -win $_nSchema15
schZoomIn -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schSelect -win $_nSchema15 -inst "uBusMatrix"
schSelect -win $_nSchema15 -inst "uBusMatrix"
schDeselectAll -win $_nSchema15
schSelect -win $_nSchema15 -inst "uBusMatrix"
schSelect -win $_nSchema15 -inst "uBusMatrix"
schDeselectAll -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schSetOptions -win $_nSchema15 -portName on
schSetOptions -win $_nSchema15 -pinName on
schSetOptions -win $_nSchema15 -instName on
schSetOptions -win $_nSchema15 -localNetName on
schSetOptions -win $_nSchema15 -parameterList on
schSetOptions -win $_nSchema15 -highContrastMode on
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanLeft -win $_nSchema15
schSelect -win $_nSchema15 -signal "HREADYOUTM1"
schPanUp -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanDown -win $_nSchema15
schPanLeft -win $_nSchema15
schPanDown -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schSelect -win $_nSchema15 -signal "HREADYmtrxS0"
schChangeDisplayAttr -color ID_RED5
schPanUp -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schSelect -win $_nSchema15 -signal "HREADYmtrxS1"
schChangeDisplayAttr -color ID_RED5
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanLeft -win $_nSchema15
schPanUp -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schSelect -win $_nSchema15 -signal "HREADYOUTM1"
schPanLeft -win $_nSchema15
schPanUp -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanDown -win $_nSchema15
schPanLeft -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanDown -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schSelect -win $_nSchema15 -signal "HREADYM1"
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanDown -win $_nSchema15
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schChangeDisplayAttr -color ID_RED5
schChangeDisplayAttr -default
schDeselectAll -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schSelect -win $_nSchema15 -signal "HREADYmtrxS0"
schSelect -win $_nSchema15 -signal "HREADYmtrxS0"
schSelect -win $_nSchema15 -signal "HREADYmtrxS0"
schChangeDisplayAttr -default
schDeselectAll -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanLeft -win $_nSchema15
schPanDown -win $_nSchema15
schSelect -win $_nSchema15 -signal "HREADYmtrxS1"
schPanRight -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schSelect -win $_nSchema15 -signal "HREADYOUTdmac"
schChangeDisplayAttr -color ID_RED5
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schSelect -win $_nSchema15 -instpin "uBusMatrix" "HREADYM1"
schSelect -win $_nSchema15 -signal "HSELM1"
schSelect -win $_nSchema15 -signal "HSIZEM1\[2:0\]"
schSelect -win $_nSchema15 -signal "HREADYM1"
schChangeDisplayAttr -color ID_RED5
schPanDown -win $_nSchema15
schPanDown -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanLeft -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanRight -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schPanLeft -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanUp -win $_nSchema15
schSelect -win $_nSchema15 -signal "HREADYmtrxS1"
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanLeft -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanLeft -win $_nSchema15
schPanDown -win $_nSchema15
schPanUp -win $_nSchema15
schPanRight -win $_nSchema15
schPanDown -win $_nSchema15
schSelect -win $_nSchema15 -inst "uBusMatrix"
schSelect -win $_nSchema15 -signal "HADDRS0\[11:2\]"
schSelect -win $_nSchema15 -signal "HSIZEword\[2:0\]"
schSelect -win $_nSchema15 -signal "HREADYmtrxS1"
schDeselectAll -win $_nSchema15
schPopViewUp -win $_nSchema8
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema15 -signal "HSELM2"
schSelect -win $_nSchema8 -signal "TCK"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "TESTREQA"
schDeselectAll -win $_nSchema8
schZoomIn -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schSelect -win $_nSchema8 -signal "nReset"
schDeselectAll -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schSelect -win $_nSchema8 -inst "uEASY_ML"
schPushViewIn -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schSelect -win $_nSchema8 -inst "uInport0"
schPushViewIn -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schLastView -win $_nSchema8
schPopViewUp -win $_nSchema8
schDeselectAll -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -inst "uInport0"
schPushViewIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schSelect -win $_nSchema8 -inst "uIntMem"
schSelect -win $_nSchema8 -inst "uIntMem"
schPushViewIn -win $_nSchema8
schPopViewUp -win $_nSchema8
schSelect -win $_nSchema8 -inst "uIntMem"
schSelect -win $_nSchema8 -inst "uIntMem"
schPushViewIn -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schSelect -win $_nSchema8 -inst "TBEasy_ML:SigTap6:198:198:Combo"
schSelect -win $_nSchema8 -inst "uMemory"
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schSelect -win $_nSchema8 -signal "XD\[31:0\]"
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schSelect -win $_nSchema8 -signal "XBLS\[3:0\]"
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schSelect -win $_nSchema8 -signal "XCSN\[7:4\]"
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schDeselectAll -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -inst "uEASY_ML"
schSelect -win $_nSchema8 -inst "uEASY_ML"
schPushViewIn -win $_nSchema8
schSelect -win $_nSchema8 -inst "uOutport0"
schPushViewIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -inst "uMuxS2M"
schDeselectAll -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schZoomOut -win $_nSchema8
schPanUp -win $_nSchema8
schZoomIn -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schSelect -win $_nSchema8 -signal "HSELS13"
schDeselectAll -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schSelect -win $_nSchema8 -inst "uDecoder"
schDeselectAll -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -signal "HSELS0B"
schPanUp -win $_nSchema8
schSelect -win $_nSchema8 -signal "HSELS0R"
schSelect -win $_nSchema8 -signal "TieOffLo1"
schDeselectAll -win $_nSchema8
schPanUp -win $_nSchema8
schSelect -win $_nSchema8 -signal "TieOffLo1"
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schZoomIn -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -signal "HRDATAS0\[31:0\]"
schPanLeft -win $_nSchema8
schSelect -win $_nSchema8 -signal "HRDATAS0\[31:0\]"
schFocusConnection -win $_nSchema8
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -inst "Outport0:SigTap10:600:600:Combo"
schPushViewIn -win $_nSchema8
srcCloseWindow -win $_nTrace16
schSelect -win $_nSchema8 -signal "HRDATAS0\[31:0\]"
schPanUp -win $_nSchema8
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "HRDATASmi\[31:0\]"
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schSelect -win $_nSchema8 -inst "uMemory"
schPushViewIn -win $_nSchema8
schZoomIn -win $_nSchema8
schSelect -win $_nSchema8 -signal "XCSN\[3:0\]"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "XCSN\[3:0\]"
schZoomIn -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schChangeDisplayAttr -color ID_RED5
schDeselectAll -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schSelect -win $_nSchema8 -signal "XCSN\[0\]"
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schSelect -win $_nSchema8 -signal "XCSN\[1\]"
schSelect -win $_nSchema8 -signal "XCSN\[3\]"
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schSelect -win $_nSchema8 -signal "XCSN\[1\]"
schSelect -win $_nSchema8 -signal "XCSN\[0\]"
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schLastView -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schDeselectAll -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schSelect -win $_nSchema8 -signal "XOEN"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -inst "uTube"
schSelect -win $_nSchema8 -inst "uMemory"
schSelect -win $_nSchema8 -inst "uTube"
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schSelect -win $_nSchema8 -signal "XBLS\[3:0\]"
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schSelect -win $_nSchema8 -inst "uMemory"
schSelect -win $_nSchema8 -inst "uEASY_ML"
schPushViewIn -win $_nSchema8
schSelect -win $_nSchema8 -inst "uOutport0"
schSelect -win $_nSchema8 -inst "uInport0"
schSelect -win $_nSchema8 -inst "uInport0"
schPushViewIn -win $_nSchema8
schSelect -win $_nSchema8 -inst "Inport0:SigOp10:457:476:Combo"
schFit -win $_nSchema8
schDeselectAll -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schSelect -win $_nSchema8 -signal "iHWDATA\[31:0\]"
schSelect -win $_nSchema8 -signal "iHADDR\[31:0\]"
schSelect -win $_nSchema8 -signal "HRESETn"
schSelect -win $_nSchema8 -signal "HCLK"
schSelect -win $_nSchema8 -signal "HRESETn"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "iHSIZE\[2:0\]"
schSelect -win $_nSchema8 -signal "iHWDATA\[31:0\]"
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "iHREADY"
schSelect -win $_nSchema8 -inst "uIntMem"
schPushViewIn -win $_nSchema8
schPopViewUp -win $_nSchema8
schDeselectAll -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schZoomOut -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schLastView -win $_nSchema8
schLastView -win $_nSchema8
schLastView -win $_nSchema8
schLastView -win $_nSchema8
schLastView -win $_nSchema8
schLastView -win $_nSchema8
schLastView -win $_nSchema8
schLastView -win $_nSchema8
schLastView -win $_nSchema8
schLastView -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -inst "uEASY_ML"
schPushViewIn -win $_nSchema8
schSelect -win $_nSchema8 -inst "uOutport0"
schPushViewIn -win $_nSchema8
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schSelect -win $_nSchema8 -port "SMDATAOUT\[31:0\]"
schSelect -win $_nSchema8 -signal "SMDATAOUT\[31:0\]"
schSelect -win $_nSchema8 -signal "SMDATAOUT\[31:0\]"
schPopViewUp -win $_nSchema8
schDeselectAll -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schSelect -win $_nSchema8 -inst "uOutport0"
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -signal "SMDATAOUT\[31:0\]"
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanUp -win $_nSchema8
schPopViewUp -win $_nSchema8
schZoomIn -win $_nSchema8
schZoomIn -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "XD\[31:0\]"
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schSelect -win $_nSchema8 -signal "XOEN"
schSelect -win $_nSchema8 -signal "XD\[31:0\]"
schPanDown -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanDown -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -signal "XDout\[31:0\]"
schPanUp -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanDown -win $_nSchema8
schChangeDisplayAttr -color ID_YELLOW5
schDeselectAll -win $_nSchema8
schSelect -win $_nSchema8 -signal "XD\[31:0\]"
schChangeDisplayAttr -color ID_YELLOW5
schDeselectAll -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -signal "XDATAEN\[0\]"
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schChangeDisplayAttr -color ID_ORANGE6
schDeselectAll -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schSelect -win $_nSchema8 -signal "XDATAEN\[3:0\]"
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schSelect -win $_nSchema8 -signal "XDATAEN\[3:0\]"
schPanLeft -win $_nSchema8
schPanRight -win $_nSchema8
schPanLeft -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanDown -win $_nSchema8
schSelect -win $_nSchema8 -signal "XBLS\[3:0\]"
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
schPanLeft -win $_nSchema8
schPanUp -win $_nSchema8
schPanUp -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanRight -win $_nSchema8
schPanDown -win $_nSchema8
