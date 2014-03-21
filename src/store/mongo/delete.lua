local packageName = (...):match("(.-)[^%.]+$")
local query = require 'lusty-store-mongo.query'
local connection = require(packageName..'.connection')

return {
  handler = function(context)
    local col = connection(lusty, config)
    local data = nil
    local q = query(context.query)

    if q['_id'] then
      data = col:find_one(q)
    else
      data = col:find(q)
    end
    col:delete(q, 0, 1)
    return data
  end
}
