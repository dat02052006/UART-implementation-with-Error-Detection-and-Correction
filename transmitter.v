module transmitter (
  input clk_16x, reset, w_en, 
  input [7:0] data_in,
  output data_out, full, empty
);
  wire done;
  wire [7:0] fifo_out;
  wire [12:0] encoder_out;
  reg tx_ready;
  always @(posedge clk_16x or posedge reset) begin
    if (reset) 
      tx_ready <= 1'b0;
    else if (done) 
      tx_ready <= 1'b0; 
    else if (!empty) 
      tx_ready <= 1'b1; 
  end
  wire fifo_read = (!empty) && (!tx_ready);
  queue inst0 (
    .clk(clk_16x), 
    .rs(reset),
    .w_en(w_en), 
    .r_en(fifo_read), 
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
    .tx_start(tx_ready),
    .data_in(encoder_out),
    .data_out(data_out),
    .done(done)
  );
endmodule