import { combineReducers } from 'redux';
import mainReducer from './mainReducer';

import { initialState as mainState } from './mainReducer';

export default combineReducers({
  main: mainReducer,
});

export const initialStates = {
  mainState,
};
