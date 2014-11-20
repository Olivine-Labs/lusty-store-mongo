local util = require 'lusty.util'
local methods = {}
return {
  handler = function(context)
    local methodName = string.lower(context.method)
    local method = methods[methodName]
    if not method then
      method = util.inline('lusty-store-mongo.store.mongo.'..methodName, {context=context, config=config}).handler
      methods[methodName] = method
    end
    return method(context)
  end
}
