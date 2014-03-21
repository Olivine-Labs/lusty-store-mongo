local packageName = (...):match("(.-)[^%.]+$")
local query = require 'lusty-store-mongo.query'
local connection = require(packageName..'.connection')

return {
  handler = function(context)
    if not context.data then context.data = {} end
    local q, m = query(context.query)
    if m and m.inc then
      context.data["$inc"] = m.inc
    end
    if not next(context.data) then context.data["$set"] = {} end
    local col = connection(lusty, config)
    return col:update(q, context.data, 0, 1, 1)
  end
}
