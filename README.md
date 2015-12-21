LOVE neural network implementation
===

The code is written in [moonscript](http://moonscript.org/) (based on and complies to Lua) with [LOVE](http://love2d.org) support.
The code is based on [Welch Lab's youtube series](https://www.youtube.com/watch?v=bxe2T-V8XRs).

The moonscript code is in the `moon/` folder. The compiled lua code is in the `lua/` folder.

NOTE: All the files in `lua/` are deleted and re-created when building, so don't write code in there.

The `NeuralNetwork` class consists of the following:
 * `NeuralNetwork([topology])` - constructor. Creates a new neural network with the specified topology
 * `netCost()` - calculates the cost of the whole neural network (where `nnet.YHat` is the computed result and `nnet.Y` is the desired one)
 * `propagate()` - propagates the input data (`nnet.X`) through the neural net, thus calculating the output (`nnet.YHat`)
 * `backpropagate()` - calculates correction values for the synapses
 
