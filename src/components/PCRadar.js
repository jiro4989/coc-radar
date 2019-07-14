import React from 'react';
import 'css/PCRadar.css';
import Header from './Header';
import Footer from './Footer';
import { Radar, Bar } from 'react-chartjs-2';
import queryString from 'query-string';

const rootUrl = "https://jiro4989.github.io/coc-radar/data"
const indexDataUrl = `${rootUrl}/index.json`

const abilityFields = ["str", "con", "pow", "dex", "app", "siz", "int2", "edu", "hp", "mp"];
const battleFields = ["avoidance", "kick", "hold", "punch", "headThrust", "throwing", "martialArts", "handGun", "submachineGun", "shotGun", "machineGun", "rifle" ];
const findFields = ["firstAid", "lockPicking", "hide", "disappear", "ear", "quietStep", "photography", "psychoAnalysis", "tracking", "climbing", "library", "aim", ];
const actionFields = ["driving", "repairingMachine", "operatingHeavyMachine", "ridingHorse", "swimming", "creating", "control", "jumping", "repairingElectric", "navigate", "disguise", ];
const negotiationFields = ["winOver", "credit", "haggle", "argue", "nativeLanguage", ];
const knowledgeFields = ["medicine", "occult", "chemistry", "cthulhuMythology", "art", "accounting", "archeology", "computer", "psychology", "anthropology", "biology", "geology", "electronicEngineering", "astronomy", "naturalHistory", "physics", "law", "pharmacy", "history", ];
const artsFields = abilityFields
  .concat(battleFields)
  .concat(findFields)
  .concat(actionFields)
  .concat(negotiationFields)
  .concat(knowledgeFields);

const templatePlayerData = { "id": "", "name": "", "tags": [], "url": "", "param": { "ability": { "str": { "name": "STR", "num":0 }, "con": { "name": "CON", "num":0 }, "pow": { "name": "POW", "num":0 }, "dex": { "name": "DEX", "num":0 }, "app": { "name": "APP", "num":0 }, "siz": { "name": "SIZ", "num":0 }, "int2": { "name": "INT", "num":0 }, "edu": { "name": "EDU", "num":0 }, "hp": { "name": "HP", "num":0 }, "mp": { "name": "MP", "num":0 }, "initSan": { "name": "初期SAN", "num":0 }, "idea": { "name": "アイデア", "num":0 }, "luk": { "name": "幸運", "num":0 }, "knowledge": { "name": "知識", "num":0 } }, "battleArts": { "avoidance": { "name": "回避", "num":0 }, "kick": { "name": "キック", "num":0 }, "hold": { "name": "組み付き", "num":0 }, "punch": { "name": "こぶし（パンチ）", "num":0 }, "headThrust": { "name": "頭突き", "num":0 }, "throwing": { "name": "投擲", "num":0 }, "martialArts": { "name": "マーシャルアーツ", "num":0 }, "handGun": { "name": "拳銃", "num":0 }, "submachineGun": { "name": "サブマシンガン", "num":0 }, "shotGun": { "name": "ショットガン", "num":0 }, "machineGun": { "name": "マシンガン", "num":0 }, "rifle": { "name": "ライフル", "num":0 } }, "findArts": { "firstAid": { "name": "応急手当", "num":0 }, "lockPicking": { "name": "鍵開け", "num":0 }, "hide": { "name": "隠す", "num":0 }, "disappear": { "name": "隠れる", "num":0 }, "ear": { "name": "聞き耳", "num":0 }, "quietStep": { "name": "忍び歩き", "num":0 }, "photography": { "name": "写真術", "num":0 }, "psychoAnalysis": { "name": "精神分析", "num":0 }, "tracking": { "name": "追跡", "num":0 }, "climbing": { "name": "登攀", "num":0 }, "library": { "name": "図書館", "num":0 }, "aim": { "name": "目星", "num":0 } }, "actionArts": { "driving": { "name": "運転", "num":0 }, "repairingMachine": { "name": "機械修理", "num":0 }, "operatingHeavyMachine": { "name": "重機械操作", "num":0 }, "ridingHorse": { "name": "乗馬", "num":0 }, "swimming": { "name": "水泳", "num":0 }, "creating": { "name": "製作", "num":0 }, "control": { "name": "操縦", "num":0 }, "jumping": { "name": "跳躍", "num":0 }, "repairingElectric": { "name": "電気修理", "num":0 }, "navigate": { "name": "ナビゲート", "num":0 }, "disguise": { "name": "変装", "num":0 } }, "negotiationArts": { "winOver": { "name": "言いくるめ", "num":0 }, "credit": { "name": "信用", "num":0 }, "haggle": { "name": "値切り", "num":0 }, "argue": { "name": "説得", "num":0 }, "nativeLanguage": { "name": "母国語", "num":0 } }, "knowledgeArts": { "medicine": { "name": "医学", "num":0 }, "occult": { "name": "オカルト", "num":0 }, "chemistry": { "name": "化学", "num":0 }, "cthulhuMythology": { "name": "クトゥルフ神話", "num":0 }, "art": { "name": "芸術", "num":0 }, "accounting": { "name": "経理", "num":0 }, "archeology": { "name": "考古学", "num":0 }, "computer": { "name": "コンピューター", "num":0 }, "psychology": { "name": "心理学", "num":0 }, "anthropology": { "name": "人類学", "num":0 }, "biology": { "name": "生物学", "num":0 }, "geology": { "name": "地質学", "num":0 }, "electronicEngineering": { "name": "電子工学", "num":0 }, "astronomy": { "name": "天文学", "num":0 }, "naturalHistory": { "name": "博物学", "num":0 }, "physics": { "name": "物理学", "num":0 }, "law": { "name": "法律", "num":0 }, "pharmacy": { "name": "薬学", "num":0 }, "history": { "name": "歴史", "num":0 } } } }

function createColors(span) {
    const gradation = (span, r1, g1, b1, r2, g2, b2) => {
        const rd = (r2 - r1) / span;
        const gd = (g2 - g1) / span;
        const bd = (b2 - b1) / span;
        let cs = [];
        for (let i = 0; i < span; i++) {
            const r = r1 + i * rd;
            const g = g1 + i * gd;
            const b = b1 + i * bd;
            cs.push('rgba(' + r + ', ' + g + ', ' + b + ', 0.2)');
        }
        return cs;
    }
    let colors = [];
    gradation(span, 255, 0, 0, 255, 69, 0).forEach((item) => colors.push(item));
    gradation(span, 255, 69, 0, 255, 255, 0).forEach((item) => colors.push(item));
    gradation(span, 255, 255, 0, 0, 128, 0).forEach((item) => colors.push(item));
    gradation(span, 0, 128, 0, 0, 0, 255).forEach((item) => colors.push(item));
    gradation(span, 0, 0, 255, 75, 0, 130).forEach((item) => colors.push(item));
    gradation(span, 75, 0, 130, 238, 130, 238).forEach((item) => colors.push(item));
    gradation(span, 238, 130, 238, 255, 0, 0).forEach((item) => colors.push(item));
    return colors;
}

const colors = createColors(10);

function includeId(queryParams, playerId) {
  const params = queryString.parse(queryParams.search);
  // idは0から始まり、URLの数だけ数値が増加する
  for (let j = 0; j < 100000; j++) {
    const key = "id" + j;
    if (key in params) {
      const v = params[key];
      if (playerId === v) return true;
      continue;
    }
    // ここに到達するということはidNの数値を超過したということ
    // よって後続のインデックスのidをチェックする必要はない
    return false;
  }
  return false;
}

class PCRadar extends React.Component {
  constructor(props) {
    super(props);
  }

  // componentDidMount() {
  //   return fetch(indexDataUrl)
  //     .then((resp) => resp.json())
  //     .then((json) => {
  //       json.filter((player) => {
  //         return 0 <= player.tags.indexOf(this.state.tag) 
  //           || player.id === this.state.playerId
  //           // || includeId(this.state.params, player.id)
  //       })
  //       .forEach((player) => {
  //         const url = `${rootUrl}/${player.id}.json`;
  //         fetch(url)
  //           .then((resp) => resp.json())
  //           .then((player) => {
  //             this.setState({
  //               playersLoaded: true,
  //               players: this.state.players.concat([player]),
  //             });
  //           })
  //           .catch((err) => console.error(err));
  //       });
  //     })
  //     .catch((err) => console.error(err));
  // }

  createChartData = (json, genres, fields) => {
    // 凡例を追加
    const labels = [];
    const pc = templatePlayerData;
    for (let genre of genres) {
      for (let field of fields) {
        if ((genre in pc.param) && (field in pc.param[genre])) {
          let label = pc.param[genre][field].name;
          labels.push(label);
        }
      }
    }

    if (json.length <= 0) {
      return {labels: labels, datasets: []};
    }

    const colorInterval = Math.floor(colors.length / json.length);
    const datasets = [];
    let i = 0;
    for (let pc of json) {
      // 能力値、戦闘技能〜とかのをループ
      let data = [];
      for (let genre of genres) {
        for (let field of fields) {
          if ((genre in pc.param) && (field in pc.param[genre])) {
            let num = pc.param[genre][field].num;
            data.push(num);
          }
        }
      }
      const n = i * colorInterval;
      let d = {
        label: pc.name,
        data: data,
        backgroundColor: colors[n],
        borderColor: colors[n].replace("0.2", "0.3"), // FIXME 力技すぎる
        borderWidth: 2
      }
      i++;
      if (colors.length <= i) {
        i = 0;
      }
      datasets.push(d);
    }

    return {labels: labels, datasets: datasets}
  }

  render() {
    const json = this.props.players;
    const abilityData = this.createChartData(json, ["ability"], abilityFields);

    const artsData = this.createChartData(json, [
      "battleArts",
      "findArts",
      "actionArts",
      "negotiationArts",
      "knowledgeArts"], artsFields);
    const battleData = this.createChartData(json, ["battleArts"], battleFields);
    const findData = this.createChartData(json, ["findArts"], findFields);
    const actionData = this.createChartData(json, ["actionArts"], actionFields);
    const negotiationData = this.createChartData(json, ["negotiationArts"], negotiationFields);
    const knowledgeData = this.createChartData(json, ["knowledgeArts"], knowledgeFields);

    const circleOptions = {
      scale: {
          ticks: {
              beginAtZero: true,
              min: 0,
              max: 20
          }
      }
    };
    const barOptions = {
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero: true,
                    min: 0,
                    max: 100
                }
            }]
        }
    };

    const graphs = [
      <RadarGraph key="1" title="能力値" data={abilityData} options={circleOptions} />,
      <BarGraph key="2" title="全技能" data={artsData} options={barOptions} />,
      <BarGraph key="3" title="戦闘技能" data={battleData} options={barOptions} />,
      <BarGraph key="4" title="探索技能" data={findData} options={barOptions} />,
      <BarGraph key="5" title="行動技能" data={actionData} options={barOptions} />,
      <BarGraph key="6" title="交渉技能" data={negotiationData} options={barOptions} />,
      <BarGraph key="7" title="知識技能" data={knowledgeData} options={barOptions} />,
    ];

    return (
      <div className="Radar">
        {graphs}
      </div>
    );
  }
}

class RadarGraph extends React.Component {
  render() {
    return (
      <div className="board">
        <h2>{this.props.title}</h2>
        <Radar data={this.props.data} options={this.props.options} />
      </div>
    );
  }
}

class BarGraph extends React.Component {
  render() {
    return (
      <div className="board">
        <h2>{this.props.title}</h2>
        <Bar data={this.props.data} options={this.props.options} />
      </div>
    );
  }
}

export default PCRadar;
