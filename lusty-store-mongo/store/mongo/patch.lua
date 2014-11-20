local query = require 'lusty-store-mongo.query'
local connection = require 'lusty-store-mongo.store.mongo.connection'

return {
  handler = function(context)
    local data = context.data or {}
    local q, m
    if getmetatable(context.query) then
      q, m = query(context.query)
    else
      q = context.query
    end
    local first = next(data)
    if first and first:sub(1,1) ~= '$' then data = {['$set']=data} end
    if m and m.inc then
      data["$inc"] = m.inc
    end
    local col = connection(lusty, config)
    return col:update(q, context.data, 0, 1, 1)
  end
}
