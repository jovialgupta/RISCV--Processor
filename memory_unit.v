
module memory_unit (
    input  wire        clk,
    input  wire        reset,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] address_in,
    input  wire [31:0] write_data_in,
    output reg  [31:0] mar,
    output reg  [31:0] mdr,
    output wire [31:0] read_data
);

    data_memory #(
        .DEPTH(256)
    ) dm (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(mar),
        .write_data(write_data_in),
        .read_data(read_data)
    );

    always @(posedge clk) begin
        if (reset) begin
            mar <= 32'd0;
            mdr <= 32'd0;
        end
        else begin
            mar <= address_in;

            if (mem_read)
                mdr <= read_data;
        end
    end

endmodule
