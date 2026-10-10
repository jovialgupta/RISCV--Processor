
`timescale 1ns/1ps

module tb_immediate_branch_target;

    reg [31:0] instruction;
    wire [31:0] immediate;

    immediate_branch_target dut (
        .instruction(instruction),
        .immediate(immediate)
    );

    initial begin
        // I-type: immediate = -1
        instruction = 32'b0;
        instruction[31:20] = 12'hFFF;
        instruction[19:15] = 5'd1;
        instruction[14:12] = 3'b000;
        instruction[11:7]  = 5'd2;
        instruction[6:0]   = 7'b0010011;
        #10;
        if (immediate === 32'hFFFFFFFF)
            $display("PASS: I-type");
        else
            $display("FAIL: I-type got %h", immediate);

        // S-type: immediate = -4
        instruction = 32'b0;
        instruction[31:25] = 7'b1111111;
        instruction[24:20] = 5'd2;
        instruction[19:15] = 5'd1;
        instruction[14:12] = 3'b010;
        instruction[11:7]  = 5'b11100;
        instruction[6:0]   = 7'b0100011;
        #10;
        if (immediate === 32'hFFFFFFFC)
            $display("PASS: S-type");
        else
            $display("FAIL: S-type got %h", immediate);

        // B-type: immediate = +8
        instruction = 32'b0;
        instruction[31]    = 1'b0;
        instruction[30:25] = 6'b000000;
        instruction[24:20] = 5'd2;
        instruction[19:15] = 5'd1;
        instruction[14:12] = 3'b000;
        instruction[11:8]  = 4'b0100;
        instruction[7]     = 1'b0;
        instruction[6:0]   = 7'b1100011;
        #10;
        if (immediate === 32'd8)
            $display("PASS: B-type");
        else
            $display("FAIL: B-type got %h", immediate);

        // U-type: LUI immediate = 0x12345000
        instruction = 32'h12345037;
        #10;
        if (immediate === 32'h12345000)
            $display("PASS: U-type");
        else
            $display("FAIL: U-type got %h", immediate);

        // J-type: immediate = +8
        instruction = 32'b0;
        instruction[31]    = 1'b0;
        instruction[30:21] = 10'b0000000100;
        instruction[20]    = 1'b0;
        instruction[19:12] = 8'b0;
        instruction[11:7]  = 5'd1;
        instruction[6:0]   = 7'b1101111;
        #10;
        if (immediate === 32'd8)
            $display("PASS: J-type");
        else
            $display("FAIL: J-type got %h", immediate);

        $finish;
    end

endmodule
