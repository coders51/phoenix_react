import React from 'react';
import ReactDom from 'react-dom';
import { Provider } from 'react-redux';
import { createStore, applyMiddleware, compose } from 'redux';
import thunk from 'redux-thunk';
import combinedReducer from '../reducers';
import { initialStates } from '../reducers';
import MainPage from '../components/mainPage/MainPage';

export default class PhoenixReactContainer extends React.Component {

  render() {
    const { route } = this.props;

    const composedStore = compose(
        applyMiddleware(thunk),
    );

    const initialState = {
      main: {
      },
    };

    const storeCreator = composedStore(createStore);
    const store = storeCreator(combinedReducer, initialState);

    return (
      <Provider store={ store }>
        <MainPage {...this.props}/>
      </Provider>
    );
  }
}
