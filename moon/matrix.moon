-- Matrix.moon
--
-- Matrices can be declared like:
-- Matrix {{1, 2, 3}, {4, 5, 6}, {...}, ...}
-- Matrix (myMatrix, (i, j, e) -> e*3) - equivalent to myMatrix*2
-- Matrix (rows, columns[, default])
-- Matrix (rows, columns[, func])

class Matrix
	new: (h, w, e = 0) =>
		if type(h) == "table"
			if h.__class == Matrix	-- Matrix(myMatrix, (i, j, e) -> e*2)
				@w = h.w
				@h = h.h
				@e = [ [w(i, j, h.e[i][j]) for j = 1, h.w] for i = 1, h.h]
			elseif type(h[1]) == "table" -- Matrix{{1, 2, 3}, {4, 5, 6}}
				@e = h
				@h = #@e
				@w = #@e[1]
		else	-- Matrix(2, 3, ...)
			@h = h
			@w = w
			if type(e) == "function"	--Matrix(2, 3, (i, j) -> i*3 + j)
				@e = [ [e(i, j) for j = 1, w] for i = 1, h]
			else		-- Matrix(2, 3, 1) or Matrix(2, 3[, default=0])
				@e = [ [e for j = 1, w] for i = 1, h]

	entrywise: (a, b) ->
		if a.__class != Matrix
			error "Lvalue for schur multiplication is not a matrix"
		if b.__class != Matrix
			error "Rvalue for schur multiplication is not a matrix"
		if a.w != b.w or a.h != b.h
			error "Matrix dimenstions for schur multiplication don't match"

		mat = {}
		for i = 1, a.h
			mat[i] = {}
			for j = 1, a.w
				mat[i][j] = a.e[i][j] * b.e[i][j]

		return Matrix(mat)

	__add: (a, b) ->
		if a.__class != Matrix
			error "Lvalue for addition is not a matrix"
		if b.__class != Matrix
			error "Rvalue for addition is not a matrix"

		maxW, maxH = math.max(a.w, b.w), math.max(a.h, b.h)
		mat = {}
		for i = 1, maxH
			mat[i] = {}
			for j = 1, maxW
				mat[i][j] = a.e[i][j] + b.e[i][j]

		return Matrix(mat)

	__sub: (a, b) ->
		if a.__class != Matrix
			error "Lvalue for subtraction is not a matrix"
		if b.__class != Matrix
			error "Rvalue for subtraction is not a matrix"

		maxW, maxH = math.max(a.w, b.w), math.max(a.h, b.h)
		mat = {}
		for i = 1, maxH
			mat[i] = {}
			for j = 1, maxW
				mat[i][j] = a.e[i][j] - b.e[i][j]

		return Matrix(mat)

	__unm: (a) ->
		return Matrix(a, (i, j, e) -> -e)

	__tostring: () =>
		res = ""
		for i = 1, @h
			for j = 1, @w
				res ..= tostring(@e[i][j])\sub(1, 5) .. "\t"
			res ..= "\n"
		return res

	__mul: (a, b) ->
		if type(a) == "number"
			return Matrix(b, (i, j, e) -> e * a)
		elseif type(b) == "number"
			return Matrix.__mul(b, a)
		elseif type(a) != "table"
			error("Lvalue for matrix multiplication is not a matrix")
		elseif type(b) != "table"
			error("Rvalue for matrix multiplication is not a matrix")
		elseif a.__class != Matrix
			error("Lvalue for matrix multiplication is not a matrix")
		elseif b.__class != Matrix
			error("Rvalue for matrix multiplication is not a matrix")
		elseif a.w != b.h
			error("Matrix sizes don't match: lvalue.w ("..a.w..") =/= rvalue.h ("..b.h..")")

		mat = {}
		for i = 1, a.h
			mat[i] = {}
			for j = 1, b.w
				mat[i][j] = 0
				for k = 1, a.w
					mat[i][j] += a.e[i][k] * b.e[k][j]

		return Matrix(mat)

	T: () => 			-- transpose
		newMat = {}
		for j = 1, @w
			newMat[j] = {}
			for i = 1, @h
				newMat[j][i] = @e[i][j]

		return Matrix(newMat)


return Matrix
