LB_ID="5ec7375a-2fd4-4dfa-801b-98027f694d46"
LB_DATA=$(neutron --os-user-domain-name Default lbaas-loadbalancer-show ${LB_ID} --format yaml)
LB_LISTENERS_ID=$(echo -e "$LB_DATA"|grep '\- id'|head -1|awk -F': ' '{print $2}')
LB_POOL_ID=$(echo -e "$LB_DATA"|grep '\- id'|tail -1|awk -F': ' '{print $2}')
LB_HEALTH_ID=$(neutron --os-user-domain-name Default lbaas-pool-show ${LB_POOL_ID} | awk '/healthmonitor_id/ '{print $4}')
neutron --os-user-domain-name Default lbaas-listener-delete "${LB_LISTENERS_ID}"
neutron --os-user-domain-name Default lbaas-healthmonitor-delete "${LB_HEALTH_ID}"
neutron --os-user-domain-name Default lbaas-pool-delete "${LB_POOL_ID}"
neutron --os-user-domain-name Default lbaas-loadbalancer-delete "${LB_ID}"
