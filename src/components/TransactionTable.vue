<template>
  <div>
    <div class="row">
      <div class="col">
        <table v-once id="table" class="table table-striped">
          <thead>
            <tr>
              <th>Redemption Ref.</th>
              <th>Description</th>
              <th>Date</th>
              <th>Status</th>
              <th>Amount</th>
              <th>Balance</th>
            </tr>
          </thead>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
/* global $:readonly */ //eslint-disable-line

const urlBase = process.env.VUE_APP_TRANSACTION_MANAGER_API_BASE; //eslint-disable-line

if (process.env.VUE_APP_API_MODE == "dev") {
  let token = process.env.VUE_APP_DEV_TOKEN;
  if (token) {
    //Can't enable dev mode without a token to use
    window.ew.dev.enableAjaxDev(token);
  }
}

export default {
  name: "TransactionTable",
  props: {
    userGuid: {
      type: String
    }
  },
  data() {
    return {};
  },
  mounted() {
    $("#table").DataTable({
      serverSide: true,
      order: [[2, "desc"]],
      ajax: async (data, callback, settings) => {//eslint-disable-line
        console.log(settings)
        console.log(data)

        let options = {
          page: data.start / data.length,
          size: data.length,
          sort: data.order[0].column,
          sortdir: data.order[0].dir,
          q: data.search.value
        }
        

        let getData = await window.ew.ajax.getRequest(`${urlBase}/user/${this.userGuid}/transactions`, options)
        console.log('getData: ', getData.data)

        //dataTables expects returned JSON to have these parameters set: data, recordsTotal and recordsFiltered
        getData.data.recordsTotal = getData.data.totalRecords;
        getData.data.recordsFiltered = getData.data.totalRecords
        
        callback(getData.data)
      },
      columns: [
        { data: "txRef", orderable: false },
        { data: "userText", orderable: false },
        { data: null,
          render: data => {
            let date = data.recordedDate.split('T')
            return date[0]
          }
        },
        { data: "txStatus", orderable: false },
        { data: null,
          orderable: false,
          render: data => {
            return data.amountPos - data.amountNeg;
          },
        },
        { data: "balance", orderable: false }
      ]
    })
  },
  methods: {

  }
};
</script>

<style>
</style>
