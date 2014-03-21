local packageName = (...):match("(.-)[^%.]+$")
local query = require 'lusty-store-mongo.query'
local connection = require(packageName..'.connection')
return {
  handler = function(context)
    local q, m = query(context.query)
    local col = connection(lusty, config)
    local count = col:count(q)
    return count
  end
}
