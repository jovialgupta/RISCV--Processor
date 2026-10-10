
module tb_writeback_mux;

    reg [31:0] alu_result, memory_data, pc_plus4;
    reg [1:0] wb_sel;
    wire [31:0] writeback_data;

    writeback_mux uut (
        .alu_result(alu_result),
        .memory_data(memory_data),
        .pc_plus4(pc_plus4),
        .wb_sel(wb_sel),
        .writeback_data(writeback_data)
    );

    initial begin
        alu_result = 15;
        memory_data = 200;
        pc_plus4 = 104;

        wb_sel = 2'b00;
        #1;
        if (writeback_data !== 15)
            $display("FAIL: ALU writeback");
        else
            $display("PASS: ALU writeback");

        wb_sel = 2'b01;
        #1;
        if (writeback_data !== 200)
            $display("FAIL: Memory writeback");
        else
            $display("PASS: Memory writeback");

        wb_sel = 2'b10;
        #1;
        if (writeback_data !== 104)
            $display("FAIL: PC+4 writeback");
        else
            $display("PASS: PC+4 writeback");

        $finish;
    end

endmodule
