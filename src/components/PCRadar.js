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
    if (json.length <= 0) {
      return {labels: [], datasets: []};
    }

    // 凡例を追加
    const labels = [];
    const pc = json[0];
    for (let genre of genres) {
      for (let field of fields) {
        if ((genre in pc.param) && (field in pc.param[genre])) {
          let label = pc.param[genre][field].name;
          labels.push(label);
        }
      }
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
