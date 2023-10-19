#!/bin/bash

# clean error logs:
for i in `ls ${1}/err`; do rm -rf ${i}/*; done
# clean dag logs:
rm -rf *.dag.*
