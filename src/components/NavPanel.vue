<template>
  <div id="nav-panel" class="mb-5">
    <div class="card" :class="shadow">
      <div class="card-body">
        <a :href="goBackUrl()" class="btn btn-primary"><i class="bi bi-arrow-left"></i>Back</a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'NavPanel',
  props: {
    userGuid: {
      type: String
    }
  },
  data() {
    return {
      scrollPosition: null
    }
  },
  mounted() {
    window.addEventListener('scroll', this.updateScroll);
  },
  methods: {
    goBackUrl() {
      let url = window.ew.dashboard.getUrlForFeature('userAdmin', this.userGuid)
      //console.log(url)
      if(url) {
        return url
      } else {
        //handle no url case
      }
    },
    updateScroll() {
      this.scrollPosition = window.scrollY
    },
    
  },
  computed: {
    shadow: function() {
      return this.scrollPosition > 100 ? 'panel-shadow' : 'no-panel-shadow'
    },
    goBackUrl2() {
      return window.ew.dashboard.getUrlForFeature('userAdmin', this.userGuid)
    }
  }
}
</script>

<style scoped>
  #nav-panel {
    position: sticky;
    top: 0;
    
    z-index: 999;
  }

  .panel-shadow {
    box-shadow: 0 .5rem 1rem rgba(34, 34, 34, 0.459);
    border-radius: 0;
    transition: all 0.2s ease-in-out;
  }

  .no-panel-shadow {
    box-shadow: none;
    border-radius: 0;
    transition: all 0.1s ease-in-out;
  }
</style>
