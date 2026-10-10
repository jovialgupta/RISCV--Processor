
module data_memory #(
    parameter DEPTH = 256
) (
    input  wire        clk,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] address,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);

    reg [31:0] memory [0:DEPTH-1];
    wire [31:0] word_index;

    // Convert byte address into a word index.
    assign word_index = address >> 2;

    // Combinational word read.
    assign read_data =
        (mem_read && word_index < DEPTH)
        ? memory[word_index]
        : 32'd0;

    // Synchronous word write.
    always @(posedge clk) begin
        if (mem_write && word_index < DEPTH)
            memory[word_index] <= write_data;
    end

endmodule
