`timescale 1ns/1ps
module hamming_encoder_tb ();
  reg [7:0] data;
  wire [12:0] encoded_data;
  hamming_encoder uut (.d(data), .encoded_data(encoded_data));
  initial begin
    $monitor ("Input: %b | Encoded: %b", data, encoded_data);
    data = 8'haa;
    #10;
    data = 8'hbb;
    #10;
    data = 8'hcc;
    #10;
    $finish;
  end
endmodule
