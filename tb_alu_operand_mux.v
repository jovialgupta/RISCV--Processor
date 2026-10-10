
module tb_alu_operand_mux;

    reg [31:0] register_data, immediate;
    reg alu_src;
    wire [31:0] alu_operand;

    alu_operand_mux uut (
        .register_data(register_data),
        .immediate(immediate),
        .alu_src(alu_src),
        .alu_operand(alu_operand)
    );

    initial begin
        register_data = 25;
        immediate = 100;

        alu_src = 0;
        #1;
        if (alu_operand !== 25)
            $display("FAIL: Register selection");
        else
            $display("PASS: Register selection");

        alu_src = 1;
        #1;
        if (alu_operand !== 100)
            $display("FAIL: Immediate selection");
        else
            $display("PASS: Immediate selection");

        $finish;
    end

endmodule
