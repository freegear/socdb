library verilog;
use verilog.vl_types.all;
entity Uart4Ch is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(6 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        TXD             : out    vl_logic_vector(3 downto 0);
        RXD             : in     vl_logic_vector(3 downto 0);
        Interrupt       : out    vl_logic_vector(3 downto 0);
        RxDMAReq        : out    vl_logic_vector(3 downto 0);
        TxDMAReq        : out    vl_logic_vector(3 downto 0)
    );
end Uart4Ch;
