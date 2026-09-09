library verilog;
use verilog.vl_types.all;
entity NFEcc16 is
    port(
        Clk             : in     vl_logic;
        nRst            : in     vl_logic;
        DCntIn          : in     vl_logic_vector(7 downto 0);
        EccRstIn        : in     vl_logic;
        EccEnIn         : in     vl_logic;
        Ecc512EnIn      : in     vl_logic;
        EccDataIn       : in     vl_logic_vector(15 downto 0);
        EccInitIn       : in     vl_logic;
        MainEccOut      : out    vl_logic_vector(23 downto 0);
        SpareEccOut     : out    vl_logic_vector(9 downto 0)
    );
end NFEcc16;
