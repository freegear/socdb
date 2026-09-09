; Define the wire tracks.
;

setCaseSensitive #t

geOpenLib
    setFormField "Open Library" "Library Name" "tsmc090g"
    formOK "Open Library"

axgDefineWireTracks
    setFormField "Define Wire Track" "Poly Offset" 0.0
    setFormField "Define Wire Track" "M1 Offset" 0.140
    setFormField "Define Wire Track" "M2 Offset" 0.140
    setFormField "Define Wire Track" "M3 Offset" 0.140
    setFormField "Define Wire Track" "M4 Offset" 0.140
    setFormField "Define Wire Track" "M5 Offset" 0.140
    setFormField "Define Wire Track" "M6 Offset" 0.140
    setFormField "Define Wire Track" "M7 Offset" 0.140
    setFormField "Define Wire Track" "M8 Offset" 0.140
    setFormField "Define Wire Track" "M9 Offset" 0.140 
    formOK "Define Wire Track"

axgCheckWireTrack
    setFormField "Check Wire Track" "Library Name" "tsmc090g"
    setFormField "Check Wire Track" "allOrN" "All Cells"
    formOK "Check Wire Track"

geCloseLib
exit
