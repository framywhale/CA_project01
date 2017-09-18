module ALUcontrol(
    input  [5:0] Func,
    input  [2:0] ALUOp,
    input  [5:0] Opcode,
    output [2:0] ALUop
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

    wire IsSlt;
    wire IsOr;
    assign IsSlt = (func == SLT);
    assign IsOr  = (func == OR);
    assign ALUop[2] = (ALUOp[0] && ~ALUOp[1] && ~ALUOp[2]) || (ALUOp[1] && ~ALUOp[0] && IsSlt) || ALUOp[2];
    assign ALUop[1] = (~IsOr && ~ALUOp[2] && ALUOp[1] && ~ALUOp[0]) || 
                      (~ALUOp[2] && ~ALUOp[1] && ~ALUOp[0]) || 
                      (ALUOp[0] && ALUOp[1] && ~ALUOp[2]) || 
                      (ALUOp[2] && ~ALUOp[1] && ~ALUOp[0]) ||
                      (~ALUOp[2] && ~ALUOp[1] && ALUOp[0]);
    assign ALUop[0] = (IsSlt && ~ALUOp[2] && ALUOp[1] && ~ALUOp[0]) || 
                      (IsOr && ~ALUOp[2] && ALUOp[1] && ~ALUOp[0]) || 
                      (ALUOp[0] && ALUOp[1] && ~ALUOp[2]) || 
                      (ALUOp[2] && ~ALUOp[1] && ~ALUOp[0]);

    always @(ALUOp or func or opcode) begin
        if(ALUop == 2'b00)  ALUcontrol = 3'b010;
        else if(ALUop == 2'b01) ALUcontrol =  3'b110;
        else if(ALUop == 2'b10) begin
            case(IR[5:0])
                SUBU: ALUcontrol = 3'b110;
                SLL : ALUcontrol = 3'b101;
                JR  : ALUcontrol = 3'b010;
                ADDU: ALUcontrol = 3'b010;
                OR  : ALUcontrol = 3'b001;
                SLT : ALUcontrol = 3'b111;
            endcase
        end
        else begin
            case(IR[31:26])
                LUI:    ALUcontrol = 3'b100;
                SLTI:   ALUcontrol = 3'b111; 
                SLTIU:  ALUcontrol = 3'b011;
            endcase
        end
    end
endmodule
