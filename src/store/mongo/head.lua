local util = require 'lusty.util'
local db = util.inline('lusty-store-mongo.store.mongo.connection', {lusty=lusty, config=config})
local col = db.get_col(config.collection)

return {
  handler = function(context)
    local query, data = context.query, context.data
    return col:find(query, data)
  end
}
