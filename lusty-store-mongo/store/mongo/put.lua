local objectId = require 'resty-mongol.object_id'
local query = require 'lusty-store-mongo.query'
local connection = require 'lusty-store-mongo.store.mongo.connection'

return {
  handler = function(context)
    local q
    if getmetatable(context.query) then
      q = query(context.query)
    else
      q = context.query
    end
    local col = connection(lusty, config)
    if not context.data['_id'] then
      context.data['_id'] = q['_id'] and q['_id']['$in'][1] or objectId.new():tostring()
    end
    col:delete(q)
    return col:insert({context.data}, 0, 1)
  end
}
