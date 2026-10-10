
`timescale 1ns/1ps

module tb_control_unit;

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;

    wire reg_write, alu_src, mem_read, mem_write;
    wire branch, jump, jalr;
    wire [1:0] wb_sel;
    wire [3:0] alu_control;

    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .wb_sel(wb_sel),
        .alu_control(alu_control)
    );

    initial begin
        // ADD x3, x1, x2 (R-type)
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (reg_write && !mem_read && !mem_write && !branch)
            $display("PASS: ADD control signals");
        else
            $display("CHECK: ADD control signals");

        // LW x3, 0(x1)
        opcode = 7'b0000011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10;
        if (reg_write && mem_read && !mem_write)
            $display("PASS: LOAD control signals");
        else
            $display("FAIL: LOAD control signals");

        // SW x2, 0(x1)
        opcode = 7'b0100011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10;
        if (mem_write && !reg_write)
            $display("PASS: STORE control signals");
        else
            $display("FAIL: STORE control signals");

        // BEQ x1, x2, offset
        opcode = 7'b1100011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (branch && !reg_write)
            $display("PASS: BRANCH control signals");
        else
            $display("FAIL: BRANCH control signals");

        // JAL x1, offset
        opcode = 7'b1101111;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (jump)
            $display("PASS: JAL control signals");
        else
            $display("FAIL: JAL control signals");

        $finish;
    end

endmodule
