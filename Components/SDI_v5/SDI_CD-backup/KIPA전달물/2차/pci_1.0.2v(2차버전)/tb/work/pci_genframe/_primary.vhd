library verilog;
use verilog.vl_types.all;
entity pci_genframe is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        m_busreq        : in     vl_logic;
        m_drdy          : in     vl_logic;
        last_tx         : in     vl_logic;
        lirdyno         : in     vl_logic;
        abort_timeout   : in     vl_logic;
        gntni           : in     vl_logic;
        framenid        : in     vl_logic;
        irdynid         : in     vl_logic;
        devselni        : in     vl_logic;
        trdyni          : in     vl_logic;
        stopni          : in     vl_logic;
        lframeno        : out    vl_logic;
        ce_frameno      : out    vl_logic;
        new_frameno     : out    vl_logic
    );
end pci_genframe;
