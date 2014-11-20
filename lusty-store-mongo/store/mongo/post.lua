local objectId = require 'resty-mongol.object_id'
local connection = require 'lusty-store-mongo.store.mongo.connection'

return {
  handler = function(context)
    local col   = connection(lusty, config)

    local data  = context.query
    data['_id'] = objectId.new():tostring()

    return col:insert({data}, 0, 1)
  end
}
