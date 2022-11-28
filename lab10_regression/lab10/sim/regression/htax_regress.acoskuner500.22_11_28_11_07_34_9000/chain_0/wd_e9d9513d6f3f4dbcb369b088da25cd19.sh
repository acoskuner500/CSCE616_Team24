#!/bin/sh


/opt/coe/cadence/vmanager/tools/vmgr/jobs_manager/bin/vm_jobs_manager_watchdog -chain_dir /home/grads/a/acoskuner500/csce616/lab10_regression/lab10/sim/regression/htax_regress.acoskuner500.22_11_28_11_07_34_9000/chain_0 -launch_file /home/grads/a/acoskuner500/csce616/lab10_regression/lab10/sim/regression/htax_regress.acoskuner500.22_11_28_11_07_34_9000/chain_0/jobs_manager_launch.json -proc_dir /home/vmanager/vmgr_2003profile/proc_mgnt/projects/vmgr -chunks_dir /home/vmanager/vmgr_2003profile/chunks/projects/vmgr

exitCode=$?

if [ $exitCode -ne 0 ]; then

echo " failure job_manager_server {
description: Unable to start job manager server please look at the logs /home/grads/a/acoskuner500/csce616/lab10_regression/lab10/sim/regression/htax_regress.acoskuner500.22_11_28_11_07_34_9000/chain_0/.job_manager.out, /home/grads/a/acoskuner500/csce616/lab10_regression/lab10/sim/regression/htax_regress.acoskuner500.22_11_28_11_07_34_9000/chain_0/debug_logs.;
severity: <text>critical</text>;
failure_source_type_vmgr: pre_session;
}
" >> /tmp/vmgr-vmanager.acoskuner500.VgdlYOnq1.1669651885198/job_manager_server.chunk;

/home/grads/a/acoskuner500/csce616/lab10_regression/lab10/sim/regression/htax_regress.acoskuner500.22_11_28_11_07_34_9000/chain_0/vsof_appender.sh /tmp/vmgr-vmanager.acoskuner500.VgdlYOnq1.1669651885198/job_manager_server.chunk

rm /tmp/vmgr-vmanager.acoskuner500.VgdlYOnq1.1669651885198/job_manager_server.chunk;
fi

exit $exitCode;

