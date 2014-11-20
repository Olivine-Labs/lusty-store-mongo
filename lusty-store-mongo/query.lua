local queries = {}

local ops = {
  eq      = function(result, clause)
    result[clause.field] = clause.arguments[1]
  end,
  neq     = function(result, clause) queries.simpleOp("$ne", result, clause) end,
  lt      = function(result, clause) queries.simpleOp("$lt", result, clause) end,
  lte     = function(result, clause) queries.simpleOp("$lte", result, clause) end,
  gt      = function(result, clause) queries.simpleOp("$gt", result, clause) end,
  gte     = function(result, clause) queries.simpleOp("$gte", result, clause) end,
  reg     = function(result, clause) queries.regexOp(result, clause) end,
  is      = function(result, clause) queries.arrayOp("$in", result, clause) end,
  has     = function(result, clause) queries.arrayOp("$all", result, clause) end,
  isnot   = function(result, clause) queries.arrayOp("$nin", result, clause) end,
  ["and"] = function(result, clause) queries.subquery("$and", result, clause) end,
  ["or"]  = function(result, clause) queries.subquery("$or", result, clause) end,
  sort    = function(result, clause, meta)
    meta.sort = clause.arguments[1]
  end,
  limit   = function(result, clause, meta)
    meta.limit = clause.arguments[1]
  end,
  fields  = function(result, clause, meta)
    meta.fields = clause.arguments[1]
  end,
  inc     = function(result, clause, meta)
    if not meta.inc then meta.inc = {} end
    meta.inc[clause.field] = clause.arguments[1]
  end
}

local function query(query)
  local result, meta = {}, {}
  for _, clause in pairs(query) do
    local op = ops[clause.operation]
    if op then
      op(result, clause, meta)
    else
      error("Unsupported query operation '"..clause.operation.."'")
    end
  end
  return result, meta
end


function queries.simpleOp(op, result, clause)
  result[clause.field] = {[op] = clause.arguments[1]}
end

function queries.arrayOp(op, result, clause)
  result[clause.field] = {[op] = clause.arguments}
end

function queries.regexOp(result, clause)
  local regexes = {}

  for _, v in pairs(clause.arguments) do
    local res = {}
    string.gsub(v, "([^/]+)", function(c) res[#res+1] = c end)
    regexes[#regexes+1] = {["$regex"] = res[1], ["$options"] = res[2]}
  end

  if #regexes == 1 then
    result[clause.field] = regexes[1]
  else
    result[clause.field] = {["$in"] = regexes}
  end
end

function queries.subquery(op, result, clause)
  if not result[op] then
    result[op] = {}
  end
  for i=1, #clause.arguments do
    if not result[op][0] then
      result[op][0]=query(clause.arguments[i])
    else
      result[op][#result[op]+1] = query(clause.arguments[i])
    end
  end
end

return query
