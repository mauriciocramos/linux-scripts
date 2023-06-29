#!/bin/bash
kafka-topics.sh --describe --bootstrap-server localhost:9092 --topic $1 
