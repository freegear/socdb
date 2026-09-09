library verilog;
use verilog.vl_types.all;
entity pci_genreq64 is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        m_areq64        : in     vl_logic;
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
        lreq64no        : out    vl_logic;
        ce_req64no      : out    vl_logic;
        new_req64no     : out    vl_logic
    );
end pci_genreq64;
