`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.08.2025 18:25:21
// Design Name: 
// Module Name: router_fifo
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



module router_fifo(clk,rst,write_en,read_enb,soft_reset,data_in,lfd_state,empty,data_out,full);
    input clk,rst,write_en,soft_reset,read_enb,lfd_state;
    input [7:0] data_in;
    output empty, full;
    output reg [7:0]data_out;
    
    reg [6:0] count;
    reg [3:0] read_ptr, write_ptr;
    reg temp;
    reg [8:0] mem[15:0];
    integer i;
    
    assign full = ( (write_ptr + 1'b1) == read_ptr) ? 1'b1: 1'b0;
    assign empty = (write_ptr == read_ptr) ? 1'b1 : 1'b0;
    
    //lfd state to be given to msb of each data_in
    always @(posedge clk) begin
        if(!rst) temp <= 0;
        else temp <= lfd_state;
    end
    
    //read logic
    always @(posedge clk) begin
        if(!rst)begin
         data_out<=8'bz;
         read_ptr <= 0;
        end
        else if(soft_reset) data_out <= 8'bz;
        if(count == 0) data_out <= 8'bz;
        else begin
            if(read_enb && !empty) begin
                data_out <= mem[read_ptr][7:0];
                read_ptr <= read_ptr + 1'b1;
            end
            else data_out <= data_out;
        end
    end
    
    //write logic
    always @(posedge clk) begin
        if(!rst) begin
            for(i=0;i<16;i=i+1)begin
                mem[i] <= 0;
                write_ptr <= 0;
            end
        end
        else if(soft_reset) begin
            for(i=0;i<16;i=i+1) mem[i]<=0;
            write_ptr <= 0;
        end
        else begin
            if(write_en && !full) begin
                mem[write_ptr] <= {temp,data_in};
                write_ptr <= write_ptr + 1'b1;
            end
            else write_ptr <= write_ptr;
        end
    end
    
    //count logic
    always @(posedge clk) begin
        if(!rst) count <= 0;
        else if(soft_reset) count <= 0;
        else if(mem[read_ptr][8] == 1) count <= mem[read_ptr][7:2] + 1'b1;
        else if(read_enb && !empty) count <= count - 1;
    end
   
endmodule
