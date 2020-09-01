#!/usr/bin/env python
import os
import json
import noc_soc
import axi_soc
import wb_soc


def soc_main(base_dir, in_json_file):
    soc_config = None
    
    global filepath
    for root, dirs, files in os.walk(base_dir):
        for name in files:
            if name == in_json_file:
                filepath = os.path.abspath(os.path.join(root, name))
    
    with open(filepath) as file:
        try:
            soc_config = json.load(file)
        except ValueError as e:
            print(e)

    for val in soc_config:
        for i in soc_config[val]:
            if (i == 'fabric') and (soc_config[val][i] == 'Wishbone'):
                wb_soc.soc_generator_wb(base_dir, in_json_file)
            elif (i == 'fabric') and (soc_config[val][i] == 'NoC'):
                noc_soc.soc_generator_noc(base_dir, in_json_file)
            elif (i == 'fabric') and (soc_config[val][i] == 'AXI'):
                axi_soc.soc_generator_axi(base_dir, in_json_file)
            elif (i == 'fabric') and (soc_config[val][i] == 'Multi-bus'):
                wb_soc.soc_generator_wb(base_dir, in_json_file)


if __name__ == '__main__':
    soc_main('/home/machine/Downloads/SoCCom_v1.0', 'axi_soc.json')
#argv[1] = SoC Compiler Tool dir
#argv[2] = wb_soc.json, axi_soc.json, noc_soc.json,
#soc_main(sys.argv[1], sys.argv[2])

