#!/bin/bash
nvidia-smi --query-accounted-apps=\
timestamp,\
gpu_name,\
gpu_bus_id,\
gpu_serial,\
gpu_uuid,\
vgpu_instance,\
pid,\
gpu_utilization,\
mem_utilization,\
max_memory_usage,\
time \
--format=csv -l 1 \
#-f nvidia-accounted-apps.csv
