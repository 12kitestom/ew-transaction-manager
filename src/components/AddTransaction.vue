<template>
  <div>
    <div v-if="showInputs" class="row mb-5 gx-2 point-adjustement-container" :class="fadeClass">
      <div class="col-sm-12 col-md-8">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title mb-5">
              Add Manual transaction
              <button @click="closeInputs" class="btn  text-danger float-end" title="Close" >
                <i class="bi bi-x-lg"></i>
              </button>
            </h5>

            <div v-if="pointsValidationMsg || txNameValidationMsg || message" class="alert alert-danger" role="alert">
              <ul>
                <li v-if="pointsValidationMsg">{{pointsValidationMsg}}</li>
                <li v-if="txNameValidationMsg">{{txNameValidationMsg}}</li>
                <li v-if="txDateValidationMsg">{{txDateValidationMsg}}</li>
                <li v-if="message">{{message}}</li>
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
                  placeholder="Amount of points"
                />
              </div>

              <div class="col-sm-12 col-md-4 mb-3">
                <label for="date" class="form-label">Transaction date</label>
                <input
                  v-model="txDate"
                  type="date"
                  class="form-control"
                  id="date"

                />
              </div>

              <div class="col-sm-12 mb-3">
                <label for="tx-name" class="form-label">Transaction text</label>
                <input
                  v-model="txName"
                  type="text"
                  class="form-control"
                  id="tx-name"
                  placeholder="Transaction text shown to the user"
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
    <div v-if="!showInputs" class="row mt-4 mb-5">
      <div class="col">
        <button @click="handleClick" class="btn btn-primary btn">
          Add transaction
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import dayjs from 'dayjs';

export default {
  name: "AddTransaction",
  props: {
    message: {
      type: String
    },
    update: {
      type: Number
    }
  },
  data() {
    return {
      showInputs: false,
      points: '',
      pointsValidationMsg: '',
      txName: '',
      txNameValidationMsg: '',
      txDesc: '',
      //txDate: new Date().toISOString().split('T')[0],
      txDate: dayjs().format('YYYY-MM-DD'),
      txDateValidationMsg: '',
      testPoints: -105,
    };
  },
  methods: {
    handleClick: function() {
        this.showInputs = !this.showInputs


    },
    validateInputs: function() {
      let points = this.points
      let txName = this.txName
      let txDate = this.txDate.split('-').join('')
      let today = dayjs().format('YYYY-MM-DD')
      today = today.split('-').join('')

      let isValid = true

      console.log('today ',today)
      console.log('txDate', txDate)

      if(points.length < 1 || points == 0) {
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

      if(txDate > today ) {
        this.txDateValidationMsg = 'Transaction date cannot be set in the future'
        isValid = false
      } else {
        this.txDateValidationMsg = ''
      } 

      return isValid
    },
    formatPoints: function(points) {
      points = Math.floor(parseInt(points))

      let amountPos = 0
      let amountNeg = 0

      if(points > 0) {
        amountPos = points
      }
      if(points < 0) {
        amountNeg = Math.abs(points)
      }

      return { amountPos, amountNeg }
    },
    closeInputs: function() {
        this.$emit('clear-errors')
        this.showInputs = false
        this.txNameValidationMsg = ''
        this.pointsValidationMsg = ''
        this.txDateValidationMsg = ''
        this.points = ''
        this.txName = ''
        this.txDesc = ''
        this.txDate = dayjs().format('YYYY-MM-DD')
    },
    handleSubmit: function () {

      let userText = this.txName
      let adminDescription = this.txDesc
      let amount = this.points
      let eventDate = this.txDate
      //let formatedPoints = this.formatPoints(this.points)
      let isValid = this.validateInputs()

      //send
      let payload = { amount, userText, adminDescription, eventDate }


      if(isValid && window.confirm(
        `
        Are you sure you want to add this transaction?
        Amount: ${amount}
        Name: ${userText}
        `
      )) {
        this.$emit("add-transaction", payload);
        
      }

    },
  },
  computed: {
    fadeClass: function() {
      return this.showInputs ? 'fade-in' : 'fade-out'
    },

  },
  watch: {
    update: function() {
      this.closeInputs()
    }
  }
};
</script>

<style>
.btn-block {
  width: 100%;
}
</style>
