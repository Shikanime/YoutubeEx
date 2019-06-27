<template>
  <a-card hoverable id="card">
    <img
      alt="example"
      src="https://gw.alipayobjects.com/zos/rmsportal/JiqGstEfoWAOHiTxclqi.png"
      slot="cover"
    >
    <a-card-meta :title="video.title" :description="`${video.views} views`">
    </a-card-meta>
  </a-card>
</template>

<script>
export default {
  props: [
    "video"
  ]
}
</script>
<style scoped>
#card {
  margin: 2vh 1vw;
}
</style>
