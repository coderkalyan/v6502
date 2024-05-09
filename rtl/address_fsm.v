`default_nettype none

`define ADDR_MODE_IMM    3'h0    // immediate
`define ADDR_MODE_ABS    3'h1    // absolute
`define ADDR_MODE_ZPG    3'h2    // zero page
`define ADDR_MODE_ABSI   3'h3    // indexed absolute
`define ADDR_MODE_ZPGI   3'h4    // indexed zero page
`define ADDR_MODE_INDI   3'h5    // indirect indexed
`define ADDR_MODE_INDA   3'h6    // indirect absolute
`define ADDR_MODE_INDZ   3'h7    // indirect zero page

`define ADDR_INDEX_X 1'b0
`define ADDR_INDEX_Y 1'b1

// TODO: make this more synthesizable
module address_fsm (
    input wire i_clk,
    input wire i_rst_n,
    input wire [2:0] i_mode,
    input wire i_index_reg,
    input wire i_start,
    output wire o_done,
    output wire [3:0] o_ctrl
);
    reg done, running;
    reg [1:0] step;

    always @(posedge i_clk, negedge i_rst_n) begin
        if (!i_rst_n)
            done <= 1'b0;
        else if (step == step_done)
            done <= 1'b1;
        else if (i_start)
            done <= 1'b0;
    end

    always @(posedge i_clk, negedge i_rst_n) begin
        if (!i_rst_n)
            running <= 1'b0;
        else if (done)
            running <= 1'b0;
        else if (i_start)
            running <= 1'b1;
    end

    always @(posedge i_clk, negedge i_rst_n) begin
        if (!i_rst_n)
            step <= 2'b00;
        else if (i_start)
            step <= 2'b00;
        else
            step <= step + running;
    end

    reg [2:0] mode;
    reg index_reg;
    always @(posedge i_clk, negedge i_rst_n) begin
        if (!i_rst_n) begin
            mode <= 3'h0;
            index_reg <= 1'b0;
        end else if (i_start) begin
            mode <= i_mode;
            index_reg <= i_index_reg;
        end
    end

    reg [1:0] step_done;
    always @(*) begin
        step_done = 2'bxx;

        case (mode)
            `ADDR_MODE_IMM: step_done = 0;
            `ADDR_MODE_ABS: step_done = 2;
            `ADDR_MODE_ZPG: step_done = 1;
            `ADDR_MODE_ABSI: step_done = 0;
            `ADDR_MODE_ZPGI: step_done = 2;
            `ADDR_MODE_INDI: step_done = 3;
            `ADDR_MODE_INDA: step_done = 1;
            `ADDR_MODE_INDZ: step_done = 1;
        endcase
    end

    localparam STATE_LDPC = 0; // output program counter on address bus
    localparam STATE_RDLO = 1; // read immediate into low byte of addr
    localparam STATE_RDHI = 2; // read immediate into high byte of addr

    // step cycles through states, depending on mode
    reg [1:0] state;
    always @(*) begin
        state = 2'hx;
        
        case (mode)
            `ADDR_MODE_IMM: begin
                case (step)
                    0: state = STATE_LDPC;
                endcase
            end
            `ADDR_MODE_ABS: begin
                case (step)
                    0: state = STATE_RDLO;
                    1: state = STATE_RDHI;
                endcase
            end
        endcase
    end

    reg pc_out, pc_inc, ldlo, ldhi;
    always @(*) begin
        pc_out = 0;
        pc_inc = 0;
        ldlo = 0;
        ldhi = 0;

        case (state)
            STATE_LDPC: begin
                pc_out = 1;
            end
            STATE_RDLO: begin
                pc_out = 1;
                pc_inc = 1;
                ldlo = 1;
            end
            STATE_RDHI: begin
                pc_out = 1;
                pc_inc = 1;
                ldhi = 1;
            end
        endcase
    end

    assign o_done = done;
    assign o_ctrl = {pc_out, pc_inc, ldlo, ldhi};
endmodule
