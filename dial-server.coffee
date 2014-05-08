http = require 'http'
fs   = require 'fs'
url  = require 'url'
path = require 'path'
ArduinoFirmata = require 'arduino-firmata'
RotaryEncoder = require path.join __dirname, 'libs/RotaryEncoder'
JogShuttle = require path.join __dirname, 'libs/JogShuttle'

## HTTP Server ##

app_handler = (req, res) ->
  _url = url.parse(decodeURI(req.url), true);
  path = if _url.pathname == '/' then '/index.html' else _url.pathname
  console.log "#{req.method} - #{path}"
  fs.readFile __dirname+path, (err, data) ->
    if err
      res.writeHead 500
      return res.end 'error load file'
    res.writeHead 200
    res.end data

app = http.createServer(app_handler)
io = require('socket.io').listen(app)
io.configure 'development', ->
  io.set 'log level', 2


## Linda Server ##

linda = require('linda-socket.io').Linda.listen(io: io, server: app)
ts = linda.tuplespace('paddle')

process.env.PORT ||= 3000
app.listen process.env.PORT
console.log "server start - port:#{process.env.PORT}"


## Arduino RotaryEncoder ##

arduino = new ArduinoFirmata()
rotenc = new RotaryEncoder arduino, 4, 3
jog = new JogShuttle arduino, 5, 6, 7, 8

arduino.on 'connect', ->
  console.log "Arduino board version: #{arduino.boardVersion}"

rotenc.on 'rotate', (direction) ->
  data =
    type: 'dial'
    name: 'RotaryEncoder'
    direction: direction
  console.log data
  ts.write data

jog.on 'jog', (state) ->
  data =
    type: 'dial'
    name: 'JogShuttle'
    state: state
  console.log data
  ts.write data

arduino.connect process.env.ARDUINO
