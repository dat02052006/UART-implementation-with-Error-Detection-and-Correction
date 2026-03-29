library verilog;
use verilog.vl_types.all;
entity receiver is
    port(
        clk_16x         : in     vl_logic;
        reset           : in     vl_logic;
        data_in         : in     vl_logic;
        ready           : out    vl_logic;
        error_sec       : out    vl_logic;
        error_dec       : out    vl_logic;
        data_out        : out    vl_logic_vector(7 downto 0)
    );
end receiver;
