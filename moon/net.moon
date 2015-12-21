-- net.moon
import exp from math
Matrix = require "matrix"

class NeuralNetwork
	new: (topology = {1, 1}) => 	-- default topology is 1 input -> 1 output
		@topology = topology
		@layerC = #topology	-- layer count

		@X 		= Matrix(1, topology[1])			-- input layer
		@Y 		= Matrix(1, topology[#@topology])	-- correct output layer
		@YHat 	= Matrix(1, topology[#@topology])	-- calculated output layer

		@W = [Matrix(topology[w], topology[w+1], (i, j) -> math.random()) 	for w = 1, (#topology - 1)]
		@Z = [Matrix(1, topology[w]) for w = 2, #topology]
		@A = [Matrix(1, topology[w]) for w = 2, #topology]

	sigmoid: (x) -> 	-- sigmoid function
		if type(x) == "number"
			return 1/(1+exp(-x))
		if x.__class == Matrix -- map it to a matrix if argument is a matrix
			return Matrix(x, (i, j, e) -> NeuralNetwork.sigmoid(e))

	sigmoidP: (x) ->	-- sigmoid' function
		if type(x) == "number"
			return exp(-x)/((1+exp(-x))^2)
		if x.__class == Matrix -- map it to a matrix if argument is a matrix
			return Matrix(x, (i, j, e) -> NeuralNetwork.sigmoid(e))

	netCost: =>
		J = 0
		for i = 1, #@Y.e
			for j = 1, #@Y.e[1]
				J += (@Y.e[i][j] - @YHat.e[i][j])^2/2
		return J

	propagate: =>
		@Z[1] = @X
		@A[1] = @X	-- for backpropagating on the first layer
		for l = 2, #@topology						-- for every layer (excepting the input)
			@Z[l] = @Z[l-1] * @W[l-1]				-- compute its Z
			@A[l] = Matrix(@Z[l], (i, j, e) -> NeuralNetwork.sigmoid(e))
		@YHat = @A[#@topology]

	backpropagate: =>
		dJdW, delta = {}, {}

		-- compute delta values for each layer
		delta[@layerC] = Matrix.entrywise(-(@Y-@YHat), NeuralNetwork.sigmoidP(@Z[@layerC]))
		for L = @layerC-1, 2, -1
			delta[L] = Matrix.entrywise(delta[L+1] * @W[L]\T!, NeuralNetwork.sigmoidP(@Z[L]))

		-- compute dJdW values for each layer
		for L = @layerC-1, 1, -1
			dJdW[L] = @A[L]\T() * delta[L+1]

		return dJdW

return NeuralNetwork
