local queries = {}

local ops = {
  eq      = function(result, clause)
    result[clause.field] = clause.arguments[1]
  end,
  neq     = function(result, clause) queries.simpleOp("$neq", result, clause) end,
  lt      = function(result, clause) queries.simpleOp("$lt", result, clause) end,
  lte     = function(result, clause) queries.simpleOp("$lte", result, clause) end,
  gt      = function(result, clause) queries.simpleOp("$gt", result, clause) end,
  gte     = function(result, clause) queries.simpleOp("$gte", result, clause) end,
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

function queries.subquery(op, result, clause)
  result[op] = query(clause.arguments[1])
end

return query
