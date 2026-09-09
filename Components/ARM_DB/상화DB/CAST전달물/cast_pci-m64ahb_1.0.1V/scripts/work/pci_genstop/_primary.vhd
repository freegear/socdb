library verilog;
use verilog.vl_types.all;
entity pci_genstop is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        t_trdata        : in     vl_logic;
        t_term          : in     vl_logic;
        t_abort         : in     vl_logic;
        frameni         : in     vl_logic;
        irdyni          : in     vl_logic;
        ltrdyno         : in     vl_logic;
        lstopno         : out    vl_logic;
        new_stopno      : out    vl_logic
    );
end pci_genstop;
