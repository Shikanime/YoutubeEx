<template>
  <a-list
    :grid="{ gutter: 16, column: 4 }"
    :dataSource="getVideos"
  >
    <a-list-item slot="renderItem" slot-scope="item">
      <nuxt-link :to="`/video/${item.id}`"><Card :video="item"/></nuxt-link>
    </a-list-item>
  </a-list>

  <!-- <a-row type="flex">
    <a-col v-for="video in getVideos" :key="video.id" :span="6">
      <nuxt-link to="/{video.id}"><Card/></nuxt-link>
    </a-col>
  </a-row> -->
</template>

<script>
import { mapGetters } from "vuex";

import Card from "~/components/Card.vue";

export default {
  components: {
    Card
  },
  computed: {
    ...mapGetters({
      getVideos: 'video/getVideos'
    })
  }
};
</script>
