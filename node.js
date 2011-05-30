var http = require('http'),  
    io   = require('socket.io'),
    index = require('fs').readFileSync('./index.html');

var server = http.createServer(function(req, res){ 
 // your normal server code 
 res.writeHead(200, {'Content-Type': 'text/html'}); 
 res.end(index);
});
server.listen(3000);
  
// socket.io 
var socket = io.listen(server); 
socket.on('connection', function(client){ 
  client.on('message', function(){
    client.send("PONG");
  });
});