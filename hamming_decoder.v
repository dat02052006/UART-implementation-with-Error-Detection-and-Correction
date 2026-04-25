module hamming_decoder (
  input [12:0] data_in,
  output reg [7:0] data_out,
  output error_sec, error_ded
);
  wire [3:0] s;
  wire s_total;
  // frame p0, p1, d0, p2, d1, d2, d3, p3, d4, d5, d6, d7, p_total 
  // p0: d0, d1, d3, d4, d6
  // p1: d0, d2, d3, d5, d6
  // p2: d1, d2, d3, d7
  // p3: d4, d5, d6, d7
  assign s[0] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10];
  assign s[1] = data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[10];
  assign s[2] = data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[11];
  assign s[3] = data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11];
  assign s_total = ^data_in;
  wire [7:0] raw_d;
  assign raw_d = {data_in[11:8], data_in[6:4], data_in[2]}; // ghep 8 bit d
  always @(*) begin
    data_out = raw_d;   // mac dinh ko co loi
    case (s)
      4'd3: data_out[0] = ~raw_d[0];    // sua d0
      4'd5: data_out[1] = ~raw_d[1];    // sua d1
      4'd6: data_out[2] = ~raw_d[2];    // sua d2
      4'd7: data_out[3] = ~raw_d[3];    // sua d3
      4'd9: data_out[4] = ~raw_d[4];    // sua d4
      4'd10: data_out[5] = ~raw_d[5];   // sua d5
      4'd11: data_out[6] = ~raw_d[6];   // sua d6
      4'd12: data_out[7] = ~raw_d[7];   // sua d7
      default: data_out = raw_d;
    endcase
  end
  assign error_sec = (s != 4'd0) && (s_total == 1'b1);
  assign error_ded = (s != 4'd0) && (s_total == 1'b0);
endmodule