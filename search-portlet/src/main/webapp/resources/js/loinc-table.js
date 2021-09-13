//LOINC table component
Vue.component('loincTable', {
  template: '#loinc-template',
  props: {
    results: Array,
    openDetail: Function,
    changeLanguageProperty: Function,
    lang: String,
    buildStatusCode: Function,
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
    //console.log("Mounted loincTable component!");
  }
});
