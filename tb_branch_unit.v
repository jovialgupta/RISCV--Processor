
`timescale 1ns/1ps

module tb_branch_unit;

    reg [31:0] a, b;
    reg branch;
    reg [2:0] funct3;
    wire branch_taken;

    branch_unit dut (
        .a(a),
        .b(b),
        .branch(branch),
        .funct3(funct3),
        .branch_taken(branch_taken)
    );

    task check_branch;
        input expected;
        input [160*8-1:0] test_name;
        begin
            #10;
            if (branch_taken === expected)
                $display("PASS: %0s", test_name);
            else
                $display("FAIL: %0s; got %b expected %b",
                         test_name, branch_taken, expected);
        end
    endtask

    initial begin
        branch = 1;

        a = 32'd10; b = 32'd10;
        funct3 = 3'b000; // BEQ
        check_branch(1, "BEQ equal");

        a = 32'd10; b = 32'd20;
        funct3 = 3'b000; // BEQ
        check_branch(0, "BEQ not equal");

        a = 32'd10; b = 32'd20;
        funct3 = 3'b001; // BNE
        check_branch(1, "BNE not equal");

        a = 32'hFFFFFFFF; b = 32'd1;
        funct3 = 3'b100; // BLT signed: -1 < 1
        check_branch(1, "BLT signed comparison");

        a = 32'd5; b = 32'd5;
        funct3 = 3'b101; // BGE signed
        check_branch(1, "BGE equal values");

        a = 32'd1; b = 32'd2;
        funct3 = 3'b110; // BLTU
        check_branch(1, "BLTU unsigned comparison");

        a = 32'd2; b = 32'd1;
        funct3 = 3'b111; // BGEU
        check_branch(1, "BGEU unsigned comparison");

        branch = 0;
        funct3 = 3'b000;
        a = 32'd5; b = 32'd5;
        check_branch(0, "Branch disabled");

        $finish;
    end

endmodule
