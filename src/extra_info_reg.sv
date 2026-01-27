class extra_info_reg extends uvm_reg;
  `uvm_object_utils(extra_info_reg)
 
rand uvm_reg_field extra_info;
 
  function new(string name="extra_info_reg");
super.new(name,32,UVM_CVR_FIELD_VALS);
endfunction
 
function void build;
extra_info=uvm_reg_field::type_id::create("extra_info");
extra_info.configure(.parent(this),.size(32),.lsb_pos(0),.access("RW"),.volatile(0),.reset(32'b0),.has_reset(1),.is_rand(1),.individually_accessible(1));
 
endfunction
 
endclass
