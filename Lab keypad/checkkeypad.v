`define TimeExpire 32'd2500
`define TimeExpire_KEY 32'd250000

module checkkeypad(clk,rst,keypadRow,keypadCol,dot_row,dot_col);

input clk,rst;
input [3:0] keypadCol;
output [3:0] keypadRow;
output [7:0] dot_row;
output [7:0] dot_col;

reg [3:0] keypadRow;
reg [3:0] keypadBuf;
reg [31:0] keypadDelay;

always@(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		keypadRow<=4'b1110;
		keypadBuf<=4'b0000;
		keypadDelay<=32'd0;
	end
	else
	begin
		if(keypadDelay == `TimeExpire_KEY)
		begin
			keypadDelay<=32'd0;
			case({keypadRow,keypadCol})
				8'b1110_1110 : keypadBuf<= 4'h7;
				8'b1110_1101 : keypadBuf<= 4'h4;
				8'b1110_1011 : keypadBuf<= 4'h1;
				8'b1110_0111 : keypadBuf<= 4'h0;
				8'b1101_1110 : keypadBuf<= 4'h8;
				8'b1101_1101 : keypadBuf<= 4'h5;
				8'b1101_1011 : keypadBuf<= 4'h2;
				8'b1101_0111 : keypadBuf<= 4'ha;
				8'b1011_1110 : keypadBuf<= 4'h9;
				8'b1011_1101 : keypadBuf<= 4'h6;
				8'b1011_1011 : keypadBuf<= 4'h3;
				8'b1011_0111 : keypadBuf<= 4'hb;
				8'b0111_1110 : keypadBuf<= 4'hc;
				8'b0111_1101 : keypadBuf<= 4'hd;
				8'b0111_1011 : keypadBuf<= 4'he;
				8'b0111_0111 : keypadBuf<= 4'hf;
				default : keypadBuf<= keypadBuf;
			endcase
			case(keypadRow)
				4'b1110 : keypadRow <= 4'b1101;
				4'b1101 : keypadRow <= 4'b1011;
				4'b1011 : keypadRow <= 4'b0111;
				4'b0111 : keypadRow <= 4'b1110;
			endcase
		end
		else
			keypadDelay <= keypadDelay + 32'd1;
	end
end

reg [7:0] dot_row;
reg [7:0] dot_col;
reg [2:0] row_count;
reg [31:0] clk_count;

always@(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		dot_row<=8'b0;
		dot_col<=8'b0;
		row_count<=3'd0;
		clk_count<=32'd0;
	end
	else
	begin
		if(clk_count == `TimeExpire)
		begin
			clk_count<=32'd0;
			row_count<=row_count+3'd1;
			case(row_count)
				3'd0: dot_row<=8'b01111111;
				3'd1: dot_row<=8'b10111111;
				3'd2: dot_row<=8'b11011111;
				3'd3: dot_row<=8'b11101111;
				3'd4: dot_row<=8'b11110111;
				3'd5: dot_row<=8'b11111011;
				3'd6: dot_row<=8'b11111101;
				3'd7: dot_row<=8'b11111110;
			endcase
			
			case(keypadBuf)
			4'h0:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000000;
					3'd1: dot_col<=8'b00000000;
					3'd2: dot_col<=8'b00000000;
					3'd3: dot_col<=8'b00000000;
					3'd4: dot_col<=8'b00000000;
					3'd5: dot_col<=8'b00000000;
					3'd6: dot_col<=8'b11000000;
					3'd7: dot_col<=8'b11000000;
				endcase
			end
			4'h1:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000000;
					3'd1: dot_col<=8'b00000000;
					3'd2: dot_col<=8'b00000000;
					3'd3: dot_col<=8'b00000000;
					3'd4: dot_col<=8'b00000000;
					3'd5: dot_col<=8'b00000000;
					3'd6: dot_col<=8'b00110000;
					3'd7: dot_col<=8'b00110000;
				endcase
			end
			4'h2:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000000;
					3'd1: dot_col<=8'b00000000;
					3'd2: dot_col<=8'b00000000;
					3'd3: dot_col<=8'b00000000;
					3'd4: dot_col<=8'b00110000;
					3'd5: dot_col<=8'b00110000;
					3'd6: dot_col<=8'b00000000;
					3'd7: dot_col<=8'b00000000;
				endcase
			end
			4'h3:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000000;
					3'd1: dot_col<=8'b00000000;
					3'd2: dot_col<=8'b00110000;
					3'd3: dot_col<=8'b00110000;
					3'd4: dot_col<=8'b00000000;
					3'd5: dot_col<=8'b00000000;
					3'd6: dot_col<=8'b00000000;
					3'd7: dot_col<=8'b00000000;
				endcase
			end
			4'h4:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000000;
					3'd1: dot_col<=8'b00000000;
					3'd2: dot_col<=8'b00000000;
					3'd3: dot_col<=8'b00000000;
					3'd4: dot_col<=8'b00000000;
					3'd5: dot_col<=8'b00000000;
					3'd6: dot_col<=8'b00001100;
					3'd7: dot_col<=8'b00001100;
				endcase
			end
			4'h5:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000000;
					3'd1: dot_col<=8'b00000000;
					3'd2: dot_col<=8'b00000000;
					3'd3: dot_col<=8'b00000000;
					3'd4: dot_col<=8'b00001100;
					3'd5: dot_col<=8'b00001100;
					3'd6: dot_col<=8'b00000000;
					3'd7: dot_col<=8'b00000000;
				endcase
			end
			4'h6:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000000;
					3'd1: dot_col<=8'b00000000;
					3'd2: dot_col<=8'b00001100;
					3'd3: dot_col<=8'b00001100;
					3'd4: dot_col<=8'b00000000;
					3'd5: dot_col<=8'b00000000;
					3'd6: dot_col<=8'b00000000;
					3'd7: dot_col<=8'b00000000;
				endcase
			end
			4'h7:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000000;
					3'd1: dot_col<=8'b00000000;
					3'd2: dot_col<=8'b00000000;
					3'd3: dot_col<=8'b00000000;
					3'd4: dot_col<=8'b00000000;
					3'd5: dot_col<=8'b00000000;
					3'd6: dot_col<=8'b00000011;
					3'd7: dot_col<=8'b00000011;
				endcase
			end
			4'h8:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000000;
					3'd1: dot_col<=8'b00000000;
					3'd2: dot_col<=8'b00000000;
					3'd3: dot_col<=8'b00000000;
					3'd4: dot_col<=8'b00000011;
					3'd5: dot_col<=8'b00000011;
					3'd6: dot_col<=8'b00000000;
					3'd7: dot_col<=8'b00000000;
				endcase
			end
			4'h9:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000000;
					3'd1: dot_col<=8'b00000000;
					3'd2: dot_col<=8'b00000011;
					3'd3: dot_col<=8'b00000011;
					3'd4: dot_col<=8'b00000000;
					3'd5: dot_col<=8'b00000000;
					3'd6: dot_col<=8'b00000000;
					3'd7: dot_col<=8'b00000000;
				endcase
			end
			4'ha:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000000;
					3'd1: dot_col<=8'b00000000;
					3'd2: dot_col<=8'b00000000;
					3'd3: dot_col<=8'b00000000;
					3'd4: dot_col<=8'b11000000;
					3'd5: dot_col<=8'b11000000;
					3'd6: dot_col<=8'b00000000;
					3'd7: dot_col<=8'b00000000;
				endcase
			end
			4'hb:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000000;
					3'd1: dot_col<=8'b00000000;
					3'd2: dot_col<=8'b11000000;
					3'd3: dot_col<=8'b11000000;
					3'd4: dot_col<=8'b00000000;
					3'd5: dot_col<=8'b00000000;
					3'd6: dot_col<=8'b00000000;
					3'd7: dot_col<=8'b00000000;
				endcase
			end
			4'hc:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00000011;
					3'd1: dot_col<=8'b00000011;
					3'd2: dot_col<=8'b00000000;
					3'd3: dot_col<=8'b00000000;
					3'd4: dot_col<=8'b00000000;
					3'd5: dot_col<=8'b00000000;
					3'd6: dot_col<=8'b00000000;
					3'd7: dot_col<=8'b00000000;
				endcase
			end
			4'hd:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00001100;
					3'd1: dot_col<=8'b00001100;
					3'd2: dot_col<=8'b00000000;
					3'd3: dot_col<=8'b00000000;
					3'd4: dot_col<=8'b00000000;
					3'd5: dot_col<=8'b00000000;
					3'd6: dot_col<=8'b00000000;
					3'd7: dot_col<=8'b00000000;
				endcase
			end
			4'he:
			begin
				case(row_count)
					3'd0: dot_col<=8'b00110000;
					3'd1: dot_col<=8'b00110000;
					3'd2: dot_col<=8'b00000000;
					3'd3: dot_col<=8'b00000000;
					3'd4: dot_col<=8'b00000000;
					3'd5: dot_col<=8'b00000000;
					3'd6: dot_col<=8'b00000000;
					3'd7: dot_col<=8'b00000000;
				endcase
			end
			4'hf:
			begin
				case(row_count)
					3'd0: dot_col<=8'b11000000;
					3'd1: dot_col<=8'b11000000;
					3'd2: dot_col<=8'b00000000;
					3'd3: dot_col<=8'b00000000;
					3'd4: dot_col<=8'b00000000;
					3'd5: dot_col<=8'b00000000;
					3'd6: dot_col<=8'b00000000;
					3'd7: dot_col<=8'b00000000;
				endcase
			end
			endcase
		end
		else
		begin
			clk_count<=clk_count+32'd1;
		end
	end
end

endmodule
