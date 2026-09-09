library verilog;
use verilog.vl_types.all;
entity mmc_feedbacksync is
    port(
        nrst            : in     vl_logic;
        sdreset         : in     vl_logic;
        mmc_fbclk       : in     vl_logic;
        mmc_cmdin       : in     vl_logic;
        mmc_datin       : in     vl_logic_vector(7 downto 0);
        cmdin           : out    vl_logic;
        datin           : out    vl_logic_vector(7 downto 0)
    );
end mmc_feedbacksync;
