const LOGIN = "LOGIN";
const LOGIN_SUCCESS = "LOGIN_SUCCESS";
const LOGOUT = "LOGOUT";

export const state = () => {
  return {
    isLoggedIn: true,
    pending: false
  }
}

export const mutations = {
  [LOGIN](state) {
    state.pending = true;
  },
  [LOGIN_SUCCESS](state) {
    state.isLoggedIn = true;
    state.pending = false;
  },
  [LOGOUT](state) {
    state.isLoggedIn = false;
  }
};

export const actions = {
  login({ state, commit, rootState }, creds) {
    console.log("login...", creds);
    commit(LOGIN);
    return new Promise(resolve => {
      setTimeout(() => {
        // localStorage.setItem("user-token", "JWT");
        commit(LOGIN_SUCCESS);
        resolve();
      }, 1000);
    });
  },
  logout({ commit }) {
    // localStorage.removeItem("user-token");
    commit(LOGOUT);
  },
  nuxtServerInit({ dispatch }) {
    return dispatch("user/isLoggedIn");
  }
};

export const getters = {
  isLoggedIn(state) {
    return state.isLoggedIn;
  }
};
