library verilog;
use verilog.vl_types.all;
entity pci_iobuf is
    port(
        i               : in     vl_logic;
        t               : in     vl_logic;
        o               : out    vl_logic;
        iopci           : inout  vl_logic
    );
end pci_iobuf;
