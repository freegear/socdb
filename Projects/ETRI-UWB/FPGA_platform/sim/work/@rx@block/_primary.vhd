library verilog;
use verilog.vl_types.all;
entity RxBlock is
    generic(
        UART_FIFO_WIDTH : integer := 5;
        ST_IDLE         : integer := 1;
        ST_WAIT_STARTBIT: integer := 2;
        ST_DETECT_STARTBIT0: integer := 4;
        ST_DETECT_STARTBIT1: integer := 8;
        ST_DETECT_STARTBIT2: integer := 16;
        ST_GOOD_STARTBIT: integer := 32;
        ST_DATA0        : integer := 64;
        ST_DATA1        : integer := 128;
        ST_DATA2        : integer := 256;
        ST_DATA3        : integer := 512;
        ST_DATA4        : integer := 1024;
        ST_DATA5        : integer := 2048;
        ST_DATA6        : integer := 4096;
        ST_DATA7        : integer := 8192;
        ST_PARITY       : integer := 16384;
        ST_STOP0        : integer := 32768;
        ST_STOP1        : integer := 65536;
        ST_FIFOWRB      : integer := 131072;
        DELAY_TAPS      : integer := 6
    );
    port(
        baudx16clk      : in     vl_logic;
        clk             : in     vl_logic;
        databit         : in     vl_logic;
        fifordb         : in     vl_logic;
        loopbacken      : in     vl_logic;
        parity          : in     vl_logic_vector(1 downto 0);
        rstb            : in     vl_logic;
        rxd             : in     vl_logic;
        stopbit         : in     vl_logic;
        swrst           : in     vl_logic;
        txd             : in     vl_logic;
        uarten          : in     vl_logic;
        bytereceivedb   : out    vl_logic;
        fifodata_rx     : out    vl_logic_vector(7 downto 0);
        frameerror      : out    vl_logic;
        overrunerror    : out    vl_logic;
        parityerror     : out    vl_logic;
        rxbusy          : out    vl_logic;
        rxfifocnt       : out    vl_logic_vector;
        frameerr_clear  : in     vl_logic;
        parityerr_clear : in     vl_logic;
        overrunerr_clear: in     vl_logic
    );
end RxBlock;
