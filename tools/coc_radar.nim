import os, strutils, json, marshal, strformat, logging, httpclient, uri, times, rdstdin
from sequtils import mapIt
from algorithm import sort

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
    NA1: string ## STR
    V_NA2: string
    NA2: string ## CON
    V_NA3: string
    NA3: string ## POW
    V_NA4: string
    NA4: string ## DEX
    V_NA5: string
    NA5: string ## APP
    V_NA6: string
    NA6: string ## SIZ
    V_NA7: string
    NA7: string ## INT
    V_NA8: string
    NA8: string ## EDU
    NA9: string ## HP
    NA10: string ## MP
    NA11: string ## 初期SAN
    NA12: string ## アイデア
    NA13: string ## 幸運
    NA14: string ## 知識
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
    #TS_Skill_HideMind: string # TODO
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
    # select2: string ## TODO
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

proc toIndexPc*(this: SrcPc, url: string): IndexPc = 
  let tags = if this.pc_tags == "": @[]
             else: this.pc_tags.split(" ")
  result = IndexPc(id: $this.data_id, name: this.pc_name, tags: tags,
                   url: url)

proc toPc*(this: SrcPc, url: string): Pc =
  var pc = Pc(id: $this.data_id,
              name: this.pc_name,
              tags: this.pc_tags.split(" "),
              url: url)
  block:
    var data: Ability
    data.str = CValue(name: "STR", num: this.NA1.parseInt)
    data.con = CValue(name: "CON", num: this.NA2.parseInt)
    data.pow = CValue(name: "POW", num: this.NA3.parseInt)
    data.dex = CValue(name: "DEX", num: this.NA4.parseInt)
    data.app = CValue(name: "APP", num: this.NA5.parseInt)
    data.siz = CValue(name: "SIZ", num: this.NA6.parseInt)
    data.int2 = CValue(name: "INT", num: this.NA7.parseInt)
    data.edu = CValue(name: "EDU", num: this.NA8.parseInt)
    data.hp = CValue(name: "HP", num: this.NA9.parseInt)
    data.mp = CValue(name: "MP", num: this.NA10.parseInt)
    data.initSan = CValue(name: "初期SAN", num: this.NA11.parseInt)
    data.idea = CValue(name: "アイデア", num: this.NA12.parseInt)
    data.luk = CValue(name: "幸運", num: this.NA13.parseInt)
    data.knowledge = CValue(name: "知識", num: this.NA14.parseInt)
    pc.param.ability = data
  block:
    var data: BattleArts # TBAP
    data.avoidance = CValue(name: "回避", num: this.TBAP[0].parseInt)
    data.kick = CValue(name: "キック", num: this.TBAP[1].parseInt)
    data.hold = CValue(name: "組み付き", num: this.TBAP[2].parseInt)
    data.punch = CValue(name: "こぶし（パンチ）", num: this.TBAP[3].parseInt)
    data.headThrust = CValue(name: "頭突き", num: this.TBAP[4].parseInt)
    data.throwing = CValue(name: "投擲", num: this.TBAP[5].parseInt)
    data.martialArts = CValue(name: "マーシャルアーツ", num: this.TBAP[6].parseInt)
    data.handGun = CValue(name: "拳銃", num: this.TBAP[7].parseInt)
    data.submachineGun = CValue(name: "サブマシンガン", num: this.TBAP[8].parseInt)
    data.shotGun = CValue(name: "ショットガン", num: this.TBAP[9].parseInt)
    data.machineGun = CValue(name: "マシンガン", num: this.TBAP[10].parseInt)
    data.rifle = CValue(name: "ライフル", num: this.TBAP[11].parseInt)
    pc.param.battleArts = data
  block:
    var data: FindArts # TFAP
    data.firstAid = CValue(name: "応急手当", num: this.TFAP[0].parseInt)
    data.lockPicking = CValue(name: "鍵開け", num: this.TFAP[1].parseInt)
    data.hide = CValue(name: "隠す", num: this.TFAP[2].parseInt)
    data.disappear = CValue(name: "隠れる", num: this.TFAP[3].parseInt)
    data.ear = CValue(name: "聞き耳", num: this.TFAP[4].parseInt)
    data.quietStep = CValue(name: "忍び歩き", num: this.TFAP[5].parseInt)
    data.photography = CValue(name: "写真術", num: this.TFAP[6].parseInt)
    data.psychoAnalysis = CValue(name: "精神分析", num: this.TFAP[7].parseInt)
    data.tracking = CValue(name: "追跡", num: this.TFAP[8].parseInt)
    data.climbing = CValue(name: "登攀", num: this.TFAP[9].parseInt)
    data.library = CValue(name: "図書館", num: this.TFAP[10].parseInt)
    data.aim = CValue(name: "目星", num: this.TFAP[11].parseInt)
    pc.param.findArts = data
  block:
    var data: ActionArts # TAAP
    data.driving = CValue(name: "運転", num: this.TAAP[0].parseInt)
    data.repairingMachine = CValue(name: "機械修理", num: this.TAAP[1].parseInt)
    data.operatingHeavyMachine = CValue(name: "重機械操作", num: this.TAAP[2].parseInt)
    data.ridingHorse = CValue(name: "乗馬", num: this.TAAP[3].parseInt)
    data.swimming = CValue(name: "水泳", num: this.TAAP[4].parseInt)
    data.creating = CValue(name: "制作", num: this.TAAP[5].parseInt)
    data.control = CValue(name: "操縦", num: this.TAAP[6].parseInt)
    data.jumping = CValue(name: "跳躍", num: this.TAAP[7].parseInt)
    data.repairingElectric = CValue(name: "電気修理", num: this.TAAP[8].parseInt)
    data.navigate = CValue(name: "ナビゲート", num: this.TAAP[9].parseInt)
    data.disguise = CValue(name: "変装", num: this.TAAP[10].parseInt)
    pc.param.actionArts = data
  block:
    var data: NegotiationArts # TCAP
    data.winOver = CValue(name: "言いくるめ", num: this.TCAP[0].parseInt)
    data.credit = CValue(name: "信用", num: this.TCAP[1].parseInt)
    data.haggle = CValue(name: "説得", num: this.TCAP[2].parseInt)
    data.argue = CValue(name: "値切り", num: this.TCAP[3].parseInt)
    data.nativeLanguage = CValue(name: "母国語", num: this.TCAP[4].parseInt)
    pc.param.negotiationArts = data
  block:
    var data: KnowledgeArts # TKAP
    data.medicine = CValue(name: "医学", num: this.TKAP[0].parseInt)
    data.occult = CValue(name: "オカルト", num: this.TKAP[1].parseInt)
    data.chemistry = CValue(name: "科学", num: this.TKAP[2].parseInt)
    data.cthulhuMythology = CValue(name: "クトゥルフ神話", num: this.TKAP[3].parseInt)
    data.art = CValue(name: "芸術", num: this.TKAP[4].parseInt)
    data.accounting = CValue(name: "経理", num: this.TKAP[5].parseInt)
    data.archeology = CValue(name: "考古学", num: this.TKAP[6].parseInt)
    data.computer = CValue(name: "コンピュータ", num: this.TKAP[7].parseInt)
    data.psychology = CValue(name: "心理学", num: this.TKAP[8].parseInt)
    data.anthropology = CValue(name: "人類学", num: this.TKAP[9].parseInt)
    data.biology = CValue(name: "生物学", num: this.TKAP[10].parseInt)
    data.geology = CValue(name: "地質学", num: this.TKAP[11].parseInt)
    data.electronicEngineering = CValue(name: "電子工学", num: this.TKAP[12].parseInt)
    data.astronomy = CValue(name: "天文学", num: this.TKAP[13].parseInt)
    data.naturalHistory = CValue(name: "博物学", num: this.TKAP[14].parseInt)
    data.physics = CValue(name: "物理学", num: this.TKAP[15].parseInt)
    data.law = CValue(name: "法律", num: this.TKAP[16].parseInt)
    data.pharmacy = CValue(name: "薬学", num: this.TKAP[17].parseInt)
    data.history = CValue(name: "歴史", num: this.TKAP[18].parseInt)
    pc.param.knowledgeArts = data
  return pc

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

proc fetchPcsWithTag(client: HttpClient, url: string): seq[IndexPc] =
  info &"Fetch players with tag: url = {url}"
  let tag = url.parseUri.query.split("=")[1]
  # キーがからの箇所が存在してるので削除してから変換
  for tagObj in client.retryGet(url).parseJson.to(SrcTags):
    let pc = tagObj.toIndexPc(@[tag])
    result.add(pc)

proc fetchPcs(client: HttpClient, url: string): seq[IndexPc] =
  # キーがからの箇所が存在してるので削除してから変換
  info &"Fetch players: url = {url}"
  let pc = client.retryGet(url).parseJson.to(SrcPc).toIndexPc(url)
  result.add(pc)

template benchmark(msg: string, code: untyped) =
  block:
    let t0 = epochTime()
    code
    let elapsed = epochTime() - t0
    let elapsedStr = elapsed.formatFloat(format = ffDecimal, precision = 3)
    info msg & " (" & elapsedStr & " s)"

proc scrape(pageFiles: seq[string]): int =
  ## 設定ファイルからURLを取得し、JSONAPIからデータを取得する。
  info "START scrape"
  benchmark "END SUCCESS scrape":
    let indexFile = &"{outDir}/index.json"
    let client = newHttpClient()
    var indexPcs: seq[IndexPc]
    benchmark &"Created index file: file = {indexFile}":
      # 引数から取得データの一覧ファイルを取得
      let gettingPagesFile = pageFiles[0]
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
        sleep(retrySleepMS)

      # index.jsonの生成。生成前にidでソート
      indexPcs.sort do (x, y: IndexPc) -> int:
        result = cmp(x.id.parseInt, y.id.parseInt)
      writeFile(indexFile, "[\n" & indexPcs.mapIt($$it).join(",\n") & "\n]")

    # 各探索者のJSONを取得し、1探索者1JSONとしてファイル出力する
    # 出力するファイル名は探索者のIDを使用する。
    for indexPc in indexPcs:
      let pcFile = &"{outDir}/{indexPc.id}.json"
      benchmark &"Created pc file: file = {pcFile}":
        var url = indexPc.url
        # 手動で登録するデータにはjsという拡張子を含めているので、
        # 含めていないURLについてのみ追加する
        if not url.endsWith(".js"):
          url.add(".js")
        let srcPc = client.retryGet(url).parseJson.to(SrcPc)
        let pc = srcPc.toPc(url)
        writeFile(pcFile, $$pc[])
      sleep(retrySleepMS)

proc addPage(configFiles: seq[string]): int =
  ## 対話型インタフェースにより、探索者のデータのURLを追加する
  var name: string
  echo "誰の探索者か入力してください"
  if not readLineFromStdin("? ", name):
    echo "入力を中断しました"
    return 1
  echo ""

  var url: string
  echo "探索者、あるいはタグのページのURLを入力してください。"
  echo "ただし、URLの拡張子はjsです。"
  if not readLineFromStdin("? ", url):
    echo "入力を中断しました"
    return 2
  if not url.parseUri.path.endsWith(".js"):
    echo &"入力したURLが不正です。 url = {url}"
    return 3
  echo ""

  var genreId: string
  echo("""URLの分類を選択してください。
    1 )  tag
    2 )  player""")
  if not readLineFromStdin("? ", genreId):
    echo "入力を中断しました"
    return 2
  var genre: string
  case genreId:
  of "1": genre = "tag"
  of "2": genre = "player"
  else:
    echo &"入力が不正でした。 genre = {genre}"
    return 4
  echo ""
  
  var comment: string
  echo "自由なコメントを入力してください。(空欄も可）"
  if not readLineFromStdin("? ", comment):
    echo "入力を中断しました"
    return 2
  echo ""

  var yn: string
  echo(&"""以上の入力で、探索者を追加しますか？ [y/n]
    name ....... {name}
    url ........ {url}
    genre ...... {genre}
    comment .... {comment}""")
  if not readLineFromStdin("? ", yn):
    echo "入力を中断しました"
    return 5
  case yn.toLowerAscii
  of "y":
    let configFile = configFiles[0]
    var pages = parseFile(configFile).to(GettingPages)
    pages.add(GettingPage(name: name, url: url, genre: genre, comment: comment))
    writeFile(configFile, pages.`$$`.parseJson.pretty)
    echo &"設定ファイルを更新しました。 configFile = {configFile}"
  of "n":
    echo "追加をキャンセルしました。"
  else:
    echo &"入力が不正でした。 genre = {genre}"
    return 7


proc validate(pageFiles: seq[string]): int =
  ## データ取得先指定のJSONファイルの書式をチェックする。
  ## チェック項目は以下の通り。
  ##
  ## 1. オブジェクトにバインドできるか？
  ## 2. URLはjsか？
  ## 3. genreはtagまたはplayerか？
  info "Start validation."
  let pageFile = pageFiles[0]
  # オブジェクトマッピング
  for page in parseFile(pageFile).to(GettingPages):
    # chekc URL
    if not page.url.parseUri.path.endsWith(".js"):
      error &"URLが不正でした。 url = {page.url}"
      return 1
    if page.genre notin ["tag", "player"]:
      error &"genreが不正でした。 genre = {page.genre}"
      return 1
  info "Validation OK."

when isMainModule:
  import cligen
  dispatchMulti([scrape], [addPage], [validate])