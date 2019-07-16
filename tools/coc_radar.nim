import os, parsecsv, strutils, sequtils, json, marshal, strformat, logging, httpclient

type
  IndexPc* = object
    id*: string
    name*: string
    tags*: seq[string]
    url*: string
  NilType = ref object
  SrcTags = seq[SrcTag]
  SrcTag = ref object
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
  SrcPc = ref object
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
    comment*: string

const
  retryCount = 3
  retrySleepMS = 1000

addHandler(newConsoleLogger(lvlAll, verboseFmtStr, useStderr=true))

proc toIndexPc*(this: SrcTag, tag: string): IndexPc = 
  result = IndexPc(id: $this.id, name: this.name, tags: @[tag], url: this.idurl)

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

proc getTag(urls: seq[string]): int =
  info "Start main:"
  let client = newHttpClient()
  var pcs: seq[IndexPc]
  for url in urls:
    let tag = url.split("?")[^1].split("=")[1]
    for tagObj in client.retryGet(url).parseJson.to(SrcTags):
      let pc = tagObj.toIndexPc(tag)
      pcs.add(pc)
  echo $$pcs
  info "Success main:"

when isMainModule:
  let gettingPagesFile = commandLineParams()[0]
  for pageInfo in gettingPagesFile.parseFile.to(GettingPages):
    echo pageInfo