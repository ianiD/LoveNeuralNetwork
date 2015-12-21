local Matrix
do
  local _base_0 = {
    entrywise = function(a, b)
      if a.__class ~= Matrix then
        error("Lvalue for schur multiplication is not a matrix")
      end
      if b.__class ~= Matrix then
        error("Rvalue for schur multiplication is not a matrix")
      end
      if a.w ~= b.w or a.h ~= b.h then
        error("Matrix dimenstions for schur multiplication don't match")
      end
      local mat = { }
      for i = 1, a.h do
        mat[i] = { }
        for j = 1, a.w do
          mat[i][j] = a.e[i][j] * b.e[i][j]
        end
      end
      return Matrix(mat)
    end,
    __add = function(a, b)
      if a.__class ~= Matrix then
        error("Lvalue for addition is not a matrix")
      end
      if b.__class ~= Matrix then
        error("Rvalue for addition is not a matrix")
      end
      local maxW, maxH = math.max(a.w, b.w), math.max(a.h, b.h)
      local mat = { }
      for i = 1, maxH do
        mat[i] = { }
        for j = 1, maxW do
          mat[i][j] = a.e[i][j] + b.e[i][j]
        end
      end
      return Matrix(mat)
    end,
    __sub = function(a, b)
      if a.__class ~= Matrix then
        error("Lvalue for subtraction is not a matrix")
      end
      if b.__class ~= Matrix then
        error("Rvalue for subtraction is not a matrix")
      end
      local maxW, maxH = math.max(a.w, b.w), math.max(a.h, b.h)
      local mat = { }
      for i = 1, maxH do
        mat[i] = { }
        for j = 1, maxW do
          mat[i][j] = a.e[i][j] - b.e[i][j]
        end
      end
      return Matrix(mat)
    end,
    __unm = function(a)
      return Matrix(a, function(i, j, e)
        return -e
      end)
    end,
    __tostring = function(self)
      local res = ""
      for i = 1, self.h do
        for j = 1, self.w do
          res = res .. (tostring(self.e[i][j]):sub(1, 5) .. "\t")
        end
        res = res .. "\n"
      end
      return res
    end,
    __mul = function(a, b)
      if type(a) == "number" then
        return Matrix(b, function(i, j, e)
          return e * a
        end)
      elseif type(b) == "number" then
        return Matrix.__mul(b, a)
      elseif type(a) ~= "table" then
        error("Lvalue for matrix multiplication is not a matrix")
      elseif type(b) ~= "table" then
        error("Rvalue for matrix multiplication is not a matrix")
      elseif a.__class ~= Matrix then
        error("Lvalue for matrix multiplication is not a matrix")
      elseif b.__class ~= Matrix then
        error("Rvalue for matrix multiplication is not a matrix")
      elseif a.w ~= b.h then
        error("Matrix sizes don't match: lvalue.w (" .. a.w .. ") =/= rvalue.h (" .. b.h .. ")")
      end
      local mat = { }
      for i = 1, a.h do
        mat[i] = { }
        for j = 1, b.w do
          mat[i][j] = 0
          for k = 1, a.w do
            mat[i][j] = mat[i][j] + (a.e[i][k] * b.e[k][j])
          end
        end
      end
      return Matrix(mat)
    end,
    T = function(self)
      local newMat = { }
      for j = 1, self.w do
        newMat[j] = { }
        for i = 1, self.h do
          newMat[j][i] = self.e[i][j]
        end
      end
      return Matrix(newMat)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, h, w, e)
      if e == nil then
        e = 0
      end
      if type(h) == "table" then
        if h.__class == Matrix then
          self.w = h.w
          self.h = h.h
          do
            local _accum_0 = { }
            local _len_0 = 1
            for i = 1, h.h do
              do
                local _accum_1 = { }
                local _len_1 = 1
                for j = 1, h.w do
                  _accum_1[_len_1] = w(i, j, h.e[i][j])
                  _len_1 = _len_1 + 1
                end
                _accum_0[_len_0] = _accum_1
              end
              _len_0 = _len_0 + 1
            end
            self.e = _accum_0
          end
        elseif type(h[1]) == "table" then
          self.e = h
          self.h = #self.e
          self.w = #self.e[1]
        end
      else
        self.h = h
        self.w = w
        if type(e) == "function" then
          do
            local _accum_0 = { }
            local _len_0 = 1
            for i = 1, h do
              do
                local _accum_1 = { }
                local _len_1 = 1
                for j = 1, w do
                  _accum_1[_len_1] = e(i, j)
                  _len_1 = _len_1 + 1
                end
                _accum_0[_len_0] = _accum_1
              end
              _len_0 = _len_0 + 1
            end
            self.e = _accum_0
          end
        else
          do
            local _accum_0 = { }
            local _len_0 = 1
            for i = 1, h do
              do
                local _accum_1 = { }
                local _len_1 = 1
                for j = 1, w do
                  _accum_1[_len_1] = e
                  _len_1 = _len_1 + 1
                end
                _accum_0[_len_0] = _accum_1
              end
              _len_0 = _len_0 + 1
            end
            self.e = _accum_0
          end
        end
      end
    end,
    __base = _base_0,
    __name = "Matrix"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Matrix = _class_0
end
return Matrix
