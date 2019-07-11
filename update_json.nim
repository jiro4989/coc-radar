import parsecsv, strutils, sequtils
from os import execShellCmd

var urls: seq[string]

var p: CsvParser
p.open("conf/page.csv")
p.readHeaderRow()
while p.readRow():
  let url = p.row[1].strip
  urls.add(url)

let params = urls.join(" ")
let exitCode = execShellCmd("coc -rXf json -t 1000 " & params & " > docs/js/data.json")
if exitCode != 0:
  stderr.writeLine("Error occured")
  quit(1)
