import parsecsv, strutils, sequtils
from os import execShellCmd

type
  Args = object
    url: string
    opt: string

var args: seq[Args]

var p: CsvParser
p.open("conf/page.csv")
p.readHeaderRow()
while p.readRow():
  let url = p.row[1].strip
  let isList = p.row[2].strip
  var opt: Args
  opt.url = url
  if isList == "true":
    opt.opt = "-l"
  args.add(opt)

let params = args.mapIt(it.url).join(" ")
quit(execShellCmd("coc -f json -l " & params & " > docs/js/data.json"))
