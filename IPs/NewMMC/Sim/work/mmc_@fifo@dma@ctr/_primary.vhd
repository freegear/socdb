library verilog;
use verilog.vl_types.all;
entity mmc_fifodmactr is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        sdreset         : in     vl_logic;
        frst            : in     vl_logic;
        datmode         : in     vl_logic_vector(1 downto 0);
        dmasize         : in     vl_logic_vector(5 downto 0);
        txactive        : in     vl_logic;
        txrdptrinc      : in     vl_logic;
        pwdata          : in     vl_logic_vector(31 downto 0);
        rxactive        : in     vl_logic;
        rxrdptrinc      : in     vl_logic;
        rxfwrdata       : in     vl_logic_vector(31 downto 0);
        rxwriteen       : in     vl_logic;
        txwriteen       : in     vl_logic;
        rxunderrun      : out    vl_logic;
        txoverrun       : out    vl_logic;
        tfdet           : out    vl_logic;
        tfhalf          : out    vl_logic;
        tfempty         : out    vl_logic;
        tfrempty        : out    vl_logic;
        rffull          : out    vl_logic;
        rfhalf          : out    vl_logic;
        rfdet           : out    vl_logic;
        ffcnt           : out    vl_logic_vector(4 downto 0);
        fiforddata      : out    vl_logic_vector(31 downto 0);
        endma           : in     vl_logic;
        dreq            : out    vl_logic
    );
end mmc_fifodmactr;
