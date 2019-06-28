<template>
  <div id="container">
    <a-form :form="form" @submit="handleSubmit">
      <a-form-item v-bind="formItemLayout" label="E-mail">
        <a-input
          v-decorator="[
          'email',
          {
            rules: [{
              type: 'email', message: 'The input is not valid E-mail!',
            }, {
              required: true, message: 'Please input your E-mail!',
            }]
          }
        ]"
        />
      </a-form-item>
      <a-form-item v-bind="formItemLayout">
        <span slot="label">
          Pseudo&nbsp;
          <a-tooltip title="What do you want others to call you?">
            <a-icon type="question-circle-o"/>
          </a-tooltip>
        </span>
        <a-input
          v-decorator="[
          'pseudo',
          {
            rules: [{ required: true, message: 'Please input your pseudo!', whitespace: true }]
          }
        ]"
        />
      </a-form-item>
      <a-form-item v-bind="formItemLayout">
        <span slot="label">
          Username&nbsp;
          <a-tooltip title="What do you want others to call you? (Only alphanumeric characters)">
            <a-icon type="question-circle-o"/>
          </a-tooltip>
        </span>
        <a-input
          v-decorator="[
          'username',
          {
            rules: [{ required: true, message: 'Please input your username!', whitespace: true }]
          }, {
            validator: isAlphanumeric
          }
        ]"
        />
      </a-form-item>
      <a-form-item v-bind="formItemLayout" label="Password">
        <a-input
          v-decorator="[
          'password',
          {
            rules: [{
              required: true, message: 'Please input your password!',
            }, {
              validator: validateToNextPassword,
            }],
          }
        ]"
          type="password"
        />
      </a-form-item>
      <a-form-item v-bind="formItemLayout" label="Confirm Password">
        <a-input
          v-decorator="[
          'confirm',
          {
            rules: [{
              required: true, message: 'Please confirm your password!',
            }, {
              validator: compareToFirstPassword,
            }],
          }
        ]"
          type="password"
          @blur="handleConfirmBlur"
        />
      </a-form-item>
      <a-form-item v-bind="tailFormItemLayout">
        <a-button type="primary" html-type="submit">Register</a-button>
      </a-form-item>
    </a-form>
  </div>
</template>

<script>
export default {
  middleware: "notAuthenticated",
  data() {
    return {
      confirmDirty: false,
      autoCompleteResult: [],
      formItemLayout: {
        labelCol: {
          xs: { span: 24 },
          sm: { span: 8 }
        },
        wrapperCol: {
          xs: { span: 24 },
          sm: { span: 16 }
        }
      },
      tailFormItemLayout: {
        wrapperCol: {
          xs: {
            span: 24,
            offset: 0
          },
          sm: {
            span: 16,
            offset: 8
          }
        }
      }
    };
  },
  beforeCreate() {
    this.form = this.$form.createForm(this);
  },
  methods: {
    isAlphanumeric(rule, value, callback) {
      const form = this.form;
      if (
        value &&
        "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".indexOf(
          value
        ) > -1
      ) {
        form.validateFields(["confirm"], { force: true });
      }
      callback();
    },
    handleSubmit(e) {
      e.preventDefault();
      this.form.validateFieldsAndScroll((err, values) => {
        if (!err) {
          console.log("Received values of form: ", values);
          this.$axios.post("/api/user", values);
        }
      });
    },
    handleConfirmBlur(e) {
      const value = e.target.value;
      this.confirmDirty = this.confirmDirty || !!value;
    },
    compareToFirstPassword(rule, value, callback) {
      const form = this.form;
      if (value && value !== form.getFieldValue("password")) {
        callback("Two passwords that you enter is inconsistent!");
      } else {
        callback();
      }
    },
    validateToNextPassword(rule, value, callback) {
      const form = this.form;
      if (value && this.confirmDirty) {
        form.validateFields(["confirm"], { force: true });
      }
      callback();
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
