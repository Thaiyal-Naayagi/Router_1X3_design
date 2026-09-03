class slave_seq_item extends uvm_sequence_item;
        `uvm_object_utils(slave_seq_item)

        extern function new(string name="slave_seq_item");
        extern function void do_copy(uvm_object rhs);
        extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        extern function void do_print(uvm_printer printer);


        //signals
        bit read_enb, pkt_valid_out; //used from the interface itself
        logic [7:0] header;
        logic [7:0] data_out[];
        logic [7:0] parity;
        rand int delay;

        constraint delay_const{
                delay inside {[1:40]};
        }

endclass

function slave_seq_item::new(string name="slave_seq_item");
        super.new(name);
endfunction

function void slave_seq_item::do_copy(uvm_object rhs);
//      super.do_copy(rhs);
        slave_seq_item rhs_;
        assert($cast(rhs_,rhs));
        super.do_copy(rhs);
        this.read_enb = rhs_.read_enb;
        this.pkt_valid_out = rhs_.pkt_valid_out;
        this.header = rhs_.header;
        this.data_out = new[header[7:2]];
        foreach(data_out[i]) begin
                this.data_out[i] = rhs_.data_out[i];
        end
        this.parity = rhs_.parity;
endfunction

function bit slave_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
//      super.do_compare(rhs,comparer);
        slave_seq_item rhs_;
        bit flag = 0;
        assert($cast(rhs_,rhs));
        super.do_compare(rhs,comparer);
        flag = (this.read_enb == rhs_.read_enb) && (this.pkt_valid_out == rhs_.pkt_valid_out) && (this.header == rhs_.header) && (this.data_out.size() == rhs_.data_out.size()) && (this.parity == rhs_.parity);

        foreach(data_out[i]) begin
                flag = flag && (this.data_out[i] == rhs_.data_out[i]);
        end

        return flag;
endfunction

function void slave_seq_item::do_print(uvm_printer printer);
        super.do_print(printer);

        printer.print_field("read_enb",this.read_enb,1,UVM_DEC);
        printer.print_field("pkt_valid_out",this.pkt_valid_out,1,UVM_DEC);
        printer.print_field("header",this.header,8,UVM_DEC);
        foreach(data_out[i]) begin
                printer.print_field($sformatf("data_out[%0d]",i),this.data_out[i],8,UVM_DEC);
        end
        printer.print_field("parity",this.parity,8,UVM_DEC);
endfunction
