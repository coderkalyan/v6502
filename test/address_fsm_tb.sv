`default_nettype none

module address_fsm_tb();
    logic clk, rst_n;
    logic [2:0] mode;
    logic index_reg;
    logic start, done;
    logic [15:0] pc;
    logic [3:0] ctrl;
    logic pc_out, pc_inc, ldlo, ldhi;

    address_fsm fsm (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_mode(mode),
        .i_index_reg(index_reg),
        .i_start(start),
        .o_done(done),
        .o_ctrl(ctrl)
    );

    assign {pc_out, pc_inc, ldlo, ldhi} = ctrl;

    initial begin
        $dumpfile("address_fsm_tb.vcd");
        $dumpvars(0, address_fsm_tb);

        clk = 1;
        rst_n = 0;
        start = 0;

        @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        // 1 - immediate addressing
        mode = `ADDR_MODE_IMM;
        start = 1;

        @(posedge clk);
        start = 0;

        if (!done) begin
            $display("expected done asserted");
            $finish;
        end
        if (ctrl !== 4'b1000) begin
            $display("incorrect ctrl flags: got %04b", ctrl);
            $finish;
        end

        // 2 - absolute addressing
        @(posedge clk);
        mode = `ADDR_MODE_ABS;
        start = 1;

        @(posedge clk);
        if (done) begin
            $display("expected done not asserted");
            $display(fsm.i_start);
            $finish;
        end
        if (ctrl !== 4'b1110) begin
            $display("incorrect ctrl flags: got %04b", ctrl);
            $finish;
        end

        @(posedge clk);
        if (!done) begin
            $display("expected done asserted");
            $finish;
        end
        if (ctrl !== 4'b1101) begin
            $display("incorrect ctrl flags: got %04b", ctrl);
            $finish;
        end

        $display("all tests passed");
        $finish;
    end

    always
        #5 clk = ~clk;

    always @(posedge clk) begin
        if (pc_inc)
            pc <= pc + 1;
    end

    // always @(negedge clk) begin
    //     if (start)
    //         start = 0;
    // end
endmodule
