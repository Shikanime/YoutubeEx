<template>
  <div>
    <a-menu mode="horizontal">
      <a-menu-item key="video-camera">
        <router-link to="/">
          <a-icon type="video-camera"/>MyYouTube
        </router-link>
      </a-menu-item>
      <a-sub-menu>
        <span slot="title" class="submenu-title-wrapper">
          <a-icon type="user"/>Account
        </span>
        <a-menu-item v-if="!this.$store.state.user.isLoggedIn" key="setting:1">
          <router-link to="login">
            <a-icon type="login"/>Login
          </router-link>
        </a-menu-item>
        <a-menu-item v-if="!this.$store.state.user.isLoggedIn" key="setting:3">
          <router-link to="signup">
            <a-icon type="form"/>Sign Up
          </router-link>
        </a-menu-item>
        <a-menu-item v-if="this.$store.state.user.isLoggedIn" key="setting:2" @click="userLogout">
          <a-icon type="logout"/>Log Out
        </a-menu-item>
        <a-menu-item v-if="this.$store.state.user.isLoggedIn" key="setting:4">
          <router-link to="profile">
            <a-icon type="setting"/>My Profile
          </router-link>
        </a-menu-item>
        <a-menu-item v-if="this.$store.state.user.isLoggedIn" key="setting:5">
          <router-link to="upload">
            <a-icon type="cloud-upload"/>Upload
          </router-link>
        </a-menu-item>
      </a-sub-menu>
    </a-menu>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  computed: {
    ...mapGetters({
      isLoggedIn: "user/isLoggedIn"
    })
  },
  methods: {
    userLogout() {
      this.$notification.open({
        message: "Disconnecting",
        description: "Logging out in 2 seconds",
        onClick: () => {
          console.log("Notification Clicked!");
        }
      });
      this.$store.commit("user/logout");
    },
  }
};
</script>
