local exp
exp = math.exp
local Matrix = require("matrix")
local NeuralNetwork
do
  local _base_0 = {
    sigmoid = function(x)
      if type(x) == "number" then
        return 1 / (1 + exp(-x))
      end
      if x.__class == Matrix then
        return Matrix(x, function(i, j, e)
          return NeuralNetwork.sigmoid(e)
        end)
      end
    end,
    sigmoidP = function(x)
      if type(x) == "number" then
        return exp(-x) / ((1 + exp(-x)) ^ 2)
      end
      if x.__class == Matrix then
        return Matrix(x, function(i, j, e)
          return NeuralNetwork.sigmoid(e)
        end)
      end
    end,
    netCost = function(self)
      local J = 0
      for i = 1, #self.Y.e do
        for j = 1, #self.Y.e[1] do
          J = J + ((self.Y.e[i][j] - self.YHat.e[i][j]) ^ 2 / 2)
        end
      end
      return J
    end,
    propagate = function(self)
      self.Z[1] = self.X
      self.A[1] = self.X
      for l = 2, #self.topology do
        self.Z[l] = self.Z[l - 1] * self.W[l - 1]
        self.A[l] = Matrix(self.Z[l], function(i, j, e)
          return NeuralNetwork.sigmoid(e)
        end)
      end
      self.YHat = self.A[#self.topology]
    end,
    backpropagate = function(self)
      local dJdW, delta = { }, { }
      delta[self.layerC] = Matrix.entrywise(-(self.Y - self.YHat), NeuralNetwork.sigmoidP(self.Z[self.layerC]))
      for L = self.layerC - 1, 2, -1 do
        delta[L] = Matrix.entrywise(delta[L + 1] * self.W[L]:T(), NeuralNetwork.sigmoidP(self.Z[L]))
      end
      for L = self.layerC - 1, 1, -1 do
        dJdW[L] = self.A[L]:T() * delta[L + 1]
      end
      return dJdW
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, topology)
      if topology == nil then
        topology = {
          1,
          1
        }
      end
      self.topology = topology
      self.layerC = #topology
      self.X = Matrix(1, topology[1])
      self.Y = Matrix(1, topology[#self.topology])
      self.YHat = Matrix(1, topology[#self.topology])
      do
        local _accum_0 = { }
        local _len_0 = 1
        for w = 1, (#topology - 1) do
          _accum_0[_len_0] = Matrix(topology[w], topology[w + 1], function(i, j)
            return math.random()
          end)
          _len_0 = _len_0 + 1
        end
        self.W = _accum_0
      end
      do
        local _accum_0 = { }
        local _len_0 = 1
        for w = 2, #topology do
          _accum_0[_len_0] = Matrix(1, topology[w])
          _len_0 = _len_0 + 1
        end
        self.Z = _accum_0
      end
      do
        local _accum_0 = { }
        local _len_0 = 1
        for w = 2, #topology do
          _accum_0[_len_0] = Matrix(1, topology[w])
          _len_0 = _len_0 + 1
        end
        self.A = _accum_0
      end
    end,
    __base = _base_0,
    __name = "NeuralNetwork"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  NeuralNetwork = _class_0
end
return NeuralNetwork
