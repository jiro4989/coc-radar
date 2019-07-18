import { shallow, mount, render } from 'enzyme';

test('子コンポーネントが存在すること', () => {
    const wrapper = shallow(<App />);
  
    expect(wrapper.find(Header).length).toBe(1);
    expect(wrapper.find(Footer).length).toBe(1);
    expect(wrapper.find(Input).length).toBe(2);
    expect(wrapper.find(Table).length).toBe(2);

    wrapper.setState({
      searchWord: 'jiro',
    });

    expect(wrapper.find(".user-text-input")[0].value).toBe("jiro");
  });