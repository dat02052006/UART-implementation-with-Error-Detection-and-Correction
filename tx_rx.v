module tx_rx (
  input clk_16x, reset, 
  input [7:0] tx_in,
  input tx_en,
  output tx_full,
  output [7:0] rx_out,
  input rx_en,
  output rx_empty, rx_full, rx_sec, rx_dec,
  output tx_out,
  input rx_in
);
  transmitter inst0 (
    .clk_16x(clk_16x),
    .reset(reset),
    .w_en(tx_en),
    .data_in(tx_in),
    .data_out(tx_out),
    .full(tx_full)
  );
  receiver inst1 (
    .clk_16x(clk_16x),
    .reset(reset),
    .data_in(rx_in),
    .data_out(rx_out),
    .error_sec(rx_sec),
    .error_dec(rx_dec),
    .r_en(rx_en),
    .empty(rx_empty),
    .full(rx_full)
  );
endmodule
