# MSM_Client
MSM Client for MSM project

## Install
```text
$ flutter pub add mqtt_client
$ flutter pub add flutter_local_notifications
$ flutter pub add shared_preferences
```

## How to open 1883 port for MQTT testing
```text
$ sudo iptables -I INPUT -p tcp -m tcp --dport 1883 -j ACCEPT
```