library verilog;
use verilog.vl_types.all;
entity y_lpf is
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        luma_offset     : in     vl_logic_vector(7 downto 0);
        luma_fsel       : in     vl_logic_vector(1 downto 0);
        data_in         : in     vl_logic_vector(9 downto 0);
        data_out        : out    vl_logic_vector(9 downto 0)
    );
end y_lpf;
