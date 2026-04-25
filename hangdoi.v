module queue #(
  parameter data_width = 8, addr_width = 4
)( 
  input wire clk,rs,w_en,r_en,
  input wire [data_width-1:0] in,
  output reg [data_width-1:0] out,
  output full,empty
);
  localparam depth = 1 << addr_width;
  reg [data_width-1:0] ram [0:depth-1];
  reg [addr_width-1:0] w_ptr,r_ptr;
  reg [addr_width:0] count;
    
always @(posedge clk)
  begin
    if (w_en && !full) 
    ram[w_ptr] <= in;
  end
always @(posedge clk or posedge rs)
  begin
    if (rs) 
       out <= {data_width{1'b0}};
    else if (r_en && !empty)
            out <= ram[r_ptr];
  end
always @(posedge clk or posedge rs) 
  begin
    if (rs) 
      begin
        w_ptr <= 0;
        r_ptr <= 0;
        count <= 0;
      end 
    else 
      begin
        case ({w_en && !full, r_en && !empty})
            2'b01: 
            begin 
              r_ptr <= r_ptr+1;
              count  <= count-1;
            end
            2'b10: 
            begin 
              w_ptr <= w_ptr+1;
              count  <= count+1;
            end
            2'b11: 
            begin 
              w_ptr <= w_ptr+1;
              r_ptr <= r_ptr+1;
            end
            default: ;
        endcase
       end
   end
  assign empty = (!count)?1:0;
  assign full = (count == depth)?1:0;
endmodule
