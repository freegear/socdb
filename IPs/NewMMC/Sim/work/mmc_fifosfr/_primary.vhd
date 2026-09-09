library verilog;
use verilog.vl_types.all;
entity mmc_fifosfr is
    port(
        mresetn         : in     vl_logic;
        hclk            : in     vl_logic;
        hwdata          : in     vl_logic_vector(31 downto 0);
        hsfr00wr        : in     vl_logic
    );
end mmc_fifosfr;
