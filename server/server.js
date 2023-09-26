const express=require('express');
const http=require('http');
const socketio=require('socket.io');

const app=express();
const server=http.createServer(app);
const io=socketio(server);

io.on('connection',(socket)=>{
console.log('Client connected');

setInterval(()=>{
 const randomupdate=Math.random();
socket.emit('update',randomupdate);


},5000);


socket.on('disconnect',()=>{
console.log('client disconnected');



});



});

const port=3000;

server.listen(port,'192.168.87.10',()=>{
console.log(`Server is running on port ${port}`);


});
