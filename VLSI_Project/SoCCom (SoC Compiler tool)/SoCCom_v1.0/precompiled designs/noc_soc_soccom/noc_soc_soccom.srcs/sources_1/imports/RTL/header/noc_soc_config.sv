/* Copyright (c) 2016-2017 by the author(s)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * ============================================================================
 *
 * Configuration struct
 *
 * This is the static configuration struct. It contains all global configuration
 * settings and is propagated through the hierarchy.
 *
 * There are two struct: The base_config_t struct contains all configuration
 * settings. It is used to setup the system. The config_t struct contains some
 * extra settings, which are derived from the base settings. You can call the
 * function derive_config to convert a base_config_t struct into a config_t.
 *
 * When you add a base variable you need to add it at three positions:
 *
 *  - In base_config_t
 *  - In config_t
 *  - The copy operation in derive_config
 *
 * If it is a derived setting, you only need to add it to the latter two.
 *
 * Author(s):
 *   Stefan Wallentowitz <stefan@wallentowitz.de>
 */

package noc_soc_config;

   import noc_soc_functions::*;

   typedef enum { EXTERNAL, PLAIN } lmem_style_t;

   typedef struct packed {
   
      integer            NR_MASTERS;
      integer            NR_SLAVES;
      integer            ID;

      
      logic              ENABLE_S0;
      integer            S0_BASE;
      integer            S0_SIZE;
      
      logic              ENABLE_S1;
      integer            S1_BASE;
      integer            S1_SIZE;
      
      logic              ENABLE_S2;
      integer            S2_BASE;
      integer            S2_SIZE;
      
      logic              ENABLE_S3;
      integer            S3_BASE;
      integer            S3_SIZE;
      
      logic              ENABLE_S4;
      integer            S4_BASE;
      integer            S4_SIZE;
      
      logic              ENABLE_S5;
      integer            S5_BASE;
      integer            S5_SIZE;
      
      logic              ENABLE_S6;
      integer            S6_BASE;
      integer            S6_SIZE;
      
      logic              ENABLE_S7;
      integer            S7_BASE;
      integer            S7_SIZE;
      
      logic              ENABLE_S8;
      integer            S8_BASE;
      integer            S8_SIZE;
      
      logic              ENABLE_S9;
      integer            S9_BASE;
      integer            S9_SIZE;
   
      
      // System configuration
      integer     NUMTILES;
      integer     NUMCTS;
      logic [63:0][15:0] CTLIST;
      integer            CORES_PER_TILE;
      integer            GMEM_SIZE;
      integer            GMEM_TILE;

 
      // NoC-related configuration
      logic NOC_ENABLE_VCHANNELS;
      //  -> derived
      integer   NOC_FLIT_WIDTH;
      integer   NOC_CHANNELS;
      integer  FLIT_WIDTH;
      integer   CHANNELS;
      integer   VCHANNELS;
      
      integer  BUFFER_SIZE_IN;
      integer  BUFFER_SIZE_OUT;
      integer  DESTS; 
      integer  ROUTES;

      // Tile configuration
      integer            LMEM_SIZE;
      lmem_style_t       LMEM_STYLE;
      logic              ENABLE_BOOTROM;
      integer            BOOTROM_SIZE;
      logic              ENABLE_DM;
      integer            DM_BASE;
      integer            DM_SIZE;
      logic              ENABLE_PGAS;
      integer            PGAS_BASE;
      integer            PGAS_SIZE;

      // Network adapter configuration
      logic              NA_ENABLE_MPSIMPLE;
      logic              NA_ENABLE_DMA;
      logic              NA_DMA_GENIRQ;
      integer            NA_DMA_ENTRIES;

      // Debug configuration
      logic              USE_DEBUG;
      logic              DEBUG_STM;
      logic              DEBUG_CTM;
      integer            DEBUG_SUBNET_BITS;
      integer            DEBUG_LOCAL_SUBNET;
      integer            DEBUG_ROUTER_BUFFER_SIZE;
      integer            DEBUG_MAX_PKT_LEN;
   } base_config_t;

   typedef struct        packed {
      
      logic              ENABLE_S0;
      integer            S0_BASE;
      integer            S0_SIZE;
      integer            S0_RANGE_WIDTH;
      integer            S0_RANGE_MATCH;
      
      logic              ENABLE_S1;
      integer            S1_BASE;
      integer            S1_SIZE;
      integer            S1_RANGE_WIDTH;
      integer            S1_RANGE_MATCH;
      
      logic              ENABLE_S2;
      integer            S2_BASE;
      integer            S2_SIZE;
      integer            S2_RANGE_WIDTH;
      integer            S2_RANGE_MATCH;
      
      logic              ENABLE_S3;
      integer            S3_BASE;
      integer            S3_SIZE;
      integer            S3_RANGE_WIDTH;
      integer            S3_RANGE_MATCH;
      
      logic              ENABLE_S4;
      integer            S4_BASE;
      integer            S4_SIZE;
      integer            S4_RANGE_WIDTH;
      integer            S4_RANGE_MATCH;
      
      logic              ENABLE_S5;
      integer            S5_BASE;
      integer            S5_SIZE;
      integer            S5_RANGE_WIDTH;
      integer            S5_RANGE_MATCH;
      
      logic              ENABLE_S6;
      integer            S6_BASE;
      integer            S6_SIZE;
      integer            S6_RANGE_WIDTH;
      integer            S6_RANGE_MATCH;
      
      logic              ENABLE_S7;
      integer            S7_BASE;
      integer            S7_SIZE;
      integer            S7_RANGE_WIDTH;
      integer            S7_RANGE_MATCH;
      
      logic              ENABLE_S8;
      integer            S8_BASE;
      integer            S8_SIZE;
      integer            S8_RANGE_WIDTH;
      integer            S8_RANGE_MATCH;
      
      
      logic              ENABLE_S9;
      integer            S9_BASE;
      integer            S9_SIZE;
      integer            S9_RANGE_WIDTH;
      integer            S9_RANGE_MATCH; 
      
      integer NR_MASTERS;
      integer NR_SLAVES;
      integer ID;
      // System configuration
      integer            NUMTILES;
      integer            NUMCTS;
      logic [63:0][15:0] CTLIST;
      integer            CORES_PER_TILE;
      integer            GMEM_SIZE;
      integer            GMEM_TILE;
      //  -> derived
      integer            TOTAL_NUM_CORES;

      // NoC-related configuration
      logic              NOC_ENABLE_VCHANNELS;
      //  -> derived
      integer            NOC_FLIT_WIDTH;
      integer            NOC_CHANNELS;
       integer  FLIT_WIDTH;
      integer   CHANNELS;
      integer            VCHANNELS;
      
      integer BUFFER_SIZE_IN;
      integer BUFFER_SIZE_OUT;
      integer DESTS; 
      integer ROUTES;

      // Tile configuration
      integer            LMEM_SIZE;
      lmem_style_t       LMEM_STYLE;
      logic              ENABLE_BOOTROM;
      integer            BOOTROM_SIZE;
      logic              ENABLE_DM;
      integer            DM_BASE;
      integer            DM_SIZE;
      logic              ENABLE_PGAS;
      integer            DM_RANGE_WIDTH;
      integer            DM_RANGE_MATCH;
      integer            PGAS_BASE;
      integer            PGAS_SIZE;
      integer            PGAS_RANGE_WIDTH;
      integer            PGAS_RANGE_MATCH;

      // Network adapter configuration
      logic              NA_ENABLE_MPSIMPLE;
      logic              NA_ENABLE_DMA;
      logic              NA_DMA_GENIRQ;
      integer            NA_DMA_ENTRIES;

      // Debug configuration
      logic              USE_DEBUG;
      logic              DEBUG_STM;
      logic              DEBUG_CTM;
      integer            DEBUG_SUBNET_BITS;
      integer            DEBUG_LOCAL_SUBNET;
      integer            DEBUG_ROUTER_BUFFER_SIZE;
      integer            DEBUG_MAX_PKT_LEN;
      // -> derived
      integer            DEBUG_MODS_PER_CORE;
      integer            DEBUG_MODS_PER_TILE;
      integer            DEBUG_NUM_MODS;
   } config_t;

   function config_t derive_config(base_config_t conf);
      
      derive_config.ENABLE_S0 = conf.ENABLE_S0;
      derive_config.S0_BASE = conf.S0_BASE;
      derive_config.S0_SIZE = conf.S0_SIZE;
      
      derive_config.ENABLE_S1 = conf.ENABLE_S1;
      derive_config.S1_BASE = conf.S1_BASE;
      derive_config.S1_SIZE = conf.S1_SIZE;
      
      derive_config.ENABLE_S2 = conf.ENABLE_S2;
      derive_config.S2_BASE = conf.S2_BASE;
      derive_config.S2_SIZE = conf.S2_SIZE;
      
      derive_config.ENABLE_S3 = conf.ENABLE_S3;
      derive_config.S3_BASE = conf.S3_BASE;
      derive_config.S3_SIZE = conf.S3_SIZE;
      
      derive_config.ENABLE_S4 = conf.ENABLE_S4;
      derive_config.S4_BASE = conf.S4_BASE;
      derive_config.S4_SIZE = conf.S4_SIZE;
      
      derive_config.ENABLE_S5 = conf.ENABLE_S5;
      derive_config.S5_BASE = conf.S5_BASE;
      derive_config.S5_SIZE = conf.S5_SIZE;
      
      derive_config.ENABLE_S6 = conf.ENABLE_S6;
      derive_config.S6_BASE = conf.S6_BASE;
      derive_config.S6_SIZE = conf.S6_SIZE;
      
      derive_config.ENABLE_S7 = conf.ENABLE_S7;
      derive_config.S7_BASE = conf.S7_BASE;
      derive_config.S7_SIZE = conf.S7_SIZE;
      
      derive_config.ENABLE_S8 = conf.ENABLE_S8;
      derive_config.S8_BASE = conf.S8_BASE;
      derive_config.S8_SIZE = conf.S8_SIZE;
      
      derive_config.ENABLE_S9 = conf.ENABLE_S9;
      derive_config.S9_BASE = conf.S9_BASE;
      derive_config.S9_SIZE = conf.S9_SIZE; 

      derive_config.S0_RANGE_WIDTH = 1;
      derive_config.S0_RANGE_MATCH = 1'b0;
      
      derive_config.S1_RANGE_WIDTH = 1;
      derive_config.S1_RANGE_MATCH = 1'b0; 
      
      //derive_config.S2_RANGE_WIDTH = 1;
      //derive_config.S2_RANGE_MATCH = 1'b0;
      
      //derive_config.S3_RANGE_WIDTH = 1;
      //derive_config.S3_RANGE_MATCH = 1'b0;
      
     // derive_config.S4_RANGE_WIDTH = 1;
      //derive_config.S4_RANGE_MATCH = 1'b0;
      
     // derive_config.S5_RANGE_WIDTH = 1;
     // derive_config.S5_RANGE_MATCH = 1'b0;
      
     // derive_config.S6_RANGE_WIDTH = 1;
    //  derive_config.S6_RANGE_MATCH = 1'b0;
      
     // derive_config.S7_RANGE_WIDTH = 1;
     // derive_config.S7_RANGE_MATCH = 1'b0;
      
     // derive_config.S8_RANGE_WIDTH = 1;
     // derive_config.S8_RANGE_MATCH = 1'b0;
      
     // derive_config.S9_RANGE_WIDTH = 1;
     // derive_config.S9_RANGE_MATCH = 1'b0;
      
      derive_config.S1_RANGE_WIDTH = conf.ENABLE_S1 ? 32-clog2_width(conf.S1_SIZE) : 1;
      derive_config.S1_RANGE_MATCH = conf.S1_BASE >> (32-derive_config.S1_RANGE_WIDTH);
      
     derive_config.S2_RANGE_WIDTH = conf.ENABLE_S2 ? 32-clog2_width(conf.S2_SIZE) : 1;
     derive_config.S2_RANGE_MATCH = conf.S2_BASE >> (32-derive_config.S2_RANGE_WIDTH);
      
     derive_config.S3_RANGE_WIDTH = conf.ENABLE_S3 ? 32-clog2_width(conf.S3_SIZE) : 1;
     derive_config.S3_RANGE_MATCH = conf.S3_BASE >> (32-derive_config.S3_RANGE_WIDTH);
      
     derive_config.S4_RANGE_WIDTH = conf.ENABLE_S4 ? 32-clog2_width(conf.S4_SIZE) : 1;
    derive_config.S4_RANGE_MATCH = conf.S4_BASE >> (32-derive_config.S4_RANGE_WIDTH);
      
      derive_config.S5_RANGE_WIDTH = conf.ENABLE_S5 ? 32-clog2_width(conf.S5_SIZE) : 1;
     derive_config.S5_RANGE_MATCH = conf.S5_BASE >> (32-derive_config.S5_RANGE_WIDTH);
      
     derive_config.S6_RANGE_WIDTH = conf.ENABLE_S6 ? 32-clog2_width(conf.S6_SIZE) : 1;
     derive_config.S6_RANGE_MATCH = conf.S6_BASE >> (32-derive_config.S6_RANGE_WIDTH);
      
     derive_config.S7_RANGE_WIDTH = conf.ENABLE_S7 ? 32-clog2_width(conf.S7_SIZE) : 1;
      derive_config.S7_RANGE_MATCH = conf.S7_BASE >> (32-derive_config.S7_RANGE_WIDTH);
      
      derive_config.S8_RANGE_WIDTH = conf.ENABLE_S8 ? 32-clog2_width(conf.S8_SIZE) : 1;
      derive_config.S8_RANGE_MATCH = conf.S8_BASE >> (32-derive_config.S8_RANGE_WIDTH);
      
      derive_config.S9_RANGE_WIDTH = conf.ENABLE_S9 ? 32-clog2_width(conf.S9_SIZE) : 1;
      derive_config.S9_RANGE_MATCH = conf.S9_BASE >> (32-derive_config.S9_RANGE_WIDTH);
      
      derive_config.S0_RANGE_WIDTH = conf.ENABLE_S0 ? 32-clog2_width(conf.S0_SIZE) : 1;
      derive_config.S0_RANGE_MATCH = conf.S0_BASE >> (32-derive_config.S0_RANGE_WIDTH);
      
      //derive_config.S1_RANGE_WIDTH = conf.ENABLE_S1 ? 32-clog2_width(conf.S1_SIZE) : 1;
      //derive_config.S1_RANGE_MATCH = conf.S1_BASE >> (32-derive_config.S1_RANGE_WIDTH);
      
     // derive_config.S2_RANGE_WIDTH = conf.ENABLE_S2 ? 32-clog2_width(conf.S2_SIZE) : 1;
     // derive_config.S2_RANGE_MATCH = conf.S2_BASE >> (32-derive_config.S2_RANGE_WIDTH);
      
     // derive_config.S3_RANGE_WIDTH = conf.ENABLE_S3 ? 32-clog2_width(conf.S3_SIZE) : 1;
     // derive_config.S3_RANGE_MATCH = conf.S3_BASE >> (32-derive_config.S3_RANGE_WIDTH);
      
     // derive_config.S4_RANGE_WIDTH = conf.ENABLE_S4 ? 32-clog2_width(conf.S4_SIZE) : 1;
    //  derive_config.S4_RANGE_MATCH = conf.S4_BASE >> (32-derive_config.S4_RANGE_WIDTH);
      
      //derive_config.S5_RANGE_WIDTH = conf.ENABLE_S5 ? 32-clog2_width(conf.S5_SIZE) : 1;
     // derive_config.S5_RANGE_MATCH = conf.S5_BASE >> (32-derive_config.S5_RANGE_WIDTH);
      
     // derive_config.S6_RANGE_WIDTH = conf.ENABLE_S6 ? 32-clog2_width(conf.S6_SIZE) : 1;
     // derive_config.S6_RANGE_MATCH = conf.S6_BASE >> (32-derive_config.S6_RANGE_WIDTH);
      
     // derive_config.S7_RANGE_WIDTH = conf.ENABLE_S7 ? 32-clog2_width(conf.S7_SIZE) : 1;
      //derive_config.S7_RANGE_MATCH = conf.S7_BASE >> (32-derive_config.S7_RANGE_WIDTH);
      
      //derive_config.S8_RANGE_WIDTH = conf.ENABLE_S8 ? 32-clog2_width(conf.S8_SIZE) : 1;
      //derive_config.S8_RANGE_MATCH = conf.S8_BASE >> (32-derive_config.S8_RANGE_WIDTH);
      
      //derive_config.S9_RANGE_WIDTH = conf.ENABLE_S9 ? 32-clog2_width(conf.S9_SIZE) : 1;
      //derive_config.S9_RANGE_MATCH = conf.S9_BASE >> (32-derive_config.S9_RANGE_WIDTH);
      
      // Copy the basic parameters
      derive_config.NUMTILES = conf.NUMTILES;
      derive_config.NUMCTS = conf.NUMCTS;
      derive_config.CTLIST = conf.CTLIST;
      derive_config.CORES_PER_TILE = conf.CORES_PER_TILE;
      derive_config.GMEM_SIZE = conf.GMEM_SIZE;
      derive_config.GMEM_TILE = conf.GMEM_TILE;
      derive_config.NOC_ENABLE_VCHANNELS = conf.NOC_ENABLE_VCHANNELS;
      derive_config.LMEM_SIZE = conf.LMEM_SIZE;
      derive_config.LMEM_STYLE = conf.LMEM_STYLE;
      derive_config.ENABLE_BOOTROM = conf.ENABLE_BOOTROM;
      derive_config.BOOTROM_SIZE = conf.BOOTROM_SIZE;
      derive_config.ENABLE_DM = conf.ENABLE_DM;
      derive_config.DM_BASE = conf.DM_BASE;
      derive_config.DM_SIZE = conf.DM_SIZE;
      derive_config.ENABLE_PGAS = conf.ENABLE_PGAS;
      derive_config.PGAS_BASE = conf.PGAS_BASE;
      derive_config.PGAS_SIZE = conf.PGAS_SIZE;
      derive_config.NA_ENABLE_MPSIMPLE = conf.NA_ENABLE_MPSIMPLE;
      derive_config.NA_ENABLE_DMA = conf.NA_ENABLE_DMA;
      derive_config.NA_DMA_GENIRQ = conf.NA_DMA_GENIRQ;
      derive_config.NA_DMA_ENTRIES = conf.NA_DMA_ENTRIES;
      derive_config.USE_DEBUG = conf.USE_DEBUG;
      derive_config.DEBUG_STM = conf.DEBUG_STM;
      derive_config.DEBUG_CTM = conf.DEBUG_CTM;
      derive_config.DEBUG_SUBNET_BITS = conf.DEBUG_SUBNET_BITS;
      derive_config.DEBUG_LOCAL_SUBNET = conf.DEBUG_LOCAL_SUBNET;
      derive_config.DEBUG_ROUTER_BUFFER_SIZE = conf.DEBUG_ROUTER_BUFFER_SIZE;
      derive_config.DEBUG_MAX_PKT_LEN = conf.DEBUG_MAX_PKT_LEN;

      // Derive the other parameters
      derive_config.TOTAL_NUM_CORES = conf.NUMCTS * conf.CORES_PER_TILE;

      derive_config.DM_RANGE_WIDTH = conf.ENABLE_DM ? 32-clog2_width(conf.DM_SIZE) : 1;
      derive_config.DM_RANGE_MATCH = conf.DM_BASE >> (32-derive_config.DM_RANGE_WIDTH);
      derive_config.PGAS_RANGE_WIDTH = conf.ENABLE_PGAS ? 32-clog2_width(conf.PGAS_SIZE) : 1;
      derive_config.PGAS_RANGE_MATCH = conf.PGAS_BASE >> (32-derive_config.PGAS_RANGE_WIDTH);

      derive_config.DEBUG_MODS_PER_CORE = (int'(conf.DEBUG_STM) + int'(conf.DEBUG_CTM)) * int'(conf.USE_DEBUG);
      derive_config.DEBUG_MODS_PER_TILE = conf.USE_DEBUG *
                                          (1 /* MAM */
                                           + derive_config.DEBUG_MODS_PER_CORE * conf.CORES_PER_TILE);
      derive_config.DEBUG_NUM_MODS = conf.USE_DEBUG *
                                     (1 /* SCM */
                                      + conf.NUMCTS * derive_config.DEBUG_MODS_PER_TILE);

      // Those are supposed to be variables, but are constant at least for now
     // derive_config.CHANNELS = 2;
     // derive_config.FLIT_WIDTH = 32;
   endfunction // DERIVE_CONFIG

     localparam base_config_t
     BASE_CONFIG = '{ 
     
     ENABLE_S0:1,
     S0_BASE:32'h0000_0000,
     S0_SIZE: 32,
                      
     ENABLE_S1:1,
     S1_BASE:32'h9000_0000,
     S1_SIZE: 32,
     
     ENABLE_S2:1,
     S2_BASE:32'h9300_0000,
     S2_SIZE:32,
     
     ENABLE_S3:1,
     S3_BASE:32'h9400_0000,
     S3_SIZE:32,
     
     ENABLE_S4:1,
     S4_BASE:32'h9500_0000,
     S4_SIZE:32,
     
     ENABLE_S5:1,
     S5_BASE:32'h9600_0000,
     S5_SIZE:32,
     
     ENABLE_S6:1,
     S6_BASE:32'h9700_0000,
     S6_SIZE:32,
     
     ENABLE_S7:1,
     S7_BASE:32'h9800_0000,
     S7_SIZE:32,
     
     ENABLE_S8:1,
     S8_BASE:32'h9900_0000,
     S8_SIZE:32,
     
     ENABLE_S9:1,
     S9_BASE:32'h9A00_0000,
     S9_SIZE:32,
     
      NR_MASTERS:1,
      NR_SLAVES:9,
      ID: 10,
      
      NUMTILES: 10,
      NUMCTS: 10,
      CTLIST: 0,
      CORES_PER_TILE: 1,
      GMEM_SIZE: 'x,
      GMEM_TILE: 'x,

      // NoC-related configuration
      NOC_ENABLE_VCHANNELS:1,
      //  -> derived
      NOC_FLIT_WIDTH: 32,
      NOC_CHANNELS:2,
      FLIT_WIDTH:32,
      CHANNELS:2,
      VCHANNELS:2,
      BUFFER_SIZE_IN: 4,
      BUFFER_SIZE_OUT: 4,
      DESTS: 32, 
      ROUTES: 320,

      // Tile configuration
      LMEM_SIZE: 'x,
      LMEM_STYLE: PLAIN,
      ENABLE_BOOTROM:0,
      BOOTROM_SIZE:'x,
      ENABLE_DM:0,
      DM_BASE:'x,
      DM_SIZE:'x,
      ENABLE_PGAS:0,
      PGAS_BASE:'x,
      PGAS_SIZE:'x,

      // Network adapter configuration
      NA_ENABLE_MPSIMPLE:1,
      NA_ENABLE_DMA:1,
      NA_DMA_GENIRQ: 1,
      NA_DMA_ENTRIES:'x,

      // Debug configuration
      USE_DEBUG:0,
      DEBUG_STM:0,
      DEBUG_CTM:0,
      DEBUG_SUBNET_BITS: 'x,
      DEBUG_LOCAL_SUBNET: 'x,
      DEBUG_ROUTER_BUFFER_SIZE: 'x,
      DEBUG_MAX_PKT_LEN: 'x
 
                      };

   localparam config_t CONFIG = derive_config(BASE_CONFIG);


endpackage // optimsoc
