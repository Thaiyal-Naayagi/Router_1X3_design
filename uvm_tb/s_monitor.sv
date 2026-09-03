class slave_monitor extends uvm_monitor;
        `uvm_component_utils(slave_monitor)

        uvm_analysis_port #(slave_seq_item) an_port;
        slave_seq_item req;
        slave_config s_cfg;

        virtual router_intf.S_MON vif;
        extern function new(string name="slave_monitor", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task monitor(slave_seq_item req);
        extern function void report_phase(uvm_phase phase);

endclass

function slave_monitor::new(string name="slave_monitor", uvm_component parent=null);
        super.new(name,parent);
//      an_port = new("an_port",this);
endfunction

function void slave_monitor::build_phase(uvm_phase phase);
        super.build_phase(phase);
        //assert(uvm_config_db#(virtual router_intf)::get(this,"","router_intf",vif));
        assert(uvm_config_db#(slave_config)::get(this,"","slave_config",s_cfg));
        an_port = new("an_port",this);
endfunction

function void slave_monitor::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = s_cfg.vif;
endfunction


task slave_monitor::run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
                req = slave_seq_item::type_id::create("req");
                monitor(req);
                an_port.write(req);
        end
endtask

task slave_monitor::monitor(slave_seq_item req);
        @(vif.s_mon_cb);
        while(vif.s_mon_cb.read_enb == 0) @(vif.s_mon_cb);
        `uvm_info("S_MON","read_enb detected",UVM_NONE)

        `uvm_info("DBG_SLAVE_MON", $sformatf("time=%0t read_enb=%0b  data_out=%0d", $time, vif.s_mon_cb.read_enb,  vif.s_mon_cb.data_out), UVM_NONE)

        @(vif.s_mon_cb);
        req.header = vif.s_mon_cb.data_out;
        req.data_out = new[req.header[7:2]];
        @(vif.s_mon_cb);
        foreach(req.data_out[i]) begin
                req.data_out[i] = vif.s_mon_cb.data_out;
                @(vif.s_mon_cb);
        end

        req.parity = vif.s_mon_cb.data_out;
        @(vif.s_mon_cb);
        `uvm_info("S_MON","PKT FROM MON",UVM_LOW)
        req.print();
        s_cfg.s_mon_count++;

endtask

function void slave_monitor::report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("S_MON",$sformatf("no of transactions %0d",s_cfg.s_mon_count),UVM_LOW)
endfunction
