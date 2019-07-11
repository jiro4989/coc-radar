import parsecsv, strutils, sequtils, json, marshal, strformat
from os import execShellCmd

type
  IndexPc* = ref object
    id*: string
    name*: string
    tags*: seq[string]
    url*: string

  Pc* = ref object
    id*: string
    name*: string
    tags*: seq[string]
    url*: string
    param*: Param
  Param* = object
    ability*: Ability
    battleArts*: BattleArts
    findArts*: FindArts
    actionArts*: ActionArts
    negotiationArts*: NegotiationArts
    knowledgeArts*: KnowledgeArts
  CValue* = object
    name*: string
    num*: int
  Ability* = object
    str*: CValue    ## STR
    con*: CValue    ## CON
    pow*: CValue    ## POW
    dex*: CValue    ## DEX
    app*: CValue    ## APP
    siz*: CValue    ## SIZ
    int2*: CValue    ## INT
    edu*: CValue    ## EDU
    hp*: CValue    ## HP
    mp*: CValue    ## MP
    initSan*: CValue    ## 初期SAN
    idea*: CValue    ## アイデア
    luk*: CValue    ## 幸運
    knowledge*: CValue    ## 知識
  BattleArts* = object
    avoidance*: CValue    ## 回避
    kick*: CValue    ## キック
    hold*: CValue    ## 組み付き
    punch*: CValue    ## こぶし（パンチ）
    headThrust*: CValue    ## 頭突き
    throwing*: CValue    ## 投擲
    martialArts*: CValue    ## マーシャルアーツ
    handGun*: CValue    ## 拳銃
    submachineGun*: CValue    ## サブマシンガン
    shotGun*: CValue    ## ショットガン
    machineGun*: CValue    ## マシンガン
    rifle*: CValue    ## ライフル
  FindArts* = object
    firstAid*: CValue    ## 応急手当
    lockPicking*: CValue    ## 鍵開け
    hide*: CValue    ## 隠す
    disappear*: CValue    ## 隠れる
    ear*: CValue    ## 聞き耳
    quietStep*: CValue    ## 忍び歩き
    photography*: CValue    ## 写真術
    psychoAnalysis*: CValue    ## 精神分析
    tracking*: CValue    ## 追跡
    climbing*: CValue    ## 登攀
    library*: CValue    ## 図書館
    aim*: CValue    ## 目星
  ActionArts* = object
    driving*: CValue    ## 運転
    repairingMachine*: CValue    ## 機械修理
    operatingHeavyMachine*: CValue    ## 重機械操作
    ridingHorse*: CValue    ## 乗馬
    swimming*: CValue    ## 水泳
    creating*: CValue    ## 製作
    control*: CValue    ## 操縦
    jumping*: CValue    ## 跳躍
    repairingElectric*: CValue    ## 電気修理
    navigate*: CValue    ## ナビゲート
    disguise*: CValue    ## 変装
  NegotiationArts* = object
    winOver*: CValue    ## 言いくるめ
    credit*: CValue    ## 信用
    haggle*: CValue    ## 値切り
    argue*: CValue    ## 説得
    nativeLanguage*: CValue    ## 母国語
  KnowledgeArts* = object
    medicine*: CValue    ## 医学
    occult*: CValue    ## オカルト
    chemistry*: CValue    ## 化学
    cthulhuMythology*: CValue    ## クトゥルフ神話
    art*: CValue    ## 芸術
    accounting*: CValue    ## 経理
    archeology*: CValue    ## 考古学
    computer*: CValue    ## コンピューター
    psychology*: CValue    ## 心理学
    anthropology*: CValue    ## 人類学
    biology*: CValue    ## 生物学
    geology*: CValue    ## 地質学
    electronicEngineering*: CValue    ## 電子工学
    astronomy*: CValue    ## 天文学
    naturalHistory*: CValue    ## 博物学
    physics*: CValue    ## 物理学
    law*: CValue    ## 法律
    pharmacy*: CValue    ## 薬学
    history*: CValue    ## 歴史

proc scrape(confFiles: seq[string]): int =
  ## 指定のCSVからURLを取得してスクレイピングする。
  var urls: seq[string]

  # 設定ファイルからURLを取得
  for conf in confFiles:
    var p: CsvParser
    p.open(conf)
    p.readHeaderRow()
    while p.readRow():
      let url = p.row[1].strip
      urls.add(url)
    p.close

  # URLをコマンドの引数に変換して実行
  let params = urls.join(" ")
  result = execShellCmd("coc -lrXf json -t 1000 " & params)
  if result != 0:
    stderr.writeLine("Error occured")

proc generateJson(): int =
  ## 標準入力から1行ごとのJSONを受け取って、index.jsonと探索者のID.jsonを生成する。
  const outDir = "docs/js"
  # index.jsonの生成
  var indexPcs: seq[string]
  var line: string
  while stdin.readLine(line):
    # 各探索者ごとのデータJSONを生成
    let pc = line.parseJson.to(Pc)[]
    writeFile(&"{outDir}/{pc.id}.json", $$pc)

    # index.jsonではparamは不要なのでそれらを持たないオブジェクトを生成
    let indexPc = IndexPc(
      id: pc.id,
      name: pc.name,
      tags: pc.tags,
      url: pc.url)
    indexPcs.add($$indexPc[])
  writeFile(&"{outDir}/index.json", "[\n" & indexPcs.join(",\n") & "\n]")

when isMainModule:
  import cligen
  dispatchMulti([scrape], [generateJson])