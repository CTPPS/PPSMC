#!/bin/bash

# clean error logs:
for i in `ls ./err`; do rm -rf ./err/${i}/*; done
# clean dag logs:
rm -rf *.dag.*
