events = require 'eventemitter2'
ArduinoFirmata = require 'arduino-firmata'

module.exports = class RotaryEncoder extends events.EventEmitter2
  constructor: (@arduino, @pinA, @pinB) ->
    console.log "set rotary encoder pin : #{@pinA} and #{@pinB}"
    @state = 0

    if @arduino.isOpen()
      @initPins()

    @arduino.on 'connect', =>
      @initPins()

    @arduino.on 'digitalChange', (e) =>
      @pastState = @state
      @state = @getState()
      if (@state+3+1)%3 is @pastState
        @emit 'rotate', 'right'
      else if (@state+3-1)%3 is @pastState
        @emit 'rotate', 'left'

  initPins: ->
    @arduino.pinMode @pinA, ArduinoFirmata.INPUT
    @arduino.pinMode @pinB, ArduinoFirmata.INPUT

  getState: ->
    if @arduino.digitalRead @pinA
      if @arduino.digitalRead @pinB
        return 2
      else
        return 0
    else
      if @arduino.digitalRead @pinB
        return 1
      else
        return 3
