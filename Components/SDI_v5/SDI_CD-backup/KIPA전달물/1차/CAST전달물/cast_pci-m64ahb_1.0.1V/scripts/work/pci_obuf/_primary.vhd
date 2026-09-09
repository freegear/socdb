library verilog;
use verilog.vl_types.all;
entity pci_obuf is
    port(
        i               : in     vl_logic;
        o               : out    vl_logic
    );
end pci_obuf;
