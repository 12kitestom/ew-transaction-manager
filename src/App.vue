<template>
  <div id="app" class="container">
    <div v-if="!isLoading">
      <UserSummary :balanceData="balanceData" />
      <PointsAdjustment @adjust="adjustBalance"/>
      <TransactionTable :userGuid="sampleUser"/>
    </div>
    <div v-else>
      <div v-if="isLoading" class="col-12">
        <div class="my-5">
          <div class="d-flex justify-content-center py-5">
            <div class="spinner-border text-secondary" role="status">
              <span class="visually-hidden">Loading...</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import PointsAdjustment from './components/PointsAdjustment.vue';
import TransactionTable from './components/TransactionTable.vue';
import UserSummary from './components/UserSummary.vue';


const urlBase = process.env.VUE_APP_TRANSACTION_MANAGER_API_BASE; //eslint-disable-line

if (process.env.VUE_APP_API_MODE == "dev") {
  let token = process.env.VUE_APP_DEV_TOKEN;
  if (token) {
    //Can't enable dev mode without a token to use
    window.ew.dev.enableAjaxDev(token);
  }
}

export default {
  name: 'App',
  components:  {UserSummary, TransactionTable, PointsAdjustment },
  data() {
    return {
      sampleUser: 'lstTYg9nEApvgh7e',
      isLoading: true,
      balanceData: {},
      statementData: {}
    }
  },
  async created() {
    await this.loadUserBalance()
    this.loadUserStatement()

    this.isLoading = false
  },
  methods: {
    loadUserBalance: async function() {
      let userGuid = this.sampleUser
      const res = await window.ew.ajax.getRequest(`${urlBase}/user/${userGuid}/balance`);

      if (res.success) {
        this.balanceData = res.data
      } else {
        alert("Error fetching balance data. Please try again.");
      }
    },
    loadUserStatement: async function() {
      let userGuid = this.sampleUser
      const res = await window.ew.ajax.getRequest(`${urlBase}/user/${userGuid}/transactions`);

      if (res.success) {
        this.statementData = res.data
      } else {
        alert("Error fetching statement data. Please try again.");
      }
    },
    adjustBalance: function(payload) {
      console.log(payload)
    }
  }

}
</script>

<style>
.point-adjustement-container input::placeholder,
.point-adjustement-container textarea::placeholder {
  font-size: 0.9rem;
}

th {
  font-size: 0.8rem;
}

td {
  font-size: 0.8rem;
}

.fade-out {
  opacity: 0;
  transition: all 0.5s;
}

.fade-in {
  opacity: 1;
  transition: all 0.5s;
}
</style>
