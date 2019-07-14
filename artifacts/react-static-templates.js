

import React from 'react'
import universal, { setHasBabelPlugin } from '/home/jiro4989/src/github.com/jiro4989/coc-radar/node_modules/react-universal-component/dist/index.js'

setHasBabelPlugin()

const universalOptions = {
  loading: () => null,
  error: props => {
    console.error(props.error);
    return <div>An error occurred loading this page's template. More information is available in the console.</div>;
  },
  ignoreBabelRename: true
}

const t_0 = universal(import('../node_modules/react-static/lib/browser/components/Default404'), universalOptions)
      t_0.template = '../node_modules/react-static/lib/browser/components/Default404'
      
const t_1 = universal(import('../src/App.js'), universalOptions)
      t_1.template = '../src/App.js'
      
const t_2 = universal(import('../src/components/Footer.js'), universalOptions)
      t_2.template = '../src/components/Footer.js'
      
const t_3 = universal(import('../src/components/Header.js'), universalOptions)
      t_3.template = '../src/components/Header.js'
      
const t_4 = universal(import('../src/components/RadarPage.js'), universalOptions)
      t_4.template = '../src/components/RadarPage.js'
      
const t_5 = universal(import('../src/index.js'), universalOptions)
      t_5.template = '../src/index.js'
      
const t_6 = universal(import('../src/serviceWorker.js'), universalOptions)
      t_6.template = '../src/serviceWorker.js'
      

// Template Map
export default {
  '../node_modules/react-static/lib/browser/components/Default404': t_0,
'../src/App.js': t_1,
'../src/components/Footer.js': t_2,
'../src/components/Header.js': t_3,
'../src/components/RadarPage.js': t_4,
'../src/index.js': t_5,
'../src/serviceWorker.js': t_6
}
// Not Found Template
export const notFoundTemplate = "../node_modules/react-static/lib/browser/components/Default404"

