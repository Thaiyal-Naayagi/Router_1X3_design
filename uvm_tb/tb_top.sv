`include "interface.sv"

module router_tb_top;
        `include "uvm_macros.svh"
//      `include "router_interface.sv"
        import uvm_pkg::*;
        import pkg::*;

        bit clk;
        router_intf m_intf(clk);
        router_intf s_intf_0(clk);
        router_intf s_intf_1(clk);
        router_intf s_intf_2(clk);

        router_top dut(.clk(clk), .rst(m_intf.rst_n), .pkt_valid(m_intf.pkt_valid), .data_in(m_intf.data_in), .busy(m_intf.busy), .err(m_intf.error), .read_en_0(s_intf_0.read_enb), .read_en_1(s_intf_1.read_enb), .read_en_2(s_intf_2.read_enb), .vld_out_0(s_intf_0.pkt_valid_out), .vld_out_1(s_intf_1.pkt_valid_out), .vld_out_2(s_intf_2.pkt_valid_out), .data_out_0(s_intf_0.data_out), .data_out_1(s_intf_1.data_out), .data_out_2(s_intf_2.data_out));

        initial begin
                clk = 1'b0;
                forever #5 clk = ~clk;
        end

        initial begin
                uvm_config_db#(virtual router_intf)::set(null,"*","m_router_intf",m_intf);
                uvm_config_db#(virtual router_intf)::set(null,"*","s_router_intf_0",s_intf_0);
                uvm_config_db#(virtual router_intf)::set(null,"*","s_router_intf_1",s_intf_1);
                uvm_config_db#(virtual router_intf)::set(null,"*","s_router_intf_2",s_intf_2);
                run_test();
        end

property pkt_valid;
        @(posedge clk) $rose(m_intf.pkt_valid) |=> m_intf.busy;
endproperty

property pkt_vld_out_0;
        bit [1:0] addr;
        @(posedge clk) ($rose(m_intf.pkt_valid),addr=m_intf.data_in[1:0]) ##3 (addr == 2'b00) |-> s_intf_0.pkt_valid_out;
endproperty

property pkt_vld_out_1;
        bit [1:0] addr;
        @(posedge clk) ($rose(m_intf.pkt_valid),addr=m_intf.data_in[1:0]) ##3 (addr == 2'b01) |-> s_intf_1.pkt_valid_out;
endproperty

property pkt_vld_out_2;
        bit [1:0] addr;
        @(posedge clk) ($rose(m_intf.pkt_valid),addr=m_intf.data_in[1:0]) ##3 (addr == 2'b10) |-> s_intf_2.pkt_valid_out;
endproperty

property stable_data;
        @(posedge clk) (m_intf.busy == 1) |=> $stable(m_intf.data_in);
endproperty

property soft_reset_0;
        bit [1:0] addr;
        @(posedge clk) ($rose(m_intf.pkt_valid),addr = m_intf.data_in[1:0]) ##3 (addr == 2'b00) |=> ##[0:28] s_intf_0.read_enb;
endproperty

property soft_reset_1;
        bit [1:0] addr;
        @(posedge clk) ($rose(m_intf.pkt_valid),addr = m_intf.data_in[1:0]) ##3 (addr == 2'b01) |=> ##[0:28] s_intf_1.read_enb;
endproperty

property soft_reset_2;
        bit [1:0] addr;
        @(posedge clk) ($rose(m_intf.pkt_valid),addr = m_intf.data_in[1:0]) ##3 (addr == 2'b10) |=> ##[0:28] s_intf_2.read_enb;
endproperty

assert property (pkt_valid);
assert property (pkt_vld_out_0);
assert property (pkt_vld_out_1);
assert property (pkt_vld_out_2);
assert property (stable_data);
assert property (soft_reset_0);
assert property (soft_reset_1);
assert property (soft_reset_2);


endmodule
