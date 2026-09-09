library verilog;
use verilog.vl_types.all;
entity filereadcore is
    generic(
        inputfilename   : string  := "filestim.frd"
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        mready          : in     vl_logic;
        merror          : in     vl_logic;
        mrdata          : in     vl_logic_vector(31 downto 0);
        mtrans          : out    vl_logic_vector(1 downto 0);
        mburst          : out    vl_logic_vector(2 downto 0);
        mprot           : out    vl_logic_vector(3 downto 0);
        msize           : out    vl_logic_vector(2 downto 0);
        mwrite          : out    vl_logic;
        mmastlock       : out    vl_logic;
        maddr           : out    vl_logic_vector(31 downto 0);
        mwdata          : out    vl_logic_vector(31 downto 0)
    );
end filereadcore;
