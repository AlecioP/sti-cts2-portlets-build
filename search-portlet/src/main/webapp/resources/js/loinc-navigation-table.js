//LOINC navigation table component
Vue.component('loincNavigationTable', {
  template: '#loinc-navigation-template',
  props: {
    results: Array,
    association: Boolean,
    isAssociated: Function,
    toggleAssociation: Function,
    openDetail: Function,
    lang: String,
    side: String,
    tooltipPosition: String,
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
    //console.log("Mounted loincNavigationTable component!");
  }
});
