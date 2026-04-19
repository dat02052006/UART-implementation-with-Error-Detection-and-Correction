`timescale 1ns/1ps
module hamming_decoder_tb ();
  reg [12:0] data;
  wire [7:0] decoded_data;
  wire sec, dec;
  hamming_decoder uut (.data_in(data), .data_out(decoded_data), .error_sec(sec), .error_dec(dec));
  initial begin
    $monitor ("Input: %b | Output: %b | sec: %b | dec: %b", data, decoded_data, sec, dec );
    data = 13'b0000000000000;
    #10;
    data = 13'b0111101110111;
    #10;
    data = 13'b1010100101111;
    #10;
    $finish;
  end
endmodule