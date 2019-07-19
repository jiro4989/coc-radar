import { shallow, mount, render } from 'enzyme';
import React from 'react';
import App from "../App";
import Header from "../components/Header";
import Footer from "../components/Footer";
import PCRadar from '../components/PCRadar';

test('子コンポーネントが存在すること', () => {
    const wrapper = shallow(<App />);
  
    expect(wrapper.find(Header).length).toBe(1);
    expect(wrapper.find(Footer).length).toBe(1);
    expect(wrapper.find(PCRadar).length).toBe(1);

    // wrapper.setState({
    //   searchWord: 'jiro',
    // });

    // expect(wrapper.find(".user-text-input")[0].value).toBe("jiro");
  });