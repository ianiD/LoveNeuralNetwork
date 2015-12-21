-- net.moon
import exp from math
Matrix = require "matrix"

class NeuralNetwork
	new: (topology = {1, 1}) => 	-- default topology is 1 input -> 1 output
		@topology = topology

		@X 		= Matrix(1, topology[1])			-- input layer
		@Y 		= Matrix(1, topology[#@topology])	-- correct output layer
		@YHat 	= Matrix(1, topology[#@topology])	-- calculated output layer

		@W = [Matrix(topology[w], topology[w+1], (i, j) -> math.random()) 	for w = 1, (#topology - 1)]
		@Z = [Matrix(1, topology[w]) for w = 2, #topology]
		@A = [Matrix(1, topology[w]) for w = 2, #topology]

	sigmoid: (x) -> 1/(1+exp(-x))						-- sigmoid function for a number
	sigmoidP: (x) -> exp(-x)/((1+exp(-x))^2)	-- sigmoid' function for a number

	netCost: =>
		J = 0
		for i = 1, #@Y.e
			J += (@Y.e[i][1] - @YHat.e[i][1])^2/2
		return J

	propagate: =>
		@Z[1] = @X
		@A[1] = @X
		for l = 2, #@topology						-- for every layer (excepting the input)
			@Z[l] = @Z[l-1] * @W[l-1]				-- compute its Z
			@A[l] = Matrix(@Z[l], (i, j, e) -> NeuralNetwork.sigmoid(e))
		@YHat = @A[#@topology]

	backpropagate: =>
		dJdW, delta = {}, {}

		-- compute delta values
		delta[#@topology] = Matrix.schur(-(@Y-@YHat), Matrix(@Z[#@topology], (i, j, e) -> NeuralNetwork.sigmoidP(e)))
		for l = (#@topology - 1), 2, -1
			sigmoidPL = Matrix(@Z[l], (i, j, e) -> NeuralNetwork.sigmoidP(e))
			delta[l] = Matrix.schur(delta[l+1] * @W[l]\T(), sigmoidPL)

		for l = (#@topology - 1), 1, -1			-- iterate from right to left
			dJdW[l] = @A[l]\T() * delta[l+1]

		return dJdW

return NeuralNetwork
