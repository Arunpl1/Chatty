var http = require('http'),
    faye = require('faye');

var server = new faye.NodeAdapter({mount: '/faye', timeout: 45});
server.listen(8000);