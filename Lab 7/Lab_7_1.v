module Lab_7_1 (
    input [3:0] in,
    output reg [6:0] out
);

always @(*) begin
    if (in == 4'b0000)
        out = 7'b1000000;    //input 0
    else if (in == 4'b0001)
        out = 7'b1111001;    //input 1
    else if (in == 4'b0010)
        out = 7'b0100100;    //input 2
    else if (in == 4'b0011)
        out = 7'b1111000;    //input 3 (3 * 2 + 1 = 7)
    else if (in == 4'b0100)
        out = 7'b0010000;    //input 4 (4 * 2 + 1 = 9)
    else if (in == 4'b0101)
        out = 7'b0000011;    //input 5 (5 * 2 + 1 = 11)
    else if (in == 4'b0110)
        out = 7'b0000011;    //input 6 (6 * 2 - 1 = 11)
    else if (in == 4'b0111)
        out = 7'b0100001;    //input 7 (7 * 2 - 1 = 13)
    else if (in == 4'b1000)
        out = 7'b0001110;    //input 8 (8 * 2 - 1 = 15)
    else
        out = 7'b1000000;
end

endmodule
