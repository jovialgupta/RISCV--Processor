
`timescale 1ns/1ps

module tb_data_memory;

    reg clk;
    reg mem_read, mem_write;
    reg [31:0] address, write_data;
    wire [31:0] read_data;

    data_memory #(.DEPTH(256)) dut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        mem_read = 0;
        mem_write = 0;
        address = 0;
        write_data = 0;

        // Test 1: Write 123 to address 0
        @(negedge clk);
        address = 32'd0;
        write_data = 32'd123;
        mem_write = 1;

        @(negedge clk);
        mem_write = 0;

        // Read address 0
        address = 32'd0;
        mem_read = 1;
        #1;

        if (read_data === 32'd123)
            $display("PASS: Write and read address 0");
        else
            $display("FAIL: Expected 123, got %h", read_data);

        // Test 2: Write a second value at address 4
        @(negedge clk);
        mem_read = 0;
        address = 32'd4;
        write_data = 32'hA5A5A5A5;
        mem_write = 1;

        @(negedge clk);
        mem_write = 0;

        // Read address 4
        address = 32'd4;
        mem_read = 1;
        #1;

        if (read_data === 32'hA5A5A5A5)
            $display("PASS: Write and read address 4");
        else
            $display("FAIL: Expected A5A5A5A5, got %h", read_data);

        // Test 3: Confirm address 0 is unchanged
        address = 32'd0;
        #1;

        if (read_data === 32'd123)
            $display("PASS: Addresses store independent values");
        else
            $display("FAIL: Address 0 got %h", read_data);

        $display("Data memory tests completed.");
        $finish;
    end

endmodule
