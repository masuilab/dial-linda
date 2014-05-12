events = require 'eventemitter2'
ArduinoFirmata = require 'arduino-firmata'

module.exports = class JogShuffle extends events.EventEmitter2
  constructor: (@arduino, @pinA, @pinB, @pinC, @pinD) ->
    console.log "set jogshuffle pin : #{@pinA}, #{@pinB}, #{@pinC} and #{@pinD}"

    if @arduino.isOpen()
      @initPins()

    @arduino.on 'connect', =>
      @initPins()

    @arduino.on 'digitalChange', (e) =>
      @pastState = @state
      @state = @getState()
      if @state isnt @pastState
        @emit 'shuttle', @state

  initPins: ->
    @arduino.pinMode @pinA, ArduinoFirmata.INPUT
    @arduino.pinMode @pinB, ArduinoFirmata.INPUT
    @arduino.pinMode @pinC, ArduinoFirmata.INPUT
    @arduino.pinMode @pinD, ArduinoFirmata.INPUT

  getState: ->
    @code = [@pinA, @pinB, @pinC, @pinD].map (i) =>
      if @arduino.digitalRead i then 1 else 0
    .join ''
    return @codes.indexOf(@code) - @codes.length/2
    
  codes: [
    "1001"
    "1101"
    "1111"
    "1011"
    "0011"
    "0111"
    "0101"
    "0001"
    "0000"  # neutral
    "0100"
    "0110"
    "0010"
    "1010"
    "1110"
    "1100"
    "1000"
  ]
