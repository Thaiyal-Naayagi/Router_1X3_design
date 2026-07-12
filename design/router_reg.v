`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2025 11:17:51
// Design Name: 
// Module Name: router_reg
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


module router_reg(clk,rst,pkt_valid,data_in,fifo_full,rst_int_reg,detect_addr,lfd_state,ld_state,laf_state,full_state,parity_done,low_pkt_valid,err,dout);
    input clk,rst,pkt_valid,fifo_full,rst_int_reg,detect_addr,lfd_state,ld_state,laf_state,full_state;
    input [7:0] data_in;
    output reg parity_done,low_pkt_valid,err;
    output reg [7:0] dout;
    
    reg [7:0] header_byte, fifo_full_byte, internal_parity, packet_parity;
    
    //header byte logic
    always @(posedge clk) begin
       if(!rst) header_byte <= 0;
       else if(pkt_valid && detect_addr && data_in[1:0] != 2'b11)  begin
            header_byte <= data_in;
       end
       else header_byte <= data_in;
    end
    
    //fifo full logic
    always @(posedge clk) begin
        if(!rst) fifo_full_byte <= 0;
        else if(full_state) begin
            fifo_full_byte <= data_in;
        end
    end
    
    // output logic
    always @(posedge clk) begin
        if(!rst) dout <= 0;
        else if(lfd_state) dout <= header_byte;
        else if(laf_state) dout <= fifo_full_byte;
        else if(ld_state && !fifo_full) dout <= data_in;
        else dout <= dout;
    end
    
    //parity done
    always @(posedge clk) begin
        if(!rst) parity_done <= 1'b0;
        else if(laf_state && low_pkt_valid && !parity_done) parity_done <= 1;
        else if(ld_state && !pkt_valid && !fifo_full) parity_done <= 1;
        else if(detect_addr) parity_done <= 0; 
    end
    
    //low_pkt_valid to check the pkt_valid
    always @(posedge clk) begin
        if(!rst) low_pkt_valid <= 1'b0;
        else if(ld_state && !pkt_valid) begin
            low_pkt_valid <= 1;
        end
        else low_pkt_valid <= low_pkt_valid;
    end
    
    //packet parity
    always @(posedge clk) begin
        if(!rst) packet_parity <= 0;
        else if(laf_state && low_pkt_valid && !parity_done) begin
            packet_parity <= data_in;
        end
        else if(ld_state && !pkt_valid && !fifo_full) begin
            packet_parity <= data_in;
        end
        else if(detect_addr) begin
            packet_parity <= 0;
        end
    end
    
    //internal parity
    always @(posedge clk) begin
        if(!rst) internal_parity <= 0;
        else if(lfd_state) begin 
            internal_parity <= header_byte;
        end
        else if(ld_state && pkt_valid && !fifo_full) begin
            internal_parity <= internal_parity ^ data_in;
        end
        else if(!pkt_valid && rst_int_reg) begin
         internal_parity <= 0;
        end
    end
    
    //error logic
    always @(posedge clk) begin
        if(internal_parity != packet_parity && parity_done) err <= 1'b1;
        else err <= 1'b0;
    end
    
endmodule
