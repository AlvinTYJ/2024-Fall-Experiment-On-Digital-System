`define TimeExpire 32'd2500
`define TimeExpire_KEY 32'd250000

// module keypad(clk,rst,keypadRow,keypadCol,keypadBuf);

// input clk,rst;
// input [3:0] keypadCol;
// output [3:0] keypadRow;


// reg [3:0] keypadRow;
// output reg [3:0] keypadBuf;

// keypadScanner kps (
// 	.clk(clk),
// 	.rst(rst),
// 	.keypadRow(keypadRow),
// 	.keypadCol(keypadCol),
// 	.keypadBuf(keypadBuf)
// );

// endmodule

module SevenDisplay(in, out);
	input [3:0] in;
	output [6:0] out;
	reg [6:0] out;

	always @(in) begin
		case (in)
			4'd0: out = 7'b1000000;
			4'd1: out = 7'b1111001;
			4'd2: out = 7'b0100100;
			4'd3: out = 7'b0110000;
			4'd4: out = 7'b0011001;
			4'd5: out = 7'b0010010;
			4'd6: out = 7'b0000010;
			4'd7: out = 7'b1111000;
			4'd8: out = 7'b0000000;
			4'd9: out = 7'b0010000;
			4'd10: out = 7'b0001000;
			4'd11: out = 7'b0000011;
			4'd12: out = 7'b1000110;
			4'd13: out = 7'b0100001;
			4'd14: out = 7'b0000110;
			default: out = 7'b0001110;
		endcase
	end
endmodule

// module LFSR_with_delay (
//     input clk,               // 时钟信号
//     input rst,               // 复位信号
//     output reg [7:0] lfsr    // 8位 LFSR 输出
// );
//     // 计数器用于延迟操作
//     reg [31:0] counter;      // 用于计数到 500,000 (32位计数器可以覆盖 0 到 500,000 的范围)

//     // 8位 LFSR 的反馈多项式，假设使用 x^8 + x^6 + x^5 + x^4 + x^2 + x + 1
//     wire feedback;

//     // 计算反馈值：根据多项式 x^8 + x^6 + x^5 + x^4 + x^2 + x + 1
//     assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3] ^ lfsr[1] ^ lfsr[0];

//     always @(posedge clk or negedge rst) begin
//         if (!rst) begin
//             lfsr <= 8'b11111111;  // 初始化 LFSR
//             counter <= 32'd0;     // 初始化计数器
//         end else begin
//             if (counter == 32'd50000000) begin
//                 // 计数器到达 50,000,000 时更新 LFSR
//                 lfsr <= {lfsr[6:0], feedback};  // LFSR 更新，反馈位加入到最低位
//                 counter <= 32'd0;  // 重置计数器
//             end else begin
//                 // 否则继续计数
//                 counter <= counter + 1;
//             end
//         end
//     end
// endmodule



module dadishu(clk, rst, rand_signal, keypadBuf, dot_row, dot_col_hit, dot_col, out);
	input clk, rst;
	input [3:0] keypadBuf;
	input [3:0] rand_signal;// wire [7:0] rand_signal;
	output [7:0] dot_row;
	output [7:0] dot_col_hit;
	output [7:0] dot_col;
	output [6:0] out;
	reg [3:0] mole_position;

	// LFSR_with_delay hvhvhk(.clk(clk), .rst(rst), .lfsr(rand_signal)); // 连接LFSR模块
	SevenDisplay display(.in(mole_position), .out(out)); // 显示当前 mole_position
	// keypad k(.clk(clk), .rst(rst), .keypadCol(keypadCol), .keypadRow(keypadRow), .keypadBuf(keypadBuf));
	 
	reg [7:0] dot_col_hit;
	reg [7:0] dot_row;
	reg [7:0] dot_col;
	reg [2:0] row_count;
	reg [31:0] clk_count;

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			dot_row <= 8'b0;
			dot_col <= 8'b0;
			row_count <= 3'd0;
			clk_count <= 32'd0;
			mole_position <= 4'b0000;  // 初始化 mole_position
		end else begin
			if (clk_count == `TimeExpire) begin
				clk_count <= 32'd0;
				row_count <= row_count + 3'd1;
				mole_position <= rand_signal[3:0]; // 更新 mole_position
				if (keypadBuf == mole_position) begin
					case (row_count)
						3'd0: dot_row <= 8'b01111111;
						3'd1: dot_row <= 8'b10111111;
						3'd2: dot_row <= 8'b11011111;
						3'd3: dot_row <= 8'b11101111;
						3'd4: dot_row <= 8'b11110111;
						3'd5: dot_row <= 8'b11111011;
						3'd6: dot_row <= 8'b11111101;
						3'd7: dot_row <= 8'b11111110;
					endcase
					dot_col <= 8'd0;
					case (row_count)
						3'd0: dot_col_hit <= 8'b00000000;
						3'd1: dot_col_hit <= 8'b00100100;
						3'd2: dot_col_hit <= 8'b00100100;
						3'd3: dot_col_hit <= 8'b00100100;
						3'd4: dot_col_hit <= 8'b01000010;
						3'd5: dot_col_hit <= 8'b00100100;
						3'd6: dot_col_hit <= 8'b00011000;
						3'd7: dot_col_hit <= 8'b00000000;
					endcase
					//加分......
				end else begin
					case (row_count)
						3'd0: dot_row <= 8'b01111111;
						3'd1: dot_row <= 8'b10111111;
						3'd2: dot_row <= 8'b11011111;
						3'd3: dot_row <= 8'b11101111;
						3'd4: dot_row <= 8'b11110111;
						3'd5: dot_row <= 8'b11111011;
						3'd6: dot_row <= 8'b11111101;
						3'd7: dot_row <= 8'b11111110;
					endcase
					// Use the random_num for selecting the case
					case (mole_position)  // Randomly select between 0 to 15 (for the hex digits)
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
					dot_col_hit <= 8'd0;
				end
			end else begin
				clk_count <= clk_count + 32'd1;
			end
		end
	end
endmodule
