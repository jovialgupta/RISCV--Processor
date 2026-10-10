
`timescale 1ns/1ps

module tb_next_pc_logic;

    reg [31:0] pc;
    reg [31:0] immediate;
    reg [31:0] rs1_data;

    reg branch_taken;
    reg jump;
    reg jalr;

    wire [31:0] next_pc;

    // Instantiate the Next PC Logic module
    next_pc_logic dut (
        .pc(pc),
        .immediate(immediate),
        .rs1_data(rs1_data),
        .branch_taken(branch_taken),
        .jump(jump),
        .jalr(jalr),
        .next_pc(next_pc)
    );

    // Task to check the expected next PC
    task check_pc;
        input [31:0] expected;
        input [160*8-1:0] test_name;

        begin
            #10;

            if (next_pc === expected)
                $display("PASS: %0s", test_name);
            else
                $display(
                    "FAIL: %0s; got %h, expected %h",
                    test_name, next_pc, expected
                );
        end
    endtask

    initial begin
        // Initialize inputs
        pc = 32'h1000;
        immediate = 32'd16;
        rs1_data = 32'h2000;

        branch_taken = 0;
        jump = 0;
        jalr = 0;

        // Test 1: Normal execution (PC + 4)
        check_pc(32'h1004, "Sequential PC + 4");

        // Test 2: Taken branch (PC + immediate)
        branch_taken = 1;
        check_pc(32'h1010, "Taken branch");

        // Test 3: JAL (PC + immediate)
        branch_taken = 0;
        jump = 1;
        check_pc(32'h1010, "JAL target");

        // Test 4: JALR (rs1 + immediate)
        jump = 0;
        jalr = 1;
        check_pc(32'h2010, "JALR target");

        // Test 5: JALR clears bit 0
        rs1_data = 32'h2001;
        immediate = 32'd4;

        check_pc(32'h2004, "JALR clears bit zero");

        $display("Next PC tests completed.");

        $finish;
    end

endmodule
