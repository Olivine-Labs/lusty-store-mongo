local packageName = (...):match("(.-)[^%.]+$")
local query = require 'lusty-store-mongo.query'
local connection = require(packageName..'.connection')

return {
  handler = function(context)
    local col = connection(lusty, config)
    local q = query(context.query)
    if q['_id'] then
      return col:find_one(q, {_id=1, lastModified=1})
    else
      local results = {}
      local cursor = col:find(q, {_id=1, lastModified=1})
      for index, result in cursor:pairs() do
        table.insert(results, result)
      end
      return results
    end
  end
}
