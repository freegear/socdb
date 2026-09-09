library verilog;
use verilog.vl_types.all;
entity FE08RB is
    port(
        D               : in     vl_logic_vector(7 downto 0);
        TI              : in     vl_logic;
        EN              : in     vl_logic;
        CK              : in     vl_logic;
        TE              : in     vl_logic;
        RN              : in     vl_logic;
        Q0              : out    vl_logic;
        Q1              : out    vl_logic;
        Q2              : out    vl_logic;
        Q3              : out    vl_logic;
        Q4              : out    vl_logic;
        Q5              : out    vl_logic;
        Q6              : out    vl_logic;
        Q7              : out    vl_logic
    );
end FE08RB;
