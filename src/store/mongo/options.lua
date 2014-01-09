local util = require 'lusty.util'
local packageName = (...):match("(.-)[^%.]+$")
local query = require 'lusty-store-mongo.query'

return {
  handler = function(context)
    local q, m = query(context.query)
    local col = util.inline(packageName..'.connection', {lusty=lusty, config=config})
    local count = col:count(q)
    return count
  end
}
