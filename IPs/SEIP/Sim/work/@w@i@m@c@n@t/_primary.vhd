library verilog;
use verilog.vl_types.all;
entity WIMCNT is
    port(
        WDB             : in     vl_logic_vector(15 downto 0);
        PMD             : in     vl_logic_vector(15 downto 0);
        WIMEA           : in     vl_logic_vector(8 downto 0);
        PMA             : in     vl_logic_vector(8 downto 0);
        WIMWE           : in     vl_logic;
        ENP             : in     vl_logic;
        WWREQ           : in     vl_logic;
        WSCST           : in     vl_logic;
        WPWEN           : in     vl_logic;
        WIMA            : out    vl_logic_vector(8 downto 0);
        WIMI            : out    vl_logic_vector(15 downto 0);
        XWIMWE          : out    vl_logic;
        WWRDY           : out    vl_logic
    );
end WIMCNT;
