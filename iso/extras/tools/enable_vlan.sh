#! /bin/bash
# This script configure vlan into openstck environment to enable creating vlan network. 
# This script accept the name of the network interface which to be bond to ovs bridge br-eth1.

# *************************************************************************************
# ************************** check the input ******************************************
# *************************************************************************************
set -o xtrace
NETWORK_INTERFACE=$1
echo ${NETWORK_INTERFACE}

if [ "${NETWORK_INTERFACE}" = "" ];then
    echo "No network interface input."
    exit 1
fi

#ip a | grep "${NETWORK_INTERFACE}"
ifconfig ${NETWORK_INTERFACE}
if [ ! $? -eq 0 ];then
    echo "There is no such network interface named ${NETWORK_INTERFACE}"
    exit 1
fi


# **************************************************************************************
# Config container neutron_openvswitch_agent and container neutron_server
# **************************************************************************************
OPENVSWITCH_PATH="/etc/kolla/neutron-openvswitch-agent"
OPENVSWITCH_ID=`docker ps |grep Up|grep neutron-openvswitch-agent|awk -F' ' '{print $1}'`
if [ ! -n ${OPENVSWITCH_ID} ];then
OPENVSWITCH_ID=`docker ps |grep Up|grep centos-source-openvswitch-vswitchd|awk -F' ' '{print $1}'`
fi
#NEUTRON_SERVER_PATH="/etc/kolla/neutron-server"
#NEUTRON_SERVER_ID=`docker ps |grep neutron-server|awk -F' ' '{print $1}'`
echo ${OPENVSWITCH_ID}
#echo ${NEUTRON_SERVER_ID}

# ****** add openvswitch bridge br-eth1 and add the network interface as a port  *******
# docker exec -it -u root $ID bash -c "(ovs-vsctl br-exists br-phy && ovs-vsctl list-ports br-phy | grep -q ${ICS_NETDEV_NAME}) || (ovs-vsctl br-exists br-phy && ovs-vsctl add-port br-phy ${ICS_NETDEV_NAME} || ovs-vsctl add-br br-phy -- add-port br-phy ${ICS_NETDEV_NAME})" || true
docker ps | grep -q ${OPENVSWITCH_ID} && docker exec -it -u root ${OPENVSWITCH_ID} bash -c "(ovs-vsctl br-exists br-eth1 && ovs-vsctl list-ports br-eth1 | grep -q ${NETWORK_INTERFACE}) || (ovs-vsctl br-exists br-eth1 && ovs-vsctl add-port br-eth1 ${NETWORK_INTERFACE} || ovs-vsctl add-br br-eth1 -- add-port br-eth1 ${NETWORK_INTERFACE})" || true

# ***************************** config ml2_conf.ini to enable vlan *********************

#cd ${OPENVSWITCH_PATH}
#if [ ! -f "ml2_conf.ini" ]; then
#    echo " ml2_conf.ini does not exist in ${OPENVSWITCH_PATH}"
#    exit 1
#else
#    if [ -z "`grep "default:3001:4000" ml2_conf.ini`" ];then
#        sed -i /network_vlan_ranges/s/$/" default:3001:4000"/g ml2_conf.ini
#    fi
#    if [ -z "`grep "default:br-eth1" ml2_conf.ini`" ];then
#        sed -i /bridge_mappings/s/$/,default:br-eth1/g ml2_conf.ini
#    fi
#fi
#
#cd ${NEUTRON_SERVER_PATH}
#if [ ! -f "ml2_conf.ini" ]; then
#    echo " ml2_conf.ini does not exist in ${NEUTRON_SERVER_PATH}"
#    exit 1
#else
#    if [ -z "`grep "default:3001:4000" ml2_conf.ini`" ];then
#        sed -i /network_vlan_ranges/s/$/" default:3001:4000"/g ml2_conf.ini
#    fi
#    if [ -z "`grep "default:br-eth1" ml2_conf.ini`" ];then
#        sed -i /bridge_mappings/s/$/,default:br-eth1/g ml2_conf.ini
#    fi
#fi
#docker stop ${OPENVSWITCH_ID} && docker start ${OPENVSWITCH_ID}
#docker stop ${NEUTRON_SERVER_ID} && docker start ${NEUTRON_SERVER_ID}
