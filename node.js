var http = require('http'),  
    io   = require('socket.io'),
    fs   = require('fs'),
    index;
    
    fs.readFile('./index.html', function (err, data) {
        if (err) {
            throw err;
        }
        index = data;
    });

var server = http.createServer(function(req, res){ 
 // your normal server code 
 res.writeHead(200, {'Content-Type': 'text/html'}); 
 res.write(index);
 res.end();
});
server.listen(3000);
  
// socket.io 
var socket = io.listen(server); 
socket.on('connection', function(client){ 
  client.on('message', function(){
    client.send("PONG");
  }) 
  client.on('disconnect', function(){ })
});