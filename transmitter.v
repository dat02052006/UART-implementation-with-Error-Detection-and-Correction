module Emitter (
  input [7:0] d,
  output [12:0] encoded_data
);
  wire [3:0] p;
  wire p_total;
  assign encoded_data = {p_total, d[7:4], p[3], d[3:1], p[2], d[0], p[1:0]};
  assign p[0] = d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[6];
  assign p[1] = d[0] ^ d[2] ^ d[3] ^ d[5] ^ d[6];
  assign p[2] = d[1] ^ d[2] ^ d[3] ^ d[7];
  assign p[3] = d[4] ^ d[5] ^ d[6] ^ d[7];
  assign p_total = ^encoded_data[11:0];
endmodule 
