<template>
  <div id="user-summary">
    <div class="row mt-3 mb-5">
      <h1 class="user-name">User transactions – {{balanceData.displayName}}</h1>
      <span class="text-muted fs-5">{{balanceData.userEmail}}</span>
    </div>
    <p class="text-muted my-2 balance_date">Last updated on {{formatedDate}}</p>
    <div class="row row-flex gx-2 mt-1 mb-3">

      <div class="col-md-4 col-sm-12 mb-2">
        <div class="card">
          <div class="card-body">
            <h6 class="card-title">Balance:</h6>
            <div class="card-text text-center">
              <h2>{{balanceData.balance}}</h2>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-4 col-sm-12 mb-2">
        <div class="card">
          <div class="card-body">
            <h6 class="card-title">Available Balance:</h6>
            <div class="card-text text-center">
              <h2>{{balanceData.availableBalance}}</h2>
            </div>
          </div>
        </div>
      </div>

      <!-- <div class="col-md-3 col-sm-12">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Pending points:</h5>
            <div class="card-text">
              <h2>{{balanceData.pendingBalance}}</h2>
            </div>
          </div>
        </div>
      </div> -->
    </div>
    
  </div>
</template>

<script>
import dayjs from 'dayjs';
const advancedFormat = require('dayjs/plugin/advancedFormat')
dayjs.extend(advancedFormat)

export default {
  name: "UserSummary",
  props: {
    balanceData: {},
  },
  data() {
    return {};
  },
  methods: {

  },
  computed: {
    formatedDate: function() {
      return dayjs(this.balanceData.balanceDate).format('dddd, MMMM Do, YYYY')
    }
  }
};
</script>

<style scoped>
.balance_date {
  font-size: 0.8rem;
}

.user-name {
  margin-bottom: 0;
}
</style>
