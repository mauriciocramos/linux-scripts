#!/bin/bash
kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic $1