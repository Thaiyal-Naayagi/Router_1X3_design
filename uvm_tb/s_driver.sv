class slave_driver extends uvm_driver#(slave_seq_item);
        `uvm_component_utils(slave_driver)

        virtual router_intf.S_DRV vif;
        slave_config s_cfg;
        int timeout = 0;


        extern function new(string name="slave_driver", uvm_component parent=null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task drive(slave_seq_item req);
        extern function void report_phase(uvm_phase phase);

endclass

function slave_driver::new(string name="slave_driver", uvm_component parent=null);
        super.new(name,parent);
endfunction

function void slave_driver::build_phase(uvm_phase phase);
        super.build_phase(phase);
        //assert(uvm_config_db#(virtual router_intf)::get(this,"","router_intf",vif));
        assert(uvm_config_db#(slave_config)::get(this,"","slave_config",s_cfg));
endfunction

function void slave_driver::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = s_cfg.vif;
endfunction

task slave_driver::run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
                seq_item_port.get_next_item(req);
                drive(req);
                seq_item_port.item_done();
        end
endtask

task slave_driver::drive(slave_seq_item req);
        @(vif.s_drv_cb);
        `uvm_info("S_DRV",$sformatf("Waiting for packet pkt_valid_out=%b",vif.s_drv_cb.pkt_valid_out),UVM_LOW)
        while(vif.s_drv_cb.pkt_valid_out == 0) @(vif.s_drv_cb);
        `uvm_info("S_DRV","Asserting read_enb",UVM_NONE)
        repeat(req.delay) @(vif.s_drv_cb);
        vif.s_drv_cb.read_enb <= 1;
        while(vif.s_drv_cb.pkt_valid_out == 1) @(vif.s_drv_cb);
        `uvm_info("S_DRV","Deasserting read_enb",UVM_NONE)
        vif.s_drv_cb.read_enb <= 0;
        s_cfg.s_drv_count++;
        @(vif.s_drv_cb);

endtask

function void slave_driver::report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("S_DRV",$sformatf("no of transactions %0d",s_cfg.s_drv_count),UVM_LOW)
endfunction
