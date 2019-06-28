<template>
  <div id="container">
    <a-form
      id="components-form-demo-normal-login"
      :form="form"
      class="login-form"
      @submit="handleSubmit"
    >
      <a-form-item>
        <a-input
          v-decorator="[
          'userName',
          { rules: [{ required: true, message: 'Please input your username!' }] }
        ]"
          placeholder="Username"
        >
          <a-icon slot="prefix" type="user" style="color: rgba(0,0,0,.25)"/>
        </a-input>
      </a-form-item>
      <a-form-item>
        <a-input
          v-decorator="[
          'password',
          { rules: [{ required: true, message: 'Please input your Password!' }] }
        ]"
          type="password"
          placeholder="Password"
        >
          <a-icon slot="prefix" type="lock" style="color: rgba(0,0,0,.25)"/>
        </a-input>
      </a-form-item>
      <a-form-item>
        <a-checkbox
          v-decorator="[
          'remember',
          {
            valuePropName: 'checked',
            initialValue: true,
          }
        ]"
        >Remember me</a-checkbox>
        <a class="login-form-forgot" href>Forgot password</a>
        <a-button type="primary" html-type="submit" class="login-form-button">Log in</a-button>Or
        <a href>register now!</a>
      </a-form-item>
    </a-form>
  </div>
</template>

<script>
import { mapMutations } from 'Vuex';
import Cookie from "js-cookie";

export default {
  middleware: "notAuthenticated",
  beforeCreate() {
    this.form = this.$form.createForm(this);
  },
  computed: {
    ...mapMutations({
      setAuthenticationToken: 'user/AUTH'
    })
  },
  methods: {
    handleSubmit(e) {
      e.preventDefault();
      this.form.validateFields((err, values) => {
        if (!err) {
          console.log("Received values of form: ", values);
          setTimeout(() => {
            const auth = {
              accessToken: "someStringGotFromApiServiceWithAjax"
            };
            console.log("hello world")
            this.$store.dispatch('user/setAuth', auth);
            Cookie.set("auth", auth); // sauver le jeton dans un cookie pour le rendu serveur
            this.$router.push("/");
          }, 1000);
        }
      });
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
#components-form-demo-normal-login .login-form-forgot {
  float: right;
}
#components-form-demo-normal-login .login-form-button {
  width: 100%;
}
</style>
