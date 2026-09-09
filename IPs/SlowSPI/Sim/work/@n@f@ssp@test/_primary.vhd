library verilog;
use verilog.vl_types.all;
entity nfssptest is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        lbm             : in     vl_logic;
        ssprxd          : in     vl_logic;
        intr            : in     vl_logic;
        fssout          : in     vl_logic;
        clkout          : in     vl_logic;
        txd             : in     vl_logic;
        nctloe          : in     vl_logic;
        noe             : in     vl_logic;
        intssprxd       : out    vl_logic;
        intsspintr      : out    vl_logic;
        intsspfssout    : out    vl_logic;
        intsspclkout    : out    vl_logic;
        intssptxd       : out    vl_logic;
        intnsspctloe    : out    vl_logic;
        intnsspoe       : out    vl_logic
    );
end nfssptest;
