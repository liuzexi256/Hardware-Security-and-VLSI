
#-*- coding: utf-8 -*-
"""
File:   Wishbone_Generator.py
Author: Zexi Liu, Henian Li
Date:   
Desc:   This code will intake user_define_file as input and generate Wishbone compatible IP cores (top module wrapper) as the output. 
    
"""
""" =======================  Import dependencies ========================== """
import numpy as np
import math
import sys
from PyQt5.QtWidgets import (QMainWindow, QTextEdit, 
    QAction, QFileDialog, QApplication,QWidget, QLabel, QLineEdit, QGridLayout)
from PyQt5.QtGui import QIcon
from PyQt5.QtGui import QFont

""" ======================  Function definitions ========================== """
def write_io(fp, define):
    #Define input and output from Define_File

    fp.write('module ' + define[0][1] + '_top(\n')
    fp.write('           wb_adr_i, wb_cyc_i, wb_dat_i, wb_sel_i,\n')
    fp.write('           wb_stb_i, wb_we_i,\n')
    fp.write('           wb_ack_o, wb_err_o, wb_dat_o,\n')
    fp.write('           wb_clk_i, wb_rst_i, int_o\n')
    fp.write('       );\n')
    fp.write('parameter dw = 32;\n')
    fp.write('parameter aw = 32;\n')
    fp.write('input [aw-1:0] wb_adr_i;\n')
    fp.write('input   wb_cyc_i;\n')
    fp.write('input [dw-1:0]  wb_dat_i;\n')
    fp.write('input [3:0]   wb_sel_i;\n')
    fp.write('input   wb_stb_i;\n')
    fp.write('input   wb_we_i;\n')
    fp.write('output   wb_ack_o;\n')
    fp.write('output   wb_err_o;\n')
    fp.write('output reg [dw-1:0]  wb_dat_o;\n')
    fp.write('output  int_o;\n')
    fp.write('input   wb_clk_i;\n')
    fp.write('input   wb_rst_i;\n')

    fp.write("assign wb_ack_o = 1'b1;\n")
    fp.write("assign wb_err_o = 1'b0;\n")
    fp.write("assign int_o = 1'b0;\n")

def write_reg(fp, define):
    #Define internal registers from Define_File

    fp.write("reg start, start_r;\n")
    if int(define[5][1]):
        fp.write("reg next, next_r;\n")
    if int(define[22][1]):
        fp.write("reg " + define[22][2] + ", " + define[22][2] +  "_r;\n")

    if int(define[9][1]):
        temp = int(define[9][1])//32
        fp.write("reg [31:0] data [0:" + str(int(temp) - 1) + "];\n")
        fp.write("wire [" + str(int(define[9][1]) - 1) + ":0] bigData = {")
        for i in range(temp):
            if i == temp - 1:
                fp.write("data[" + str(temp - 1 - i) + "]")
                continue
            fp.write("data[" + str(temp - 1 - i) + "], ")
        fp.write("};\n")
            
    if int(define[12][1]):
        fp.write("wire [" + str(int(define[12][1]) - 1) + ":0] valid;\n")

    if int(define[10][1]):
        fp.write("wire ready;\n")
    if int(define[11][1]):
        fp.write("wire ready_for_res;\n")
    if int(define[4][1]):
        fp.write("reg decrypt;\n")

    if int(define[6][1]) != 0 and int(define[7][1]) != 0 and int(define[8][1]) != 0:
        temp = (int(define[6][1]) + int(define[7][1]) + int(define[8][1]))
        fp.write("reg wb_stb_i_r;\n")
        fp.write("reg [31:0] key [0:" + str(temp//32) + "];\n")
        fp.write("wire [" + str(int(define[6][1]) - 1) + ":0] key_1;\n")
        fp.write("wire [" + str(int(define[7][1]) - 1) + ":0] key_2;\n")
        fp.write("wire [" + str(int(define[8][1]) - 1) + ":0] key_3;\n")
    elif int(define[6][1]) != 0 and int(define[7][1]) == 0 and int(define[8][1]) == 0:
        temp = int(define[6][1])//32
        fp.write("reg wb_stb_i_r;\n")
        fp.write("reg [31:0] key [0:" + str(int(temp) - 1) + "];\n")
        fp.write("wire [" + str(int(define[6][1]) - 1) + ":0] bigKey = {")
        for i in range(temp):
            if i == temp - 1:
                fp.write("key[" + str(temp - 1 - i) + "]")
                continue
            fp.write("key[" + str(temp - 1 - i) + "], ")
        fp.write("};\n")


def write_ws(fp, define):
    #Define write side from Define_File

    fp.write("always @(posedge wb_clk_i)\n")
    fp.write("    begin\n")
    fp.write("        if(!wb_rst_i)\n")
    fp.write("            begin\n")
    fp.write("                start       <= 0;\n")
    fp.write("                start_r     <= 0;\n")
    if int(define[5][1]):
        fp.write("                next      <= 0;\n")
        fp.write("                next_r    <= 0;\n")
    if int(define[22][1]):
        fp.write("                " + define[22][2] + " <= 0;\n")
        fp.write("                " + define[22][2] + "_r <= 0;\n")
    if int(define[4][1]):
        fp.write("                decrypt     <= 0;\n")

    for i in range(int(define[9][1])//32):
        fp.write("                data[" + str(i) + "] <= 0;\n")

    if int(define[6][1]):
        temp = math.ceil((int(define[6][1]) + int(define[7][1]) + int(define[8][1]))/32)
        for i in range(temp):
            fp.write("                key[" + str(i) + "] <= 0;\n")

        fp.write("                wb_stb_i_r  <= 1'b0;\n")
    fp.write("            end\n")
    fp.write("        else begin\n")
    if int(define[3][1]):
        fp.write("            start_r         <= start;\n")
    if int(define[5][1]):
        fp.write("            next_r        <= next;\n")
    if int(define[22][1]):
        fp.write("            " + define[22][2] + "_r <= " + define[22][2] + ";\n")
    if int(define[6][1]):
        fp.write("            wb_stb_i_r      <= wb_stb_i;\n")
    fp.write("            if(wb_stb_i & wb_we_i) begin\n")
    fp.write("                case(wb_adr_i[6:2])\n")
    if int(define[5][1]):
        fp.write("                    0:  begin\n")
        fp.write("                            start <= wb_dat_i[0];\n")
        fp.write("                            next <= wb_dat_i[1];\n")
        fp.write("                        end\n")
    else:
        fp.write("                    0:  start <= wb_dat_i[0];\n")
    for i in range(14,17):
        name = define[i][0].split('_')[1].lower()
        if define[i][1] != '0':
            start = int(define[i][1][-2::])
            end = int(define[i][3][-2::])
            length = end - start
            num = 0
            for j in range(start, end + 1):
                if name == 'decrypt':
                    fp.write("                    " + str(j) + ":  " + name + " <= wb_dat_i;\n")
                else:
                    fp.write("                    " + str(j) + ":  " + name + "[" + str(num) + "] <= wb_dat_i;\n")
                num = num + 1
    if int(define[22][1]):
        start = int(define[22][3][-2::])
        end = int(define[22][5][-2::])
        length = end - start
        num = 0
        for j in range(start, end + 1):
            fp.write("                    " + str(j) + ":  " + define[22][6] + define[22][7] + define[22][8] + "\n")
            num = num + 1
    fp.write("                    default:\n")
    fp.write("                        ;\n")
    fp.write("                endcase\n")
    fp.write("            end else begin\n")
    fp.write("                start           <= 1'b0;\n")
    if int(define[5][1]):
        fp.write("                next          <= 1'b0;\n")
    if int(define[22][1]):
        fp.write("                " + define[22][2] + "       <= 1'b0;\n")
    fp.write("            end\n")
    fp.write("        end\n")
    fp.write("    end\n")


def write_rs(fp, define):
    #Define read side from Define_File

    fp.write("always @(*)\n")
    fp.write("    begin\n")
    fp.write("        case(wb_adr_i[6:2])\n")
    for i in range(17,22):
        name = define[i][0].split('_')[1].lower()
        if define[i][1] != '0':
            if name != 'ready' and name != 'valid' and name != 'result':
                start = int(define[i][1][-2::])
                end = int(define[i][3][-2::])
                length = end - start
                num = 0
                for j in range(start, end + 1):
                    fp.write("            " + str(j) + ":  wb_dat_o = " + name + "[" + str(num) + "];\n")
                    num = num + 1
            if name == 'ready':
                start = int(define[i][1][-2::])
                end = int(define[i][3][-2::])
                length = end - start
                num = 0
                for j in range(start, end + 1):
                    fp.write("            " + str(j) + ":  wb_dat_o = {31'b0, ready};\n")
                    num = num + 1
            if name == 'valid':
                start = int(define[i][1][-2::])
                end = int(define[i][3][-2::])
                length = end - start
                num = 0
                for j in range(start, end + 1):
                    fp.write("            " + str(j) + ":  wb_dat_o = {31'b0, ready_for_res};\n")
                    num = num + 1
            if name == 'result':
                start = int(define[i][1][-2::])
                end = int(define[i][3][-2::])
                length = end - start
                num = 0
                for j in range(start, end + 1):
                    fp.write("            " + str(j) + ": wb_dat_o = valid[" + str((num + 1)*32 - 1) + ":" + str(num*32) + "];\n")
                    num = num + 1

    fp.write("            default:\n")
    fp.write("                wb_dat_o = 32'b0;\n")
    fp.write("        endcase\n")
    fp.write("    end\n")


def write_ip(fp, define):
    #Define IP interface from Define_File

    fp.write(define[0][1] + ' ' + define[0][1] + '(\n')
    name1 = []
    name2 = []
    for i in range(1,13):
        if define[i][1] != '0':
            name1.append(define[i][-1])
            name2.append(define[i][0])
    if define[26][1] != '0':
        idx = name1.index(define[26][2])
        del name1[idx]
        del name2[idx]
        temp = define[26]
        del temp[0:2]
        fp.write('            ')
        for i in range(1, len(temp)):
            fp.write(temp[i])
        fp.write('\n')

    for i in range(len(name1)):
        if name2[i] == 'CLK':
            fp.write("           ." + name1[i] + "(wb_clk_i),\n")
        if name2[i] == 'RESET':
            fp.write("           ." + name1[i] + "(wb_rst_i),\n")
        if name2[i] == 'START':
            fp.write("           ." + name1[i] + "(start && ~start_r),\n")
        if name2[i] == 'DECRYPT':
            fp.write("           ." + name1[i] + "(decrypt),\n")
        if name2[i] == 'NEXT_MESSAGE':
            fp.write("           ." + name1[i] + "(next && ~next_r),\n")
        if name2[i] == 'KEY_1':
            if define[0][1] != 'des3':
                fp.write("           ." + name1[i] + "(bigKey),\n")
            else:
                fp.write("           ." + name1[i] + "(key_1),\n")
        if name2[i] == 'KEY_2':
            fp.write("           ." + name1[i] + "(key_2),\n")
        if name2[i] == 'KEY_3':
            fp.write("           ." + name1[i] + "(key_3),\n")
        if name2[i] == 'DATA_IN':
            fp.write("           ." + name1[i] + "(bigData),\n")
        if name2[i] == 'READY_FOR_INPUT':
            fp.write("           ." + name1[i] + "(ready),\n")
        if name2[i] == 'READY_FOR_RESULTS':
            fp.write("           ." + name1[i] + "(ready_for_res),\n")
        if name2[i] == 'DATA_OUT':
            fp.write("           ." + name1[i] + "(valid)\n")

    fp.write("        );\n")
    fp.write("endmodule\n")

def write_add(define):
    #Add extra RTL code in wrapper

    wrapper = open('%s_wrapper.v' % define[0][1], 'r')
    addwrapper = wrapper.readlines()
    wrapper.close()
    line = int(define[27][1])
    for i in range(29,10000):
        if define[i] != 'END':
            addwrapper.insert(line,define[i])
            line = line + 1
        else:
            break
    addwrapper = ''.join(addwrapper)
    f = open('%s_wrapper.v' % define[0][1], 'w+') 
    f.write(addwrapper)
    f.close()


def read_file(fileloc):
    #Read Define_File

    report = open(fileloc,"r")
    alldefine = report.readlines()
    define = alldefine
    i = 0
    while i < np.size(define):
        if define[i].find('//') == 0 or define[i].find('\n') == 0:
            del define[i]
            continue
        i = i + 1
    for i in range(29):
        define[i] = define[i].strip()
        define[i] = define[i].split()
    return define

""" ====================== GUI ========================== """
class GUI(QMainWindow):

    def __init__(self):
        super().__init__()
        
        
        self.initUI()

    def initUI(self):

        self.textEdit = QTextEdit()
        self.setCentralWidget(self.textEdit)
        self.statusBar()

        opendefine = QAction(QIcon('open.png'), 'Open', self)
        opendefine.setShortcut('Ctrl+O')
        opendefine.setStatusTip('Open Define File')
        
        opendefine.triggered.connect(self.definefile)

        menubar = self.menuBar()

        fileMenu = menubar.addMenu('&Define File')
        fileMenu.addAction(opendefine)

        self.setGeometry(300, 300, 350, 300)
        self.setWindowTitle('Wishbone Bus Generator')
        self.show()

    def definefile(self):

        fname = QFileDialog.getOpenFileName(self, 'Open define file', '/home')
        define = read_file(fname[0])
        fp = open('%s_wrapper.v' % define[0][1], 'w')

        if fname[0]:
            
            write_io(fp, define)
            write_reg(fp, define)
            write_ws(fp, define)
            write_rs(fp, define)
            write_ip(fp, define)
            fp.close()
            if int(define[27][1]):
                write_add(define)
            #fp.close()
        f = open('%s_wrapper.v' % define[0][1], 'r')
        data = f.read()
        self.textEdit.setText(data)

""" ====================== Main ========================== """
if __name__ == '__main__':

    app = QApplication(sys.argv)
    ex = GUI()
    sys.exit(app.exec_())


