`timescale 10ns / 1ns

module mips_cpu(
    input  clk,
    input  resetn,

    // instruction fetch port
    output reg        inst_sram_en,
    output reg [ 3:0] inst_sram_wen,
    output     [31:0] inst_sram_addr, // PC 
    output reg [31:0] inst_sram_wdata,
    input  reg [31:0] inst_sram_rdata,
    
    // data fetch port
    output reg        data_sram_en,
    output reg [ 3:0] data_sram_wen,
    output     [31:0] data_sram_addr,
    output reg [31:0] data_sram_wdata,
    input  reg [31:0] data_sram_rdata,

    // debug signal
	output reg [31:0] debug_wb_pc,
	output reg [ 3:0] debug_wb_rf_wen,
	output reg [ 4:0] debug_wb_rf_wnum,
	output reg [31:0] debug_wb_rf_wdata
);

endmodule