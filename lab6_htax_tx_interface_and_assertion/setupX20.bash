#!/bin/bash
export UVMHOME="/opt/coe/cadence/XCELIUM20/tools/methodology/UVM/CDNS-1.1d/sv"
#source /opt/coe/cadence/XCELIUM20/setup.XCELIUM.linux.bash
export CDS_ROOT=/opt/coe/cadence/XCELIUM20
export CDS_INST_DIR=/opt/coe/cadence/XCELIUM20
export PATH=/opt/coe/cadence/XCELIUM20/tools/bin:/opt/coe/cadence/XCELIUM20/tools/dfII/bin:/opt/coe/cadence/XCELIUM20/tools/plot/bin:/opt/coe/cadence/XCELIUM20/tools/cdsgcc/gcc/bin:/opt/coe/cadence/XCELIUM20/tools.lnx86/bin:${PATH}
export CDS=/opt/coe/cadence/XCELIUM20
export IC=/opt/coe/cadence/XCELIUM20
export CDS_SITE=localhost
export CDS_LIC_FILE=5280@coe-vtls2.engr.tamu.edu
export LD_LIBRARY_PATH=/opt/coe/cadence/XCELIUM20/tools.lnx86/lib/64bit:$LD_LIBRARY_PATH
export W3264_NO_HOST_CHECK=1
export MDV_XLM_HOME=/opt/coe/cadence/XCELIUM20
source /opt/coe/cadence/vmanager/setup.vmanager.linux.bash
echo Success
