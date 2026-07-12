`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.08.2025 11:24:25
// Design Name: 
// Module Name: router_fsm
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


module router_fsm(rst,clk,pkt_valid,parity_done,data_in,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,busy,detect_address,ld,lfd,laf,write_en_reg,rst_int_reg,full_state);
    input rst,clk,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
    input [1:0] data_in;
    output busy,detect_address,ld,lfd,laf,write_en_reg,rst_int_reg,full_state;
    
    //fsm coding style 03
    
    parameter [2:0] decode_address = 3'b0, load_first_data = 3'b1, load_data = 3'b10, wait_till_empty = 3'b11, load_parity = 3'b100, check_parity_error = 3'b101, fifo_full_state = 3'b110, load_after_full = 3'b111;
    reg [1:0] addr;
    reg [2:0] present_state, next_state;
    
    
    //to check the previously used fifo with the help of addr variable
    always @(posedge clk) begin
        if(!rst) addr <= 2'b11;
        else if(decode_address) addr <= data_in;
        else addr <= 2'b11;
    end
    
    //sequential present state
    always @(posedge clk or negedge rst)
    begin
        if(!rst) present_state <= decode_address;
        else if ( (soft_reset_0 && (data_in == 2'b00)) || (soft_reset_1 && (data_in == 2'b01)) || (soft_reset_2 && (data_in == 2'b10)) ) present_state <= decode_address;
        else present_state <= next_state;
    end
    
    //combinational next state
    always @(*)
    begin
        next_state = decode_address;
        case(present_state)
        
            decode_address:begin
                           if((pkt_valid && (data_in == 2'b00) && fifo_empty_0) || (pkt_valid && (data_in == 2'b01) && fifo_empty_1) || (pkt_valid && (data_in == 2'b10) && fifo_empty_2)) next_state = load_first_data;
                           else if((pkt_valid && (data_in == 2'b00) && !fifo_empty_0) || (pkt_valid && (data_in == 2'b01) && !fifo_empty_1) || (pkt_valid && (data_in == 2'b10) && !fifo_empty_2)) next_state = wait_till_empty;
                           end
            load_first_data: next_state = load_data;
            
            load_data: begin
                       if(!pkt_valid && !fifo_full) next_state = load_parity;
                       else if(fifo_full) next_state = fifo_full_state;
                       else next_state = load_data;
                       end
            
            load_parity: next_state = check_parity_error;
            
            check_parity_error: begin
                                if(!fifo_full) next_state = decode_address;
                                else next_state = fifo_full_state;
                                end
            
            fifo_full_state: begin
                             if(!fifo_full) next_state = load_after_full;
                             else next_state = fifo_full_state;
                             end
             
            load_after_full: begin
                              if(parity_done) next_state = decode_address;
                              else if(!parity_done && !low_pkt_valid) next_state = load_data;
                              else if(!parity_done && low_pkt_valid) next_state = load_parity;
                             end
                             
            
            wait_till_empty: begin
                             if((pkt_valid && (addr == 2'b00) && fifo_empty_0) || (pkt_valid && (addr == 2'b01) && fifo_empty_1) || (pkt_valid && (addr == 2'b10) && fifo_empty_2)) next_state = load_first_data;
                             else next_state = wait_till_empty;
                             end
        endcase
    end
    
    //output state
    
    assign busy = ((present_state == load_first_data) || (present_state == load_parity) || (present_state == check_parity_error) || (present_state == fifo_full_state) || (present_state == load_after_full) || (present_state == wait_till_empty));
    assign detect_address = (present_state == decode_address);
    assign ld = (present_state == load_data);
    assign lfd = (present_state == load_first_data);
    assign laf = (present_state == load_after_full);
    assign write_en_reg = ((present_state == load_data) || (present_state == load_parity) || (present_state == load_after_full));
    assign rst_int_reg = (present_state == check_parity_error);
    assign full_state = (present_state == fifo_full_state);
//    always @(*) begin
//        if(!rst) {busy,detect_address,ld,lfd,laf,write_en_reg,rst_int_reg,full_state} = 8'b0;
//        else begin
//        case(present_state)
        
//            decode_address: {busy,detect_address,ld,lfd,laf,write_en_reg,rst_int_reg,full_state} = 01000000;
            
//            load_first_data: {busy,detect_address,ld,lfd,laf,write_en_reg,rst_int_reg,full_state} = 10010000;
            
//            load_data: {busy,detect_address,ld,lfd,laf,write_en_reg,rst_int_reg,full_state} = 00100100;
            
//            load_parity: {busy,detect_address,ld,lfd,laf,write_en_reg,rst_int_reg,full_state} = 10000100;
            
//            check_parity_error: {busy,detect_address,ld,lfd,laf,write_en_reg,rst_int_reg,full_state} = 10000010;
            
//            fifo_full_state: {busy,detect_address,ld,lfd,laf,write_en_reg,rst_int_reg,full_state} = 10000001;
             
//            load_after_full: {busy,detect_address,ld,lfd,laf,write_en_reg,rst_int_reg,full_state} = 10000100;
                             
//            wait_till_empty: {busy,detect_address,ld,lfd,laf,write_en_reg,rst_int_reg,full_state} = 10000000;
            
//        endcase       
//        end
//    end
endmodule
