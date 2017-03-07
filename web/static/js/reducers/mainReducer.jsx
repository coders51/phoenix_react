import { ACTION, } from '../actions/mainActions';

export const initialState = {
};

export default function mainReducer(state = initialState, action) {
  const { type } = action;
  switch (type) {

    case ACTION: {
      return state;
    }

    default: {
      return state;
    }
  }
}
