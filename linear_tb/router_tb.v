`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2025 20:21:27
// Design Name: 
// Module Name: router_top_tb
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


module router_top_tb();
    reg clk,rst,read_en_0,read_en_1,read_en_2,pkt_valid;
    reg [7:0] data_in;
    wire [7:0] data_out_0,data_out_1,data_out_2;
    wire busy,err,vld_out_0,vld_out_1,vld_out_2;
    
    router_top dut(clk,rst,read_en_0,read_en_1,read_en_2,pkt_valid,data_in,data_out_0,data_out_1,data_out_2,busy,err,vld_out_0,vld_out_1,vld_out_2);
    
    task clk_gen;
    begin
        forever #5 clk = ~clk;
    end
    endtask
    
    task rst_gen;
    begin
        rst = ~rst;
        #20;
    end
    endtask
    
    task initialize;
    begin
        clk = 1'b1;
        {rst,read_en_0,read_en_1,read_en_2,pkt_valid} = 5'b0;
        data_in = 8'b0;
        #20;
    end
    endtask
    
    task bad_pkt_8;
        reg[7:0] payload, parity, header;
        reg[5:0] payload_len;
        reg[1:0] addr;
    begin
        @(negedge clk);
        wait(~busy)
        payload_len = 8;
        parity = 1'b0;
        addr = 2'b01;
        pkt_valid = 1'b1;
        header = {payload_len,addr};
        data_in = header;
        @(negedge clk) 
        repeat(payload_len) begin
            @(negedge clk);
            payload = $random;
            data_in = payload;
        end
        parity = $random;
        @(negedge clk);
        wait(~busy)
        pkt_valid = 1'b0;
        data_in = parity;
    end
    endtask
    
        task good_pkt_8;
        reg[7:0] payload, parity, header;
        reg[5:0] payload_len;
        reg[1:0] addr;
    begin
        @(negedge clk);
        wait(~busy)
        payload_len = 8;
        parity = 1'b0;
        addr = 2'b00;
        pkt_valid = 1'b1;
        header = {payload_len,addr};
        data_in = header;
        parity = parity ^ header;
        @(negedge clk) 
        repeat(payload_len) begin
            @(negedge clk);
            payload = $random;
            data_in = payload;
            parity = parity ^ payload;
        end
        @(negedge clk);
        wait(~busy)
        pkt_valid = 1'b0;
        data_in = parity;
    end
    endtask
    
    task good_pkt_17;
        reg[7:0] payload, parity, header;
        reg[5:0] payload_len;
        reg [5:0] count;
        reg[1:0] addr;
    begin
        @(negedge clk);
        count = 1'b0;
        wait(~busy)
        payload_len = 17;
        parity = 1'b0;
        addr = 2'b10;
        pkt_valid = 1'b1;
        header = {payload_len,addr};
        data_in = header;
        parity = parity ^ header;
        @(negedge clk) 
        repeat(payload_len) begin
            @(negedge clk);
            count = count + 1'b1;
            payload = $random;
            data_in = payload;
            parity = parity ^ payload;
            if(count > 15) begin
                read_en_2 = 1'b1;
            end
            else read_en_2 = 1'b0;
        end
        @(negedge clk);
        wait(~busy)
        pkt_valid = 1'b0;
        data_in = parity;
    end
    endtask
    
    task stimulus(input x, input y, input z);
    begin
       read_en_0 = x;
       read_en_1 = y;
       read_en_2 = z;
       #20;
    end
    endtask
    
    initial begin
        clk_gen;
    end
    
    initial begin
        initialize;
        rst_gen;
        good_pkt_8;
        stimulus(1,0,0);
        #100;
        bad_pkt_8;
        stimulus(0,1,0);
        #100;
        good_pkt_17;
        stimulus(0,0,1);
        #100 $finish(2);
    end
endmodule
