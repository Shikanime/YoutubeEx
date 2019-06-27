export const state = () => {
  return {
    videos: [
      {
        id: 1,
        title: "Video 1",
        views: 500
      },
      {
        id: 2,
        title: "Video 2",
        views: 500
      },
      {
        id: 3,
        title: "Video 3",
        views: 500
      },
      {
        id: 4,
        title: "Video 4",
        views: 500
      },
      {
        id: 5,
        title: "Video 5",
        views: 500
      }
    ]
  };
};

export const mutations = {};

export const actions = {
  nuxtServerInit({ dispatch }) {
    return dispatch("video/getVideos");
  }
};

export const getters = {
  getVideos(state) {
    return state.videos;
  }
};
