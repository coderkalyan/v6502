`default_nettype none

module cpu (
    input wire i_clk,
    input wire i_rst_n,
    output wire [15:0] o_addr,  // address bus output
    output wire [7:0] o_data,   // data bus output
);
    wire [15:0] pc;
    pc_control pc_control (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_inc(),
        .i_load_addr(),
        .i_load_en(),
        .o_pc(pc)
    );

    reg [7:0] index_x, index_y;
    reg [7:0] acc;

    always @(posedge i_clk, negedge i_rst_n) begin
        if (!i_rst_n) begin
            index_x <= 8'h00;
            index_y <= 8'h00;
            acc <= 8'h00;
        end else begin
        end
    end

    alu alu (
        .i_op_a(alu_op_a),
        .i_op_b(alu_op_b),
        .i_cin(),
        .i_op_sel(alu_op_sel),
        .i_bool_op(alu_bool_op),
        .i_sub(),
        .i_dec(),
        .o_result(alu_result),
        .o_cout()
    );
endmodule
