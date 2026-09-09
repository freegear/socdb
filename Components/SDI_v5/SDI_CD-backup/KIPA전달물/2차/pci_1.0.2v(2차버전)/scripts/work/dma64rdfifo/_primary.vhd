library verilog;
use verilog.vl_types.all;
entity dma64rdfifo is
    generic(
        mid_thr         : integer := 8;
        aae_limit       : integer := 1;
        aaf_limit       : integer := 12;
        atf_limit       : integer := 13;
        maxptr          : integer := 15;
        minptr          : integer := 0
    );
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        rd              : in     vl_logic;
        wrl             : in     vl_logic;
        wrh             : in     vl_logic;
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
end dma64rdfifo;
