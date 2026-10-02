`ifndef TINYMIPS_SIM_V_
`define TINYMIPS_SIM_V_

`define DATA_MEM_ADDR_WIDTH   5
`define DATA_MEM_SIZE         2 ** `DATA_MEM_ADDR_WIDTH
`define DATA_MEM_BUS          `DATA_MEM_SIZE - 1:0

`define INST_MEM_ADDR_WIDTH   8
//指令存储器的地址宽度是8位
`define INST_MEM_SIZE         2 ** `INST_MEM_ADDR_WIDTH
//计算地址宽度为8位时的存储器大小
`define INST_MEM_BUS          `INST_MEM_SIZE - 1:0

`endif  // TINYMIPS_SIM_V_
