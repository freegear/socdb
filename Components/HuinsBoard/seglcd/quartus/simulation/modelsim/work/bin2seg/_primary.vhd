library verilog;
use verilog.vl_types.all;
entity bin2seg is
    port(
        clk             : in     vl_logic;
        bin_data        : in     vl_logic_vector(3 downto 0);
        seg_data        : out    vl_logic_vector(7 downto 0)
    );
end bin2seg;
