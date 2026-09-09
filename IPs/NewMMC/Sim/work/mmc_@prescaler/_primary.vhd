library verilog;
use verilog.vl_types.all;
entity mmc_prescaler is
    port(
        pclk            : in     vl_logic;
        nrst            : in     vl_logic;
        sdreset         : in     vl_logic;
        sdipre          : in     vl_logic_vector(7 downto 0);
        enclk           : in     vl_logic;
        mmc_clk         : out    vl_logic;
        neg_ckpulse     : out    vl_logic;
        ckpulse         : out    vl_logic
    );
end mmc_prescaler;
