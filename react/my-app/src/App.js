import React from 'react';
import logo from './logo.svg';
import './App.css';

const indexDataUrl = "https://jiro4989.github.io/coc-radar/data/index.json"

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      playersLoaded: false,
      players: [{
        id: "",
        name: "",
        tags: [],
        url: ""
      }],
      filteredPlayers: [],
    };
  }

  componentDidMount() {
    return fetch(indexDataUrl)
      .then((resp) => resp.json())
      // .then((json) => console.log(json))
      .then((json) => {
        this.setState({
          playersLoaded: true,
          players: json,
          filteredPlayers: json,
        })
      })
      .catch((err) => console.error(err));
  }

  filterPlayers = (event) => {
    const val = event.target.value;
    const filtered = this.state.players.filter((p) => {
      // タグの名称、あるいは探索者の名前に一致すればtrue
      if (val === "") return true;
      for (let tag of p.tags) {
        if (tag.includes(val)) return true;
      }
      if (p.name.includes(val)) return true;
      return false;
    });
    this.setState({filteredPlayers: filtered});
  }

  render() {
    return (
      <div className="App">
        <header>
          <h1>coc-radar</h1>
        </header>
        <div className="main">
          <div className="row-area">
            <input type="text" className="user-input" onChange={this.filterPlayers}></input>
            <div>
              <input type="button" className="user-input" value="表示"></input>
              <input type="button" className="user-input" value="選択全解除"></input>
            </div>
          </div>
          <div id="tagsArea" className="row-area"></div>
          <PlayerTable players={this.state.filteredPlayers} />
        </div>
      </div>
    );
  }
}

class PlayerTable extends React.Component {
  render() {
    const rows = this.props.players.map((p) => {
      // チェックボックスの生成
      const checkBox = <td>
        <input type="checkbox" value={p.id}></input>
      </td>;

      // タグを生成
      const tags = Object.keys(p.tags).map((index) => {
        const tag = p.tags[index];
        const key = p.id + "_" + tag;
        const url = "radar.html?tag=" + encodeURI(tag);
        return <td key={key}><span>
          <a href={url}>{tag}</a>
          <input type="button" value="検索" className="tag-button"></input>
        </span></td>
      });

      // 探索者を生成
      const pcRadarUrl = "radar.html?id0=" + p.id;
      const name = <td>
        <a href={pcRadarUrl}>{p.name}</a>
      </td>

      // キャラクター保管所のURLを生成
      const url = <td>
        <a href={p.url}>
          保管所
        </a>
        </td>

      return <tr key={p.id}>{checkBox}{tags}{name}{url}</tr>
    });

    return (
      <table>
        <thead>
          <tr>
            <th>選択</th>
            <th>タグ</th>
            <th>探索者名</th>
            <th>キャラクター保管所</th>
          </tr>
        </thead>
        <tbody>
          {rows}
        </tbody>
      </table>
    );
  }
}

export default App;
