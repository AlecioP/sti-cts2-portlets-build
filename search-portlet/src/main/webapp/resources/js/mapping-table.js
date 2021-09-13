//MAPPING table component
Vue.component('mappingTable', {
  template: '#mapping-table-template',
  props: {
    results: Array,
    openDetail: Function,
    changeLanguageProperty: Function,
    lang: String,
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
    //console.log("Mounted localTable component!");
  }
});

