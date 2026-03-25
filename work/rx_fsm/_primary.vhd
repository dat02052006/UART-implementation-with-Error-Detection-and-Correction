library verilog;
use verilog.vl_types.all;
entity rx_fsm is
    generic(
        idle            : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        start           : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        data            : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        stop            : vl_logic_vector(0 to 1) := (Hi1, Hi1)
    );
    port(
        clk_16x         : in     vl_logic;
        reset           : in     vl_logic;
        data_in         : in     vl_logic;
        rx_frame        : out    vl_logic_vector(12 downto 0);
        ready           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of idle : constant is 1;
    attribute mti_svvh_generic_type of start : constant is 1;
    attribute mti_svvh_generic_type of data : constant is 1;
    attribute mti_svvh_generic_type of stop : constant is 1;
end rx_fsm;
