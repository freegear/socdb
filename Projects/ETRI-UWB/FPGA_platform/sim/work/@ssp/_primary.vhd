library verilog;
use verilog.vl_types.all;
entity Ssp is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PADDR           : in     vl_logic_vector(4 downto 2);
        PSEL            : in     vl_logic;
        PENABLE         : in     vl_logic;
        PWRITE          : in     vl_logic;
        PWDATA          : in     vl_logic_vector(15 downto 0);
        SSPINTR         : out    vl_logic;
        SSPRXD          : in     vl_logic;
        SSPFSSIN        : in     vl_logic;
        SSPCLKIN        : in     vl_logic;
        SSPFSSOUT       : out    vl_logic;
        SSPCLKOUT       : out    vl_logic;
        SSPTXD          : out    vl_logic;
        nSSPOE          : out    vl_logic;
        nSSPCTLOE       : out    vl_logic;
        PRDATA          : out    vl_logic_vector(31 downto 0);
        TxDMAReq        : out    vl_logic;
        RxDMAReq        : out    vl_logic
    );
end Ssp;
