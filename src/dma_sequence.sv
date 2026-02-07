class dma_sequence extends uvm_sequence #(dma_seq_item);
  `uvm_object_utils(dma_sequence)

  dma_reg_block reg_block;
  uvm_status_e status;
//uvm_reg_data_t data;

  function new(string name = "dma_sequence");
    super.new(name);
  endfunction
  
  task pre_body();
    if(starting_phase != null)
      starting_phase.raise_objection(this);
  endtask
  
   task post_body();
    if(starting_phase != null)
      starting_phase.drop_objection(this);
  endtask

  virtual task body();
    
 	 `uvm_info(get_type_name(), "Starting DMA Sequence", UVM_MEDIUM)
    
  /*  read_write_reg(reg_block.mem_addr_inst, status, 32'hDEADBEEF);
    read_write_reg(reg_block.ctrl_inst, status, 32'h0001DEF0);
    read_write_reg(reg_block.io_addr_inst, status, 32'h12345678);
    read_write_reg(reg_block.extra_info_inst, status, 32'hABCDEF00);
    read_write_reg(reg_block.descriptor_addr_inst, status, 32'h11223344);
    read_write_reg(reg_block.config_inst, status, 32'h00000055);
    read_write_reg(reg_block.intr_inst, status, 32'hDEAD0000);
    
    read_only_reg(reg_block.status_inst, status);
    read_only_reg(reg_block.intr_inst, status);
    read_only_reg(reg_block.transfer_count_inst, status);

    write_1_clear_reg(reg_block.error_status_inst, status, 32'h0000001B);
    */
    
    `uvm_info(get_type_name(), "DMA Sequence Completed", UVM_MEDIUM)
  endtask
  
  //-------------------------VERIFICATION FOR READ WRITE REGISTERS--------------------------------------//
                              
virtual task read_write_reg(uvm_reg register_inst, uvm_status_e status, uvm_reg_data_t write_data);
    uvm_reg_data_t des;
    uvm_reg_data_t mir;
    uvm_reg_data_t read_data_fd;
    uvm_reg_data_t read_data_bd;
    string reg_name;
    write_data = write_data & 32'hFFFFFFFF;
  
  //----------------------------------------WRITING ONTO FROM THE FRONTDOOR----------------------------------------//
    
    reg_name = register_inst.get_name();
  `uvm_info(get_type_name(), $sformatf("------ Testing RW Register: %s -----", reg_name), UVM_MEDIUM)
    
  `uvm_info(get_type_name(), $sformatf("Writing to %s: 0x%0d via FRONTDOOR", reg_name, write_data), UVM_MEDIUM)
    register_inst.write(status, write_data, UVM_FRONTDOOR);
    
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Write failed with status: %s", reg_name, status.name()))
      
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
    `uvm_info(get_type_name(), 
              $sformatf("%s after WRITE - Desired: 0x%0d, Mirrored: 0x%0d", reg_name, des, mir), UVM_MEDIUM)
  
    register_inst.mirror(status, UVM_CHECK);
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Mirror check failed after write", reg_name))
    else
      `uvm_info(get_type_name(), $sformatf("%s Mirror verification passed after write", reg_name), UVM_MEDIUM)
    
      //--------------------------------------READING FROM THE FRONT DOOR-------------------------------------//
    
      `uvm_info(get_type_name(), $sformatf("Reading from %s via FRONTDOOR", reg_name), UVM_MEDIUM)
      register_inst.read(status, read_data_fd, UVM_FRONTDOOR);
    
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Read frontdoor failed with status: %s", reg_name, status.name()))
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
  `uvm_info(get_type_name(), $sformatf("%s after READ (FD) - Desired: 0x%0d, Mirrored: 0x%0d, ReadData: 0x%0d", reg_name, des, mir, read_data_fd), UVM_MEDIUM)

    if(read_data_fd == write_data)
      `uvm_info(get_type_name(), $sformatf("%s Read data matches written data ", reg_name), UVM_MEDIUM)
    else
      `uvm_error(get_type_name(), $sformatf("%s Read/Write mismatch - Expected: 0x%0d, Got: 0x%0d", reg_name, write_data, read_data_fd))
    
    register_inst.mirror(status, UVM_CHECK);
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Mirror check failed after read (FD)", reg_name))
    else
      `uvm_info(get_type_name(), $sformatf("%s Mirror verification passed after read (FD)", reg_name), UVM_MEDIUM)
      
 //--------------------------------------------READING FROM THE BACKDOOR--------------------------------------------//
    
      `uvm_info(get_type_name(), $sformatf("Reading from %s via BACKDOOR", reg_name), UVM_MEDIUM)
      register_inst.read(status, read_data_bd, UVM_BACKDOOR);
    
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Read (BACKDOOR) failed with status: %s", reg_name, status.name()))
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
  `uvm_info(get_type_name(), $sformatf("%s after READ (BD) - Desired: 0x%0d, Mirrored: 0x%0d, ReadData: 0x%0d", reg_name, des, mir, read_data_bd), UVM_MEDIUM)
    
    register_inst.mirror(status, UVM_CHECK);
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Mirror check failed after read (BD)", reg_name))
    else
      `uvm_info(get_type_name(), $sformatf("%s Mirror verification passed after read (BD)", reg_name), UVM_MEDIUM)
    
      `uvm_info(get_type_name(), $sformatf("----- %s RW Test Complete -------", reg_name), UVM_MEDIUM)
      
  endtask
      
 //-----------------------------------READ ONLY REGISTERS VERIFICATION------------------------------------------------//
  
 /* virtual task read_only_reg(uvm_reg register_inst, uvm_status_e status);
    uvm_reg_data_t des;
    uvm_reg_data_t mir;
    uvm_reg_data_t read_data_fd;
    uvm_reg_data_t write_data = 32'h0234ffff;
    string reg_name;
  
  //----------------------------------------WRITING FROM THE BACKDOOR----------------------------------------//
    
    reg_name = register_inst.get_name();
  `uvm_info(get_type_name(), $sformatf("--------Testing RO Register: %s-------", reg_name), UVM_MEDIUM)

    `uvm_info(get_type_name(), 
              $sformatf("Writing to %s via FRONTDOOR: 0x%0d (simulating HW update)", reg_name, write_data), 
              UVM_MEDIUM)
  register_inst.write(status, write_data, UVM_FRONTDOOR);
    
//     if(status != UVM_IS_OK)
//       `uvm_error(get_type_name(), $sformatf("%s Backdoor write failed with status: %s", reg_name, status.name()))
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
    `uvm_info(get_type_name(), 
              $sformatf("%s after FRONTDOOR WRITE - Desired: 0x%0d, Mirrored: 0x%0d", reg_name, des, mir), UVM_MEDIUM)
  
  `uvm_info(get_type_name(), 
            $sformatf("Reading to %s via FRONTDOOR using read method", reg_name), 
              UVM_MEDIUM)
  register_inst.read(status, read_data_fd, UVM_FRONTDOOR);
    
//     if(status != UVM_IS_OK)
//       `uvm_error(get_type_name(), $sformatf("%s Backdoor write failed with status: %s", reg_name, status.name()))
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
    `uvm_info(get_type_name(), 
              $sformatf("%s after FRONTDOOR READ - Desired: 0x%0d, Mirrored: 0x%0d", reg_name, des, mir), UVM_MEDIUM)

//   `uvm_info(get_type_name(), $sformatf("Writing to %s via BACKDOOR (RO access)", reg_name), UVM_MEDIUM)
//   register_inst.poke(status, write_data);
    
// //     if(status != UVM_IS_OK)
// //       `uvm_error(get_type_name(), $sformatf("%s Read (FRONTDOOR) failed with status: %s", reg_name, status.name()))
    
//     des = register_inst.get();
//     mir = register_inst.get_mirrored_value();
//     `uvm_info(get_type_name(), 
//               $sformatf("%s after POKE (BD) - Desired: 0x%0h, Mirrored: 0x%0d, ReadData: 0x%0d", reg_name, des, mir, read_data_fd), UVM_MEDIUM)
  
//   `uvm_info(get_type_name(), 
//             $sformatf("Reading to %s via FRONTDOOR using read method: 0x%0d", reg_name, write_data), 
//               UVM_MEDIUM)
//   register_inst.read(status, read_data_fd, UVM_FRONTDOOR);
    
// //     if(status != UVM_IS_OK)
// //       `uvm_error(get_type_name(), $sformatf("%s Backdoor write failed with status: %s", reg_name, status.name()))
    
//     des = register_inst.get();
//     mir = register_inst.get_mirrored_value();
//     `uvm_info(get_type_name(), 
//               $sformatf("%s after FRONTDOOR READ - Desired: 0x%0d, Mirrored: 0x%0d", reg_name, des, mir), UVM_MEDIUM)

//     if(read_data_fd == write_data)
//       `uvm_info(get_type_name(), $sformatf("%s Read data matches backdoor-written data ", reg_name), UVM_MEDIUM)
//     else
//       `uvm_warning(get_type_name(), $sformatf("%s Read mismatch - Expected: 0x%0h, Got: 0x%0h", reg_name, write_data, read_data_fd))
    
//     register_inst.mirror(status, UVM_CHECK);
//     if(status != UVM_IS_OK)
//       `uvm_error(get_type_name(), $sformatf("%s Mirror check failed after RO read", reg_name))
//     else
//       `uvm_info(get_type_name(), $sformatf("%s Mirror verification passed (RO)", reg_name), UVM_MEDIUM)
    
      `uvm_info(get_type_name(), $sformatf("-------%s RO Test Complete -------", reg_name), UVM_MEDIUM)
  endtask */

 virtual task read_only_reg(uvm_reg register_inst, uvm_status_e status, uvm_reg_data_t write_data);
    uvm_reg_data_t des;
    uvm_reg_data_t mir;
    uvm_reg_data_t read_data_fd;
//     uvm_reg_data_t write_data = 32'hA234ffff;
    string reg_name;
    write_data = write_data & 32'hFFFFFFFF;
  
  //----------------------------------------WRITING FROM THE FRONTDOOR----------------------------------------//
    
    reg_name = register_inst.get_name();
  `uvm_info(get_type_name(), $sformatf("--------Testing RO Register: %s-------", reg_name), UVM_MEDIUM)

    `uvm_info(get_type_name(), 
              $sformatf("Writing to %s via FRONTDOOR: 0x%0h (simulating HW update)", reg_name, write_data), 
              UVM_MEDIUM)
  register_inst.write(status, write_data, UVM_FRONTDOOR);
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
    `uvm_info(get_type_name(), 
              $sformatf("%s after FRONTDOOR WRITE - Desired: 0x%0h, Mirrored: 0x%0h", reg_name, des, mir), UVM_MEDIUM)
  
  `uvm_info(get_type_name(), 
            $sformatf("Reading to %s via FRONTDOOR using read method", reg_name), 
              UVM_MEDIUM)
  register_inst.read(status, read_data_fd, UVM_FRONTDOOR);
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
    `uvm_info(get_type_name(), 
              $sformatf("%s after FRONTDOOR READ - Desired: 0x%0h, Mirrored: 0x%0h", reg_name, des, mir), UVM_MEDIUM)

  `uvm_info(get_type_name(), $sformatf("Writing to %s via BACKDOOR (RO access)", reg_name), UVM_MEDIUM)
  register_inst.poke(status, write_data);
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
    `uvm_info(get_type_name(), 
              $sformatf("%s after POKE (BD) - Desired: 0x%0h, Mirrored: 0x%0h, ReadData: 0x%0h", reg_name, des, mir, read_data_fd), UVM_MEDIUM)
  
//   `uvm_info(get_type_name(), 
//             $sformatf("Reading to %s via FRONTDOOR using read method: 0x%0d", reg_name, write_data), 
//               UVM_MEDIUM)
//   register_inst.read(status, read_data_fd, UVM_FRONTDOOR);
  
    `uvm_info(get_type_name(), 
              $sformatf("Predicting the value of %s using predict method", reg_name), 
              UVM_MEDIUM)
  register_inst.predict(write_data);
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
    `uvm_info(get_type_name(), 
              $sformatf("%s after predicting - Desired: 0x%0h, Mirrored: 0x%0h", reg_name, des, mir), UVM_MEDIUM)

//     if(read_data_fd == write_data)
//       `uvm_info(get_type_name(), $sformatf("%s Read data matches backdoor-written data ", reg_name), UVM_MEDIUM)
//     else
//       `uvm_warning(get_type_name(), $sformatf("%s Read mismatch - Expected: 0x%0h, Got: 0x%0h", reg_name, write_data, read_data_fd))
    
    register_inst.mirror(status, UVM_CHECK);
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Mirror check failed after RO read", reg_name))
    else
      `uvm_info(get_type_name(), $sformatf("%s Mirror verification passed (RO)", reg_name), UVM_MEDIUM)
    
      `uvm_info(get_type_name(), $sformatf("-------%s RO Test Complete -------", reg_name), UVM_MEDIUM)
  endtask
      
 //------------------------------VERIFICATION FOR WIC REGISTERS-------------------------------------------//
      
  virtual task write_1_clear_reg(uvm_reg register_inst, uvm_status_e status, uvm_reg_data_t set_bits);
    uvm_reg_data_t des;
    uvm_reg_data_t mir;
    uvm_reg_data_t read_before;
    uvm_reg_data_t read_after;
    string reg_name;
    set_bits = set_bits & 32'hFFFF_FF1F;
    
    reg_name = register_inst.get_name();
  `uvm_info(get_type_name(), $sformatf("--------Testing W1C Register: %s--------", reg_name), UVM_MEDIUM)

    `uvm_info(get_type_name(), $sformatf("Backdoor write to %s: 0x%0h (setting error bits)", reg_name, set_bits), UVM_MEDIUM)
  register_inst.poke(status, set_bits);
    
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Backdoor write failed", reg_name))
    
      `uvm_info(get_type_name(), $sformatf("Reading %s before W1C operation", reg_name), UVM_MEDIUM)
      register_inst.read(status, read_before, UVM_FRONTDOOR);
    
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Read before clear failed", reg_name))
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
    `uvm_info(get_type_name(), 
              $sformatf("%s before CLEAR - Desired: 0x%0h, Mirrored: 0x%0h, ReadData: 0x%0h", 
                        reg_name, des, mir, read_before), UVM_MEDIUM)
    
    if(read_before == set_bits)
      `uvm_info(get_type_name(), $sformatf("%s Error bits set correctly: 0x%0h ", reg_name, read_before), UVM_MEDIUM)
    else
      `uvm_warning(get_type_name(), $sformatf("%s Error bits mismatch - Expected: 0x%0h, Got: 0x%0h", reg_name, set_bits, read_before))
    
    `uvm_info(get_type_name(), $sformatf("Writing 0x%0h to %s to clear set bits (W1C)", set_bits, reg_name), UVM_MEDIUM)
    register_inst.write(status, 32'hABCDE01F, UVM_FRONTDOOR);
    
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s W1C write failed", reg_name))

      `uvm_info(get_type_name(), $sformatf("Reading %s after W1C operation", reg_name), UVM_MEDIUM)
    register_inst.read(status, read_after, UVM_FRONTDOOR);
    
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Read after clear failed", reg_name))
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
    `uvm_info(get_type_name(), $sformatf("%s after CLEAR - Desired: 0x%0h, Mirrored: 0x%0h, ReadData: 0x%0h", reg_name, des, mir, read_after), UVM_MEDIUM)

    if(read_after == {set_bits[31:5], 5'b0000})
      `uvm_info(get_type_name(), $sformatf("%s Bits successfully cleared ", reg_name), UVM_MEDIUM)
    else
      `uvm_error(get_type_name(), 
                 $sformatf("%s Clear failed - Expected: 0x%0h, Got: 0x%0h", reg_name, {set_bits[31:5], 5'b0000}, read_after))
    
    register_inst.mirror(status, UVM_CHECK);
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Mirror check failed", reg_name))
    else
      `uvm_info(get_type_name(), $sformatf("%s Mirror verification passed", reg_name), UVM_MEDIUM)
    
      `uvm_info(get_type_name(), $sformatf("---------- %s W1C Test Complete -------------", reg_name), UVM_MEDIUM)
  endtask
    
endclass

class reset_dma_seq extends dma_sequence;
  `uvm_object_utils(reset_dma_seq)

  uvm_status_e status;

  function new(string name="reset_dma_seq");
    super.new(name);
  endfunction

  task body();

    reg_block.reset();
    reg_block.mirror(status, UVM_CHECK);

    `uvm_info(get_type_name(),"reset test completed",UVM_LOW)

  endtask
endclass    

class intr_reg_sequence extends dma_sequence;
 `uvm_object_utils(intr_reg_sequence)
   bit [31:0] intr_data;

  function new(string name = "intr_reg_sequence");
   super.new(name);
  endfunction

  task body();
read_write_reg(reg_block.intr_inst, status, 32'h00000000);
   read_write_reg(reg_block.intr_inst, status, 32'hDEAD0000);
   repeat(100) begin
    intr_data = {$random, 16'h0000};
    read_write_reg(reg_block.intr_inst, status, intr_data);
   end
   endtask
endclass

 class transfer_count_reg_sequence extends dma_sequence;
    `uvm_object_utils(transfer_count_reg_sequence)
      
    function new(string name = "transfer_count_reg_sequence");
        super.new(name);
      endfunction
      
      task body();
        read_only_reg(reg_block.transfer_count_inst, status, 32'h0001DEF0);
        repeat(20) begin
          read_only_reg(reg_block.transfer_count_inst, status, $random);
        end
      endtask 
    endclass

class ctrl_reg_sequence extends dma_sequence;
  `uvm_object_utils(ctrl_reg_sequence)

      function new(string name = "ctrl_reg_sequence");
        super.new(name);
      endfunction

       task read_write_reg(uvm_reg register_inst, uvm_status_e status, uvm_reg_data_t write_data);
    uvm_reg_data_t des;
    uvm_reg_data_t mir;
    uvm_reg_data_t read_data_fd;
    uvm_reg_data_t read_data_bd;
    uvm_reg_data_t predict_data;
    string reg_name;
    write_data = write_data & 32'h0000_FFFF;
    predict_data = write_data & 32'hFFFF_FFFE;
  
  //----------------------------------------WRITING ONTO FROM THE FRONTDOOR----------------------------------------//
    
    reg_name = register_inst.get_name();
  `uvm_info(get_type_name(), $sformatf("------ Testing RW Register: %s -----", reg_name), UVM_MEDIUM)
    
  `uvm_info(get_type_name(), $sformatf("Writing to %s: 0x%0h via FRONTDOOR", reg_name, write_data), UVM_MEDIUM)
    register_inst.write(status, write_data, UVM_FRONTDOOR);
      
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
    `uvm_info(get_type_name(), 
              $sformatf("%s after WRITE - Desired: 0x%0h, Mirrored: 0x%0h", reg_name, des, mir), UVM_MEDIUM)
    
      //--------------------------------------READING FROM THE FRONT DOOR-------------------------------------//
      `uvm_info(get_type_name(), $sformatf("Reading from %s via FRONTDOOR", reg_name), UVM_MEDIUM)
      register_inst.read(status, read_data_fd, UVM_FRONTDOOR);
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
  `uvm_info(get_type_name(), $sformatf("%s after READ (FD) - Desired: 0x%0h, Mirrored: 0x%0h, ReadData: 0x%0h", reg_name, des, mir, read_data_fd), UVM_MEDIUM)
      
      `uvm_info(get_type_name(), 
              $sformatf("Predicting the value of %s using predict method", reg_name), 
              UVM_MEDIUM)
      register_inst.predict(predict_data);
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
    `uvm_info(get_type_name(), 
              $sformatf("%s after predicting - Desired: 0x%0h, Mirrored: 0x%0h", reg_name, des, mir), UVM_MEDIUM)
    
    register_inst.mirror(status, UVM_CHECK);
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Mirror check failed after read (FD)", reg_name))
    else
      `uvm_info(get_type_name(), $sformatf("%s Mirror verification passed after read (FD)", reg_name), UVM_MEDIUM)
      
 //--------------------------------------------READING FROM THE BACKDOOR--------------------------------------------//
    
      `uvm_info(get_type_name(), $sformatf("Reading from %s via BACKDOOR", reg_name), UVM_MEDIUM)
      register_inst.read(status, read_data_bd, UVM_BACKDOOR);
    
    des = register_inst.get();
    mir = register_inst.get_mirrored_value();
  `uvm_info(get_type_name(), $sformatf("%s after READ (BD) - Desired: 0x%0d, Mirrored: 0x%0h, ReadData: 0x%0h", reg_name, des, mir, read_data_bd), UVM_MEDIUM)
    
    register_inst.mirror(status, UVM_CHECK);
    if(status != UVM_IS_OK)
      `uvm_error(get_type_name(), $sformatf("%s Mirror check failed after read (BD)", reg_name))
    else
      `uvm_info(get_type_name(), $sformatf("%s Mirror verification passed after read (BD)", reg_name), UVM_MEDIUM)
    
      `uvm_info(get_type_name(), $sformatf("----- %s RW Test Complete -------", reg_name), UVM_MEDIUM)
      
  endtask

      task body();
        read_write_reg(reg_block.ctrl_inst, status, 32'h0001DEF0);
        repeat(100) begin
          read_write_reg(reg_block.ctrl_inst, status, $random);
        end
      endtask 
    endclass

class io_addr_reg_sequence extends dma_sequence;
 `uvm_object_utils(io_addr_reg_sequence)

      function new(string name = "io_addr_reg_sequence");
        super.new(name);
      endfunction

      task body();
        read_write_reg(reg_block.io_addr_inst, status, 32'h0001DEF0);
        read_write_reg(reg_block.io_addr_inst, status, 32'h0000_0A5C);
        read_write_reg(reg_block.io_addr_inst, status, 32'h0000_45AB);
        repeat(50) begin
          read_write_reg(reg_block.io_addr_inst, status, $random);
        end
      endtask 
endclass

class mem_addr_reg_sequence extends dma_sequence;
  `uvm_object_utils(mem_addr_reg_sequence)

      function new(string name = "mem_addr_reg_sequence");
        super.new(name);
      endfunction

      task body();
        read_write_reg(reg_block.mem_addr_inst, status, 32'h0001DEF0);
        repeat(20) begin
          read_write_reg(reg_block.mem_addr_inst, status, $random);
        end
      endtask 
endclass

class extra_info_reg_sequence extends dma_sequence;
  `uvm_object_utils(extra_info_reg_sequence)

      function new(string name = "extra_info_reg_sequence");
        super.new(name);
      endfunction

      task body();
       read_write_reg(reg_block.extra_info_inst, status, 32'h00000000);
        read_write_reg(reg_block.extra_info_inst, status, 32'h0001DEF0);
        repeat(20) begin
          read_write_reg(reg_block.extra_info_inst, status, $random);
        end
      endtask 
endclass

class descriptor_addr_reg_sequence extends dma_sequence;
      `uvm_object_utils(descriptor_addr_reg_sequence)

      function new(string name = "descriptor_addr_reg_sequence");
        super.new(name);
      endfunction

      task body();
        read_write_reg(reg_block.descriptor_addr_inst, status, 32'h0001DEF0);
        repeat(20) begin
          read_write_reg(reg_block.descriptor_addr_inst, status, $random);
        end
      endtask 
endclass

class config_reg_sequence extends dma_sequence;
      `uvm_object_utils(config_reg_sequence)
      bit [8:0] config_data;

      function new(string name = "config_reg_sequence");
        super.new(name);
      endfunction

      task body();
        read_write_reg(reg_block.config_inst, status, 32'h00000055);
        repeat(20) begin
          config_data = $random;
          read_write_reg(reg_block.config_inst, status, config_data);
        end
      endtask 
endclass

class error_status_reg_sequence extends dma_sequence;
      `uvm_object_utils(error_status_reg_sequence)

      function new(string name = "error_status_reg_sequence");
        super.new(name);
      endfunction

      task body();
        write_1_clear_reg(reg_block.error_status_inst, status, 32'h0000001B);
        repeat(20) begin
          write_1_clear_reg(reg_block.error_status_inst, status, $random);
        end
      endtask 
endclass

 class regression_reg_sequence extends dma_sequence;
    `uvm_object_utils(regression_reg_sequence)
    
    dma_reg_block reg_block;

  reset_dma_seq             s1;
  intr_reg_sequence         s2;
  transfer_count_reg_sequence s8;
  ctrl_reg_sequence         s3;
  io_addr_reg_sequence      s4;
  mem_addr_reg_sequence     s5;
  extra_info_reg_sequence   s6;
//   status_reg_sequence       s7;
  descriptor_addr_reg_sequence s9;
  error_status_reg_sequence s10;
  config_reg_sequence       s11;
    
    function new(string name = "regression_reg_sequence");
      super.new(name);
    endfunction
    
     task body();


    s1  = reset_dma_seq::type_id::create("s1");
    s2  = intr_reg_sequence::type_id::create("s2");
    s3  = ctrl_reg_sequence::type_id::create("s3");
    s4  = io_addr_reg_sequence::type_id::create("s4");
    s5  = mem_addr_reg_sequence::type_id::create("s5");
    s6  = extra_info_reg_sequence::type_id::create("s6");
//     s7  = status_reg_sequence::type_id::create("s7");
    s8  = transfer_count_reg_sequence::type_id::create("s8");
    s9  = descriptor_addr_reg_sequence::type_id::create("s9");
    s10 = error_status_reg_sequence::type_id::create("s10");
    s11 = config_reg_sequence::type_id::create("s11");

s1.reg_block  = reg_block;
s2.reg_block  = reg_block;
s3.reg_block  = reg_block;
s4.reg_block  = reg_block;
s5.reg_block  = reg_block;
s6.reg_block  = reg_block;
// s7.reg_block  = reg_block;
s8.reg_block  = reg_block;
s9.reg_block  = reg_block;
s10.reg_block = reg_block;
s11.reg_block = reg_block;

    s1.start(m_sequencer);
    s2.start(m_sequencer);
    s8.start(m_sequencer);
    s3.start(m_sequencer);
    s4.start(m_sequencer);
    s5.start(m_sequencer);
    s6.start(m_sequencer);
//     s7.start(m_sequencer);
    s9.start(m_sequencer);
    s10.start(m_sequencer);
    s11.start(m_sequencer);

  endtask
endclass
