local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")
local query = require 'lusty-store-mongo.query'

return {
  handler = function(context)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
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
