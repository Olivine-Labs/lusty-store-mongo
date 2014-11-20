local query = require 'lusty-store-mongo.query'
local connection = require 'lusty-store-mongo.store.mongo.connection'

return {
  handler = function(context)
    local col = connection(lusty, config)
    local q = query(context.query)
    local data = col:find(q)
    col:delete(q, 0, 1)
    return data
  end
}
