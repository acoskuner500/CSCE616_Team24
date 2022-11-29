#mode:-regr

puts [format "VMGR_TIME_LOG;merge_start;%s" [clock seconds]]; 

load -session htax_regress.acoskuner500.22_11_28_19_24_09_4197;
readCoverageInternal;

puts [format "VMGR_TIME_LOG;merge_end;%s" [clock seconds]];