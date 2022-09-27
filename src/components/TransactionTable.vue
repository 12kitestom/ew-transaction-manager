<template>
  <div>
    <div class="row mb-3">
      <div class="col">
        <table v-once id="table" class="table table-striped">
          <thead>
            <tr>
              <th>Transaction Ref.</th>
              <th>Type</th>
              <th>Description</th>
              <th>Date</th>
              <th>Amount</th>
              <th>Balance</th>
              <th>Action</th>
            </tr>
          </thead>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
/* global $:readonly */ //eslint-disable-line

let urlBase = process.env.VUE_APP_TRANSACTION_MANAGER_API_BASE; //eslint-disable-line

if (process.env.VUE_APP_API_MODE == "dev") {
  let token = process.env.VUE_APP_DEV_TOKEN;
  if (token) {
    //Can't enable dev mode without a token to use
    window.ew.dev.enableAjaxDev(token);
  }
}

if (window.ewGetApiBase) {
  urlBase = window.ewGetApiBase()
}

export default {
  name: "TransactionTable",
  props: {
	userGuid: {
		type: String,
		required: true
	}
  },
  data() {
    return {};
  },
  created() {
    if (window.ewGetApiBase) {
      this.urlBase = window.ewGetApiBase()
    }
  },
  mounted() {
    $("#table").DataTable({
      searchDelay: 1000,
      serverSide: true,
      order: [[2, "desc"]],
      ajax: async (data, callback, settings) => {//eslint-disable-line

        let options = {
          page: data.start / data.length,
          size: data.length,
          sort: data.order[0].column,
          sortdir: data.order[0].dir,
          q: data.search.value
        }



        let getData = await window.ew.ajax.getRequest(`${urlBase}/user/${this.userGuid}/transactions`, options)

        //dataTables expects returned JSON to have these parameters set: data, recordsTotal and recordsFiltered
        getData.data.recordsTotal = getData.data.totalRecords;
        getData.data.recordsFiltered = getData.data.totalRecords
        
        callback(getData.data)
		console.log(getData)
      },
      createdRow: function(row, data) {
        if(data.txStatus === 0) {
          $(row).addClass('new-transaction')
        }
      },
      columns: [
        { data: "txRef", orderable: false },
        { data: "txType", orderable: false },
        { data: "userText", orderable: false },
        { data: null,
          render: data => {
            let date = data.recordedDate.split('T')
            return date[0]
          }
        },
        { data: null,
          orderable: false,
          render: data => {
            return data.amountPos - data.amountNeg;
          },
        },
        { data: "balance", orderable: false },
        { data: null,
          render: data => {
            if(data.txStatus === 0) {
              return `
              <button class="btn btn-success btn-sm" data-type="approve" data-ref="${data.txRef}" data-guid="${this.userGuid}" >Approve</button>
              <button class="btn btn-danger btn-sm" data-type="reject" data-ref="${data.txRef}" data-guid="${this.userGuid}">Reject</button>
              `
            } else {
              return ''
            }
          }
        },
      ]
    })

    this.$nextTick(function() {

      $('#table').on('draw.dt', function() {
        console.log('table draw')
        $('#table .btn').click(handlePending);
      })

    })
  },
};

async function handlePending() {
      let $btn = $(this);
      let type = $btn.data('type');
      let txRef = $btn.data('ref');
      let guid = $btn.data('guid');
      let res = ''

      if(window.confirm(`Are you sure you want to ${type} this transaction?`)) {

        if(type === 'approve') {
          res = await window.ew.ajax.postRequest(`${urlBase}/admin/action/approve-transaction`, { txRef })
        }
      
        if(type === 'reject') {
          res = await window.ew.ajax.postRequest(`${urlBase}/admin/action/delete-transaction`, { txRef })
        }

        console.log(res)

        if(res.success) {
          let thisApp = ''

          if(window.appName) {
            thisApp = window.appName
          } else {
            console.error(`'appName' string has to be defined on the window object`)
          }

          console.log('thisApp:', thisApp)

          if (window[thisApp].$children) {
            //refresh user balance
            window[thisApp].$children[0].loadUserBalance(guid);
          } else {
			console.log('runs')
			console.log('guid: ', guid)
            //in preparation for vue3 where $children property is removed
			if (window.vueApps && window.vueApps[thisApp]) {
				//when deployed
				window.vueApps[thisApp].loadUserBalance()
			} else {
				window[thisApp].loadUserBalance(guid)
			}
          }

          $('#table').DataTable().ajax.reload()
        } else {
          alert(`Error occurred when attempting to ${type} transaction. Please try again.`)
        }

      }
    }

</script>

<style>
.new-transaction {
  background-color: #e5fde5 !important;
}
</style>
