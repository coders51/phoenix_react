import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import css from './MainPage.scss';

import * as mainActions from '../../actions/mainActions';

class MainPage extends React.Component {

  render() {

    const { currentUser } = this.props;

    let loginButton = <div data-href='/auth/orbita' className={`partecipa-button`}>
      Accedi
    </div>;

    if (currentUser) {
      loginButton = <div>
        <div>
          {currentUser.email}
        </div>
        <div>
          <a href='/auth/logout'>
            Esci
          </a>
        </div>
      </div>;
    }

    return (
      <div className={css.container}>
        {loginButton}
      </div>
    );
  }
}

MainPage.propTypes = {
  dispatch: PropTypes.func.isRequired,
};

function select(state) {
  return {
  };
}

export default connect(select)(MainPage);
