class master_config extends uvm_object;
        `uvm_object_utils(master_config);

        uvm_active_passive_enum is_active = UVM_ACTIVE;
        virtual router_intf vif;
        int no_of_agent = 1;

        static int m_drv_count = 0;
        static int m_mon_count = 0;

        extern function new(string name="master_config");
endclass

function master_config::new(string name="master_config");
        super.new(name);
endfunction
