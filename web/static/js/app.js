import React from 'react';
import ReactDOM from 'react-dom';
import PhoenixReactContainer from './containers/PhoenixReactContainer';

if (document.getElementById('content')) {
  var App = React.createFactory(PhoenixReactContainer);

  ReactDOM.render(
    App(window.APP_PROPS),
    document.getElementById('content'));
}
