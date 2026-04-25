module oversampling_filter (
  input clk_16x, data_in, reset,
  input wire [3:0] tick,
  output voted_bit 
);
  reg s1=1'b1, s2=1'b1, s3=1'b1;   // lay 3 mau
  always @(posedge clk_16x or posedge reset) begin
    if (reset) begin
      s1 <= 1'b1;
      s2 <= 1'b1;
      s3 <= 1'b1;
    end
    else begin
      if (tick == 4'd7) s1 <= data_in;  // lay mau tick 7
      if (tick == 4'd8) s2 <= data_in;  // lay mau tick 8
      if (tick == 4'd9) s3 <= data_in;  // lay mau tick 9
    end 
  end 
  assign voted_bit = (s1 & s2) | (s1 & s3) | (s2 & s3); // vote 2/3
endmodule