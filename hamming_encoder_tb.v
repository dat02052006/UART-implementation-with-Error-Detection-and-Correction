`timescale 1ns/1ps
module hamming_encoder_tb ();
  reg [7:0] data;
  wire [12:0] encoded_data;
  hamming_encoder uut (.d(data), .encoded_data(encoded_data));
  initial begin
    $monitor ("Input: %b | Encoded: %b", data, encoded_data);
    data = 8'b00000000;
    #10;
    data = 8'b11111111;
    #10;
    data = 8'b01010101;
    #10;
    data = 8'b11100101;
    $finish;
  end
endmodule
