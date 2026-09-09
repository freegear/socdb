library verilog;
use verilog.vl_types.all;
entity ERXD is
    port(
        SPCO            : in     vl_logic_vector(19 downto 0);
        RXD             : in     vl_logic_vector(31 downto 0);
        TI              : in     vl_logic;
        MCK             : in     vl_logic;
        SIEXS           : in     vl_logic;
        XRST            : in     vl_logic;
        TE              : in     vl_logic;
        LRSEL           : in     vl_logic;
        RXEN            : in     vl_logic;
        ESYNC           : in     vl_logic;
        RXWE            : in     vl_logic;
        EXTI            : out    vl_logic_vector(19 downto 0);
        RXSYNC          : out    vl_logic;
        RXRDY           : out    vl_logic;
        \TO\            : out    vl_logic
    );
end ERXD;
