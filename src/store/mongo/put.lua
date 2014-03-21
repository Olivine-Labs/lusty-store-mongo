local packageName = (...):match("(.-)[^%.]+$")
local objectId    = require 'resty-mongol.object_id'
local query       = require 'lusty-store-mongo.query'
local connection  = require(packageName..'.connection')

return {
  handler = function(context)
    local q = query(context.query)
    local col = connection(lusty, config)
    if not context.data['_id'] then
      context.data['_id'] = q['_id'] and q['_id']['$in'][1] or objectId.new():tostring()
    end
    col:delete(q)
    return col:insert({context.data}, 0, 1)
  end
}
