library verilog;
use verilog.vl_types.all;
entity EccErrDetect is
    port(
        Clk             : in     vl_logic;
        nRst            : in     vl_logic;
        EccbCalc        : in     vl_logic;
        MEccLastLoc     : in     vl_logic;
        SEccLastLoc     : in     vl_logic;
        RdDataEnIn      : in     vl_logic;
        RdDataIn        : in     vl_logic_vector(15 downto 0);
        MEccReg_L       : in     vl_logic_vector(23 downto 0);
        MEccReg_H       : in     vl_logic_vector(23 downto 0);
        SEccReg_L       : in     vl_logic_vector(15 downto 0);
        SEccReg_H       : in     vl_logic_vector(15 downto 0);
        NandWidthIn     : in     vl_logic;
        Ecc512EnIn      : in     vl_logic;
        PageSizeIn      : in     vl_logic;
        MErrStatus_L    : out    vl_logic_vector(1 downto 0);
        MErrStatus_H    : out    vl_logic_vector(1 downto 0);
        SErrStatus_L    : out    vl_logic_vector(1 downto 0);
        SErrStatus_H    : out    vl_logic_vector(1 downto 0);
        MErrValid       : out    vl_logic;
        Two8BitNand     : in     vl_logic;
        SErrValid       : out    vl_logic
    );
end EccErrDetect;
