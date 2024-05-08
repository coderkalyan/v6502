`default_nettype none

module pc_control (
    input wire i_clk,
    input wire i_rst_n,
    input wire i_inc,
    input wire [15:0] i_load_addr,
    input wire i_load_en,
    output wire [15:0] o_pc
);
    reg [15:0] pc;

    always @(posedge i_clk, negedge i_rst_n) begin
        if (!i_rst_n)
            pc <= 16'h0000;
        else if (i_load_en)
            pc <= i_load_addr;
        else
            pc <= pc + i_inc;
    end

    assign o_pc = pc;
endmodule
