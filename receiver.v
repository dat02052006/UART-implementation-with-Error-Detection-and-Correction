module receiver (
  input clk_16x, reset, data_in, r_en,
  output error_sec, error_dec, empty, full,
  output [7:0] data_out
);
  wire [12:0] rx_frame;
  wire rx_ready;
  wire [7:0] encoded;
  rx_fsm inst0 (
    .clk_16x(clk_16x),
    .reset(reset),
    .data_in(data_in),
    .rx_frame(rx_frame),
    .ready(rx_ready)
  );
  hamming_decoder inst1 (
    .data_in(rx_frame),
    .data_out(encoded),
    .error_sec(error_sec),
    .error_dec(error_dec)
  );
  queue inst2 (
    .clk(clk_16x),
    .rs(reset),
    .w_en(rx_ready),
    .r_en(r_en),
    .in(encoded),
    .out(data_out),
    .full(full),
    .empty(empty)
  );
endmodule
