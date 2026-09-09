library verilog;
use verilog.vl_types.all;
entity seven_seg is
    port(
        clk             : in     vl_logic;
        data            : in     vl_logic_vector(31 downto 0);
        reset_n         : in     vl_logic;
        enable_n        : in     vl_logic;
        address         : in     vl_logic_vector(9 downto 2);
        seg_data        : out    vl_logic_vector(31 downto 0);
        seg_out1        : out    vl_logic_vector(7 downto 0);
        seg_out2        : out    vl_logic_vector(7 downto 0);
        seg_gnd1        : out    vl_logic_vector(2 downto 0);
        seg_gnd2        : out    vl_logic_vector(2 downto 0);
        cnt3            : out    vl_logic_vector(1 downto 0)
    );
end seven_seg;
