import React from 'react';
import logo from './logo.svg';
import './App.css';

const indexDataUrl = "https://jiro4989.github.io/coc-radar/data/index.json"

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      searchWord: "",
      playersLoaded: false,
      players: [{
        id: "1111",
        name: "山本",
        tags: ["jiro", "saburo"],
        url: "https://hogefuga.tmp/"
      },{
        id: "1112",
        name: "田中",
        tags: ["shiro", "goro"],
        url: "https://hogefuga.tmp/2"
      }],
      languages: [ 'go', 'nim', 'python', 'bash', 'java'],
    };
  }

  componentDidMount() {
    return fetch(indexDataUrl)
      .then((resp) => resp.json())
      // .then((json) => console.log(json))
      .then((json) => {
        this.setState({
          playersLoaded: true,
          players: json
        })
      })
      .catch((err) => console.error(err));
  }

  render() {
    let list = [];
    if (this.state.playersLoaded) {
      for (let lang of this.state.languages) {
        list.push(<li>{lang}</li>)
      }
    }

    return (
      <div className="App">
        <header>
          <h1>coc-radar</h1>
        </header>
        <div className="main">
          <div className="row-area">
            <input type="text" className="user-input" value={this.state.searchWord} onChange={(e) => this.setState({searchWord: e.target.value})}></input>
            <div>
              <input type="button" className="user-input" value="表示"></input>
              <input type="button" className="user-input" value="選択全解除"></input>
            </div>
            <div>{this.state.searchWord}</div>
          </div>
          <div id="tagsArea" className="row-area"></div>
          <PlayerTable players={this.state.players} />
        </div>
        {/* <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <p>
            Edit <code>src/App.js</code> and save to reload.
          </p>
          <a
            className="App-link"
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Learn React
          </a>
        </header>
        <div>My favorite languages are below.</div>
        <ul>{list}</ul>
        <ol>{list}</ol> */}
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
