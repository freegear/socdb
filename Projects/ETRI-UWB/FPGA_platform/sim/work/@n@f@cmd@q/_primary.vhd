library verilog;
use verilog.vl_types.all;
entity NFCmdQ is
    generic(
        QSIZE           : integer := 8;
        DW              : integer := 32
    );
    port(
        Clk             : in     vl_logic;
        nRst            : in     vl_logic;
        NFCtrlRstIn     : in     vl_logic;
        QWrEnIn         : in     vl_logic;
        QRdEnIn         : in     vl_logic;
        QWrDataIn       : in     vl_logic_vector(31 downto 0);
        QRdDataOut      : out    vl_logic_vector(31 downto 0);
        QLevelOut       : out    vl_logic_vector(3 downto 0)
    );
end NFCmdQ;
