import { createApp } from 'vue'
import App from './App.vue'

const urlSearchParams = new URLSearchParams(window.location.search);
const params = Object.fromEntries(urlSearchParams.entries());

const { u } = params 

window.transactionManager = createApp(App, {  userGuid: u }).mount('#app')
