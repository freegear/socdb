library verilog;
use verilog.vl_types.all;
entity EEMIF is
    port(
        EIMDO           : in     vl_logic_vector(15 downto 0);
        EMCL            : in     vl_logic;
        TI              : in     vl_logic;
        XRST            : in     vl_logic;
        TE              : in     vl_logic;
        MCK             : in     vl_logic;
        EEMALE          : in     vl_logic;
        EEMADCR         : in     vl_logic;
        EEMDOLE         : in     vl_logic;
        EEMDI           : out    vl_logic_vector(15 downto 0);
        EEMA            : out    vl_logic_vector(15 downto 0);
        \TO\            : out    vl_logic
    );
end EEMIF;
