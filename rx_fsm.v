module rx_fsm (
  input clk_16x, reset, data_in,
  output [12:0] rx_frame,
  output ready
);
  reg [3:0] tick_counter, bit_counter;
  wire voted_bit;
  oversampling_filter inst0 (
    .clk_16x(clk_16x),
    .reset(reset),
    .data_in(data_in),
    .tick(tick_counter),
    .voted_bit(voted_bit)
  );
  parameter idle=2'b00, start=2'b01, data=2'b10, stop=2'b11;
  reg [1:0] state, next_state;
  reg [12:0] shift_reg;
  always @(posedge clk_16x or posedge reset) begin
    if (reset) shift_reg <= 13'd0;
    else if (state == data && tick_counter == 4'd15) shift_reg <= {voted_bit, shift_reg[12:1]};
  end
  always @(*) begin
    case (state)
      idle: next_state = (!data_in) ? start : idle;
      start: begin
        if (tick_counter == 4'd7) next_state = (!voted_bit) ? data : idle;
        else next_state = start;
      end
      data: begin
        if (tick_counter == 4'd15) next_state = (bit_counter == 4'd12) ? stop : data;
        else next_state = data;
      end
      stop: next_state = (tick_counter == 4'd15) ? idle : stop;
    endcase
  end
  always @(posedge clk_16x) begin
    if (reset) begin
      state <= idle;
      tick_counter <= 4'd0;
      bit_counter <= 4'd0;
    end
    else begin
      state <= next_state;
      tick_counter <= (state == idle) ? 4'd0 : tick_counter + 1;
      if (state == idle) bit_counter <= 4'd0;
      else if (state == data && tick_counter == 4'd15) bit_counter <= bit_counter + 1;
    end
  end
  assign ready = (state == stop) ? 1 : 0;
  assign rx_frame = shift_reg;
endmodule
