`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2025 11:38:43
// Design Name: 
// Module Name: synchronizer
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


    module router_sync(detect_address, data_in, write_en_reg, clk, rst, empty_0, empty_1, empty_2, full_0, full_1, full_2, read_enb_0, read_enb_1, read_enb_2, write_en, vld_out_0, vld_out_1, vld_out_2, fifo_full, soft_reset_0, soft_reset_1, soft_reset_2);

    input detect_address, write_en_reg, clk, rst, empty_0, empty_1, empty_2, read_enb_0, read_enb_1, read_enb_2, full_0, full_1, full_2;
    input [1:0] data_in;
    output reg [2:0] write_en;
    output vld_out_0, vld_out_1, vld_out_2;
    output reg  fifo_full, soft_reset_0, soft_reset_1, soft_reset_2;
    
    reg [4:0] count_0, count_1, count_2;
    reg [1:0] temp;
    
    //valid out based on whether the fifo is empty or not, if it is not empty then it become valid and the valid out is used to generate read_en in fsm
    assign vld_out_0 = ~empty_0;
    assign vld_out_1 = ~empty_1;
    assign vld_out_2 = ~empty_2;
   
   // based on data in value, it decides which fifo's full value to be assigned
    always @(*) begin
        fifo_full = 0;
    case(temp)
        2'b00: fifo_full = full_0;
        2'b01: fifo_full = full_1;
        2'b10: fifo_full = full_2;
        //default: fifo_full = 0;
    endcase
    end

    // assign data_in to temp based on detect address
    always @(posedge clk) begin
        if(!rst) temp <= 2'b11;
        else if(detect_address) temp <= data_in;
    end
    
    //based on write_en_reg and data in any one of three fifo will be enabled 
    always @(*) begin
        write_en = 3'b000;
        if(write_en_reg) begin
            case(temp)
                2'b00: write_en = 3'b001;
                2'b01: write_en = 3'b010;
                2'b10: write_en = 3'b100;
                //default: write_en = 3'b000;
            endcase
        end
    end
    
    //soft reset conditions
    
    always @(posedge clk)begin
        if(!rst) begin 
            count_0 <= 1'b0;
            soft_reset_0 <= 1'b0;
        end
         else if(vld_out_0) begin
            soft_reset_0 <= 1'b0;
            if(!read_enb_0) begin
             count_0 <= count_0 + 1'b1;
             
                if(count_0 == 29) begin
                   count_0 <= 1'b0;
                   soft_reset_0 <= 1'b1;
                end
            
            end
            else count_0 <= 1'b0; 
         end
         else begin
            count_0 <= 1'b0;
            soft_reset_0 <= 1'b0;
         end 
    end

    always @(posedge clk)begin
         if(!rst) begin
          count_1 = 1'b0;
          soft_reset_1 = 1'b0;
         end
         else if(vld_out_1) begin
            soft_reset_1 <= 1'b0;
            if(!read_enb_1) begin
             count_1 <= count_1 + 1'b1;
             
                if(count_1 == 29) begin
                   count_1 <= 1'b0;
                   soft_reset_1 <= 1'b1;
                end
            
            end
            else count_1 <= 1'b0; 
         end
         else begin
            count_1 <= 1'b0;
            soft_reset_1 <= 1'b0;
         end 
    end

    always @(posedge clk)begin
         if(!rst) begin
          count_2 = 1'b0;
          soft_reset_2 = 1'b0;
         end
         else if(vld_out_2) begin
            soft_reset_2 <= 1'b0;
            if(!read_enb_2) begin
             count_2 <= count_2 + 1'b1;
             
                if(count_2 == 29) begin
                   count_2 <= 1'b0;
                   soft_reset_2 <= 1'b1;
                end
            
            end
            else count_2 <= 1'b0; 
         end
         else begin
            count_2 <= 1'b0;
            soft_reset_2 <= 1'b0;
         end 
    end
    
endmodule 
