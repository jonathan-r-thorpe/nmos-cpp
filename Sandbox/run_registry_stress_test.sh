#!/bin/bash

run_python=$1
shift
registry_command=$1
shift
results_dir=$1
shift
host_ip=$1
shift
script_dir=$1
shift

common_params=",\
  \"logging_level\":-40,\
  \"host_address\":\"${host_ip}\",\
  \"host_addresses\":[\"${host_ip}\"]\
  "
registry_params=",\
  \"label\":\"nmos-cpp-registry\"\
  "
  
# Run Registry stress tests
"${registry_command}" "{\"pri\":0,\"http_port\":8088 ${common_params} ${registry_params}}" > ${results_dir}/registryoutput_stresstest 2>&1 &
REGISTRY_PID=$!

"${run_python} ${script_dir}/registry_stress_test.py --host ${host_ip} --port 8088" >> ${results_dir}/stresstest 2>&1

# Stop Node and Registry
kill $REGISTRY_PID || echo "registry not running"

