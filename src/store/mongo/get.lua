local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")
local query = require 'lusty-store-mongo.query'

return {
  handler = function(context)
    local q = query(context.query)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    if q['_id'] then
      return col:find_one(q, context.data)
    else
      local results = {}
      local cursor = col:find(q, context.data)
      for index, result in cursor:pairs() do
        table.insert(results, result)
      end
      return results
    end
  end
}
