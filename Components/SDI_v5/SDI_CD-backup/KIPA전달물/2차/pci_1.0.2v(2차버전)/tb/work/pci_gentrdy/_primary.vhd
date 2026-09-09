library verilog;
use verilog.vl_types.all;
entity pci_gentrdy is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        t_trdata        : in     vl_logic;
        t_drdy          : in     vl_logic;
        frameni         : in     vl_logic;
        irdyni          : in     vl_logic;
        lstopno         : in     vl_logic;
        ltrdyno         : out    vl_logic;
        new_trdyno      : out    vl_logic
    );
end pci_gentrdy;
