module transmitter (
  input clk_16x, reset, w_en, 
  input [7:0] data_in,
  output data_out, full
);
  wire empty, done;
  wire [7:0] fifo_out;
  wire [12:0] encoder_out;
  queue inst0 (
    .clk(clk_16x), 
    .rs(reset),
    .w_en(w_en), 
    .r_en(done), 
    .in(data_in), 
    .out(fifo_out), 
    .full(full), 
    .empty(empty)
  );
  hamming_encoder inst1 (
    .d(fifo_out),
    .encoded_data(encoder_out)
  );
  tx_fsm inst2 (
    .clk_16x(clk_16x),
    .reset(reset),
    .tx_start(~empty),
    .data_in(encoder_out),
    .data_out(data_out),
    .done(done)
  );
endmodule