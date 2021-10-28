<template>
  <div>
    <div v-if="showInputs" class="row mb-5 point-adjustement-container" :class="fadeClass">
      <div class="col-sm-12 col-md-9">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title mb-4">Manual adjustement</h5>
            <div v-if="pointsValidationMsg || txNameValidationMsg" class="alert alert-danger" role="alert">
              <ul>
                <li v-if="pointsValidationMsg">{{pointsValidationMsg}}</li>
                <li v-if="txNameValidationMsg">{{txNameValidationMsg}}</li>
              </ul>
            </div>

            <div class="row">
              <div class="col-sm-12 col-md-4 mb-3">
                <label for="points" class="form-label">Points</label>
                <input
                  v-model="points"
                  type="number"
                  class="form-control"
                  id="points"
                  placeholder="Adjusted points"
                />
              </div>

              <div class="col-sm-12 col-md-8 mb-3">
                <label for="tx-name" class="form-label">Transaction name</label>
                <input
                  v-model="txName"
                  type="text"
                  class="form-control"
                  id="tx-name"
                  placeholder="Transaction name shown to user"
                />
              </div>
            </div>

            <div class="row">
              <div class="col-sm-12 mb-3">
                <label for="description" class="form-label">Admin description</label>
                <textarea
                  v-model="txDesc"
                  type="text"
                  class="form-control"
                  id="description"
                  placeholder="Optional description only visible to admins"
                ></textarea>
              </div>
            </div>
            <div class="row">
              <div class="col-sm-12 col-md-2">
                <button @click="handleSubmit" class="btn btn-block btn-primary">Submit</button>
              </div>
            </div>

          </div>
        </div>
      </div>
    </div>
    <div v-if="!showInputs" class="row my-5">
      <div class="col">
        <button @click="handleClick" class="btn btn-primary btn">
          Adjust balance
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "PointsAdjustement",
  props: {},
  data() {
    return {
      showInputs: false,
      points: '',
      pointsValidationMsg: '',
      txName: '',
      txNameValidationMsg: '',
      txDesc: ''
    };
  },
  methods: {
    handleClick: function() {
        this.showInputs = !this.showInputs


    },
    validateInputs: function() {
      let points = this.points
      let txName = this.txName
      let isValid = true

      if(points.length < 1) {
        this.pointsValidationMsg = 'Please enter amount of points to be adjusted'
        isValid = false
      } else {
        this.pointsValidationMsg = ''
      }

      if(txName.length < 1) {
        this.txNameValidationMsg = 'Please enter transaction name'
        isValid = false
      } else {
        this.txNameValidationMsg = ''
      } 

      return isValid
    },
    handleSubmit: function () {

      let isValid = this.validateInputs()
      let points = this.points
      let txName = this.txName
      let txDesc = this.txDesc


      //send
      let payload = { points, txName, txDesc }
      console.log(isValid)

      if(isValid && window.confirm('Are you sure?')) {
        this.showInputs = !this.showInputs
        this.$emit("adjust", payload);
      }

    },
  },
  computed: {
    fadeClass: function() {
      return this.showInputs ? 'fade-in' : 'fade-out'
    }
  }
};
</script>

<style>
.btn-block {
  width: 100%;
}
</style>
