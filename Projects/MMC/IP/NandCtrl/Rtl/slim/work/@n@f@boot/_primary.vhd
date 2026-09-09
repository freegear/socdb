library verilog;
use verilog.vl_types.all;
entity NFBoot is
    generic(
        RDCMD1          : integer := 0;
        RDCMD2          : integer := 48
    );
    port(
        Clk             : in     vl_logic;
        nRst            : in     vl_logic;
        NFBootIn        : in     vl_logic;
        IOWidthIn       : in     vl_logic;
        NandWidthIn     : in     vl_logic;
        BootCfgIn       : in     vl_logic_vector(1 downto 0);
        BootOpRdEnIn    : in     vl_logic;
        BootOpReadyOut  : out    vl_logic;
        BootOpOut       : out    vl_logic_vector(31 downto 0);
        BootEndOut      : out    vl_logic
    );
end NFBoot;
