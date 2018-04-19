#!/bin/bash
deploy_time=`date|awk -F' ' '{{print $4}}'`
ansible node -m shell -a "date -s ${deploy_time}"
