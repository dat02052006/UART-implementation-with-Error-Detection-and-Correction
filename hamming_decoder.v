module hamming_decoder (
  input [12:0] data_in,
  output reg [7:0] data_out,
  output error_sec, error_dec
);
  wire [3:0] s;
  wire s_total;
  assign s[0] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10];
  assign s[1] = data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[10];
  assign s[2] = data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[11];
  assign s[3] = data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11];
  assign s_total = ^data_in;
  wire [7:0] raw_d;
  assign raw_d = {data_in[11:8], data_in[6:4], data_in[2]};
  always @(*) begin
    data_out = raw_d;
    case (s)
      4'd3: data_out[0] = ~raw_d[0];
      4'd5: data_out[1] = ~raw_d[1];
      4'd6: data_out[2] = ~raw_d[2];
      4'd7: data_out[3] = ~raw_d[3];
      4'd9: data_out[4] = ~raw_d[4];
      4'd10: data_out[5] = ~raw_d[5];
      4'd11: data_out[6] = ~raw_d[6];
      4'd12: data_out[7] = ~raw_d[7];
      default: data_out = raw_d;
    endcase
  end
  assign error_sec = (s != 4'd0) && (s_total == 1'b1);
  assign error_dec = (s != 4'd0) && (s_total == 1'b0);
endmodule