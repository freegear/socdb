library verilog;
use verilog.vl_types.all;
entity nfssptxljustify is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        dsspclk         : in     vl_logic_vector(3 downto 0);
        txfrddata       : in     vl_logic_vector(15 downto 0);
        ms              : in     vl_logic;
        txfrddatain     : out    vl_logic_vector(15 downto 0)
    );
end nfssptxljustify;
