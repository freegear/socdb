library verilog;
use verilog.vl_types.all;
entity c_lpf is
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        chroma_fsel     : in     vl_logic_vector(1 downto 0);
        coring_cont     : in     vl_logic_vector(1 downto 0);
        chroma_offset   : in     vl_logic_vector(7 downto 0);
        data_in         : in     vl_logic_vector(9 downto 0);
        data_out        : out    vl_logic_vector(9 downto 0)
    );
end c_lpf;
