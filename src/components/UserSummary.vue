<template>
  <div>
    <div class="row mt-3">
      <h2>{{balanceData.userGuid}}</h2>
    </div>
    <div class="row gx-2 gy-2 mt-1 mb-3">
      <p class="text-muted my-2 balance_date">Last updated on {{balanceData.balanceDate}}</p>
      <div class="col-md-3 col-sm-12">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Balance:</h5>
            <div class="card-text">
              <h2>{{balanceData.balance}}</h2>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-3 col-sm-12">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Available Balance:</h5>
            <div class="card-text">
              <h2>{{balanceData.availableBalance}}</h2>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-3 col-sm-12">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Pending points:</h5>
            <div class="card-text">
              <h2>{{balanceData.pendingBalance}}</h2>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "UserSummary",
  props: {
    balanceData: {},
  },
  data() {
    return {};
  },
  methods: {},
};
</script>

<style>
.balance_date {
  font-size: 0.8rem;
}
</style>
