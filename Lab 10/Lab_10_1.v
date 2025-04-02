module Lab_10_1( 
    input clock,
    input reset,
    output [7:0] dot_row,
    output [7:0] dot_col
);
    wire clk_div;

    freqDiv FreqDiv (
        .clk(clock),
        .rst(reset),
        .div_clk(clk_div)
    );

    dotMatrixDisplay DotMatrixDisplay ( 
        .clk(clk_div),
        .rst(reset),
        .dot_row(dot_row),
        .dot_col(dot_col)
    );
endmodule

module freqDiv(
    input clk, rst,
    output reg div_clk
);
    reg [15:0] count;
    parameter TimeExpire = 16'd2500;

    always @(posedge clk or negedge rst)
	 begin
        if (!rst)
		  begin
            count <= 16'd0;
            div_clk <= 1'b0;
        end
		  else
		  begin
            if (count == TimeExpire)
				begin
                count <= 16'd0;
                div_clk <= ~div_clk;
            end
	         else
	         begin
                count <= count + 16'd1;
            end
        end
    end
endmodule

module dotMatrixDisplay(
    input clk, rst,
    output reg [7:0] dot_row,
    output reg [7:0] dot_col
);
    reg [2:0] row_count;

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            row_count <= 3'd0;
            dot_row <= 8'b0;
            dot_col <= 8'b0;
        end
		  else begin
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
            endcase

            case (row_count)
                3'd0: dot_col <= 8'b00011000;
                3'd1: dot_col <= 8'b00100100;
                3'd2: dot_col <= 8'b01000010;
                3'd3: dot_col <= 8'b11000011;
                3'd4: dot_col <= 8'b01000010;
                3'd5: dot_col <= 8'b01000010;
                3'd6: dot_col <= 8'b01000010;
                3'd7: dot_col <= 8'b01111110;
            endcase
        end
    end
endmodule
