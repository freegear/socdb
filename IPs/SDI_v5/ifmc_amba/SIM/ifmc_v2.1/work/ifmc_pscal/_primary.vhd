library verilog;
use verilog.vl_types.all;
entity ifmc_pscal is
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        cnt_rst         : in     vl_logic;
        cnt_value       : in     vl_logic_vector(6 downto 0);
        pscal_clk       : out    vl_logic
    );
end ifmc_pscal;
