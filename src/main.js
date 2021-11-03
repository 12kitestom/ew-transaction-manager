import Vue from 'vue'
import App from './App.vue'

Vue.config.productionTip = false

const urlSearchParams = new URLSearchParams(window.location.search);
const params = Object.fromEntries(urlSearchParams.entries());

const { u } = params

window.transactionManager = new Vue({
  render: h => h(App, {
    props: {
      userGuid: u
    }
  }),
}).$mount('#app')
