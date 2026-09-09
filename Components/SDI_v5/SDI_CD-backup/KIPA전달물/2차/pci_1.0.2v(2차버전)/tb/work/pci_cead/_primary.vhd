library verilog;
use verilog.vl_types.all;
entity pci_cead is
    port(
        irdy            : in     vl_logic;
        trdy            : in     vl_logic;
        dir_ceo         : in     vl_logic;
        t_ce_rdyn       : in     vl_logic;
        m_ce_rdyn       : in     vl_logic;
        pci_ce          : out    vl_logic
    );
end pci_cead;
