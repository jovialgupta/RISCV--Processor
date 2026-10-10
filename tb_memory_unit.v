
`timescale 1ns/1ps

module tb_memory_unit;

    reg clk;
    reg reset;
    reg mem_read;
    reg mem_write;
    reg [31:0] address_in;
    reg [31:0] write_data_in;

    wire [31:0] mar;
    wire [31:0] mdr;
    wire [31:0] read_data;

    memory_unit dut (
        .clk(clk),
        .reset(reset),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address_in(address_in),
        .write_data_in(write_data_in),
        .mar(mar),
        .mdr(mdr),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        mem_read = 0;
        mem_write = 0;
        address_in = 0;
        write_data_in = 0;

        // Reset the memory unit
        repeat (2) @(negedge clk);
        reset = 0;

        // Step 1: Load address 8 into MAR
        @(negedge clk);
        address_in = 32'd8;

        @(negedge clk);
        if (mar === 32'd8)
            $display("PASS: MAR captures address");
        else
            $display("FAIL: MAR = %h", mar);

        // Step 2: Write 42 using the registered MAR address
        write_data_in = 32'd42;
        mem_write = 1;

        @(negedge clk);
        mem_write = 0;

        // Step 3: Read from address 8
        mem_read = 1;

        #1;
        if (read_data === 32'd42)
            $display("PASS: Memory read returns 42");
        else
            $display("FAIL: read_data = %h", read_data);

        // Step 4: Capture the returned value in MDR
        @(negedge clk);
        #1;

        if (mdr === 32'd42)
            $display("PASS: MDR captures read data");
        else
            $display("FAIL: MDR = %h", mdr);

        mem_read = 0;

        $display("Memory unit tests completed.");
        $finish;
    end

endmodule
