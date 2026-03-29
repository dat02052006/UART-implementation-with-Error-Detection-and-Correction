module receiver (
  input clk_16x, reset, data_in,
  output ready, error_sec, error_dec,
  output [7:0] data_out
);
  wire [12:0] wire1;
  rx_fsm inst0 (
    .clk_16x(clk_16x),
    .reset(reset),
    .data_in(data_in),
    .rx_frame(wire1),
    .ready(ready)
  );
  hamming_decoder inst1 (
    .data_in(wire1),
    .data_out(data_out),
    .error_sec(error_sec),
    .error_dec(error_dec)
  );
endmodule
