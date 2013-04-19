local util = require 'lusty.util'
local db = util.inline('lusty-store-mongo.store.mongo.connection', {lusty=lusty, config=config})
local col = db.get_col(config.collection)

return {
  handler = function(context)
    local data = context.query
    local meta = getmetatable(data)
    if type(meta.__toStore) == "function" then
      data = meta.__toStore(data, "post")
    end
    return col:insert({data}, 0, 1)
  end
}
