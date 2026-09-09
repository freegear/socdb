library verilog;
use verilog.vl_types.all;
entity RegBlk is
    generic(
        MAX_FIFO_DEPTH  : integer := 2
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
        frameerrorb     : in     vl_logic;
        overrunerrorb   : in     vl_logic;
        parityerrorb    : in     vl_logic;
        rstb            : in     vl_logic;
        rxbusyb         : in     vl_logic;
        rxfifocnt       : in     vl_logic_vector(5 downto 0);
        txbusyb         : in     vl_logic;
        txfifo_emptyb   : in     vl_logic;
        txfifo_fillb    : in     vl_logic;
        txfifo_fullb    : in     vl_logic;
        txfifocnt       : in     vl_logic_vector(5 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        baudx16clk      : out    vl_logic;
        databit         : out    vl_logic;
        fifodata_tx     : out    vl_logic_vector(7 downto 0);
        fifordb         : out    vl_logic;
        fifowrb         : out    vl_logic;
        intb            : out    vl_logic;
        loopbackenb     : out    vl_logic;
        parity          : out    vl_logic_vector(1 downto 0);
        rxdmareqb       : out    vl_logic;
        stopbit         : out    vl_logic;
        swrstb          : out    vl_logic;
        txdmareqb       : out    vl_logic;
        uartenb         : out    vl_logic
    );
end RegBlk;
