module uart_top (
  input clk, reset,
  input [7:0] send_data,
  input send,
  output [7:0] receive_data,
  input rx_pin,
  output tx_pin,
  output rx_sec, rx_ded,
  output tx_full, rx_full
);
  wire clk_16x;
  baudrate_generator inst0 (
    .clk(clk),
    .reset(reset),
    .clk_16x(clk_16x)
  );
  tx_rx inst1 (
    .clk_16x(clk_16x),
    .reset(reset),
    .tx_in(send_data),
    .tx_en(send),
    .rx_en(1'b1),
    .rx_out(receive_data),
    .tx_out(tx_pin),
    .rx_in(rx_pin),
    .tx_full(tx_full),
    .rx_full(rx_full),
    .rx_sec(rx_sec),
    .rx_ded(rx_ded)
  );
endmodule
