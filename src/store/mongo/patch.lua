local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")
local query = require 'lusty-store-mongo.query'

return {
  handler = function(context)
    if not context.data["$set"] then context.data["$set"] = {} end
    local q = query(context.query)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    return col:update(q, context.data, 0, 1, 1)
  end
}
