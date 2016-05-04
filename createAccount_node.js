var amqp = require('amqp');

var connection = amqp.createConnection(
  //Paramentros de la conexion
  { host: 'localhost'
, port: 5671
, login: 'swiii'
, password: 'swiii'
, connectionTimeout: 10000
, authMechanism: 'AMQPLAIN'
, vhost: 'cuentas'
, noDelay: true
, ssl: { enabled : false
       }

});


connection.on('ready', function () {

  connection.queue('cuenta.create',{
    // Paramentros de la cola
    passive:true
  }, function (q) {
            

      // Receive messages
      q.subscribe(function (message, headers, deliveryInfo, messageObject) {
        // Print messages to stdout
        console.log('routing key del mensaje ' + deliveryInfo.routingKey);        
        console.log(message.data.toString('utf8'));

      });
  });
});