import React from 'react';
import './css/App.css';
import Header from './components/Header';
import Footer from './components/Footer';
import PCRadar from './components/PCRadar';
import queryString from 'query-string';

const rootUrl = "https://jiro4989.github.io/coc-radar"
const apiRootUrl = `${rootUrl}/data`
const indexDataUrl = `${apiRootUrl}/index.json`

function parseQueryIds(params) {
  // idは0から始まり、URLの数だけ数値が増加する
  let ids = [];
  for (let j = 0; j < 100000; j++) {
    const key = "id" + j;
    if (key in params) {
      const v = params[key];
      ids.push(v);
      continue;
    }
    // ここに到達するということはidNの数値を超過したということ
    // よって後続のインデックスのidをチェックする必要はない
    return ids;
  }
  return ids;
}

class App extends React.Component {
  constructor(props) {
    super(props);
    const queryParam = queryString.parse(props.location.search);
    let queryTag = "";
    if (queryParam["tag"]) {
      queryTag = queryParam["tag"];
    }
    const queryIds = parseQueryIds(queryParam);

    this.state = {
      queryTag: queryTag,
      queryIds: queryIds,
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
      searchWord: "",
      radarPlayers: [],
    };
  }

  // 一覧ファイルのリクエスト
  componentDidMount() {
    fetch(indexDataUrl)
      .then((resp) => resp.json())
      .then((json) => {
        const players = this.addChecked(json);
        this.setState({
          playersLoaded: true,
          players: players,
          filteredPlayers: players,
          tags: this.filterTags(players),
        })

        // データ一覧が揃ったらtagの情報を取得
        const tag = this.state.queryTag;
        if (tag !== "") {
          const players = this.state.players
            .filter((p) => p.tags.includes(tag))
            .map((p) => {p.checked = true; return p})
          this.setState({players: players});
          this.switchSelected(-1, false);
          return;
        }

        // IDが載っていたら追加
        const ids = this.state.queryIds;
        if (0 < ids.length) {
          // this.state.players
          //   .filter((p) => 0 <= ids.indexOf(p.id))
          //   .forEach((p) => this.switchSelected(p.id, true));
          return;
        }
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
    this.setState({searchWord: val});
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

  switchSelected = (id, checked) => {
    const copyPlyaers = this.state.players.slice();
    for (let pc of copyPlyaers) {
      if (pc.id === id) {
        pc.checked = checked;
        break;
      }
    }
    this.setState({players: copyPlyaers});

    // マッチしたIDのみ、すでに登録されている探索者一覧から絞り込む
    // すでに画面に描画されているデータなので再度リクエストする必要はない
    const currentSelectedIds = this.state.players.filter((p) => p.checked).map((p) => p.id);
    const players = this.state.radarPlayers.filter((p) => 0 <= currentSelectedIds.indexOf(p.id));
    this.setState({radarPlayers: players});

    // 逆に、存在しなかったものだけAPIリクエストする
    const newIds = currentSelectedIds.filter((id) => players.map((p) => p.id).indexOf(id) < 0);
    newIds.forEach((id) => {
      fetch(`${apiRootUrl}/${id}.json`)
        .then((resp) => resp.json())
        .then((player) => this.setState({radarPlayers: this.state.radarPlayers.concat(player)}))
        .catch((err) => console.error(err));
    });
  }

  clearSelected = (__) => {
    const players = this.state.players.map((player) => {
      player.checked = false;
      return player;
    });
    this.setState({players: players});
    this.switchSelected(-1, false);
  }

  updateSearchWord = (val) => {
    this.setState({searchWord: val});
    this.filterPlayers({target: {value: val}})
  }

  render() {
    return (
      <div className="App">
        <Header />
        <div className="main">
          <div className="center">
            <div className="parent">
              <h2>検索</h2>
              <div className="left">
                <div className="row-area">
                  <input
                    type="text"
                    className="user-text-input user-input"
                    value={this.state.searchWord}
                    onChange={this.filterPlayers}
                    placeholder="タグ、あるいは探索者名で検索"
                    />
                  <div>
                    <input type="button" className="user-input" value="選択全解除" onClick={this.clearSelected}></input>
                  </div>
                </div>
                <Tags tags={this.state.tags} updateSearchWord={this.updateSearchWord} />
                <PlayerTable
                  players={this.state.filteredPlayers}
                  switchSelected={this.switchSelected}
                  updateSearchWord={this.updateSearchWord}
                  />
              </div>
            </div>
            <div className="parent">
              <h2>グラフ</h2>
              <div className="right">
                <PCRadar players={this.state.radarPlayers} />
              </div>
            </div>
          </div>
        </div>
        <Footer />
      </div>
    );
  }
}

class Tags extends React.Component {
  render() {
    const tags = this.props.tags.map((tag) => {
      return (<Tag key={tag} tag={tag} updateSearchWord={this.props.updateSearchWord} />)
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
    return (
      <span className="tag">
        <a href="javascript:void(0)" onClick={() => { this.props.updateSearchWord(tag); return false; }}>{tag}</a>
      </span>
    );
  }
}

class PlayerTable extends React.Component {
  render() {
    const rows = this.props.players.map((p) => {
      // チェックボックスの生成
      const checkBox = <input
          type="checkbox"
          value={p.id}
          checked={p.checked}
          onChange={() => this.props.switchSelected(p.id, !p.checked)}
          >
        </input>

      // タグを生成
      const tags = p.tags.map((tag) => {
        const key = p.id + "_" + tag;
        return <Tag key={key} tag={tag} updateSearchWord={this.props.updateSearchWord} />
      });

      // 探索者を生成
      const name = <a href={p.url}>{p.name}</a>

      return (
        <tr key={p.id}>
          <td>{checkBox}</td>
          <td>{tags}</td>
          <td>{name}</td>
        </tr>
      )
    });

    return (
      <table>
        <thead>
          <tr>
            <th>選択</th>
            <th>タグ</th>
            <th>探索者名</th>
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
