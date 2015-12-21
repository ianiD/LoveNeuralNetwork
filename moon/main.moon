NeuralNetwork = require "net"
Matrix = require "matrix"
import insert from table
import random from math

love = love or {}

local costs, costCount, nnet
costCount = 0

costs = {}

love.load = ->
	nnet = NeuralNetwork({2, 3, 1})
	nnet.X = Matrix{{0.2, 0.6},
					{0.54, 0.32},
					{0.55, 0.36}}
	nnet.Y = Matrix{{0.8}, {0.86}, {0.91}}

	nnet\propagate()

	love.keyboard.setKeyRepeat(true)

love.update = ->
	nnet\propagate!
	costs[costCount % 300] = nnet\netCost!
	costCount += 1
	dJdW = nnet\backpropagate!

	scalar = 12

	for l = 1, #nnet.topology-1
		nnet.W[l] -= scalar * dJdW[l]

love.draw = ->
	with love.graphics
		-- draw background
		.setColor(255, 255, 255)
		.rectangle("fill", 0, 0, 1280, 780)

		-- draw plot window
		.setColor(200, 200, 200)
		.rectangle("fill", 0, 0, 300, 300)

		-- plot cost graph
		.setColor(0, 0, 0)
		maxCost = 0
		for _, c in ipairs(costs)
			if c > maxCost
				maxCost = c
		for _, j in ipairs(costs)
			.point(_, (1-(j/maxCost))*300)

		-- display tests
		for _, test in ipairs(nnet.X.e)
			.print("Test #".._, 400, _ * 50)
			.print(test[1].." + "..test[2].."="..nnet.Y.e[_][1], 400, _ * 50 + 10)
			.print("Predicted: "..nnet.YHat.e[_][1], 400, _ * 50 + 20)
