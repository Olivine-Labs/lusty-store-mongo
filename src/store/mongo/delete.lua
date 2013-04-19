local util = require 'lusty.util'
local db = util.inline('lusty-store-mongo.store.mongo.connection', {lusty=lusty, config=config})
local col = db.get_col(config.collection)

return {
  handler = function(context)
    return col:delete(context.query, 0, 1)
  end
}
