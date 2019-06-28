<template>
  <div id="container">
    <h1>Upload your video here</h1>
    <a-upload
      name="file"
      :multiple="true"
      action="https://www.mocky.io/v2/5cc8019d300000980a055e76"
      :headers="headers"
      @change="handleChange"
    >
      <a-button>
        <a-icon type="upload"/>Click to Upload
      </a-button>
    </a-upload>
  </div>
</template>

<script>
export default {
  middleware: "authenticated",
  data() {
    return {
      headers: {
        authorization: "authorization-text"
      }
    };
  },
  methods: {
    handleChange(info) {
      if (info.file.status !== "uploading") {
        console.log(info.file, info.fileList);
      }
      if (info.file.status === "done") {
        this.$message.success(`${info.file.name} file uploaded successfully`);
      } else if (info.file.status === "error") {
        this.$message.error(`${info.file.name} file upload failed.`);
      }
    }
  }
};
</script>

<style scoped>
#container {
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
  height: 100vh;
}
</style>
