module Lab_5_1(a, b, sum, c_out); //HALF_ADDER_STRUCTURAL

input  a, b;
output sum, c_out;

xor u1(sum, a, b);
and u2(c_out, a, b);

endmodule

/*
module Lab_5_1(a, b, sum, c_out); //HALF_ADDER_DATAFLOW

input  a, b;
output sum, c_out;

assign sum = a ^ b;
assign c_out = a & b;

endmodule
*/

/*
module Lab_5_1(a, b, sum, c_out); // HALF_ADDER_BEHAVIORAL

input  a, b;
output reg sum, c_out;  // Declare as reg since they are assigned in an always block

always @(a or b)  // Always block triggered by changes in a or b
begin
  sum = a ^ b;    // XOR for sum
  c_out = a & b;  // AND for carry out
end

endmodule
*/
