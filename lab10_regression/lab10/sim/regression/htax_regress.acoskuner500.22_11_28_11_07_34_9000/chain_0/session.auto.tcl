#mode:-regr

puts [format "VMGR_TIME_LOG;merge_start;%s" [clock seconds]]; 

load -session htax_regress.acoskuner500.22_11_28_11_07_34_9000;
readCoverageInternal;

puts [format "VMGR_TIME_LOG;merge_end;%s" [clock seconds]];