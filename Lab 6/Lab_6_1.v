module Lab_6_1 (
    input [3:0] a,
    input [3:0] b,
    input select,
    output [3:0] sum,
    output carry,
    output overflow
);

wire [3:0] b_sel;
assign b_sel = select ? ~b + 1 : b;
reg [4:0] sum_reg;

always @(*) begin
    sum_reg = a + b_sel;
end

assign sum = sum_reg[3:0];
assign carry = sum_reg[4];
assign overflow = (select == 0) ? carry : (a < b);

endmodule