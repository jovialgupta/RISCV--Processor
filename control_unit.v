
module control_unit (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,

    output reg        reg_write,
    output reg        alu_src,
    output reg        mem_read,
    output reg        mem_write,
    output reg        branch,
    output reg        jump,
    output reg        jalr,
    output reg [1:0]  wb_sel,
    output reg [3:0]  alu_control
);

    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLL  = 4'b0101;
    localparam ALU_SRL  = 4'b0110;
    localparam ALU_SLT  = 4'b0111;
    localparam ALU_SLTU = 4'b1000;
    localparam ALU_SRA  = 4'b1001;

    localparam WB_ALU = 2'b00;
    localparam WB_MEM = 2'b01;
    localparam WB_PC4 = 2'b10;

    always @(*) begin
        reg_write   = 1'b0;
        alu_src     = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        jalr        = 1'b0;
        wb_sel      = WB_ALU;
        alu_control = ALU_ADD;

        case (opcode)

            // R-type arithmetic and logic
            7'b0110011: begin
                reg_write = 1'b1;

                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            alu_control = ALU_SUB;
                        else
                            alu_control = ALU_ADD;
                    end
                    3'b001: alu_control = ALU_SLL;
                    3'b010: alu_control = ALU_SLT;
                    3'b011: alu_control = ALU_SLTU;
                    3'b100: alu_control = ALU_XOR;
                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            alu_control = ALU_SRA;
                        else
                            alu_control = ALU_SRL;
                    end
                    3'b110: alu_control = ALU_OR;
                    3'b111: alu_control = ALU_AND;
                    default: alu_control = ALU_ADD;
                endcase
            end

            // I-type arithmetic and logic
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src = 1'b1;

                case (funct3)
                    3'b000: alu_control = ALU_ADD;
                    3'b010: alu_control = ALU_SLT;
                    3'b011: alu_control = ALU_SLTU;
                    3'b100: alu_control = ALU_XOR;
                    3'b110: alu_control = ALU_OR;
                    3'b111: alu_control = ALU_AND;
                    3'b001: alu_control = ALU_SLL;
                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            alu_control = ALU_SRA;
                        else
                            alu_control = ALU_SRL;
                    end
                    default: alu_control = ALU_ADD;
                endcase
            end

            // Loads
            7'b0000011: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                mem_read = 1'b1;
                wb_sel = WB_MEM;
                alu_control = ALU_ADD;
            end

            // Stores
            7'b0100011: begin
                alu_src = 1'b1;
                mem_write = 1'b1;
                alu_control = ALU_ADD;
            end

            // Conditional branches
            7'b1100011: begin
                branch = 1'b1;
                alu_control = ALU_SUB;
            end

            // JAL
            7'b1101111: begin
                reg_write = 1'b1;
                jump = 1'b1;
                wb_sel = WB_PC4;
            end

            // JALR
            7'b1100111: begin
                reg_write = 1'b1;
                jump = 1'b1;
                jalr = 1'b1;
                alu_src = 1'b1;
                wb_sel = WB_PC4;
            end

            // LUI: write immediate to rd
            7'b0110111: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_control = ALU_ADD;
            end

            // AUIPC: PC + upper immediate
            7'b0010111: begin
                reg_write = 1'b1;
                alu_control = ALU_ADD;
            end

            default: begin
                // Unsupported instruction: controls remain inactive.
            end
        endcase
    end

endmodule
