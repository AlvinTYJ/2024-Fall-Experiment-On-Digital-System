module Lab_9_1(
    input clock,
    input reset,
    input In,
    output [6:0] out
);
    wire clk_div;

    clk_div FreqDiv (
        .clk(clock),
        .rst(reset),
        .div_clk(clk_div)
    );

    moore_machine Moore_machine (
        .clk(clk_div),
        .rst(reset),
        .In(In),
        .out(out)
    );
endmodule

module clk_div(
    input clk, rst,
    output reg div_clk
);
    reg [31:0] count;
    parameter TimeExpire = 32'd25000000;

    always @(posedge clk or negedge rst) begin
        if (!rst)
		  begin
            count <= 32'd0;
            div_clk <= 1'b0;
        end
		  else
		  begin
            if (count == TimeExpire) begin
                count <= 32'd0;
                div_clk <= ~div_clk;
            end
	         else
	         begin
                count <= count + 32'd1;
            end
        end
    end
endmodule

module moore_machine(
    input clk, rst, In,
    output reg [6:0] out
);
    reg [2:0] state;
    parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4, S5 = 3'd5;

    always @(posedge clk or negedge rst) begin
        if (!rst)
		  begin
            state <= S0;
        end
		  else
		  begin
            case (state)
                S0: if (!In) state <= S1; else state <= S3;
                S1: if (!In) state <= S2; else state <= S5;
                S2: if (!In) state <= S3; else state <= S0;
                S3: if (!In) state <= S4; else state <= S1;
                S4: if (!In) state <= S5; else state <= S2;
                S5: if (!In) state <= S0; else state <= S4;
                default: state <= S0;
            endcase
        end
    end

    always @(*) begin
        case (state)
            S0: out = 7'b1000000;  // Display 0
            S1: out = 7'b1111001;  // Display 1
            S2: out = 7'b0100100;  // Display 2
            S3: out = 7'b0110000;  // Display 3
            S4: out = 7'b0011001;  // Display 4
            S5: out = 7'b0010010;  // Display 5
            default: out = 7'b1111111;
        endcase
    end
endmodule
