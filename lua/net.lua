local exp
exp = math.exp
local Matrix = require("matrix")
local NeuralNetwork
do
  local _base_0 = {
    sigmoid = function(x)
      return 1 / (1 + exp(-x))
    end,
    sigmoidP = function(x)
      return exp(-x) / ((1 + exp(-x)) ^ 2)
    end,
    netCost = function(self)
      local J = 0
      for i = 1, #self.Y.e do
        J = J + ((self.Y.e[i][1] - self.YHat.e[i][1]) ^ 2 / 2)
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
      delta[#self.topology] = Matrix.schur(-(self.Y - self.YHat), Matrix(self.Z[#self.topology], function(i, j, e)
        return NeuralNetwork.sigmoidP(e)
      end))
      for l = (#self.topology - 1), 2, -1 do
        local sigmoidPL = Matrix(self.Z[l], function(i, j, e)
          return NeuralNetwork.sigmoidP(e)
        end)
        delta[l] = Matrix.schur(delta[l + 1] * self.W[l]:T(), sigmoidPL)
      end
      for l = (#self.topology - 1), 1, -1 do
        dJdW[l] = self.A[l]:T() * delta[l + 1]
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
