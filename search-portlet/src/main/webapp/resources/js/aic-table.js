//AIC table component
Vue.component('aicTable', {
  template: '#aic-template',
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
