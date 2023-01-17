#!/bin/bash
nvidia-smi --query-compute-apps=\
timestamp,\
gpu_name,\
gpu_bus_id,\
gpu_serial,\
gpu_uuid,\
pid,\
process_name,\
used_gpu_memory \
--format=csv -l 1 \
-f nvidia-compute-apps.csv
