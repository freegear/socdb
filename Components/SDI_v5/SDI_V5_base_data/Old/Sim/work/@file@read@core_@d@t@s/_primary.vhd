library verilog;
use verilog.vl_types.all;
entity FileReadCore_DTS is
    generic(
        InputFileName   : string  := "DTSD_Filestim.frd"
    );
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        MREADY          : in     vl_logic;
        MERROR          : in     vl_logic;
        MRDATA          : in     vl_logic_vector(31 downto 0);
        MTRANS          : out    vl_logic_vector(1 downto 0);
        MBURST          : out    vl_logic_vector(2 downto 0);
        MPROT           : out    vl_logic_vector(3 downto 0);
        MSIZE           : out    vl_logic_vector(2 downto 0);
        MWRITE          : out    vl_logic;
        MMASTLOCK       : out    vl_logic;
        MADDR           : out    vl_logic_vector(31 downto 0);
        MWDATA          : out    vl_logic_vector(31 downto 0)
    );
end FileReadCore_DTS;
