package pkg;
        `include "uvm_macros.svh"
        import uvm_pkg::*;

        `include "m_config.sv"
        `include "s_config.sv"
        `include "env_config.sv"

        `include "m_seq_item.sv"
        `include "s_seq_item.sv"

        `include "m_seq.sv"
        `include "s_seq.sv"

        `include "m_seqr.sv"
        `include "s_seqr.sv"

        `include "virtual_seqr.sv"
        `include "virtual_seq.sv"

        `include "m_driver.sv"
        `include "s_driver.sv"

        `include "m_monitor.sv"
        `include "s_monitor.sv"

        `include "m_agent.sv"
        `include "s_agent.sv"

        `include "m_agt_top.sv"
        `include "s_agt_top.sv"
        `include "scoreboard.sv"

        `include "env.sv"
        `include "test.sv"
endpackage
