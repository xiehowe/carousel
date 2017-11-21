# Add the following line to your project in Framer Studio. 
# myModule = require "myModule"
# Reference the contents by name, like myModule.myFunction() or myModule.myVar

Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

class module.exports
	@property 'x',
		set: (value) -> @_scroll.x = value
		get: -> @_scroll.x

	@property 'y',
		set: (value) -> @_scroll.y = value
		get: -> @_scroll.y

	# @property 'width',
	# 	set: (value) -> @_scroll.width = value
	# 	get: -> @_scroll.width

	constructor: (layers, opt={}) ->
		# set your own value
		boxWidth = opt.boxWidth or 100
		boxHeight = opt.boxHeight or 100

		boxY = if opt.boxY == undefined then Align.center else opt.boxY
		
		scaleRatio = if opt.scaleRatio == undefined then 0.5 else opt.scaleRatio
		scaleOriginY = if opt.scaleOriginY == undefined then 0.5 else opt.scaleOriginY
		
		amount = layers.length
		
		space = if opt.space == undefined then 10 else opt.space
		
		viewWidth = opt.width or 1000
		scaleWidth = opt.scaleWidth or 300
		viewHeight = opt.height or 400

		CarouselX = if opt.x == undefined then Align.center else opt.x
		CarouselY = if opt.y == undefined then Align.center else opt.y
		scrollSpeed = if opt.scrollSpeed == undefined then 1 else opt.scrollSpeed
		
		# tweak these valuse for space between boxes
		innerThreshold = opt.innerThreshold or 100
		outerThreshold = opt.outerThreshold or 200
		offset = if opt.offset == undefined then 50 else opt.offset
		fadeOutRatio = if opt.fadeOutRatio == undefined then 1.5 else opt.fadeOutRatio
		
		# do not change
		boxes = []
		contents = []
		inset = viewWidth / 2 - boxWidth / 2
		# offset = boxWidth * (1 - scaleRatio) / 2
		
		scroll = new ScrollComponent
			scrollVertical: false
			backgroundColor: opt.backgroundColor or 'transparent'
			width: viewWidth
			height: viewHeight
			x: CarouselX
			y: CarouselY
			speedX: scrollSpeed
 		
		scroll.content.clip = false
	
		scroll.contentInset =
			top: 0
			right: inset
			bottom: 0
			left: inset
		
		for i in [0...amount]
			box = new Layer
				name: 'box' + (i + 1)
				width: boxWidth
				height: boxHeight
				scale: 1
				x: i * (boxWidth + space)
				backgroundColor: 'transparent'
	
			boxes.push(box)
			box.parent = scroll.content
			box.y = boxY
		
			layerInList = layers[i]
			layerInList.parent = box
			layerInList.width = box.width
			layerInList.height = box.height
			layerInList.originY = scaleOriginY
			contents.push(layers[i])
		
		# give an X offset to equalize in-between space
		offsetX = (x) ->
			if -innerThreshold < x < innerThreshold
				return offset * Utils.modulate x, [-innerThreshold, innerThreshold], [-1, 1]
			if x >= innerThreshold
				return offset * Utils.modulate x, [innerThreshold, outerThreshold], [1, fadeOutRatio], true
			else 
				return offset * Utils.modulate x, [-innerThreshold, -outerThreshold], [-1, -fadeOutRatio], true
		
		handleMove = ->
			for box in boxes
				distance = box.midX - viewWidth / 2 - scroll.scrollX + inset
				angleScale = Utils.modulate distance, [-scaleWidth, scaleWidth], [0, 2 * Math.PI], true
				sub = box.children[0]
				sub.scale = (1 - Math.cos(angleScale)) * (1 - scaleRatio) / 2 + scaleRatio
				sub.x = offsetX(distance)
		
		handleMoveThrottled = Utils.throttle 1/60, handleMove
		
		scroll.on Events.Move, handleMoveThrottled
		
		handleMove()
		
		#snap to closest box
		ignore = true
		
		scroll.onMove Utils.throttle 0.01, ->
			if Math.abs(scroll.velocity.x) < 0.2 and not ignore
				scroll.scrollToClosestLayer(0,0.5)
		
		scroll.on Events.ScrollEnd, -> ignore = false
		scroll.on Events.MouseDown, -> ignore = true

		@_scroll = scroll
		@_boxes = boxes
