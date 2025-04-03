#!/bin/bash
#     [-s | --select]:      One or more metrics [default=puc]
#                          Can be any of the following:
#                              p - Power Usage and Temperature
#                              u - Utilization
#                              c - Proc and Mem Clocks
#                              v - Power and Thermal Violations
#                              m - FB and Bar1 Memory
#                              e - ECC Errors and PCIe Replay errors
#                              t - PCIe Rx and Tx Throughput
#    [N/A | --gpm-metrics]: Comma-separated list of GPM metrics to watch
#                           Available metrics:
#                               Graphics Activity    = 1
#                               SM Activity          = 2
#                               SM Occupancy         = 3
#                               Integer Activity     = 4
#                               Tensor Activity      = 5
#                               DFMA Tensor Activity = 6
#                               HMMA Tensor Activity = 7
#                               IMMA Tensor Activity = 9
#                               DRAM Activity        = 10
#                               FP64 Activity        = 11
#                               FP32 Activity        = 12
#                               FP16 Activity        = 13
#                               PCIe TX              = 20
#                               PCIe RX              = 21

nvidia-smi dmon -o DT -s pucvmt --gpm-metrics 1,2,3,4,5,6,7,9,10,11,12,13,20,21 -d 2