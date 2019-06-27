<template>
  <div id="container">
    <VideoPlayer/>
    <h1>video.title</h1>
  </div>
</template>

<script>
import VideoPlayer from "~/components/VideoPlayer.vue";
export default {
  components: {
    VideoPlayer
  }
};
</script>

<style lang="scss" scoped>
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
}
</style>
