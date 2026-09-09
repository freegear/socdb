library verilog;
use verilog.vl_types.all;
entity I2S_Top is
    generic(
        I2S_RFIFO_DEPTH : integer := 5;
        I2S_TFIFO_DEPTH : integer := 5
    );
    port(
        SYS_CLK         : in     vl_logic;
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(3 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        Interrupt       : out    vl_logic;
        TxDMAReq        : out    vl_logic;
        RxDMAReq        : out    vl_logic;
        MCLK            : out    vl_logic;
        MCLK_OE         : out    vl_logic;
        BCLK_O          : out    vl_logic;
        BCLK_I          : in     vl_logic;
        BCLK_OE         : out    vl_logic;
        LRCLK_O         : out    vl_logic;
        LRCLK_I         : in     vl_logic;
        LRCLK_OE        : out    vl_logic;
        SDIN            : in     vl_logic;
        SDOUT           : out    vl_logic
    );
end I2S_Top;
