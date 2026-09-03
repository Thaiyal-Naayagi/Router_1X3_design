class slave_config extends uvm_object;
        `uvm_object_utils(slave_config);

        uvm_active_passive_enum is_active = UVM_ACTIVE;
        int no_of_agent = 1;
        virtual router_intf vif;

        static int s_drv_count = 0;
        static int s_mon_count = 0;

        extern function new(string name="slave_config");
endclass

function slave_config::new(string name="slave_config");
        super.new(name);
endfunction
