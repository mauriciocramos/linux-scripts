#!/bin/bash
nvidia-smi --query-supported-clocks=memory,graphics \
--format=csv \
#-f nvidia-clocks.csv
