import React from 'react'

class Footer extends React.Component {
    render() {
        return (
          <footer>
            <p>「クトゥルフ神話TRPG」は<a href="http://www.chaosium.com/">ケイオシアム社</a>の著作物です。</p>
            <p>
              &copy; 次郎 (2019) <a href="https://twitter.com/jiro_saburomaru">&#064;jiro_saburomaru</a>
              ソースコード <a href="https://github.com/jiro4989/coc-radar">GitHub - jiro4989/coc-radar</a>
              レーダー出力対象の追加の要望は<a href="https://github.com/jiro4989/coc-radar/issues">こちら</a>。
            </p>
          </footer>
        );
    }
}

export default Footer;