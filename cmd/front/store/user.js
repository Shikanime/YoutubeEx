const LOGIN = "LOGIN";
const LOGIN_SUCCESS = "LOGIN_SUCCESS";
const LOGOUT = "LOGOUT";
const AUTH = "AUTH";

export const state = () => {
  return {
    isLoggedIn: false,
    pending: false,
    auth: null
  };
};

export const mutations = {
  [AUTH](state, value) {
    state.auth = value;
    state.isLoggedIn = true;
  },
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
  setAuth({state, commit}, auth) {
    commit(AUTH, auth);
  },
  logout({ commit }) {
    // localStorage.removeItem("user-token");
    commit(LOGOUT);
  },
  nuxtServerInit({ commit }, { req }) {
    let accessToken = null;
    if (req.headers.cookie) {
      var parsed = cookieparser.parse(req.headers.cookie);
      accessToken = JSON.parse(parsed.auth);
    }
    commit(AUTH, accessToken);
  }
};

export const getters = {
  isLoggedIn(state) {
    return state.isLoggedIn;
  }
};
