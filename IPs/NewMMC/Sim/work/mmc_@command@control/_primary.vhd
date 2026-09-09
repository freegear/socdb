library verilog;
use verilog.vl_types.all;
entity mmc_commandcontrol is
    port(
        nrst            : in     vl_logic;
        sdreset         : in     vl_logic;
        pclk            : in     vl_logic;
        neg_ckpulse     : in     vl_logic;
        ckpulse         : in     vl_logic;
        cmdin           : in     vl_logic;
        cmdout          : out    vl_logic;
        inv_cmdout      : out    vl_logic;
        ncmden          : out    vl_logic;
        inv_ncmden      : out    vl_logic;
        sdicmdarg       : in     vl_logic_vector(31 downto 0);
        nocrcrsp        : in     vl_logic;
        longrsp         : in     vl_logic;
        waitrsp         : in     vl_logic;
        cmst            : in     vl_logic;
        cmstclr         : out    vl_logic;
        cmdindex        : in     vl_logic_vector(6 downto 0);
        rspcrcset       : out    vl_logic;
        cmdsentset      : out    vl_logic;
        cmdtoutset      : out    vl_logic;
        rspfinset       : out    vl_logic;
        cmdon           : out    vl_logic;
        rspindex        : out    vl_logic_vector(7 downto 0);
        response0       : out    vl_logic_vector(31 downto 0);
        response1       : out    vl_logic_vector(31 downto 0);
        response2       : out    vl_logic_vector(31 downto 0);
        response3       : out    vl_logic_vector(31 downto 0);
        cmdctrlidle     : out    vl_logic
    );
end mmc_commandcontrol;
