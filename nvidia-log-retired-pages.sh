#!/bin/bash
nvidia-smi --query-retired-pages=\
timestamp,\
gpu_name,\
gpu_bus_id,\
gpu_serial,\
gpu_uuid,\
retired_pages.address,\
retired_pages.timestamp,\
retired_pages.cause \
--format=csv -l 1 \
-f nvidia-gpu.csv
