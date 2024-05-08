`default_nettype none

`define ALU_OP_ADD 2'h0
`define ALU_OP_BOOL 2'h1
`define ALU_OP_SHIFT 2'h2

module alu (
    input wire [7:0] i_op_a,
    input wire [7:0] i_op_b,
    input wire i_cin,
    input wire [1:0] i_op_sel,
    input wire [1:0] i_bool_op,
    input wire i_sub,
    input wire i_dec,
    output reg [7:0] o_result,
    output wire o_cout
);
    /*
    * 00 a xor b
    * 01 0
    * 10 a or b
    * 11 a and b
    */
    wire [7:0] bool_result = ((i_op_a ^ i_op_b) & {8{~i_bool_op[0]}}) | (i_op_a & i_op_b & {8{i_bool_op[1]}});
    wire [7:0] srl_result = {1'b0, i_op_a[7:1]};

    wire [7:0] add_result;
    assign {o_cout, add_result} = i_op_a + (i_op_b ^ 8{i_sub}) + i_cin;

    always @(*) begin
        o_result = 8'bxx;

        case (i_op_sel)
            `ALU_OP_ADD: o_result = add_result;
            `ALU_OP_BOOL: o_result = bool_result;
            `ALU_OP_SHIFT: o_result = srl_result;
        endcase
    end
endmodule
