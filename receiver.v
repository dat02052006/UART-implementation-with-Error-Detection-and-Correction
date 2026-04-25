module receiver (
  input clk_16x, reset, data_in, r_en,
  output error_sec, error_ded, empty, full,
  output [7:0] data_out
);
  wire [12:0] rx_frame;
  wire rx_ready;
  wire [7:0] decoded;
  wire raw_sec, raw_ded;
  reg reg_sec, reg_ded;
  rx_fsm inst0 (
    .clk_16x(clk_16x),
    .reset(reset),
    .data_in(data_in),
    .rx_frame(rx_frame),
    .ready(rx_ready)
  );
  hamming_decoder inst1 (
    .data_in(rx_frame),
    .data_out(decoded),
    .error_sec(raw_sec),
    .error_ded(raw_ded)
  );
  queue inst2 (
    .clk(clk_16x),
    .rs(reset),
    .w_en(rx_ready),
    .r_en(r_en),
    .in(decoded),
    .out(data_out),
    .full(full),
    .empty(empty)
  );
  always @(posedge clk_16x or posedge reset) begin
    if (reset) begin
      reg_sec <= 1'b0;
      reg_ded <= 1'b0;
    end
    else if (rx_ready) begin
      reg_sec <= raw_sec;
      reg_ded <= raw_ded;
    end
  end
  assign error_sec = reg_sec;
  assign error_ded = reg_ded;
endmodule
