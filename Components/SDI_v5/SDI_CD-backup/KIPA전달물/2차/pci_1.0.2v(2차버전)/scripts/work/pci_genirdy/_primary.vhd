library verilog;
use verilog.vl_types.all;
entity pci_genirdy is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        m_drdy          : in     vl_logic;
        abort_timeout   : in     vl_logic;
        trdyni          : in     vl_logic;
        stopni          : in     vl_logic;
        lframeno        : in     vl_logic;
        lirdyno         : out    vl_logic;
        new_irdyno      : out    vl_logic
    );
end pci_genirdy;
