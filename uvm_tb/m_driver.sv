class master_driver extends uvm_driver#(master_seq_item);
        `uvm_component_utils(master_driver)
        virtual router_intf.M_DRV vif;
        master_config m_cfg;

        extern function new(string name="master_driver", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task drive(master_seq_item req);
        extern function void report_phase(uvm_phase phase);
endclass

function master_driver::new(string name="master_driver", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void master_driver::build_phase(uvm_phase phase);
        super.build_phase(phase);
//      assert(uvm_config_db#(virtual router_intf)::get(this,"","router_intf",vif));
        assert(uvm_config_db#(master_config)::get(this,"","master_config",m_cfg));
endfunction

function void master_driver::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = m_cfg.vif;
endfunction

task master_driver::run_phase(uvm_phase phase);
        vif.m_drv_cb.rst_n <= 0;
        @(vif.m_drv_cb);
        vif.m_drv_cb.rst_n <= 1;

        forever begin
                seq_item_port.get_next_item(req);
                drive(req);
                seq_item_port.item_done();
        end
endtask

task master_driver::drive(master_seq_item req);

        @(vif.m_drv_cb);
        while(vif.m_drv_cb.busy == 1) @(vif.m_drv_cb);
        vif.m_drv_cb.pkt_valid <= 1;
        vif.m_drv_cb.data_in <= req.header;
        `uvm_info("M_DRV",$sformatf("Driving header=%0d pkt_valid=%b",req.header, req.pkt_valid),UVM_LOW)
        @(vif.m_drv_cb);

        foreach(req.data_in[i]) begin
                while(vif.m_drv_cb.busy == 1) @(vif.m_drv_cb);
                vif.m_drv_cb.data_in <= req.data_in[i];
                @(vif.m_drv_cb);

        end

        while(vif.m_drv_cb.busy == 1) @(vif.m_drv_cb);
        vif.m_drv_cb.pkt_valid <= 0;
        vif.m_drv_cb.data_in <= req.parity;
        m_cfg.m_drv_count++;
        `uvm_info("M_DRV","PKT FROM DRV",UVM_LOW)
        req.print();
endtask

function void master_driver::report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("M_DRV",$sformatf("no of transactions %0d",m_cfg.m_drv_count),UVM_LOW)
endfunction
