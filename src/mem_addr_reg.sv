class mem_addr_reg extends uvm_reg;
  `uvm_object_utils(mem_addr_reg)
 
rand uvm_reg_field mem_addr;
 
  function new(string name="mem_addr_reg");
super.new(name,32,UVM_CVR_FIELD_VALS);
endfunction
 
function void build;
mem_addr=uvm_reg_field::type_id::create("mem_addr");
mem_addr.configure(.parent(this),.size(32),.lsb_pos(0),.access("RW"),.volatile(0),.reset(32'b0),.has_reset(1),.is_rand(1),.individually_accessible(1));
endfunction
endclass
 
