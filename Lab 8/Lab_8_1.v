module Lab_8_1(
    input clock,
    input reset,
    input Up_Down,
    output [6:0] out
);
    wire clk_div;
    wire [3:0] count;

    clk_div u_FreqDiv (
        .clk(clock),
        .rst(reset),
        .div_clk(clk_div)
    );

    counter u_counter (
        .clk(clk_div),
        .rst(reset),
        .Up_Down(Up_Down),
        .count(count)
    );

    SevenDisplay u_display (
        .in(count),
        .out(out)
    );
endmodule

module clk_div(
    input clk, rst,
    output reg div_clk
);
    reg [31:0] count;
    parameter TimeExpire = 32'd25000000;

    always @(posedge clk or negedge rst)
	 begin
        if (!rst)
		  begin
            count <= 32'd0;
            div_clk <= 1'b0;
        end
		  else
		  begin
		      if (count == TimeExpire)
				begin
                count <= 32'd0;
                div_clk <= ~div_clk;  // Toggle to create 1 Hz clock
            end
		      else
		      begin
                count <= count + 32'd1;
            end
		  end
    end
endmodule

module counter(
    input clk, rst, Up_Down,
    output reg [3:0] count
);
    always @(posedge clk or negedge rst) begin
        if (!rst)
            count <= 4'd0;
        else
		  begin
		      if (Up_Down)
                count <= count + 1'b1;  // Counting up
            else
                count <= count - 1'b1;  // Counting down
		  end
    end
endmodule

module SevenDisplay(
    input [3:0] in,
    output reg [6:0] out
);
    always @(*) begin
        case (in)
            4'd0: out = 7'b1000000;  // Display 0
            4'd1: out = 7'b1111001;  // Display 1
            4'd2: out = 7'b0100100;  // Display 2
            4'd3: out = 7'b0110000;  // Display 3
            4'd4: out = 7'b0011001;  // Display 4
            4'd5: out = 7'b0010010;  // Display 5
            4'd6: out = 7'b0000010;  // Display 6
            4'd7: out = 7'b1111000;  // Display 7
            4'd8: out = 7'b0000000;  // Display 8
            4'd9: out = 7'b0010000;  // Display 9
            4'd10: out = 7'b0001000; // Display A
            4'd11: out = 7'b0000011; // Display b
            4'd12: out = 7'b1000110; // Display C
            4'd13: out = 7'b0100001; // Display d
            4'd14: out = 7'b0000110; // Display E
            4'd15: out = 7'b0001110; // Display F
            default: out = 7'b1111111; // Turn off display
        endcase
    end
endmodule
