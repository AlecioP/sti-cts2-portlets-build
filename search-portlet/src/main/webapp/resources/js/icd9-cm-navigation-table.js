//ICD9-CM navigation table component
Vue.component('icd9CmNavigationTable', {
  template: '#icd9-cm-navigation-template',
  props: {
    model: Array,
    headers: Array,
    lang: String,
    searchUrl: Function,
    detailCallback: Function,
    association: Boolean,
    toggleAssociationCallback: Function,
    isAssociated: Function,
    side: String,
    showLoading: Function,
    hideLoading: Function,
    tooltipPosition: String,
  },
  data: function () {
    return {
      flatData: []
    }
  },
  computed: {
    isFolder: function () {
      return this.model.children &&
        this.model.children.length
    },
  },
  methods: {
    /**
     * Toggle the given element.
     * @param parent The element to toggle.
     * @param index The index of the element.
     */
    toggle: function (parent, index) {
      if(parent.hasChildren) {
        if(parent.loaded){
          console.log('Children already loaded');
          parent.open = !parent.open;
          this.showLoading();
          this.toggleChildren(parent.id, this.flatData, parent.open, parent.open);
          this.hideLoading();
        } else {
          this.loadSubclassOf(parent, index);
        }

      } else {
        console.log('Can\' toggle this element');
      }
    },

    /**
     * Toggle all the children of the given parentId.
     * @param parentId The parent id.
     * @param elements The array of the elements to check and if are child of the given node to close.
     * @param shown The value of shown (true or false).
     * @param parentOpen Is the parent open?
     */
    toggleChildren: function (parentId, elements, shown, parentOpen){
      //console.log('enter toggleChildren', parentId, elements, shown, parentOpen);
      var self = this;
      var operations = {};
      if(_.isUndefined(parentId)){
        console.log('FIRST - This is undefined');
      }
      operations[parentId] = {
        shown: shown,
        parentOpen: parentOpen
      };
      _.forEach(elements, function(element, key) {
        var operation = operations[element.parent];
        if(operation) {
          //console.log('operations', operations);
          //console.log('toggleChildren', parentId, key, element, shown);
          element.shown = operation.shown && operation.parentOpen;

          //Update the array
          Vue.set(self.flatData, key, element);

          if(element.hasChildren){
            if(_.isUndefined(element.id)){
              console.log('LAST - This is undefined');
            }
            operations[element.id] = {
              shown: shown,
              parentOpen: parentOpen && element.open
            };
          }
        }
      });
    },

    /**
     * Generate flat data, without children.
     * @param data The data to transform in flat.
     * @param level The level of the tree.
     * @param parentId The parent id.
     */
    generateFlatData: function (data, level, parentId){
      var self = this;
      _.forEach(data, function(element, key) {
        //console.log('element', element, 'key', key, 'parentId', parentId);
        element.parent = parentId;
        element.level = level;
        self.flatData.push(_.clone(element));
        if(!parentId){
          _.last(self.flatData).shown = true;
        }
        if(element.children && element.children.length) {
          var id = Math.random().toString(36).substring(7);
          _.last(self.flatData).id = id;
          _.last(self.flatData).hasChildren = true;
          self.generateFlatData(_.last(self.flatData).children, level + 1, id);
        }
      });
    },

    /**
     * Returns true if the given element is open, false otherwise.
     * @param element The element to open.
     */
    isShown: function(element){
      return element.shown;
    },

    /**
     * Load sub class of.
     * @param parent The parent from which load the children.
     * @param index The index of the element.
     */
    loadSubclassOf: function(parent, index){
      var url = this.searchUrl(this.side) + "&matchvalue=SUBCLASS_OF=" + parent.resourceName + APP_PROPERTIES.jsonFormatHttpParam;
      var self = this;
      self.showLoading();
      this.$http.get(url).then(function(response){
        var entries = response.body.EntityDirectory.entry;
        console.log('response', entries);
        parent.children = entries;
        parent.loaded = true;
        parent.open = true;
        var parentId = parent.id;
        var level = parent.level + 1;

        _.forEach(entries, function(entry, key) {
          index++;
          entry.parent = parentId;
          entry.level = level;
          entry.shown = true;
          var designation = jQuery.parseJSON(entry.knownEntityDescription[0].designation);
          entry.id = Math.random().toString(36).substring(7);
          entry.hasChildren = !designation.IS_LEAF;
          entry.loaded = false;
          entry.designation = designation;
          entry.codeSystemVersion = _.replace(entry.knownEntityDescription[0].describingCodeSystemVersion.version.content, '_ita', '');

          //Convert the array in string
          self.convertString(entry, 'DESCRIPTION_en');
          self.convertString(entry, 'DESCRIPTION_it');
          self.convertString(entry, 'NAME_en');
          self.convertString(entry, 'NAME_it');

          //If the name is empty (english and italian), set it to the description
          if(!entry.designation['NAME_en']){
            entry.designation['NAME_en'] = entry.designation['DESCRIPTION_en'];
          }
          if(!entry.designation['NAME_it']){
            entry.designation['NAME_it'] = entry.designation['DESCRIPTION_it'];
          }

          entry.defLang = self.lang;
          self.flatData.splice(index, 0, _.clone(entry));
        });
      }).finally(function(){
        self.hideLoading();
      });
    },

    /**
     * Convert the array in string and set its value given entry and key.
     * @param entry The entry to convert.
     * @param key The key of the entry to convert.
     */
    convertString: function(entry, key){
      if(_.isArray(entry.designation[key])){
        entry.designation[key] = _.join(entry.designation[key]);
      }
    }
  },
  mounted : function() {
    //console.log("Mounted component!");
    this.generateFlatData(this.model, 0);
  }
});
