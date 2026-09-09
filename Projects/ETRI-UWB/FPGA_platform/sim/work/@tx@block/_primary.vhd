library verilog;
use verilog.vl_types.all;
entity TxBlock is
    generic(
        UART_FIFO_WIDTH : integer := 5;
        ST_IDLE         : integer := 1;
        ST_LOADDATA     : integer := 2;
        ST_WAITTXCLK    : integer := 4;
        ST_START        : integer := 8;
        ST_DATA0        : integer := 16;
        ST_DATA1        : integer := 32;
        ST_DATA2        : integer := 64;
        ST_DATA3        : integer := 128;
        ST_DATA4        : integer := 256;
        ST_DATA5        : integer := 512;
        ST_DATA6        : integer := 1024;
        ST_DATA7        : integer := 2048;
        ST_PARITYBIT    : integer := 4096;
        ST_STOP0        : integer := 8192;
        ST_STOP1        : integer := 16384;
        TXO_IDLE        : integer := 1;
        TXO_START       : integer := 2;
        TXO_DATA        : integer := 4;
        TXO_PARITY      : integer := 8
    );
    port(
        baudx16clk      : in     vl_logic;
        clk             : in     vl_logic;
        databit         : in     vl_logic;
        fifodata_tx     : in     vl_logic_vector(7 downto 0);
        fifowrb         : in     vl_logic;
        parity          : in     vl_logic_vector(1 downto 0);
        rstb            : in     vl_logic;
        stopbit         : in     vl_logic;
        swrst           : in     vl_logic;
        uarten          : in     vl_logic;
        txbusy          : out    vl_logic;
        txd             : out    vl_logic;
        txfifo_emptyb   : out    vl_logic;
        txfifo_fillb    : out    vl_logic;
        txfifo_fullb    : out    vl_logic;
        txfifocnt       : out    vl_logic_vector
    );
end TxBlock;
