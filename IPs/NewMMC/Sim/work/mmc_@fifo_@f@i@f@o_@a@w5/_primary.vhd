library verilog;
use verilog.vl_types.all;
entity mmc_fifo_fifo_aw5 is
    port(
        clk             : in     vl_logic;
        nrst            : in     vl_logic;
        sdreset         : in     vl_logic;
        fifowrite       : in     vl_logic;
        fifowrdata      : in     vl_logic_vector(31 downto 0);
        fiforead        : in     vl_logic;
        fiforddata      : out    vl_logic_vector(31 downto 0);
        fifoflush       : in     vl_logic;
        fifofull        : out    vl_logic;
        fifohalffull    : out    vl_logic;
        fifohalfempty   : out    vl_logic;
        fifoalmostempty : out    vl_logic;
        fifoempty       : out    vl_logic;
        fiforeadempty   : out    vl_logic;
        datcnt          : out    vl_logic_vector(4 downto 0)
    );
end mmc_fifo_fifo_aw5;
