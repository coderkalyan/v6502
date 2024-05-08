`default_nettype none

module decoder (
    input wire [7:0] i_opcode
);
    wire [3:0] ophi = i_opcode[7:4];
    wire [3:0] oplo = i_opcode[3:0];

    wire op_ora = (ophi[3:1] == 3'b000) && (oplo[1:0] == 2'b01);
    wire op_and = (ophi[3:1] == 3'b001) && (oplo[1:0] == 2'b01);
    wire op_eor = (ophi[3:1] == 3'b010) && (oplo[1:0] == 2'b01);
    wire op_adc = (ophi[3:1] == 3'b011) && (oplo[1:0] == 2'b01);
    wire op_sta = (ophi[3:1] == 3'b100) && (oplo[1:0] == 2'b01);
    wire op_lda = (ophi[3:1] == 3'b101) && (oplo[1:0] == 2'b01);
    wire op_cmp = (ophi[3:1] == 3'b110) && (oplo[1:0] == 2'b01);
    wire op_sbc = (ophi[3:1] == 3'b111) && (oplo[1:0] == 2'b01);

    wire op_asl = ((ophi[3:1] == 3'b000) && (oplo[2:0] == 2'b110)) || (i_opcode == 8'h0a);
    wire op_rol = ((ophi[3:1] == 3'b000) && (oplo[2:0] == 2'b110)) || (i_opcode == 8'h2a);
    wire op_lsr = ((ophi[3:1] == 3'b000) && (oplo[2:0] == 2'b110)) || (i_opcode == 8'h4a);
    wire op_ror = ((ophi[3:1] == 3'b000) && (oplo[2:0] == 2'b110)) || (i_opcode == 8'h6a);
    wire op_stx = (ophi[3:1] == 3'b000) && (oplo[2:0] == 2'b110);
    wire op_ldx = (ophi[3:1] == 3'b000) && (oplo[2:0] == 2'b110);
    wire op_dec = (ophi[3:1] == 3'b000) && (oplo[2:0] == 2'b110);
    wire op_inc = (ophi[3:1] == 3'b000) && (oplo[2:0] == 2'b110);
endmodule
