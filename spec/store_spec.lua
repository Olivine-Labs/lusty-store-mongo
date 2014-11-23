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

local function convertToList(t)
    local list = {}
    for k, v in t:pairs() do
      list[#list+1] = v
    end
    return list
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
    local list = convertToList(c)
    assert.are.equal(1000, #list)
  end)

  it("fetches properly with skip and limit", function()
    local col = connect()
    local c = col:find({})
    c:skip(500)
    c:limit(50)
    local list = convertToList(c)
    assert.are.equal(50, #list)
  end)

  it("counts records", function()
    local col = connect()
    col:delete({}) --clear all first
    for i = 1, 50 do
      local ab
      if i <= 25 then
        ab = "a"
      else
        ab = "b"
      end
      col:insert({{test='test', item=i, ab=ab}})
    end

    local items = convertToList(col:find({}))
    assert.are.equal(50, #items)
    assert.are.equal(50, col:count())

    local items2 = convertToList(col:find({ab="a"}))
    assert.are.equal(25, #items2)
    assert.are.equal(25, col:count({ab="a"}))

  end)

end)
