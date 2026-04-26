module uart_top (
  input clk, reset,
  input [2:0] baud_rate_sel,
  input [7:0] send_data,
  input send, receive,
  output [7:0] receive_data,
  input rx_pin,                     // bit nhan
  output tx_pin,                    // bit gui
  output rx_sec, rx_ded,
  output tx_full, rx_full, tx_empty, rx_empty
);
  wire clk_16x;
  baudrate_generator inst0 (
    .clk(clk),
    .reset(reset),
    .baud_rate_sel(baud_rate_sel),
    .clk_16x(clk_16x)
  );
  transmitter inst1 (
    .clk_16x(clk_16x),
    .reset(reset),
    .w_en(send),
    .data_in(send_data),
    .data_out(tx_pin),
    .full(tx_full),
    .empty(tx_empty)
  );
  receiver inst2 (
    .clk_16x(clk_16x),
    .reset(reset),
    .r_en(receive),
    .data_in(rx_pin),
    .data_out(receive_data),
    .full(rx_full),
    .empty(rx_empty),
    .error_sec(rx_sec),
    .error_ded(rx_ded)
  );
endmodule
