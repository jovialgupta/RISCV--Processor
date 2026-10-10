
module writeback_mux (
    input wire [31:0] alu_result,
    input wire [31:0] memory_data,
    input wire [31:0] pc_plus4,
    input wire [1:0] wb_sel,
    output reg [31:0] writeback_data
);
    localparam WB_ALU = 2'b00;
    localparam WB_MEM = 2'b01;
    localparam WB_PC4 = 2'b10;

    always @(*) begin
        case (wb_sel)
            WB_ALU: writeback_data = alu_result;
            WB_MEM: writeback_data = memory_data;
            WB_PC4: writeback_data = pc_plus4;
            default: writeback_data = 32'd0;
        endcase
    end
endmodule
