library verilog;
use verilog.vl_types.all;
entity nfssp is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        paddr           : in     vl_logic_vector(4 downto 2);
        psel            : in     vl_logic;
        penable         : in     vl_logic;
        pwrite          : in     vl_logic;
        pwdata          : in     vl_logic_vector(15 downto 0);
        sspintr         : out    vl_logic;
        ssprxd          : in     vl_logic;
        sspfssin        : in     vl_logic;
        sspclkin        : in     vl_logic;
        sspfssout       : out    vl_logic;
        sspclkout       : out    vl_logic;
        ssptxd          : out    vl_logic;
        nsspoe          : out    vl_logic;
        nsspctloe       : out    vl_logic;
        prdata          : out    vl_logic_vector(31 downto 0)
    );
end nfssp;
