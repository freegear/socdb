library verilog;
use verilog.vl_types.all;
entity dma64wrfifo is
    generic(
        mid_thr         : integer := 8;
        ae_limit        : integer := 1;
        af_limit        : integer := 13;
        tf_limit        : integer := 14;
        mid_limit       : integer := 8;
        c_0x1           : integer := 1;
        c_0x2           : integer := 2
    );
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        rd              : in     vl_logic;
        wr              : in     vl_logic;
        flush           : in     vl_logic;
        undo            : in     vl_logic;
        din             : in     vl_logic_vector(63 downto 0);
        ae              : out    vl_logic;
        te              : out    vl_logic;
        af              : out    vl_logic;
        tf              : out    vl_logic;
        mid             : out    vl_logic;
        dout            : out    vl_logic_vector(63 downto 0)
    );
end dma64wrfifo;
