local NeuralNetwork = require("net")
local Matrix = require("matrix")
local insert
insert = table.insert
local random
random = math.random
local love = love or { }
local costs, costCount, nnet
costCount = 0
costs = { }
love.load = function()
  nnet = NeuralNetwork({
    2,
    3,
    1
  })
  nnet.X = Matrix({
    {
      0.2,
      0.6
    },
    {
      0.54,
      0.32
    },
    {
      0.55,
      0.36
    }
  })
  nnet.Y = Matrix({
    {
      0.8
    },
    {
      0.86
    },
    {
      0.91
    }
  })
  nnet:propagate()
  return love.keyboard.setKeyRepeat(true)
end
love.update = function()
  nnet:propagate()
  costs[costCount % 300] = nnet:netCost()
  costCount = costCount + 1
  local dJdW = nnet:backpropagate()
  local scalar = 12
  for l = 1, #nnet.topology - 1 do
    nnet.W[l] = nnet.W[l] - (scalar * dJdW[l])
  end
end
love.draw = function()
  do
    local _with_0 = love.graphics
    _with_0.setColor(255, 255, 255)
    _with_0.rectangle("fill", 0, 0, 1280, 780)
    _with_0.setColor(200, 200, 200)
    _with_0.rectangle("fill", 0, 0, 300, 300)
    _with_0.setColor(0, 0, 0)
    local maxCost = 0
    for _, c in ipairs(costs) do
      if c > maxCost then
        maxCost = c
      end
    end
    for _, j in ipairs(costs) do
      _with_0.point(_, (1 - (j / maxCost)) * 300)
    end
    for _, test in ipairs(nnet.X.e) do
      _with_0.print("Test #" .. _, 400, _ * 50)
      _with_0.print(test[1] .. " + " .. test[2] .. "=" .. nnet.Y.e[_][1], 400, _ * 50 + 10)
      _with_0.print("Predicted: " .. nnet.YHat.e[_][1], 400, _ * 50 + 20)
    end
    return _with_0
  end
end
