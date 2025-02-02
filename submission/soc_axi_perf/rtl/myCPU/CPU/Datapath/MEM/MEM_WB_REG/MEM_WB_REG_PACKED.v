module MEM_WB_REG_PACKED(clk, rst_n, stall0, irq, wcp0, MEM_WB_wcp0_data, load_type, MEM_WB_load_type_data, hi_i_sel, MEM_WB_hi_i_sel_data, lo_i_sel,MEM_WB_lo_i_sel_data, whi, MEM_WB_whi_data, wlo, MEM_WB_wlo_data, wreg, MEM_WB_wreg_data, result_sel, MEM_WB_result_sel_data,  rf_rdata0_fw, MEM_WB_rf_rdata0_fw_data, rf_rdata1_fw, MEM_WB_rf_rdata1_fw_data, ALU_result, MEM_WB_ALU_result_data, SC_result_sel, MEM_WB_SC_result_sel_data, byte_valid, MEM_WB_byte_valid_data, MulDiv_result, MEM_WB_MulDiv_result_data, regdst, MEM_WB_regdst_data, mem_rdata, MEM_WB_mem_rdata_data, PC_plus4, MEM_WB_PC_plus4_data, instruction, MEM_WB_Instruction_data, tlbr, MEM_WB_tlbr_data, tlbp, MEM_WB_tlbp_data, tlbr_result, MEM_WB_tlbr_result_data);
	/*********************
	 *	MEM - WB Pipeline Registers PACKED
	 *input:
	 *	clk								: clock
	 *	rst_n							: negetive reset signal
	 *	stall0							: stall0 signal
	 *	irq								: int request
	 *	wcp0							: write COP0 Regs
	 *	load_type[3:0]					: load type
	 *	hi_i_sel						: hi_i select signal
	 *	lo_i_sel						: lo_i select signal
	 *	whi								: write HI Reg
	 *	wlo								: write LO Reg
	 *	wreg							: write RegisterFile
	 *	result_sel[1:0]					: result to write into RF select signal
	 *	rf_rdata0_fw[31:0]				: RF read data0 with forwarding
	 *	rf_rdata1_fw[31:0]				: RF read data1 with forwarding
	 *	ALU_result[31:0]				: ALU_result
	 *	SC_result_sel					: instruction SC result select signal
	 *	byte_valid[3:0]					: identity which byte in word is valid
	 *	MulDiv_result[63:0]				: Mul / Div result
	 *	regdst[4:0]						: select which reg to write
	 *	mem_rdata[31:0]					: mem read data
	 *	PC_plus4[31:0]					: PC_plus4 data
	 *	tlbr							: tlbr instruction
	 *	tlbp							: tlbp instruction
	 *	tlbr_result[89:0]				: tlbr_result
	 *output:
	 *	MEM_WB_wcp0_data				: MEM/WB wcp0 data
	 *	MEM_WB_load_type_data[3:0]		: MEM/WB load_type data
	 *	MEM_WB_hi_i_sel_data			: MEM/WB hi_i_sel data
	 *	MEM_WB_lo_i_sel_data			: MEM/WB lo_i_sel data
	 *	MEM_WB_whi_data					: MEM/WB whi data
	 *	MEM_WB_wlo_data					: MEM/WB wlo data
	 *	MEM_WB_wreg_data				: MEM/WB wreg data
	 *	MEM_WB_result_sel_data[1:0]		: MEM/WB result_sel data
	 *	MEM_WB_rf_rdata0_fw_data[31:0]	: MEM/WB rf_rdata0_fw data
	 *	MEM_WB_rf_rdata1_fw_data[31:0]	: MEM/WB rf_rdata1_fw data
	 *	MEM_WB_ALU_result_data[31:0]	: MEM/WB ALU_result data
	 *	MEM_WB_SC_result_sel_data		: MEM/WB SC_result_sel data
	 *	MEM_WB_byte_valid_data[3:0]		: MEM/WB byte_valid data
	 *	MEM_WB_MulDiv_result_data[63:0]	: MEM/WB MulDiv_result data
	 *	MEM_WB_regdst_data[4:0]			: MEM/WB regdst data
	 *	MEM_WB_mem_rdata_data[31:0]		: MEM/WB mem_rdata data
	 *	MEM_WB_PC_plus4_data[31:0]		: MEM/WB PC_plus4 data
	 *	MEM_WB_tlbr_data				: MEM/WB tlbr data
	 *	MEM_WB_tlbp_data				: MEM/WB tlbp data
	 *	MEM_WB_tlbr_result_data[89:0]	: MEM/WB tlbr_result data
	 *********************/
	input clk, rst_n;
	input stall0, irq;
	input wcp0, hi_i_sel, lo_i_sel, whi, wlo, wreg, SC_result_sel, tlbr, tlbp;
	input [1:0] result_sel;
	input [3:0] load_type, byte_valid;
	input [4:0] regdst;
	input [31:0] rf_rdata0_fw, rf_rdata1_fw, ALU_result, mem_rdata, PC_plus4, instruction;
	input [63:0] MulDiv_result;
	input [89:0] tlbr_result;
	output reg MEM_WB_wcp0_data, MEM_WB_hi_i_sel_data, MEM_WB_lo_i_sel_data, MEM_WB_whi_data, MEM_WB_wlo_data, MEM_WB_wreg_data, MEM_WB_SC_result_sel_data;
	output reg MEM_WB_tlbr_data, MEM_WB_tlbp_data;
	output reg [1:0] MEM_WB_result_sel_data;
	output reg [3:0] MEM_WB_load_type_data;
	(* max_fanout = "32" *)output reg [3:0] MEM_WB_byte_valid_data;
	output reg [4:0] MEM_WB_regdst_data;
	output reg [31:0] MEM_WB_rf_rdata0_fw_data, MEM_WB_rf_rdata1_fw_data, MEM_WB_ALU_result_data, MEM_WB_mem_rdata_data, MEM_WB_PC_plus4_data, MEM_WB_Instruction_data;
	output reg [63:0] MEM_WB_MulDiv_result_data;
	output reg [89:0] MEM_WB_tlbr_result_data;
	
	wire MEM_WB_Stall = stall0 & ~irq;
	wire MEM_WB_Flush = irq;
	always@(posedge clk or negedge rst_n)
		begin
		if(!rst_n)
			begin
			MEM_WB_wcp0_data <= 1'b0;
			MEM_WB_load_type_data <= 4'b0;
			MEM_WB_hi_i_sel_data <= 1'b0;
			MEM_WB_lo_i_sel_data <= 1'b0;
			MEM_WB_whi_data <= 1'b0;
			MEM_WB_wlo_data <= 1'b0;
			MEM_WB_wreg_data <= 1'b0;
			MEM_WB_result_sel_data <= 2'b0;
			MEM_WB_rf_rdata0_fw_data <= 32'b0;
			MEM_WB_rf_rdata1_fw_data <= 32'b0;
			MEM_WB_ALU_result_data <= 32'b0;
			MEM_WB_SC_result_sel_data <= 1'b0;
			MEM_WB_byte_valid_data <= 4'b0;
			MEM_WB_MulDiv_result_data <= 64'b0;
			MEM_WB_regdst_data <= 5'b0;
			MEM_WB_mem_rdata_data <= 32'b0;
			MEM_WB_tlbr_data <= 1'b0;
			MEM_WB_tlbp_data <= 1'b0;
			MEM_WB_tlbr_result_data <= 90'b0;
			MEM_WB_PC_plus4_data <= 32'b0;
			MEM_WB_Instruction_data <= 32'b0;
			end
		else if(!MEM_WB_Stall)
			begin
			if(MEM_WB_Flush)
				begin
				MEM_WB_wcp0_data <= 1'b0;
				MEM_WB_load_type_data <= 4'b0;
				MEM_WB_hi_i_sel_data <= 1'b0;
				MEM_WB_lo_i_sel_data <= 1'b0;
				MEM_WB_whi_data <= 1'b0;
				MEM_WB_wlo_data <= 1'b0;
				MEM_WB_wreg_data <= 1'b0;
				MEM_WB_result_sel_data <= 2'b0;
				MEM_WB_rf_rdata0_fw_data <= 32'b0;
				MEM_WB_rf_rdata1_fw_data <= 32'b0;
				MEM_WB_ALU_result_data <= 32'b0;
				MEM_WB_SC_result_sel_data <= 1'b0;
				MEM_WB_byte_valid_data <= 4'b0;
				MEM_WB_MulDiv_result_data <= 64'b0;
				MEM_WB_regdst_data <= 5'b0;
				MEM_WB_mem_rdata_data <= 32'b0;
				MEM_WB_tlbr_data <= 1'b0;
				MEM_WB_tlbp_data <= 1'b0;
				MEM_WB_tlbr_result_data <= 90'b0;
				MEM_WB_PC_plus4_data <= 32'b0;
				MEM_WB_Instruction_data <= 32'b0;
				end
			else
				begin
				MEM_WB_wcp0_data <= wcp0;
				MEM_WB_load_type_data <= load_type;
				MEM_WB_hi_i_sel_data <= hi_i_sel;
				MEM_WB_lo_i_sel_data <= lo_i_sel;
				MEM_WB_whi_data <= whi;
				MEM_WB_wlo_data <= wlo;
				MEM_WB_wreg_data <= wreg;
				MEM_WB_result_sel_data <= result_sel;
				MEM_WB_rf_rdata0_fw_data <= rf_rdata0_fw;
				MEM_WB_rf_rdata1_fw_data <= rf_rdata1_fw;
				MEM_WB_ALU_result_data <= ALU_result;
				MEM_WB_SC_result_sel_data <= SC_result_sel;
				MEM_WB_byte_valid_data <= byte_valid;
				MEM_WB_MulDiv_result_data <= MulDiv_result;
				MEM_WB_regdst_data <= regdst;
				MEM_WB_mem_rdata_data <= mem_rdata;
				MEM_WB_tlbr_data <= tlbr;
				MEM_WB_tlbp_data <= tlbp;
				MEM_WB_tlbr_result_data <= tlbr_result;
				MEM_WB_PC_plus4_data <= PC_plus4;
				MEM_WB_Instruction_data <= instruction;
				end
			end
		end
	/*
	// MEM_WB_REG
	MEM_WB_REG m_MEM_WB_REG(
		.clk(clk), 
		.rst_n(rst_n), 
		.MEM_WB_Stall(MEM_WB_Stall), 
		.MEM_WB_Flush(MEM_WB_Flush), 
		.wcp0(wcp0), 
		.MEM_WB_wcp0_data(MEM_WB_wcp0_data), 
		.load_type(load_type), 
		.MEM_WB_load_type_data(MEM_WB_load_type_data), 
		.hi_i_sel(hi_i_sel), 
		.MEM_WB_hi_i_sel_data(MEM_WB_hi_i_sel_data), 
		.lo_i_sel(lo_i_sel),
		.MEM_WB_lo_i_sel_data(MEM_WB_lo_i_sel_data), 
		.whi(whi), 
		.MEM_WB_whi_data(MEM_WB_whi_data), 
		.wlo(wlo), 
		.MEM_WB_wlo_data(MEM_WB_wlo_data), 
		.wreg(wreg), 
		.MEM_WB_wreg_data(MEM_WB_wreg_data), 
		.result_sel(result_sel), 
		.MEM_WB_result_sel_data(MEM_WB_result_sel_data),  
		.rf_rdata0_fw(rf_rdata0_fw), 
		.MEM_WB_rf_rdata0_fw_data(MEM_WB_rf_rdata0_fw_data), 
		.rf_rdata1_fw(rf_rdata1_fw), 
		.MEM_WB_rf_rdata1_fw_data(MEM_WB_rf_rdata1_fw_data), 
		.ALU_result(ALU_result), 
		.MEM_WB_ALU_result_data(MEM_WB_ALU_result_data), 
		.SC_result_sel(SC_result_sel), 
		.MEM_WB_SC_result_sel_data(MEM_WB_SC_result_sel_data), 
		.byte_valid(byte_valid), 
		.MEM_WB_byte_valid_data(MEM_WB_byte_valid_data), 
		.MulDiv_result(MulDiv_result), 
		.MEM_WB_MulDiv_result_data(MEM_WB_MulDiv_result_data), 
		.regdst(regdst), 
		.MEM_WB_regdst_data(MEM_WB_regdst_data), 
		.mem_rdata(mem_rdata), 
		.MEM_WB_mem_rdata_data(MEM_WB_mem_rdata_data),
		.tlbr(tlbr),
		.MEM_WB_tlbr_data(MEM_WB_tlbr_data),
		.tlbp(tlbp),
		.MEM_WB_tlbp_data(MEM_WB_tlbp_data),
		.tlbr_result(tlbr_result),
		.MEM_WB_tlbr_result_data(MEM_WB_tlbr_result_data),
		// for test only
		.PC_plus4(PC_plus4),
		.MEM_WB_PC_plus4_data(MEM_WB_PC_plus4_data),
		.instruction(instruction),
		.MEM_WB_Instruction_data(MEM_WB_Instruction_data)
	);
	*/
endmodule