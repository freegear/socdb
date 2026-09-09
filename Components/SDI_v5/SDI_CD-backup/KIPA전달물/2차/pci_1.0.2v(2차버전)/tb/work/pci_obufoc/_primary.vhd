library verilog;
use verilog.vl_types.all;
entity pci_obufoc is
    port(
        i               : in     vl_logic;
        o               : out    vl_logic
    );
end pci_obufoc;
