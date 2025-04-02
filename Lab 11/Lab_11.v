module Lab_11(
    input clock,
    input reset,
    output [6:0] out,
	 output [7:0] dot_row,
    output [7:0] dot_col
);
    wire clk_div1;
	 wire clk_div2;
    wire [3:0] count;
	 wire [1:0] light;

    FreqDiv u_FreqDiv (
        .clk(clock),
        .rst(reset),
        .clk_div1(clk_div1),
        .clk_div2(clk_div2)
    );

    counter u_counter (
        .clk_div(clk_div1),
        .rst(reset),
        .count(count),
		  .light(light)
    );

    SevenDisplay u_display (
        .in(count),
        .out(out)
    );
	 
	 dotMatrixDisplay DotMatrixDisplay ( 
        .clk_div(clk_div2),
        .rst(reset),
		  .light(light),
        .dot_row(dot_row),
        .dot_col(dot_col)
    );
endmodule

module FreqDiv(
    input clk, rst,
    output reg clk_div1,
    output reg clk_div2
);
    reg [31:0] count1;
    reg [15:0] count2;
    parameter TimeExpire1 = 32'd25000000;
    parameter TimeExpire2 = 16'd2500;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count1 <= 32'd0;
            count2 <= 16'd0;
            clk_div1 <= 1'b0;
            clk_div2 <= 1'b0;
        end else begin
            // Clock Divider 1 Logic
            if (count1 == TimeExpire1) begin
                count1 <= 32'd0;
                clk_div1 <= ~clk_div1;
            end else begin
                count1 <= count1 + 32'd1;
            end
            
            // Clock Divider 2 Logic
            if (count2 == TimeExpire2) begin
                count2 <= 16'd0;
                clk_div2 <= ~clk_div2;
            end else begin
                count2 <= count2 + 16'd1;
            end
        end
    end
endmodule

module counter(
    input clk_div, rst,
    output reg [3:0] count,
	 output reg [1:0] light
);
    always @(posedge clk_div or negedge rst) begin
        if (!rst) begin
            light <= 2'd0;
            count <= 4'd10;
        end
		  else
		  begin
            if (count == 4'd0)
				begin
                case (light)
                    2'd0:
						  begin
                        light <= 2'd1;
                        count <= 4'd3;
                    end
                    2'd1:
						  begin
                        light <= 2'd2;
                        count <= 4'd15;
                    end
                    2'd2:
						  begin
                        light <= 2'd0;
                        count <= 4'd10;
                    end
                endcase
            end
				else
				begin
                count <= count - 4'd1;
            end
        end
    end
endmodule

module SevenDisplay(
    input [3:0] in,
    output reg [6:0] out
);
    always @(*) begin
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
            4'd15: out = 7'b0001110;
            default: out = 7'b1111111;
        endcase
    end
endmodule

module dotMatrixDisplay(
    input clk_div, rst,
    input [1:0] light,
    output reg [7:0] dot_row,
    output reg [7:0] dot_col
);
    reg [2:0] row_count;

    always @(posedge clk_div or negedge rst) begin
        if (~rst) begin
            row_count <= 3'd0;
            dot_row <= 8'b0;
            dot_col <= 8'b0;
        end else begin
            row_count <= row_count + 1;

            case (row_count)
                3'd0: dot_row <= 8'b01111111;
                3'd1: dot_row <= 8'b10111111;
                3'd2: dot_row <= 8'b11011111;
                3'd3: dot_row <= 8'b11101111;
                3'd4: dot_row <= 8'b11110111;
                3'd5: dot_row <= 8'b11111011;
                3'd6: dot_row <= 8'b11111101;
                3'd7: dot_row <= 8'b11111110;
					 default: dot_row <= 8'b11111111;
            endcase

            case (light)
                2'd0:
					 begin // Green Light Stage
                    case (row_count)
                        3'd0: dot_col <= 8'b00001100;
                        3'd1: dot_col <= 8'b00001100;
                        3'd2: dot_col <= 8'b00011001;
                        3'd3: dot_col <= 8'b01111110;
                        3'd4: dot_col <= 8'b10011000;
                        3'd5: dot_col <= 8'b00011000;
                        3'd6: dot_col <= 8'b00101000;
                        3'd7: dot_col <= 8'b01001000;
								default: dot_col <= 8'b00000000;
                    endcase
                end
                2'd1:
					 begin // Yellow Light Stage
                    case (row_count)
                        3'd0: dot_col <= 8'b00000000;
                        3'd1: dot_col <= 8'b00100100;
                        3'd2: dot_col <= 8'b00111100;
                        3'd3: dot_col <= 8'b10111101;
                        3'd4: dot_col <= 8'b11111111;
                        3'd5: dot_col <= 8'b00111100;
                        3'd6: dot_col <= 8'b00111100;
                        3'd7: dot_col <= 8'b00000000;
								default: dot_col <= 8'b00000000;
                    endcase
                end
                2'd2:
					 begin // Red Light Stage
                    case (row_count)
                        3'd0: dot_col <= 8'b00011000;
                        3'd1: dot_col <= 8'b00011000;
                        3'd2: dot_col <= 8'b00111100;
                        3'd3: dot_col <= 8'b00111100;
                        3'd4: dot_col <= 8'b01011010;
                        3'd5: dot_col <= 8'b00011000;
                        3'd6: dot_col <= 8'b00011000;
                        3'd7: dot_col <= 8'b00100100;
								default: dot_col <= 8'b00000000;
                    endcase
                end
            endcase
        end
    end
endmodule