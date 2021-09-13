//Pagination component
Vue.component('pagination', {
  template: '#pagination-template',
  props: {
    page: Object,
    lang: String,
    executeSearch: Function,
    pageVar: String,
    searchResultsVar: String,
    filteredPages: Function,
    hasPreviousHidePages: Function,
    hasNextHidePages: Function,
  },
  data: function () {
    return {
    }
  },
  computed: {
  },
  methods: {
  },
  mounted : function() {
    //console.log("Mounted noResult component!");
  }
});
