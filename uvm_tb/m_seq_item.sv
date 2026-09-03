class master_seq_item extends uvm_sequence_item;
        `uvm_object_utils(master_seq_item)

        extern function new(string name="master_seq_item");
        extern function void do_copy(uvm_object rhs);
        extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        extern function void do_print(uvm_printer printer);
        extern function void post_randomize();

        //signals
        rand bit rst_n;
        bit pkt_valid;
        rand bit [7:0] header;
        rand bit [7:0] data_in[];
        bit [7:0] parity;     //data_in divided into 3 based on the input protocol
        bit busy, error;

        //constraints

        constraint distribution{
                rst_n dist {0:=30, 1:=70};
        }

        constraint data_packet{
                header[1:0] != 2'b11;
                data_in.size() == header[7:2];
                data_in.size() != 0;
        }

endclass

function master_seq_item::new(string name="master_seq_item");
        super.new(name);
endfunction

function void master_seq_item::do_copy(uvm_object rhs);
        //super.do_copy(rhs);
        master_seq_item rhs_;
        assert($cast(rhs_,rhs));
        super.do_copy(rhs);
        this.rst_n = rhs_.rst_n;
        this.pkt_valid = rhs_.pkt_valid;
        this.header = rhs_.header;
        this.data_in = new[rhs_.data_in.size()];
        foreach(data_in[i]) begin
                this.data_in[i] = rhs_.data_in[i];
        end
        this.parity = rhs_.parity;
        this.busy = rhs_.busy;
        this.error = rhs_.error;
endfunction

function void master_seq_item::post_randomize();
        parity = header;
        foreach(data_in[i]) begin
                parity = parity ^ data_in[i];
        end
endfunction

function bit master_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
        //if(!super.do_compare(rhs,comparer)) return 0;
        master_seq_item rhs_;
        bit flag = 0;
        assert($cast(rhs_,rhs));
        super.do_compare(rhs,comparer);
        flag = (this.header == rhs_.header) && (this.pkt_valid == rhs_.pkt_valid) && (this.parity == rhs_.parity) && (this.busy == rhs_.busy) && (this.error == rhs_.error) && (this.data_in.size() == rhs_.data_in.size());
        if(flag) begin
                foreach(data_in[i]) flag = flag && (this.data_in[i] == rhs_.data_in[i]);
                return flag;
        end
        else return flag;
endfunction

function void master_seq_item::do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field("rst_n",this.rst_n,1,UVM_DEC);
        printer.print_field("header",this.header,8,UVM_DEC);
        printer.print_field("pkt_valid",this.pkt_valid,1,UVM_DEC);
        foreach(data_in[i]) printer.print_field($sformatf("data_in[%0d]",i),this.data_in[i],8,UVM_DEC);
        printer.print_field("parity",this.parity,8,UVM_DEC);
        printer.print_field("busy",this.busy,1,UVM_DEC);
        printer.print_field("error",this.error,1,UVM_DEC);
endfunction
