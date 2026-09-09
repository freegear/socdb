library verilog;
use verilog.vl_types.all;
entity UartTop is
    generic(
        UART_FIFO_CONFIG: integer := 3
    );
    port(
        PADDR           : in     vl_logic_vector(4 downto 2);
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PWRITE          : in     vl_logic;
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        rxd             : in     vl_logic;
        PRDATA          : out    vl_logic_vector(31 downto 0);
        int             : out    vl_logic;
        rxdmareq        : out    vl_logic;
        txd             : out    vl_logic;
        txdmareq        : out    vl_logic
    );
end UartTop;
