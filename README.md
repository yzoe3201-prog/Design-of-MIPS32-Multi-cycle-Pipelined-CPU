# MyCPU — 基于 Verilog 的五级流水线 MIPS CPU

基于 Xilinx FPGA（Vivado 2019.1）实现的教学级 MIPS CPU，采用经典五级流水线架构（IF/ID/EX/MEM/WB），支持指令流水、数据冒险处理、分支跳转、乘除运算，内置 11 条测试程序，可下载至开发板运行并通过数码管观察结果。

## 主要特性

- **五级流水线**：取指（IF）、译码（ID）、执行（EX）、访存（MEM）、写回（WB）
- **数据冒险处理（三级防线）**：寄存器写通 + EX/MEM 级结果转发 + Load 相关暂停
- **控制冒险**：分支在 ID 级提前判断，减少流水线冲刷
- **乘除单元**：HILO 寄存器 + 多周期 EX 级暂停
- **寄存器堆**：32×32，2 读 1 写，写通模式，禁写 $0/$24
- **存储访问**：字节使能（lb/lh/lw），写回符号/零扩展
- **ROM 测试程序**：覆盖算术、访存、乘除、跳转等指令
- **FPGA 外设**：数码管动态扫描显示 + 调试多路选择

## 目录结构

```text
myCPU/
├── CPUfpga.xpr            # Vivado 工程文件（打开即用）
│
├── src/                   # Verilog 源码
│   ├── Mycpu_top.v        # 顶层：连接 ROM/RAM/Core 与 FPGA 引脚
│   ├── Core.v             # 流水线总装（IF/ID/EX/MEM/WB + 流水寄存器）
│   ├── PipelineController.v   # 流水线暂停 / 冲刷控制
│   ├── PipelineDeliver.v      # 气泡插入
│   ├── RegFile.v          # 寄存器堆（32×32，写通模式）
│   ├── RegReadProxy.v     # 结果转发 + Load 相关暂停
│   ├── BranchGen.v        # 分支条件判断（ID 级提前判断）
│   ├── ALU.v              # 算术逻辑单元
│   ├── MulDiv.v           # 乘除运算（多周期）
│   ├── HILO.v             # HI/LO 寄存器
│   ├── ROM.v              # 指令存储器（内置 11 条测试程序）
│   └── RAM.v              # 数据存储器
│
├── xdc/                   # FPGA 引脚约束文件
└── sim/                   # 仿真测试平台（testbench）
```


## 如何运行

1. 用 Vivado 2019.1 打开 `CPUfpga.xpr`
2. 综合（Synthesis）→ 实现（Implementation）
3. 生成比特流（Generate Bitstream）
4. 连接开发板，通过 Hardware Manager 下载 `.bit` 文件
5. 复位并拨动开关，观察数码管显示的指令/数据结果

## 设计要点（面试向）

- **冒险三级防线**：写通解决 WB→EX 冲突，转发（forwarding）解决 EX/MEM 结果回传，Load 相关（load-use）用流水线暂停插入气泡。
- **流水线控制**：`stall_all`（全停）、ID 级暂停、EX 级暂停三种粒度，配合 `PipelineDeliver` 在停-启转换时插入气泡，保证数据一致性。
- **分支处理**：分支指令在 ID 级完成判断与目标计算，仅在确认跳转时冲刷 IF/ID，将分支代价降到一级。
- **调试手段**：片上逻辑分析仪接口 + 数码管多路显示，可单步观察各流水级状态。

## 测试程序

ROM 内置 11 条测试程序，覆盖 `addiu`、`addu`、`lw`、`sw`、`mult`、`div`、分支跳转等指令，用于验证各功能模块正确性。

## 说明

本项目为课程设计用途，基于 MIPS 指令集子集实现。

