
`timescale 1ns/1ps

module tb_alu;

    reg [31:0] a, b;
    reg [3:0] alu_control;
    wire [31:0] result;
    integer errors;

    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result)
    );

    initial begin
        errors = 0;

        // Test 1: Addition
        a = 10; b = 5; alu_control = 4'b0000;
        #10;
        if (result !== 15) begin
            $display("FAIL: ADD, got %0d", result);
            errors = errors + 1;
        end else $display("PASS: ADD");

        // Test 2: Subtraction
        a = 10; b = 5; alu_control = 4'b0001;
        #10;
        if (result !== 5) begin
            $display("FAIL: SUB, got %0d", result);
            errors = errors + 1;
        end else $display("PASS: SUB");

        // Test 3: AND
        a = 12; b = 10; alu_control = 4'b0010;
        #10;
        if (result !== 8) begin
            $display("FAIL: AND, got %0d", result);
            errors = errors + 1;
        end else $display("PASS: AND");

        // Test 4: OR
        a = 12; b = 10; alu_control = 4'b0011;
        #10;
        if (result !== 14) begin
            $display("FAIL: OR, got %0d", result);
            errors = errors + 1;
        end else $display("PASS: OR");

        // Test 5: Signed less-than
        a = 5; b = 10; alu_control = 4'b0111;
        #10;
        if (result !== 1) begin
            $display("FAIL: SLT, got %0d", result);
            errors = errors + 1;
        end else $display("PASS: SLT");

        if (errors == 0)
            $display("ALL ALU TESTS PASSED!");
        else
            $display("ALU TESTS FAILED: %0d", errors);

        $finish;
    end

endmodule
