import React from 'react';
import ReactDOM from 'react-dom';
import './css/index.css';
import App from './App';
import RadarPage from './RadarPage';
import * as serviceWorker from './serviceWorker';

import { BrowserRouter, Route, Link } from 'react-router-dom'

class Index extends React.Component {
  render() {
    return <BrowserRouter>
      <div>
        <Route exact path='/' component={App} />
        <Route path='/players/' component={RadarPage} />
        <Route path='/players/:id' component={RadarPage} />
        <Route path='/tags/:tag' component={RadarPage} />
      </div>
    </BrowserRouter>
  }
}

export default Index

ReactDOM.render(<Index />, document.getElementById('root'));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
