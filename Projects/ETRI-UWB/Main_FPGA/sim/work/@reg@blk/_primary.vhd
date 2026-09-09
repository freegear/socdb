library verilog;
use verilog.vl_types.all;
entity RegBlk is
    generic(
        UART_FIFO_CONFIG: integer := 3
    );
    port(
        PADDR           : in     vl_logic_vector(4 downto 2);
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PWRITE          : in     vl_logic;
        bytereceivedb   : in     vl_logic;
        clk             : in     vl_logic;
        fifodata_rx     : in     vl_logic_vector(7 downto 0);
        frameerror      : in     vl_logic;
        overrunerror    : in     vl_logic;
        parityerror     : in     vl_logic;
        rstb            : in     vl_logic;
        rxbusy          : in     vl_logic;
        rxfifocnt       : in     vl_logic_vector;
        txbusy          : in     vl_logic;
        txfifo_emptyb   : in     vl_logic;
        txfifo_fillb    : in     vl_logic;
        txfifo_fullb    : in     vl_logic;
        txfifocnt       : in     vl_logic_vector;
        PRDATA          : out    vl_logic_vector(31 downto 0);
        baudx16clk      : out    vl_logic;
        databit         : out    vl_logic;
        fifodata_tx     : out    vl_logic_vector(7 downto 0);
        fifordb         : out    vl_logic;
        fifowrb         : out    vl_logic;
        int             : out    vl_logic;
        loopbacken      : out    vl_logic;
        parity          : out    vl_logic_vector(1 downto 0);
        rxdmareq        : out    vl_logic;
        stopbit         : out    vl_logic;
        swrst           : out    vl_logic;
        txdmareq        : out    vl_logic;
        uarten          : out    vl_logic;
        frameerr_clear  : out    vl_logic;
        parityerr_clear : out    vl_logic;
        overrunerr_clear: out    vl_logic
    );
end RegBlk;
