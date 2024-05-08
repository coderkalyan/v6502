`default_nettype none

// FLOE: fetch low order byte from instruction stream into effective address
// FHIE: fetch high order byte from instruction stream into effective address
// ADXE: add index register x to effective address
// ADYE: add index register y to effective address

// `define ADDR_STATE_FLO
// `define ADDR_STATE_`
// module address_fsm (
//     input wire i_clk,
//     input wire i_rst_n,
//     input wire i_start,             // signals start of fsm logic
//     input wire [15:0] i_pc,         // current program counter
//     input wire [7:0] i_data,        // input on data base
//     output wire [15:0] o_addr,      // output on address bus
//     output wire o_pc_inc,           // if asserted, increment program counter
//     output wire o_done,             // asserted when fsm is ready with effective address
//     output reg [15:0] o_eff_addr    // effective address calculated (only valid when o_done)
// );
//     reg [15:0] scratch, next_scratch;
//     always @(posedge i_clk, negedge i_rst_n) begin
//         if (!i_rst_n)
//             scratch <= 16'h0000;
//         else if (i_start)
//             scratch <= 16'h0000;
//         else
//             scratch <= next_scratch;
//     end
//
//     reg state;
//     reg pc_inc, done;
//     always @(*) begin
//         next_scratch = 16'h0000;
//         pc_inc = 1'b0;
//         done = 1'b0;
//
//         case (state)
//             ``
//         endcase
//     end
// endmodule

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
);
    reg running;
    reg [1:0] step, step_done;

    always @(posedge i_clk, negedge i_rst_n) begin
        if (!i_rst_n)
            running <= 1'b0;
        else if (step == step_done)
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

    always @(*) begin
        step_done = 2'bxx;

        case (mode)
            `ADDR_MODE_IMM: step_done = 0;
            `ADDR_MODE_ABS: step_done = 2;
            `ADDR_MODE_ZPG: step_done = 1;
            `ADDR_MODE_ABSI: step_done = 0;
            `ADDR_MODE_ZPGI: step_done = 2;
            `ADDR_MODE_INDI: step_done = 4;
            `ADDR_MODE_INDA: step_done = 1;
            `ADDR_MODE_INDZ: step_done = 1;
        endcase
    end
endmodule
