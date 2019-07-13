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
        checked: false,
        id: "",
        name: "",
        tags: [],
        url: ""
      }],
      filteredPlayers: [],
      tags: [],
    };
  }

  componentDidMount() {
    return fetch(indexDataUrl)
      .then((resp) => resp.json())
      .then((json) => {
        const players = this.addChecked(json);
        this.setState({
          playersLoaded: true,
          players: players,
          filteredPlayers: players,
          tags: this.filterTags(players),
        })
      })
      .catch((err) => console.error(err));
  }

  addChecked = (players) => {
    return players.map((player) => {
      player.checked = false;
      return player;
    })
  }

  filterTags = (players) => {
    // ハッシュマップに追加することで重複を除外
    let tagMap = {};
    players.forEach((player) => {
      player.tags.forEach((tag) => {
        tagMap[tag] = 1;
      });
    });
    return Object.keys(tagMap);
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

  switchSelected = (index, checked) => {
    const copyPlyaers = this.state.players.slice();
    copyPlyaers[index].checked = checked;
    this.setState({players: copyPlyaers});
  }

  clearSelected = (__) => {
    const players = this.state.players.map((player, index) => {
      player.checked = false;
      return player;
    });
    this.setState({players: players});
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
              <input type="button" className="user-input" value="選択全解除" onClick={this.clearSelected}></input>
            </div>
          </div>
          <Tags tags={this.state.tags} />
          <PlayerTable
            players={this.state.filteredPlayers}
            switchSelected={this.switchSelected}
            />
        </div>
      </div>
    );
  }
}

class Tags extends React.Component {
  render() {
    const tags = this.props.tags.map((tag) => {
      return (<Tag key={tag} tag={tag} />)
    });
    return (
      <div className="row-area">
        {tags}
      </div>
    );
  }
}

class Tag extends React.Component {
  render() {
    const tag = this.props.tag;
    const url = "radar.html?tag=" + encodeURI(tag);
    return (
      <span>
        <a href={url}>{tag}</a>
        <input type="button" value="検索" className="tag-button"></input>
      </span>
    );
  }
}

class PlayerTable extends React.Component {
  render() {
    const rows = this.props.players.map((p, pIndex) => {
      // チェックボックスの生成
      const checkBox = <td>
        <input
          type="checkbox"
          value={p.id}
          checked={p.checked}
          onChange={() => this.props.switchSelected(pIndex, !p.checked)}
          >
        </input>
      </td>;

      // タグを生成
      const tags = p.tags.map((tag) => {
        const key = p.id + "_" + tag;
        return <td key={key}><Tag tag={tag} /></td>
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
