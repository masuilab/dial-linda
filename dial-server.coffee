ArduinoFirmata = require 'arduino-firmata'
path = require 'path'
RotaryEncoder = require path.join __dirname, 'libs/RotaryEncoder'
  
arduino = new ArduinoFirmata().connect()
rotenc = new RotaryEncoder arduino, 6, 7

arduino.on 'connect', ->
  console.log "connect!! #{arduino.serialport_name}"
  console.log "board version: #{arduino.boardVersion}"

rotenc.on 'rotate', (e) ->
  console.log e
