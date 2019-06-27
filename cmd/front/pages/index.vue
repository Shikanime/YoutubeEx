<template>
  <div class="container">
    <VideoList/>
  </div>
</template>

<script>
import VideoList from "~/components/VideoList.vue";

export default {
  components: {
    VideoList
  }
};
</script>
<style>
.container {
  margin: 5vh 5vw;
}
</style>
