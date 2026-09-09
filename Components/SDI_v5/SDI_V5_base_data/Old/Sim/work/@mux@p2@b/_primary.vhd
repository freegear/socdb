library verilog;
use verilog.vl_types.all;
entity MuxP2B is
    port(
        PSELS0          : in     vl_logic;
        PSELS1          : in     vl_logic;
        PSELS2          : in     vl_logic;
        PSELS3          : in     vl_logic;
        PSELS4          : in     vl_logic;
        PSELS5          : in     vl_logic;
        PSELS6          : in     vl_logic;
        PSELS7          : in     vl_logic;
        PSELS8          : in     vl_logic;
        PSELS9          : in     vl_logic;
        PSELS10         : in     vl_logic;
        PSELS11         : in     vl_logic;
        PSELS12         : in     vl_logic;
        PSELS13         : in     vl_logic;
        PSELS14         : in     vl_logic;
        PSELS15         : in     vl_logic;
        PRDATAS0        : in     vl_logic_vector(31 downto 0);
        PRDATAS1        : in     vl_logic_vector(31 downto 0);
        PRDATAS2        : in     vl_logic_vector(31 downto 0);
        PRDATAS3        : in     vl_logic_vector(31 downto 0);
        PRDATAS4        : in     vl_logic_vector(31 downto 0);
        PRDATAS5        : in     vl_logic_vector(31 downto 0);
        PRDATAS6        : in     vl_logic_vector(31 downto 0);
        PRDATAS7        : in     vl_logic_vector(31 downto 0);
        PRDATAS8        : in     vl_logic_vector(31 downto 0);
        PRDATAS9        : in     vl_logic_vector(31 downto 0);
        PRDATAS10       : in     vl_logic_vector(31 downto 0);
        PRDATAS11       : in     vl_logic_vector(31 downto 0);
        PRDATAS12       : in     vl_logic_vector(31 downto 0);
        PRDATAS13       : in     vl_logic_vector(31 downto 0);
        PRDATAS14       : in     vl_logic_vector(31 downto 0);
        PRDATAS15       : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0)
    );
end MuxP2B;
