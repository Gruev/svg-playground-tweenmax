$ ->

  filed = $ '.field'
  win = $ window
  pointsFiled = $ '#points'
  colorsArr = ['#2980b9','#f1c40f','#2c3e50','#1abc9c','#bdc3c7', '#e74c3c']

  class Point
    constructor: (@x, @y) ->

    listeners: ->
      filed.on 'mousemove', (e) =>
        @createPoint(e)

      win.on 'resize', =>
        @getCenterField()

      @getCenterField()

    getCenterField: ->
      w = filed.innerWidth()
      h = filed.innerHeight()

      TweenMax.set('svg', {
        attr: {
          viewBox: "0 0 #{w} #{h}"
        }
      })
    createPoint: (e) ->
      newElement = document.createElementNS "http://www.w3.org/2000/svg", 'circle'
      filed[0].appendChild newElement

      TweenMax.set(newElement, {
        attr: {
          fill: @randomColor colorsArr
          cx: e.pageX
          cy: e.pageY
          r: 20
        }
      })

      @move newElement

    move: (el) ->

      xCenter = 0;
      yCenter = 0; 
      poolRadius = 500;

      angle = Math.random() * Math.PI * 2
      radius = Math.random() * poolRadius
      randomScale = Math.random() * (2 - 0)

      deleteEl = ->
        $(el).remove()

      hideCircle = ->
        TweenMax.to(el, 1, {
          scale: 0
          transformOrigin:"center center"
          ease: Power4.easeInOut
          onComplete: deleteEl
        })

      TweenMax.to(el, 1, {
        x: Math.cos(angle) * radius + xCenter
        y: Math.sin(angle) * radius + yCenter
        scale: randomScale
        ease:Bounce.easeOut
        onComplete: hideCircle
      })
    randomColor: (arr) ->
      rc = Math.floor( Math.random() * (arr.length - 1) )
      arr[rc]
  
  points = new Point
  points.listeners()