-- Matrix.moon

import random from math

class Matrix
	new: (w, h, e) =>
		if type(w) == "table"
			@e = w
			@h = #@e
			@w = #@e[1]
		else
			@w = w
			@h = h
			@e = e
			if @e == nil
				@e = [ [random() for j = 1, @w] for i = 1, @h]

	transpose: =>
		-- construct a new matrix (T) so that T[j][i] = self[i][j]
		return Matrix(@h, @w, [ [@e[j][i] for j = 1, @h] for i = 1, @w])

	map: (mat, f, arg) ->
		return Matrix([ [f(mat.e[i][j], unpack(arg or {})) for j = 1, mat.w] for i = 1, mat.h])

	__tostring: () =>
		local res, i, j
		res = ""
		for i = 1, @h
			for j = 1, @w
				res ..= tostring(@e[i][j])\sub(1, 5) .. "\t"
			res ..= "\n"
		return res

	__mul: (a, b) ->
		if type(b) == "number"
			return Matrix([ [a.e[i][j] * b for j = 1, a.w] for i = 1, a.h])
		if a.w ~= b.h
			error "*Sizes don't match (a["..a.w..","..a.h.."], b["..b.w..","..b.h.."])"

		local res, i, j, k
		res = {}

		for i = 1, a.h do
			res[i] = {}
			for j = 1, b.w do
				res[i][j] = 0
				for k = 1, b.h do
					res[i][j] = res[i][j] + a.e[i][k] * b.e[k][j]

		return Matrix(res)

	elemmul: (a, b) -> Matrix([ [a.e[i][j] * b.e[i][j] for j = 1, a.w] for i = 1, a.h])

	__add: (a, b) ->
		if a.w != b.w or a.h != b.h
			error "+Sizes don't match (a["..a.w..","..a.h.."], b["..b.w..","..b.h.."])"
		return Matrix([ [(a.e[i][j] + b.e[i][j]) for j = 1, a.w] for i = 1, a.h])

	__unm: (a) -> Matrix([ [-a.e[i][j] for j = 1, a.w] for i = 1, a.h])

	__sub: (a, b) ->
		if a.w != b.w or a.h != b.h
			error "-Sizes don't match (a["..a.w..","..a.h.."], b["..b.w..","..b.h.."])"
		return Matrix([ [(a.e[i][j] - b.e[i][j]) for j = 1, a.w] for i = 1, a.h])

return Matrix
