local module = {}

function module.merge(...)
  local result = {}

  for _, t in ipairs{...} do
    for k, v in pairs(t) do
      result[k] = v
    end

    local mt = getmetatable(t)

    if mt then
      setmetatable(result, mt)
    end
  end

  return result
end

return module
