$ ->

  filed = $ '.field'
  logo = $ '.logo'
  cs = $ '.circle-scene'
  text = $ '.text'
  win = $ window
  pointsFiled = $ '#points'
  colorsArr = ['#42a5f5','#ffee58','#b388ff','#fff','#4068BF','#ffd54f']

  class Point
    constructor: (@x, @y) ->

    init: ->
      @initScene()
      @listeners()

    listeners: ->
      filed.on 'mousemove', (e) =>
        @createPoint(e)

      win.on 'resize', =>
        @getCenterField()

      @getCenterField()

    initScene: ->
      TweenMax.set(cs, {
        scale: 0
        transformOrigin:"center center"
      })
      TweenMax.set(text, {
        scale: 0
        transformOrigin:"center center"
      })

      hideScene = ->
        logo.fadeOut 400, ->
          @.remove()

      scene = new TimelineLite()
      scene.delay(.5)
      scene
        .staggerTo( cs, .8, {
          scale: 1
          ease: Quart.easeOut
        }, 0.1)
        .staggerTo(cs, 1, {
          scale: 8
          opacity: 0
          ease: Quart.easeOut
        }, 0.1)
        .to(text, .7, {
          scale: 1
          ease: Bounce.easeOut
          onComplete: hideScene
        })
    getCenterField: ->
      w = filed.innerWidth()
      h = filed.innerHeight()

      TweenMax.set(filed, {
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
  points.init()