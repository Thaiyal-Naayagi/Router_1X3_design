`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2025 16:52:30
// Design Name: 
// Module Name: router_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module router_top(clk,rst,read_en_0,read_en_1,read_en_2,pkt_valid,data_in,data_out_0,data_out_1,data_out_2,busy,err,vld_out_0,vld_out_1,vld_out_2);
    input clk,rst,read_en_0,read_en_1,read_en_2,pkt_valid;
    input [7:0] data_in;
    output [7:0] data_out_0,data_out_1,data_out_2;
    output busy,err,vld_out_0,vld_out_1,vld_out_2;
    
    wire fifo_full, rst_int_reg, detect_address, lfd_state, ld_state, laf_state, empty_0, empty_1, empty_2, full_0, full_1, full_2;
    wire [2:0] write_en;
    wire soft_reset_0, soft_reset_1, soft_reset_2, write_en_reg,full_state,parity_done,low_pkt_valid;
    wire [7:0] dout;
    
    router_reg register (.clk(clk),.rst(rst),.pkt_valid(pkt_valid),.data_in(data_in),.fifo_full(fifo_full),.rst_int_reg(rst_int_reg),.detect_addr(detect_address),.lfd_state(lfd_state),.ld_state(ld_state),.laf_state(laf_state),.full_state(full_state),.parity_done(parity_done),.low_pkt_valid(low_pkt_valid),.err(err),.dout(dout));
    router_fsm fsm (.rst(rst),.clk(clk),.pkt_valid(pkt_valid),.parity_done(parity_done),.data_in(data_in[1:0]),.soft_reset_0(soft_reset_0),.soft_reset_1(soft_reset_1),.soft_reset_2(soft_reset_2),.fifo_full(fifo_full),.low_pkt_valid(low_pkt_valid),.fifo_empty_0(empty_0),.fifo_empty_1(empty_1),.fifo_empty_2(empty_2),.busy(busy),.detect_address(detect_address),.ld(ld_state),.lfd(lfd_state),.laf(laf_state),.write_en_reg(write_en_reg),.rst_int_reg(rst_int_reg),.full_state(full_state));
    router_sync sync (.detect_address(detect_address), .data_in(data_in[1:0]), .write_en_reg(write_en_reg), .clk(clk), .rst(rst), .empty_0(empty_0), .empty_1(empty_1), .empty_2(empty_2), .full_0(full_0), .full_1(full_1), .full_2(full_2), .read_enb_0(read_en_0), .read_enb_1(read_en_1), .read_enb_2(read_en_2), .write_en(write_en), .vld_out_0(vld_out_0), .vld_out_1(vld_out_1), .vld_out_2(vld_out_2), .fifo_full(fifo_full), .soft_reset_0(soft_reset_0), .soft_reset_1(soft_reset_1), .soft_reset_2(soft_reset_2));
    router_fifo fifo_0(.clk(clk),.rst(rst),.write_en(write_en[0]),.read_enb(read_en_0),.soft_reset(soft_reset_0),.data_in(dout),.lfd_state(lfd_state),.empty(empty_0),.data_out(data_out_0),.full(full_0));
    router_fifo fifo_1(.clk(clk),.rst(rst),.write_en(write_en[1]),.read_enb(read_en_1),.soft_reset(soft_reset_1),.data_in(dout),.lfd_state(lfd_state),.empty(empty_1),.data_out(data_out_1),.full(full_1));
    router_fifo fifo_2(.clk(clk),.rst(rst),.write_en(write_en[2]),.read_enb(read_en_2),.soft_reset(soft_reset_2),.data_in(dout),.lfd_state(lfd_state),.empty(empty_2),.data_out(data_out_2),.full(full_2));
endmodule
