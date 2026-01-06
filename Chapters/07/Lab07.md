# Lab 07

## Wazuh server

Follow the guide for the indexer, server & dashboard.

Wazuh username and password: admin:admin

indexer_username: 'admin'
indexer_password: 't.MVeFnIJ0QaR556p15EMj\*nnIKfWL?V'/ admin

config.yml -> Add the correct ip to the config (everything is 172.30.0.6)

```yml
nodes:
    # Wazuh indexer nodes
    indexer:
        - name: node-1
          ip: "172.30.0.6"
        #- name: node-2
        #  ip: "<indexer-node-ip>"
        #- name: node-3
        #  ip: "<indexer-node-ip>"

    # Wazuh server nodes
    # If there is more than one Wazuh server
    # node, each one must have a node_type
    server:
        - name: wazuh-1
          ip: "172.30.0.6"
        #  node_type: master
        #- name: wazuh-2
        #  ip: "<wazuh-manager-ip>"
        #  node_type: worker
        #- name: wazuh-3
        #  ip: "<wazuh-manager-ip>"
        #  node_type: worker

    # Wazuh dashboard nodes
    dashboard:
        - name: dashboard
          ip: "172.30.0.6"
```

The Wazuh Indexer correctly installed?

[vagrant@SIEM ~]$ sudo curl -k -u admin https://172.30.0.6:9200
Enter host password for user 'admin':
{
"name" : "node-1",
"cluster_name" : "wazuh-cluster",
"cluster_uuid" : "Qist-LtPQpy2zFkn_9qDmQ",
"version" : {
"number" : "7.10.2",
"build_type" : "rpm",
"build_hash" : "ac8f6e0114b657a116c4a41c3e12f8e0e181bbcd",
"build_date" : "2025-11-08T11:55:34.225460336Z",
"build_snapshot" : false,
"lucene_version" : "9.12.2",
"minimum_wire_compatibility_version" : "7.10.0",
"minimum_index_compatibility_version" : "7.0.0"
},
"tagline" : "The OpenSearch Project: https://opensearch.org/"
}

[vagrant@SIEM ~]$ sudo curl -k -u admin https://172.30.0.6:9200/_cat/nodes?v
Enter host password for user 'admin':
ip heap.percent ram.percent cpu load_1m load_5m load_15m node.role node.roles cluster_manager name
172.30.0.6 30 65 4 0.12 0.18 0.13 dimr cluster_manager,data,ingest,remote_cluster_client \*  
 node-1

These outputs suggest that the indexer is installed correctly!

The Wazuh Server correctly installed?

[vagrant@SIEM ~]$ sudo filebeat test output
elasticsearch: https://172.30.0.6:9200...
parse url... OK
connection...
parse host... OK
dns lookup... OK
addresses: 172.30.0.6
dial up... OK
TLS...
security: server's certificate chain verification is enabled
handshake... OK
TLS version: TLSv1.3
dial up... OK
talk to server... OK
version: 7.10.2

This output suggest that the server is installed correctly!

## Wazuh agent

Use windows 10 agent
