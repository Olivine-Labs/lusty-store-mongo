local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")
local query = require 'lusty-store-mongo.query'

return {
  handler = function(context)
    local q, m = query(context.query)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    if q['_id'] then
      return col:find_one(q, context.data)
    else
      local results = {}
      local cursor = col:find(q, context.data)

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
  end
}
