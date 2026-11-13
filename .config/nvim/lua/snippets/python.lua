local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "defpt",
    fmt(
      [[
def test_{}(capsys):
    code = {}.{}
    out, err = capsys.readouterr()
    assert code == {}
    assert "{}" in err
    assert "{}" in out
]],
      {
        i(1, "function_name"),
        i(2, "module"),
        i(3, "function"),
        i(4, "code"),
        i(5, "error"),
        i(6, "output"),
      }
    )
  ),
}
