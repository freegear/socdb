
#######################################################
#                 DW Flattener                        #
################################################################################
#                                                                              #
# Design Compiler script to flatten DesignWare hierarchy throughout the design #
################################################################################

set save_place [current_design]

foreach_in_collection design_name [find design *] {
    current_design $design_name
    set dw_cell_list [filter [find cell *] {@is_synlib_operator==true || \
                       @is_dw_subblock==true || @is_synlib_module==true }]
    catch {sizeof_collection $dw_cell_list} result
    if {$result != 0} {
    echo [concat [format "%s%s" [format "%s%s" {Info: Found some DW \
         hierarchy in } [get_object_name $design_name]] {. Ungrouping...}]]
    ungroup -flatten $dw_cell_list -simple
}
}

current_design $save_place
unset save_place
unset dw_cell_list
