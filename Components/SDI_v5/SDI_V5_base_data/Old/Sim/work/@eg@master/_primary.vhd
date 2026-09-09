library verilog;
use verilog.vl_types.all;
entity EgMaster is
    generic(
        EBMenable       : integer := 1;
        EBMreadAddr     : integer := 208;
        EBMwriteAddr    : integer := 196;
        EBMinitCount    : integer := 4
    );
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HRDATA          : in     vl_logic_vector(31 downto 0);
        HREADY          : in     vl_logic;
        HRESP           : in     vl_logic_vector(1 downto 0);
        HGRANT          : in     vl_logic;
        HADDR           : out    vl_logic_vector(31 downto 0);
        HTRANS          : out    vl_logic_vector(1 downto 0);
        HWRITE          : out    vl_logic;
        HSIZE           : out    vl_logic_vector(2 downto 0);
        HBURST          : out    vl_logic_vector(2 downto 0);
        HPROT           : out    vl_logic_vector(3 downto 0);
        HWDATA          : out    vl_logic_vector(31 downto 0);
        HBUSREQ         : out    vl_logic;
        HLOCK           : out    vl_logic;
        SCANENABLE      : in     vl_logic;
        SCANINHCLK      : in     vl_logic;
        SCANOUTHCLK     : out    vl_logic
    );
end EgMaster;
