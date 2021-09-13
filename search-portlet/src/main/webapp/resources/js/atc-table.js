//ATC table component
Vue.component('atcTable', {
  template: '#atc-template',
  props: {
    results: Array,
    openDetail: Function,
    lang: String
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
   //console.log("Mounted atcTable component!");
  }
});
