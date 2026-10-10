
`timescale 1ns/1ps

module tb_program_counter;

    reg clk, reset, pc_enable;
    reg [31:0] next_pc;
    wire [31:0] pc;
    integer errors;

    program_counter uut (
        .clk(clk),
        .reset(reset),
        .pc_enable(pc_enable),
        .next_pc(next_pc),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        pc_enable = 1;
        next_pc = 0;
        errors = 0;

        // Test 1: Reset PC to zero
        @(posedge clk);
        #1;
        if (pc !== 32'd0) begin
            $display("FAIL: PC reset, got %0d", pc);
            errors = errors + 1;
        end else begin
            $display("PASS: PC reset");
        end

        // Test 2: Load address 4
        @(negedge clk);
        reset = 0;
        next_pc = 32'd4;

        @(posedge clk);
        #1;
        if (pc !== 32'd4) begin
            $display("FAIL: PC update, got %0d", pc);
            errors = errors + 1;
        end else begin
            $display("PASS: PC update");
        end

        // Test 3: Hold PC when disabled
        @(negedge clk);
        pc_enable = 0;
        next_pc = 32'd100;

        @(posedge clk);
        #1;
        if (pc !== 32'd4) begin
            $display("FAIL: PC hold, got %0d", pc);
            errors = errors + 1;
        end else begin
            $display("PASS: PC hold");
        end

        // Test 4: Load a branch target
        @(negedge clk);
        pc_enable = 1;
        next_pc = 32'h00000040;

        @(posedge clk);
        #1;
        if (pc !== 32'h00000040) begin
            $display("FAIL: Branch target, got %h", pc);
            errors = errors + 1;
        end else begin
            $display("PASS: Branch target");
        end

        // Final result
        if (errors == 0)
            $display("ALL PC TESTS PASSED!");
        else
            $display("FAILED TESTS: %0d", errors);

        $finish;
    end

endmodule
