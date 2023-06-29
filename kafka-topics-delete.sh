#!/bin/bash
kafka-topics.sh --delete --bootstrap-server localhost:9092 --topic $1
