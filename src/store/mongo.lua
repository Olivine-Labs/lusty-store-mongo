local util = require 'lusty.util'
local packageName = (...)
local methods = {}
return {
  handler = function(context)
    local methodName = string.lower(context.method)
    local method = methods[methodName]
    if not method then
      method = util.inline(packageName..'.'..methodName, {context=context, config=config}).handler
      methods[methodName] = method
    end
    return method(context)
  end
}
