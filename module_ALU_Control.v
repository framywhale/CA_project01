module ALUcontrol(
    input  [5:0] Func,
    input  [2:0] ALUOp,
    input  [5:0] Opcode,
    output [2:0] ALUcontrol
);
    // Opcode: IR[31:26]
    parameter [5:0] ADDIU   = 6'b001001,
                    LW      = 6'b100011,
                    SW      = 6'b101011,
                    BNE     = 6'b000101,
                    BEQ     = 6'b000100,
                    J       = 6'b000010,
                    JAL     = 6'b000011,
                    R_TYPE  = 6'b000000, 
                    LUI     = 6'b001111, 
                    SLTI    = 6'b001010,
                    SLTIU   = 6'b001011;
    // Fuction: IR[5:0]
    parameter [5:0] JR   = 6'b001000,
                    SLL  = 6'b000000,
                    SUBU = 6'b100011,
                    ADDU = 6'b100001,
                    OR   = 6'b100101,
                    SLT  = 6'b101010;
    
    reg [2:0] aluop;
    reg [5:0] func,opcode;
    always @(Func or ALUOp or Opcode) begin
       aluop  = ALUOp;
       func   = Func;
       opcode = Opcode;
    end
    
    always @(ALUOp or func or opcode) begin
        if(ALUOp == 3'b100)  ALUcontrol = 3'b111;
        else if(ALUOp == 3'b101) ALUcontrol =  3'b100;
        else if(ALUOp == 3'b011) ALUcontrol =  3'b011;
        else if(ALUOp == 3'b000) ALUcontrol =  3'b000;
        else if(ALUOp == 3'b001) ALUcontrol =  3'b110;
        else if(ALUOp == 3'b010) begin
            case(Func)
                OR:      ALUcontrol = 3'b010;
                SLT:     ALUcontrol = 3'b111;
                default: ALUcontrol = 3'b010;
            endcase
        end
        else ALUcontrol = 3'b000;
    end
endmodule
