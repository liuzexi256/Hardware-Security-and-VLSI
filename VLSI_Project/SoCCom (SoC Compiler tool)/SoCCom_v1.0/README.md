
SoC Compiler (SoCCom) -- A Framework for Automated Synthesis of Scalable SoCs 
=============================================================================

## Version: 1.0 

SoC Compiler (SoCCom) is an EDA tool that enables automated design of scalable SoCs. It supports generation of NoC and bus-based SoCs. The current version is compatible of Wishbone (B3.0) and AXI4-Lite bus protocol and an open source NoC, namely LisNoC. It incorporates a standard IP library containing processor cores, memory modules, DSP blocks, crypto modules, shared buses, NoC routers, network adapters,  and peripherals (UART, GPS, SPI) for external communication.

## Pre-requisites:

SoCCom has been developed and tested on the following: 

* Ubuntu 18.04 LTS x86_64
* Python 3.6
* Xilinx Vivado 2018.3 -- Free webpack edition
* ModelSim SE-64 2020.1 (available via ece linux server)
* bash

## Pre-compiled Designs: 

1. 'wb_soc_soccom' contains pre-compiled Vivado project on Wishbone bus-based SoC. Open the "wb_soc_soccom.xpr" file to run the project. 'wb_soc'  contains the IPs used in the project. 
2. 'axi_soc_soccom' contains pre-compiled Vivado project on AXI4-Lite bus-based SoC. Open the "axi_soc_soccom.xpr" file to run the project.  'axi_soc'  contains the IPs used in the project.
3. 'noc_soc_soccom' contains pre-compiled Vivado project on NoC-based SoC. Open the "noc_soc_soccom.xpr" file to run the project. 'noc_soc'  contains the IPs used in the project.



## Run Instructions: 

1. Simply copy and unzip the 'SoCCom_v1.0' to your desried directory.
2. SoCCom_v1.0 is the top-level directory; all the generated design files will be here. 
3. 'src' contains the source code of SoCCom. The current version includes .so (shared object) binaries of the code base. 
3. 'cores' contains the IPs. 
4. 'config' contains the JSON files that define the base configuration and architecture definitions. 




## Generating a Wishbone bus-based SoC:

1. Specify the masters and slaves in the 'wb_soc.json' file (located in 'config' of the source directory). 
2. Update the JSON file name in 'soc_main.py' (located in the 'src' of the source directory). PicoRV32, WBRAM, and UART IPs are mandatory components for the Wishbone bus-based SoC. Rest of the hardware accelerators are optional for SoC funtionality. 
3. Run the script. SoC top module design file will get generated in the source directory. 
4. Open a new project in Vivado, add generated HDL file as a design source, and specify 'cores' as the source directory. Check option 'automatically import include files'. 
5. Vivado will automatically set the hierarchy and set the top module. If wb_soc.sv is not the top module, set it as the top module manually. 
6. Update the wb_soc_config.sv to set the base address and size for each of the memory-mapped slaves. 
7. Elaborate the design for schematic view. 
8. Generated SoC can be simulated with directed and random testbenches written in HDL. IP level, bus-level, and system level testbenches for the hardware accelerators are provided. IP level and bus-level simulation can be performed via Verilator/ModelSim. FPGA mapping is required for system level emulation. 
9. RISC-V tool chain can be used to compile programs (c code compiled to binaries using RISC-V tool chain) for the RV32 processor core and the generated firmware HEX / MEM file can be stored in the RAM block of the SoC. 
10. Generated SoC can be synthesize the design to get area, power, and timing results. Template constraint file 'wb_soc_constraints' is provided in 'cores>constraints' directory. Set clock and reset signals accordingly, and try setting the deafult nettype and 'DO NOT TOUCH' properties if Vivado ends up deleting functional blocks and leaf cells for optimization. 


## Generating a AXI4-Lite bus-based SoC:

1. Specify the masters and slaves in the 'axi_soc.json' file (located in 'config' of the source directory). 
2. Update the JSON file name in 'soc_main.py' (located in the 'src' of the source directory). PicoRV32, WBRAM, and UART IPs are mandatory components of the AXI4-Lite bus-based SoC. Rest of the hardware accelerators are optional for SoC funtionality. 
3. Run the script. SoC top module design file(s) will get generated in the source directory. 
4. Open a new project in Vivado, add generated HDL file(s) as a design source, and specify 'cores' as the source directory. Check option 'automatically import include files'. 
5. Vivado will automatically set the hierarchy and set the top module. If axi_soc.sv is not assigned as the top module, update top module manually. 
6. Update the axi_soc_config.v to set the base address range for each of the memory-mapped slaves. 
7. Elaborate the design for schematic view. 
8. Generated SoC can be simulated with directed and random testbenches written in HDL. IP level, bus-level, and system level testbenches for the hardware accelerators are provided. IP level and bus-level simulation can be performed via Verilator/ModelSim. FPGA mapping is required for system level emulation. 
9. RISC-V tool chain can be used to compile programs (c code compiled to binaries using RISC-V tool chain) for the RV32 processor core and the generated firmware HEX / MEM file can be stored in the RAM block of the SoC. 
10. Generated SoC can be synthesize the design to get area, power, and timing results. Template constraint file 'axi_soc_constraints' is provided in 'cores>constraints' directory. Set clock and reset signals accordingly, and try setting the deafult nettype and 'DO NOT TOUCH' properties if Vivado ends up deleting functional blocks and leaf cells for optimization. 


## Generating a NoC-based SoC:

1. Specify router topology, the masters, and slaves in the 'noc_soc.json' file (located in 'config' of the source directory). 
2. Update the JSON file name in 'soc_main.py' (located in the 'src' of the source directory).
3. Run the script. SoC top module design file(s) will get generated in the source directory. The design files will include the top level noc module and the tiles/modules for the hardware accelerators 
4. Open a new project in Vivado, add generated HDL file(s) as a design source, and specify 'cores' as the source directory. Check option 'automatically import include files'.
5. Vivado will automatically set the hierarchy and set the top module. If noc_soc.sv is not assigned as the top module, update top module manually. 
6. Update the optimsoc_config.v to set the parameters of the IPs and the NoC. 
7. Elaborate the design for schematic view. 
8. Generated SoC can be simulated with directed and random testbenches written in HDL. IP level, bus-level, and system level testbenches for the hardware accelerators are provided. IP level and bus-level simulation can be performed via Verilator/ModelSim. FPGA mapping is required for system level emulation. 
9. RISC-V tool chain can be used to compile programs (c code compiled to binaries using RISC-V tool chain) for the RV32 processor core and the generated firmware HEX / MEM file can be stored in the RAM block of the SoC. 
10. Generated SoC can be synthesize the design to get area, power, and timing results. Template constraint file 'noc_soc_constraints' is provided in 'cores>constraints' directory. Set clock and reset signals accordingly, and try setting the deafult nettype and 'DO NOT TOUCH' properties if Vivado ends up deleting functional blocks and leaf cells for optimization. 


