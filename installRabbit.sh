#!/bin/bash
usuario=swiii
clave=swiii
machine=vagrant-ubuntu-trusty-64
vhost=cuentas
exchange=excuentas
echo "deb http://www.rabbitmq.com/debian/ testing main" > rabbitmq.list
sudo mv rabbitmq.list /etc/apt/sources.list.d/
wget https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
sudo apt-key add rabbitmq-signing-key-public.asc
sudo apt-get update
ulimit -S -n 4096
sudo apt-get install -y rabbitmq-server
sudo rabbitmq-plugins enable rabbitmq_management
sudo rabbitmq-plugins enable rabbitmq_shovel
sudo rabbitmq-plugins enable rabbitmq_shovel_management
echo "[{rabbit, [ {loopback_users, []}, {frame_max, 5368709120} ]}]." > /etc/rabbitmq/rabbitmq.config
sudo service rabbitmq-server restart
#Creando usuario con clave dmarc en RabbitMQ
curl -i -u guest:guest -H "content-type:application/json" -XPUT -d '{"password":"'$clave'","tags":"administrator"}' http://127.0.0.1:15672/api/users/$usuario
#Creando vhost
curl -i -u guest:guest -H "content-type:application/json" -XPUT http://127.0.0.1:15672/api/vhosts/$vhost
#Dando permisos sobre un vhost
curl -i -u guest:guest -H "content-type:application/json" -d'{"configure":".*","write":".*","read":".*"}' -XPUT http://127.0.0.1:15672/api/permissions/$vhost/$usuario
#Creando Un Exchange
curl -i -u $usuario:$clave -H "content-type:application/json" -XPUT -d'{"type":"direct","durable":true}' http://127.0.0.1:15672/api/exchanges/$vhost/$exchange
#Creando Colas
cola="cuenta.create"
body='{"routing_key":"crear.cuenta","arguments":{}}'
queueProp=`echo '{"auto_delete":false,"durable":true,"arguments":{},"node":"rabbit@'$machine'"}'`
curl -i -u $usuario:$clave -H "content-type:application/json" -d $queueProp -XPUT http://127.0.0.1:15672/api/queues/$vhost/$cola
curl -i -u $usuario:$clave -H "content-type:application/json" -d $body -XPOST http://127.0.0.1:15672/api/bindings/$vhost/e/$exchange/q/$cola
