local query = require 'lusty-store-mongo.query'
local connection = require 'lusty-store-mongo.store.mongo.connection'

return {
  handler = function(context)
    local q, m
    if getmetatable(context.query) then
      q, m = query(context.query)
    else
      q, m = context.query, context.data
    end
    local col = connection(lusty, config)
    local results = {}
    local cursor = col:find(q, m.fields)

    if m.sort then
      cursor:sort(m.sort)
    end

    if m.limit then
      if m.limit.offset then
        cursor:skip(m.limit.offset)
      end
      if m.limit.length then
        cursor:limit(m.limit.length)
      end
    end

    for index, result in cursor:pairs() do
      table.insert(results, result)
    end
    return results
  end
}
