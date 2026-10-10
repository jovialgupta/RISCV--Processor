
`timescale 1ns/1ps

module tb_register_file;

    reg clk, reset, reg_write;
    reg [4:0] read_addr1, read_addr2, write_addr;
    reg [31:0] write_data;
    wire [31:0] read_data1, read_data2;
    integer errors;

    register_file uut (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        reg_write = 0;
        read_addr1 = 0;
        read_addr2 = 0;
        write_addr = 0;
        write_data = 0;
        errors = 0;

        // Reset registers
        #12;
        reset = 0;

        // Test 1: Write 100 into x1
        @(negedge clk);
        reg_write = 1;
        write_addr = 1;
        write_data = 100;

        @(posedge clk);
        #1;
        reg_write = 0;
        read_addr1 = 1;
        #1;

        if (read_data1 !== 100) begin
            $display("FAIL: Register write/read");
            errors = errors + 1;
        end else $display("PASS: Register write/read");

        // Test 2: Write 200 into x2
        @(negedge clk);
        reg_write = 1;
        write_addr = 2;
        write_data = 200;

        @(posedge clk);
        #1;
        reg_write = 0;
        read_addr2 = 2;
        #1;

        if (read_data2 !== 200) begin
            $display("FAIL: Second register");
            errors = errors + 1;
        end else $display("PASS: Second register");

        // Test 3: x0 must always read zero
        read_addr1 = 0;
        #1;

        if (read_data1 !== 0) begin
            $display("FAIL: x0 is not zero");
            errors = errors + 1;
        end else $display("PASS: x0 always reads zero");

        // Test 4: Writing to x0 must not change it
        @(negedge clk);
        reg_write = 1;
        write_addr = 0;
        write_data = 999;

        @(posedge clk);
        #1;
        reg_write = 0;
        read_addr1 = 0;
        #1;

        if (read_data1 !== 0) begin
            $display("FAIL: Write to x0");
            errors = errors + 1;
        end else $display("PASS: Writes to x0 are ignored");

        if (errors == 0)
            $display("ALL REGISTER FILE TESTS PASSED!");
        else
            $display("FAILED TESTS: %0d", errors);

        $finish;
    end

endmodule
