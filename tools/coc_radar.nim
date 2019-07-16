import os, strutils, json, marshal, strformat, logging, httpclient, uri

type
  IndexPc* = object
    id*: string
    name*: string
    tags*: seq[string]
    url*: string
  NilType = ref object
  SrcTags = seq[SrcTag]
  SrcTag = object
    id: int64
    idurl: string
    md: string
    mdurl: string
    Name: string
    name: string
    title: string
    Level: int64
    level: int64
    Exp: int64
    exp: int64
    Class: string
    class: string
    Race: string
    race: string
    SortA: int64
    int_sort: int64
    SortC: string
    str_sort: string
    system: string
  SrcPc = object
    is_disp_status: string
    V_NA1: string
    NA1: string
    V_NA2: string
    NA2: string
    V_NA3: string
    NA3: string
    V_NA4: string
    NA4: string
    V_NA5: string
    NA5: string
    V_NA6: string
    NA6: string
    V_NA7: string
    NA7: string
    V_NA8: string
    NA8: string
    NA9: string
    NA10: string
    NA11: string
    NA12: string
    NA13: string
    NA14: string
    NS1: string
    NS2: string
    NS3: string
    NS4: string
    NS5: string
    NS6: string
    NS7: string
    NS8: string
    NS9: string
    NS10: string
    NS11: string
    NS12: string
    NS13: string
    NS14: string
    NM1: string
    NM2: string
    NM3: string
    NM4: string
    NM5: string
    NM6: string
    NM7: string
    NM8: string
    NM9: string
    NM10: string
    NM11: string
    NM12: string
    NM13: string
    NM14: string
    NP1: string
    NP2: string
    NP3: string
    NP4: string
    NP5: string
    NP6: string
    NP7: string
    NP8: string
    NP9: string
    NP10: string
    NP11: string
    NP12: string
    NP13: string
    NP14: string
    is_disp_san: string
    SAN_Left: string
    SAN_Max: string
    SAN_Danger: string
    is_disp_power: string
    TS_Total: string
    TS_Maximum: string
    TS_Add: string
    TK_Total: string
    TK_Maximum: string
    TK_Add: string
    TS_Skill_HideMind: string
    is_disp_battlearts: string
    TBAU: seq[string]
    TBAD: seq[string]
    TBAS: seq[string]
    TBAK: seq[string]
    TBAA: seq[string]
    TBAO: seq[string]
    TBAP: seq[string]
    TBAS_Total: string
    TBAK_Total: string
    is_disp_findarts: string
    TFAU: seq[string]
    TFAD: seq[string]
    TFAS: seq[string]
    TFAK: seq[string]
    TFAA: seq[string]
    TFAO: seq[string]
    TFAP: seq[string]
    TFAS_Total: string
    TFAK_Total: string
    is_disp_actarts: string
    TAAU: seq[string]
    unten_bunya: string
    TAAD: seq[string]
    TAAS: seq[string]
    TAAK: seq[string]
    TAAA: seq[string]
    TAAO: seq[string]
    TAAP: seq[string]
    seisaku_bunya: string
    main_souju_norimono: string
    TAAS_Total: string
    TAAK_Total: string
    is_disp_commuarts: string
    TCAU: seq[string]
    TCAD: seq[string]
    TCAS: seq[string]
    TCAK: seq[string]
    TCAA: seq[string]
    TCAO: seq[string]
    TCAP: seq[string]
    mylang_name: string
    TCAS_Total: string
    TCAK_Total: string
    is_disp_knowarts: string
    TKAU: seq[string]
    TKAD: seq[string]
    TKAS: seq[string]
    TKAK: seq[string]
    TKAA: seq[string]
    TKAO: seq[string]
    TKAP: seq[string]
    geijutu_bunya: string
    TKAS_Total: string
    TKAK_Total: string
    is_disp_battle: string
    dmg_bonus: string
    arms_name: seq[string]
    arms_hit: seq[string]
    arms_damage: seq[string]
    arms_range: seq[string]
    arms_attack_count: seq[string]
    arms_last_shot: seq[string]
    arms_vitality: seq[string]
    arms_sonota: seq[string]
    is_disp_item: string
    item_name: seq[string]
    item_tanka: seq[string]
    item_num: seq[string]
    item_price: seq[string]
    item_memo: seq[string]
    price_item_sum: string
    money: string
    debt: string
    is_disp_personal: string
    pc_name: string
    pc_tags: string
    shuzoku: string
    age: string
    sex: string
    pc_height: string
    pc_weight: string
    pc_kigen: string
    color_hair: string
    color_eye: string
    color_skin: string
    pc_making_memo: string
    pc_making_memo_rows: string
    message: string
    game: string
    data_id: int64
    phrase: string
    data_title: string
    save_limitate: string
    dodontof_send_to: string
    dodontof_url: string
    dodontof_room: string
    koma_name: string
    dodontof_image: string
    dodontof_sc_colors: string
    elysion: string
    nechro: string
    select2: string
  GettingPages = seq[GettingPage]
  GettingPage = object
    name*: string
    url*: string
    genre*: string
    comment*: string
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
  IllegalGettingPageGenreError = Defect

const
  retryCount = 3
  retrySleepMS = 1000
  outDir = "docs/data"

addHandler(newConsoleLogger(lvlAll, verboseFmtStr, useStderr=true))

proc toIndexPc*(this: SrcTag, tags: seq[string]): IndexPc = 
  result = IndexPc(id: $this.id, name: this.name, tags: tags, url: this.idurl)

proc toPc*(this: SrcPc): Pc =
  discard

proc retryGet(client: HttpClient, url: string): string =
  for i in 1..retryCount:
    try:
      result = client.get(url).body
      return
    except:
      error(getCurrentExceptionMsg())
      if i == retryCount:
        raise getCurrentException()
      sleep(retrySleepMS)
      continue

proc fetchPcs(client: HttpClient, url: string): seq[IndexPc] =
  let client = newHttpClient()
  for tagObj in client.retryGet(url).parseJson.to(SrcTags):
    let pc = tagObj.toIndexPc(@[])
    result.add(pc)

proc fetchPcsWithTag(client: HttpClient, url: string): seq[IndexPc] =
  let tag = url.parseUri.query.split("=")[1]
  for tagObj in client.retryGet(url).parseJson.to(SrcTags):
    let pc = tagObj.toIndexPc(@[tag])
    result.add(pc)

when isMainModule:
  # 引数から取得データの一覧ファイルを取得
  let gettingPagesFile = commandLineParams()[0]

  let client = newHttpClient()
  var indexPcs: seq[IndexPc]
  # 一覧ファイルのJSONからURLを取得し、データを取得
  # 取得したデータをindex.jsonとして出力する
  for pageInfo in gettingPagesFile.parseFile.to(GettingPages):
    let url = pageInfo.url
    let genre = pageInfo.genre
    case genre
    of "tag":
      indexPcs.add(client.fetchPcsWithTag(url))
    of "player":
      indexPcs.add(client.fetchPcs(url))
    else:
      raise newException(IllegalGettingPageGenreError,
                         &"genre is illegal. genre = {genre}")
  writeFile(&"{outDir}/index.json", $$indexPcs)

  # 各探索者のJSONを取得し、1探索者1JSONとしてファイル出力する
  # 出力するファイル名は探索者のIDを使用する。
  for indexPc in indexPcs:
    let url = indexPc.url & ".js"
    let srcPc = client.retryGet(url).parseJson.to(SrcPc)
    let pc = srcPc.toPc
    writeFile(&"{outDir}/{indexPc.id}.json", $$pc)