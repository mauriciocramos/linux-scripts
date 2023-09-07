#!/bin/bash
nvidia-smi --query-remapped-rows=\
timestamp,\
gpu_name,\
gpu_bus_id,\
gpu_serial,\
gpu_uuid,\
remapped_rows.correctable,\
remapped_rows.uncorrectable,\
remapped_rows.pending,\
remapped_rows.failure \
--format=csv -l 1 \
#-f nvidia-gpu.csv
