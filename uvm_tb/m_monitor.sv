class master_monitor extends uvm_monitor;
        `uvm_component_utils(master_monitor)
        uvm_analysis_port#(master_seq_item) an_port;

        virtual router_intf.M_MON vif;
        master_config m_cfg;
        master_seq_item req;

        extern function new(string name="master_monitor", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task monitor(master_seq_item req);
        extern function void report_phase(uvm_phase phase);
endclass

function master_monitor::new(string name="master_monitor", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void master_monitor::build_phase(uvm_phase phase);
        super.build_phase(phase);
//      assert(uvm_config_db#(virtual router_intf)::get(this,"","router_intf",vif));
        assert(uvm_config_db#(master_config)::get(this,"","master_config",m_cfg));
        an_port = new("an_port",this);
endfunction

function void master_monitor::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = m_cfg.vif;
endfunction

task master_monitor::run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
                req = master_seq_item::type_id::create("req");
                monitor(req);
                an_port.write(req);
        end
endtask

task master_monitor::monitor(master_seq_item req);
        @(vif.m_mon_cb);
        req.rst_n = vif.m_mon_cb.rst_n;
//      req.pkt_valid = vif.m_mon_cb.pkt_valid;

        while(vif.m_mon_cb.pkt_valid == 0 || vif.m_mon_cb.busy == 1) @(vif.m_mon_cb);
        `uvm_info("DBG_MASTER_MON", $sformatf("time=%0t data_in=%0d", $time,  vif.m_mon_cb.data_in), UVM_NONE)

        req.header = vif.m_mon_cb.data_in;
        req.data_in = new[req.header[7:2]];

        foreach(req.data_in[i]) begin
                @(vif.m_mon_cb);
                while(vif.m_mon_cb.busy == 1) @(vif.m_mon_cb);
                req.data_in[i] = vif.m_mon_cb.data_in;
        end

        @(vif.m_mon_cb);
        while(vif.m_mon_cb.busy == 1 || vif.m_mon_cb.pkt_valid == 1) @(vif.m_mon_cb);
        req.parity = vif.m_mon_cb.data_in;
        repeat(2) @(vif.m_mon_cb);
        req.error = vif.m_mon_cb.error;
        m_cfg.m_mon_count++;
        `uvm_info("M_MON","PKT FROM MON",UVM_LOW)
        req.print();

endtask

function void master_monitor::report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("M_MON",$sformatf("no of transactions %0d",m_cfg.m_mon_count),UVM_LOW)
endfunction
