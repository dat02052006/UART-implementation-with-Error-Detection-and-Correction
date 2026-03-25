module oversampling_filer (
  input clk_16x, data_in, reset,
  input wire [3:0] tick,
  output voted_bit 
);
  reg s1, s2, s3;
  always @(posedge clk_16x or posedge reset) begin
    if (reset) begin
      s1 <= 1'b1;
      s2 <= 1'b1;
      s3 <= 1'b1;
    end
    else begin
      if (tick == 4'd7) s1 <= data_in;
      if (tick == 4'd8) s2 <= data_in;
      if (tick == 4'd9) s3 <= data_in;
    end 
  end 
  assign voted_bit = (s1 & s2) | (s1 & s3) | (s2 & s3);
endmodule