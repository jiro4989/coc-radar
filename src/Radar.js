import React from 'react';
import './css/App.css';
import Header from './Header';
import Footer from './Footer';

const rootUrl = "https://jiro4989.github.io/coc-radar/data"
const indexDataUrl = `${rootUrl}/index.json`

class Radar extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      tag: props.match.params.tag,
      players: [],
    };
  }

  componentDidMount() {
    return fetch(indexDataUrl)
      .then((resp) => resp.json())
      .then((json) => {
        json.filter((player) => 0 <= player.tags.indexOf(this.state.tag))
            .forEach((player) => {
              const url = `${rootUrl}/${player.id}.json`;
              fetch(url)
                .then((resp) => resp.json())
                .then((player) => {
                  this.setState({
                    players: this.state.players.concat([player]),
                  });
                })
                .catch((err) => console.error(err));
            });
      })
      .catch((err) => console.error(err));
  }

  render() {
    const tmpP = this.state.players.map((p) => <div key={p.id}>{p.name}</div>)
    return (
      <div className="Radar">
        <div className="left"></div>
        <div className="center">
          <Header />
          <div className="main">
            {this.props.match.params.tag}
            {tmpP}
            <div className="board">
              <canvas id="abilityChart"></canvas>
            </div>
          </div>
          <Footer />
        </div>
        <div className="right"></div>
      </div>
    );
  }
}

export default Radar;
