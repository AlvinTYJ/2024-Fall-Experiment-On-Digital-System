module Lab_5_2(a, b, c_in, sum, c_out); // FULL_ADDER_STRUCTURAL

input  a, b, c_in;
output sum, c_out;
wire [2:0] TEMP;

xor u1(TEMP[0], a, b);
xor u2(sum, TEMP[0], c_in);
  
and u3(TEMP[1], a, b);
and u4(TEMP[2], TEMP[0], c_in);
or u5(c_out, TEMP[1], TEMP[2]);

endmodule

/*
module Lab_5_2(a, b, c_in, sum, c_out); //FULL_ADDER_DATAFLOW

input  a, b, c_in;
output sum, c_out;

assign sum = a ^ b ^ c_in;
assign c_out = (a & b) | ((a ^ b) & c_in);

endmodule
*/

/*
module Lab_5_2(a, b, c_in, sum, c_out); // FULL_ADDER_BEHAVIORAL

input  a, b, c_in;
output reg sum, c_out;

always @(a or b or c_in)
begin
  sum = a ^ b ^ c_in;
  c_out = (a & b) | ((a ^ b) & c_in);
end

endmodule
*/