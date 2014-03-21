local packageName = (...):match("(.-)[^%.]+$")
local objectId    = require 'resty-mongol.object_id'
local connection  = require(packageName..'.connection')

return {
  handler = function(context)
    local col   = connection(lusty, config)

    local data  = context.query
    data['_id'] = objectId.new():tostring()

    return col:insert({data}, 0, 1)
  end
}
