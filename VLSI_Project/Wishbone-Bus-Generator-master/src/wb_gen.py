#! /usr/bin/env python 
'''
Created on 2011-02-27

@author: MegabytePhreak
'''

import demjson
import argparse
import os.path
import sys
from math import ceil, log

def log2(x):
    return log(float(x),2)
def clog2(x):
    return int(ceil(log2(x)))

def is_mapping_type(obj, require_set=True):
    """
    Returns ``True`` if an object appears to
    support the ``MappingType`` protocol.

    If ``require_set`` is ``True`` then the
    object must support ``__setitem__`` as
    well as ``__getitem__`` and ``keys``.
    """
    if require_set and not hasattr(obj, '__setitem__'):
        return False
    if hasattr(obj, 'keys') and hasattr(obj, '__getitem__'):
        return True
    else:
        return False

def is_sequence_type(obj, require_set=True):
    """
    Returns ``True`` if an object appears to
    support the ``SequenceType`` protocol.

    If ``require_set`` is ``True`` then the
    object must support ``__setitem__`` as
    well as ``__getitem__``.

    The object must not have a ``keys``
    method.
    """
    if require_set and not hasattr(obj, '__setitem__'):
        return False
    if (not hasattr(obj, 'keys')) and hasattr(obj, '__getitem__'):
        return True
    else:
        return False

    
class wb_settings(object):
    def __init__(self, data_width, address_width):
        self.data_width = data_width
        self.address_width = address_width
        
class wb_master(object):
    def __init__(self, name, address_width, include_address_valid = False):
        self.name = name
        self.address_width = address_width
        self.include_address_valid = include_address_valid
    def __str__(self):
        return self.name
        
class wb_slave(object):
    def __init__(self, name, base, size):
        self.name = name
        self.base = base
        self.size = size
        self.address_width = clog2(size)
    def __str__(self):
        return self.name

class wb_bus(object):
    def __init__(self,name, settings = None,masters = [], slaves = []):
        self.name = name
        self.settings = settings
        self.masters = masters
        self.slaves = slaves
    def __str__(self):
        return self.name
           
def is_string(s):
    return isinstance(s,str) or isinstance(s,unicode)

TYPE_INT    = ('Integer',int,None)
TYPE_BOOL   = ('Boolean',bool,None)
TYPE_STRING = ('String',None,is_string)
TYPE_LIST   = ('List',None,is_sequence_type)
TYPE_MAP    = ('Dictionary',None,is_mapping_type)   
   
class wb_builder(object):      
        
    def error(self,string):
        print("Error: %s"%string)
        sys.exit(1)
    
    def infile_error(self, string):
        self.error("%s: %s"%(self.infile.name,string))
        
        
    def verify_type(self, item, type, name = None):
        if type != None:
            if (type[1] != None and not isinstance(item,type[1])) \
                or (type[2] != None and not type[2](item)):
                if name != None:
                    self.infile_error("Field %s must be a %s"%
                           (name,type[0]))
                else:
                    self.infile_error("%s must be a %s"%
                           (item ,type[0]))
                    
    def verify_field(self, within, name, type, default = None):
        if not name in within and default == None:
            self.infile_error("Could not find field '%s' in :\n%s"%
                              (name,within))
        if not name in within:
            within[name] = default
        self.verify_type(within[name],type,name)
        
    def add_line(self, line):
        self.lines.append(self.ts * '  ' + line)  
            
        
    def load_settings(self, settings):
        if not is_mapping_type(settings, require_set=True):
            self.infile_error("The 'settings' section  invalid")
        if not 'data_width' in settings:
            self.infile_error(
                "The 'settings' section does not contain a 'data_width' field")
        if not isinstance(settings['data_width'],int):
            self.infile_error("'data_width' must be an integer")
        self.config.settings = wb_settings(settings['data_width'],
                                             -1)
    
    def load_master(self, master):  
        self.verify_field(master, 'name', TYPE_STRING)
        self.verify_field(master, 'address_width', TYPE_INT)
        self.verify_field(master, 'include_address_valid',TYPE_BOOL, False)
        self.config.masters.append(wb_master(master['name'],
                                             master['address_width'],
                                             master['include_address_valid'] ))
          
    def load_masters(self, masters):
        if len(masters) < 1:
            self.infile_error("At least one master must be defined")
        if len(masters) > 1:
            self.infile_error("Only one master is currently supported")
            
        count = 0;
        addr_width = -1    
        for master in masters:
            self.verify_type(master,TYPE_MAP,"Master %d"%count)
            self.load_master(master)
            count += 1
            
        for master in self.config.masters:
            if master.address_width != addr_width and addr_width != -1:
                self.infile_error("All master address bus widths must match")
            addr_width = master.address_width
            
        self.config.settings.address_width = addr_width

    def load_slave(self, slave):
        KW_AUTO = 'auto'
        self.verify_field(slave, 'name', TYPE_STRING)
        self.verify_field(slave, 'base', ("Integer or 'auto'",None,
                                          lambda x: isinstance(x,int) or x == KW_AUTO))
        if(slave['base'] ==KW_AUTO):
            max = 0
            for s in self.config.slaves:
                next = s.base + s.size
                if(next > max):
                    max = next
            slave['base'] = max;
            
        self.verify_field(slave, 'size', TYPE_INT)   
        size = slave['size']
        base = slave['base']
            
        if (size & (size-1)) != 0:
            self.infile_error("Slave %s's size is not a power of 2"%slave['name'])
        if (base & ~(size-1)) != base: 
            self.infile_error("Slave %s is not size-aligned"%slave['name'])
            
        self.config.slaves.append( wb_slave(
                    slave['name'], base, size))
        
    def load_slaves(self, slaves):      
        if len(slaves) < 1:
            self.infile_error("At least one slave must be defined")
     
        count = 0;
        for slave in slaves:
            self.verify_type(slave, TYPE_MAP, "Slave %d"%count)
            self.load_slave(slave)
            count += 1
        for slavea in self.config.slaves:
            for slaveb in self.config.slaves:
                if not (slavea.base < slaveb.base or \
                    slavea.base >= slaveb.base + slaveb.size) \
                    and slavea != slaveb:
                    self.infile_error("Slaves '%s' and '%s' overlap"%
                                      (slavea,slaveb))
                    
    def load_config(self,jsonconfig):
        self.verify_type(jsonconfig, TYPE_MAP, "The config root")
        
        self.verify_field(jsonconfig, "name", TYPE_STRING)
        
        self.config = wb_bus(str(jsonconfig['name']))
        
        for sect in(('settings',TYPE_MAP,self.load_settings),
                       ('masters',TYPE_LIST,self.load_masters),
                       ('slaves',TYPE_LIST, self.load_slaves)):
            self.verify_field(jsonconfig,sect[0],sect[1] )
            sect[2](jsonconfig[sect[0]])

       
    
    def print_header(self):
        self.add_line('// *** THIS FILE IS GENERATED BY wb_gen.py ')
        self.add_line('// *** DO NOT MODIFY THIS FILE ')
        self.add_line('// *** GENERATED FROM:')
        self.add_line('// *** %s'%self.infile.name)
        self.add_line('// %d master, %d slave %s wishbone interconnect'%
                            (len(self.config.masters),len(self.config.slaves),
                             "shared bus"))
        self.add_line('//')
        self.add_line('// ADDRESS MAP')
        for slave in self.config.slaves:
            self.add_line("// %8s: 0x%X - 0x%X"%
                          (slave.name,slave.base,slave.base + slave.size - 1))
            
    def add_master_port(self, master):
        self.add_line("//Master port '%s':"%master.name)
        self.add_line('input wire [%d:0] %s_adr_i,'%
                      (master.address_width-1,master.name))
        self.add_line('output reg [%d:0] %s_dat_o,'%
                      (self.config.settings.data_width-1,master.name))
        self.add_line('input wire  [%d:0] %s_dat_i,'%
                      (self.config.settings.data_width-1,master.name))
        self.add_line('input wire        %s_cyc_i,'%
                      (master.name))
        self.add_line('input wire        %s_stb_i,'%
                      (master.name))
        self.add_line('input wire        %s_we_i,'%
                      (master.name))
        self.add_line('output reg       %s_ack_o,'%
                      (master.name))
        if(master.include_address_valid):
            self.add_line('output wire       %s_adrv_o,'%(master.name))
            
    def add_slave_port(self, slave):
        self.add_line("//Slave port '%s':"%slave.name)
        self.add_line('output wire [%d:0] %s_adr_o,'%
                      (slave.address_width-1,slave.name))
        self.add_line('output wire [%d:0] %s_dat_o,'%
                      (self.config.settings.data_width-1,slave.name))
        self.add_line('input wire  [%d:0] %s_dat_i,'%
                      (self.config.settings.data_width-1,slave.name))
        self.add_line('output wire       %s_cyc_o,'%
                      (slave.name))
        self.add_line('output wire       %s_stb_o,'%
                      (slave.name))
        self.add_line('output wire       %s_we_o,'%
                      (slave.name))
        self.add_line('input wire        %s_ack_i,'%
                      (slave.name))
    def add_wire_throughs(self):
        master = self.config.masters[0]
        for slave in self.config.slaves:
            self.add_line('assign %s_adr_o = %s_adr_i[%s:0];'%
                          (slave.name,master.name,slave.address_width-1))
            self.add_line('assign %s_we_o = %s_we_i;'%
                          (slave.name,master.name))
            self.add_line('assign %s_dat_o = %s_dat_i;'%
                          (slave.name,master.name))
    
    def add_addr_decode(self):
        master = self.config.masters[0]
        ssel_width = clog2(len(self.config.slaves)+1)
        self.add_line('reg [%d:0] s_sel;'%(ssel_width - 1))
        self.add_line('always @*')
        self.ts += 1
        count = 1;
        for slave in self.config.slaves:
            self.add_line("if( %s_adr_i[%d:%d] == %d'd%d)"%
                (master.name,master.address_width-1,slave.address_width, 
                 master.address_width - slave.address_width, 
                 slave.base >> (slave.address_width )))
            self.ts += 1
            self.add_line("s_sel = %d'd%d;"%(ssel_width,count))
            self.ts -= 1
            self.add_line("else")
            count +=1
        self.ts += 1
        self.add_line("s_sel = %d'd0;"%(ssel_width))
        self.ts -= 1 
        self.ts -= 1
        
    def add_m2s_muxes(self):
        master = self.config.masters[0]
        ssel_width = clog2(len(self.config.slaves)+1)
        count = 1
        for slave in self.config.slaves:
            self.add_line("assign %s_stb_o = (s_sel==%d'd%d)? %s_stb_i : 1'b0;"%
                          (slave.name,ssel_width,count,master.name))
            self.add_line("assign %s_cyc_o = (s_sel==%d'd%d)? %s_cyc_i : 1'b0;"%
                          (slave.name,ssel_width,count,master.name))
            count +=1 
            
    def add_s2m_muxes(self):
        master = self.config.masters[0]
        ssel_width = clog2(len(self.config.slaves)+1)
        count = 1
        self.add_line("always @*")
        self.ts += 1
        self.add_line("case(s_sel) /* synthesis parallel_case */")
        self.ts += 1
        for slave in self.config.slaves:
            self.add_line("%d'd%d: begin"%(ssel_width,count))
            self.ts += 1 
            self.add_line("%s_dat_o = %s_dat_i;"%(master.name, slave.name))
            self.add_line("%s_ack_o = %s_ack_i;"%(master.name, slave.name))
            self.ts -= 1
            self.add_line("end")
            count += 1
       
        self.add_line("default: begin")
        self.ts += 1 
        self.add_line("%s_dat_o = 0;"%(master.name))
        self.add_line("%s_ack_o = 0;"%(master.name))
        self.ts -= 1
        self.add_line("end")
        self.ts -= 1
        self.add_line("endcase")
        self.ts -= 1
        self.add_line("assign %s_adrv_o = s_sel != 0;"%master.name)
        
            
            
    def build_module_decl(self):
        self.add_line('module %s('%self.config.name)
        self.ts += 5
        for master in self.config.masters:
            self.add_master_port(master)
        for slave in self.config.slaves:
            self.add_slave_port(slave)
        self.add_line('//Syscon connections')
        self.add_line('input wire clk_i,')
        self.add_line('input wire rst_i')
        self.add_line(');')
        self.ts -=4
  
        
    def build_interconnect(self):
        self.build_module_decl()
        self.add_wire_throughs()  
        self.add_line('')  
        self.add_addr_decode()
        self.add_line('')
        self.add_m2s_muxes()
        self.add_line('')
        self.add_s2m_muxes()
        self.ts -=1
        self.add_line('endmodule')
    
    def __init__(self):
        argparser = argparse.ArgumentParser(
                            description='Build a Wishbone bus interconnect')
        argparser.add_argument('inpath', help='Bus description file name')
        argparser.add_argument('-o', dest = 'outpath', help='Output file name')
        args = argparser.parse_args()
        
        if args.outpath == None:
            args.outpath = os.path.splitext(args.inpath)[0] +".v" 
        self.infile = open(args.inpath)
        jsonconfig = demjson.decode(self.infile.read(), strict=True,
                                     allow_comments=True, 
                                     allow_hex_numbers=True,
                                     allow_nonstring_keys=True, 
                                     allow_trailing_comma_in_literal=True)
        self.infile.close();
        self.load_config( jsonconfig )   
        self.ts = 0
        self.lines = []
        
        self.print_header()
        self.build_interconnect()
        
        outfile = open(args.outpath,'w')
        outfile.write('\n'.join(self.lines))
        outfile.close()
    
if __name__ == "__main__":
    wb_builder()