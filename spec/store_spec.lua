package.path = './spec/?.lua;../src/?.lua;'..package.path
local mongo = require 'resty-mongol'

local function connect()
  local conn = mongo()
  local ok, err = conn:connect('127.0.0.1', 27017)

  if not ok then
    error(err)
  end

  local db = conn:new_db_handle('test')

  return db:get_col('test')
end

describe("Store", function()
  it("can insert and delete 1000 documents", function()
    local col = connect()
    col:delete({}) --clear all first
    for i = 1, 1000 do
      col:insert({{test='test'}})
    end
    assert.are.equal(col:count(), 1000)
    local c = col:find({})
    local list = {}
    for k, v in c:pairs() do
      list[#list+1] = v
    end
    assert.are.equal(1000, #list)
  end)

  it("fetches properly with skip and limit", function()
    local col = connect()
    local c = col:find({})
    c:skip(500)
    c:limit(50)
    local list = {}
    for k, v in c:pairs() do
      list[#list+1] = v
    end
    assert.are.equal(50, #list)
  end)
end)
