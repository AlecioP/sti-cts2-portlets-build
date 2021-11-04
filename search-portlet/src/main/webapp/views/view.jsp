<%@ page contentType="text/html; charset=UTF-8" %>
<!-- ICD9-CM navigation table template -->

<!-- ICD9-CM table -->
<script type="text/x-template" id="icd9-cm-template">
	<table class="table table-bordered table-striped table-hover table-condensed table-sti">
		<thead>
			<tr>
				<th>{{ $t("message.labelCode", "it") }}</th>
				<th>{{ $t("message.labelDescription", "it") }}</th>
				<th>{{ $t("icd9cm.labelOtherDescriptions", "it") }}</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<tr v-for="searchResult in results" class="mouse-pointer">
				<td v-on:click="openDetail(searchResult)">
					<i class="icon-warning-sign red"
					v-if="searchResult.designation.MAP_TO"></i>
					{{ searchResult.resourceName }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.designation['NAME_' + searchResult.defLang] }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					<ul v-for="otherDescription in searchResult.designation['OTHER_DESCRIPTION_' + searchResult.defLang]">
						<li>{{ otherDescription }}</li>
					</ul>
				</td>
				<td>
					<div class="flag flag-it flag-clickable" alt="Italian" v-if="searchResult.defLang=='en'" v-on:click="changeLanguageProperty(searchResult, 'it')"></div>
					<div class="flag flag-gb flag-clickable" alt="English" v-if="searchResult.defLang=='it'" v-on:click="changeLanguageProperty(searchResult, 'en')"></div>
				</td>
			</tr>
		</tbody>
	</table>
</script>

<!-- LOINC table -->
<script type="text/x-template" id="loinc-template">
	<table class="table table-bordered table-striped table-hover table-condensed table-sti">
		<thead>
			<tr>
				<th>{{ $t("loinc.labelCode", "it") }}</th>
				<th>{{ $t("loinc.labelComponent", "it") }}</th>
				<th>{{ $t("message.labelProperty", "it") }}</th>
				<th>{{ $t("message.labelTime", "it") }}</th>
				<th>{{ $t("message.labelSystem", "it") }}</th>
				<th>{{ $t("message.labelScale", "it") }}</th>
				<th>{{ $t("message.labelMethod", "it") }}</th>
				<th>{{ $t("message.labelClass", "it") }}</th>
				<th>{{ $t("message.labelStatus", "it") }}</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<tr v-for="searchResult in results" class="mouse-pointer">
				<td v-on:click="openDetail(searchResult)">
					<i class="icon-warning-sign red" v-if="searchResult.designation.MAP_TO"></i> {{ searchResult.resourceName }}</td>
				<td v-on:click="openDetail(searchResult)">{{ searchResult.designation['COMPONENT_'+searchResult.defLang] }}</td>
				<td v-on:click="openDetail(searchResult)">{{ searchResult.designation['PROPERTY_'+searchResult.defLang] }}</td>
				<td v-on:click="openDetail(searchResult)">{{ searchResult.designation['TIME_ASPECT_'+searchResult.defLang] }}</td>
				<td v-on:click="openDetail(searchResult)">{{ searchResult.designation['SYSTEM_'+searchResult.defLang] }}</td>
				<td v-on:click="openDetail(searchResult)">{{ searchResult.designation['SCALE_TYP_'+searchResult.defLang] }}</td>
				<td v-on:click="openDetail(searchResult)">{{ searchResult.designation['METHOD_TYP_'+searchResult.defLang] }}</td>
				<td v-on:click="openDetail(searchResult)">{{ searchResult.designation['CLASS_'+searchResult.defLang] }}</td>

				<td><span
					v-bind:class="{
							'label-important' : searchResult.designation.STATUS == 'DEPRECATED',
							'label-success' : searchResult.designation.STATUS == 'ACTIVE',
							'label-warning' : searchResult.designation.STATUS == 'DISCOURAGED' }"
					class="label"> {{ $t(buildStatusCode(searchResult.designation.STATUS), searchResult.defLang) }} </span></td>
				<!--<td>{{ searchResult.designation.STATUS }}</td>-->
				<td>
					<div class="flag flag-it flag-clickable" alt="Italian" v-if="searchResult.defLang=='en'" v-on:click="changeLanguageProperty(searchResult, 'it')"></div>
					<div class="flag flag-gb flag-clickable" alt="English" v-if="searchResult.defLang=='it'" v-on:click="changeLanguageProperty(searchResult, 'en')"></div>
				</td>
			</tr>
		</tbody>
	</table>
</script>

<!-- ATC table -->
<script type="text/x-template" id="atc-template">
	<table class="table table-bordered table-striped table-hover table-condensed table-sti">
		<thead>
			<tr>
				<th>{{ $t("message.labelAtcCode", "it") }}</th>
				<th>{{ $t("message.labelDenomination", "it") }}</th>
				<th>{{ $t("message.labelAnatomicalGroup", "it") }}</th>
			</tr>
		</thead>
		<tbody>
			<tr v-for="searchResult in results"
				class="mouse-pointer">
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.resourceName }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.designation.NAME_it }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.designation.GRUPPO_ANATOMICO }}
				</td>
			</tr>
		</tbody>
	</table>
</script>

<!-- AIC table -->
<script type="text/x-template" id="aic-template">
	<table class="table table-bordered table-striped table-hover table-condensed table-sti">
		<thead>
			<tr>
				<th>{{ $t("message.labelAicCode", "it") }}</th>
				<th>{{ $t("message.labelDenomination", "it") }}</th>
				<th>{{ $t("message.labelPackage", "it") }}</th>
				<th>{{ $t("message.labelMedicineType", "it") }}</th>
				<th>{{ $t("message.labelActiveIngredient", "it") }}</th>
				<th>{{ $t("message.labelClass", "it") }}</th>
				<th>{{ $t("message.labelCompany", "it") }}</th>
			</tr>
		</thead>
		<tbody>
			<tr v-for="searchResult in results"
				class="mouse-pointer">
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.resourceName }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.designation.DENOMINAZIONE }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.designation.CONFEZIONE }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.designation.TIPO_FARMACO }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.designation.PRINCIPIO_ATTIVO }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.designation.CLASSE }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.designation.DITTA }}
				</td>
			</tr>
		</tbody>
	</table>
</script>


<script type="text/x-template" id="local-table-template">
<div>
	<div v-if="!currentLangaugeIsPresent" class="alert alert-info">
		{{ $t("message.labelContentNotPresent", "it") }}
	</div>

	<table v-if="currentLangaugeIsPresent"  class="table table-bordered table-striped table-hover table-condensed table-sti">
		<thead>
			<th v-for="header in defaultHeaders">{{ $t(header, "it") }}</th>
			<th v-if="_.endsWith(header, lang)" v-for="header in dynamicHeaders">{{ header | clearHeader | capitalize}}</th>
			<th v-if="itaEngIsPresent"></th>
		</thead>
		<tbody>
			<tr v-for="searchResult in results" class="mouse-pointer"  v-if="searchResult.designation['NAME_'+searchResult.defLang]!==undefined || searchResult.designation['CS_DESCRIPTION_'+searchResult.defLang]!==undefined">
				<td v-on:click="openDetail(searchResult)">
					<label>{{ searchResult.resourceName }}</label>
				</td>
				<td v-on:click="openDetail(searchResult)">
					<label v-if="searchResult.designation['NAME_'+searchResult.defLang]">{{ searchResult.designation['NAME_'+searchResult.defLang] }}</label>
					<label v-else>{{ searchResult.designation['CS_DESCRIPTION_'+searchResult.defLang]}}</label>
				</td>
				
				<td v-for="field in dynamicHeaders" v-if="_.endsWith(field, searchResult.defLang)" v-on:click="openDetail(searchResult)">
					<label v-if="_.startsWith(field, 'DF_D_')">{{  moment(searchResult.designation[field]).locale('it').format('DD/MM/YYYY') }}</label>
					<label v-else>{{ searchResult.designation[field] }}<label>
				</td>
				<td v-if="itaEngIsPresent">
					<div class="flag flag-it flag-clickable" alt="Italian" v-if="searchResult.defLang=='en'" v-on:click="changeLanguageProperty(searchResult, 'it')"></div>
					<div class="flag flag-gb flag-clickable" alt="English" v-if="searchResult.defLang=='it'" v-on:click="changeLanguageProperty(searchResult, 'en')"></div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</script>


<script type="text/x-template" id="valueset-table-template">
<div>
	<div v-if="!currentLangaugeIsPresent" class="alert alert-info">
		{{ $t("message.labelContentNotPresent", "it") }}
	</div>

	<table v-if="currentLangaugeIsPresent"  class="table table-bordered table-striped table-hover table-condensed table-sti">
		<thead>
			<th v-for="header in defaultHeaders">{{ $t(header,  "it") }}</th>
			<th v-if="_.endsWith(header, lang)" v-for="header in dynamicHeaders">{{ header | clearHeader | capitalize}}</th>
			<th v-if="itaEngIsPresent"></th>
		</thead>
		<tbody>	
			<tr v-for="searchResult in results" class="mouse-pointer" v-if="searchResult.designation['NAME_'+searchResult.defLang]!==undefined || searchResult.designation['VALUESET_DESCRIPTION_'+searchResult.defLang]!==undefined">
				<td v-on:click="openDetail(searchResult)">
					<label>{{ searchResult.resourceName }}</label>
				</td>
				<td v-on:click="openDetail(searchResult)">
					<label v-if=" searchResult.designation['NAME_'+searchResult.defLang]">{{ searchResult.designation['NAME_'+searchResult.defLang] }}</label>
					<label v-else>{{  searchResult.designation['VALUESET_DESCRIPTION_'+searchResult.defLang]}}</label>
				</td>
				
				<td v-for="field in dynamicHeaders" v-if="_.endsWith(field, searchResult.defLang)" v-on:click="openDetail(searchResult)">
					<label v-if="_.startsWith(field, 'DF_D_')">{{  moment(searchResult.designation[field]).locale('it').format('DD/MM/YYYY') }}</label>
					<label v-else>{{ searchResult.designation[field] }}</label>
				</td>
				<td v-if="itaEngIsPresent">
					<div class="flag flag-it flag-clickable" alt="Italian" v-if="searchResult.defLang=='en'" v-on:click="changeLanguageProperty(searchResult, 'it')"></div>
					<div class="flag flag-gb flag-clickable" alt="English" v-if="searchResult.defLang=='it'" v-on:click="changeLanguageProperty(searchResult, 'en')"></div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</script>







<!-- MAPPING table -->
<script type="text/x-template" id="mapping-table-template">
	<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
		<thead>
			<tr>
				<th>{{ $t('message.labelCodeSystemCode', "it") }} 1</th>
				<th>{{ $t('message.labelDescriptionCodeSystemCode', "it") }} 1</th>
				<th>{{ $t('message.labelCodeSystemCode', "it") }} 2</th>
				<th>{{ $t('message.labelDescriptionCodeSystemCode', "it") }} 2</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<tr v-for="searchResult in results" class="mouse-pointer">
				<td v-on:click="openDetail(searchResult.namespace, searchResult, 'key')">
					{{ searchResult.subject.name }}
				</td>
				<td v-on:click="openDetail(searchResult.namespace,searchResult, 'key')">
					{{ searchResult.sourceTitle[lang] }}
				</td>
				<td v-on:click="openDetail(searchResult.namespace,searchResult, 'key')">
					{{ searchResult.predicate.name }}
				</td>
				<td v-on:click="openDetail(searchResult.namespace, searchResult, 'key')">
					{{ searchResult.targetTitle[lang] }}
				</td>
			</tr>
		</tbody>
	</table>
</script>

<script type="text/x-template" id="local-filter-template">
	<table class="table-filter-template">
		<tr>
			<td>
				<div class="row-fluid" v-for="i in Math.ceil(getFields.length / 2)" v-if>	
 					<div v-if="_.endsWith(field, lang)" v-for="field in getFields.slice((i - 1) * 3, i * 3)" :id="field" class="span3">
						<div class="form-group" >
							<label>{{ field  | clearHeader | capitalize}}</label>
							<select class="width-99" v-model="elementForm.dynamicField[field]">
								<option v-for="option in getValuesFromField(field)" v-bind:value="option">{{option}}</option>	
							</select>	
						</div>
					</div>
				</div>
			</td>
		</tr>
	</table>
</script>






<!-- ICD9-CM navigation table -->
<script type="text/x-template" id="icd9-cm-navigation-template">
	<table class="table table-bordered table-striped table-hover table-condensed table-sti overflow-x-visible">
		<thead>
			<tr>
				<th v-for="header in headers">{{ header }}</th>
			</tr>
		</thead>
		<tbody>
			<tr v-for="(subModel, index) in flatData" v-show="isShown(subModel)" v-bind:class="{
				'success': isAssociated(subModel, side)}" class="mouse-pointer">
				<td v-on:click="toggleAssociationCallback(subModel, side)" v-if="association">
					<i class="icon-ok"></i>
				</td>
				<td class="span4" v-bind:class="{
					'padding-left-30': subModel.level == 1,
					'padding-left-60': subModel.level == 2,
					'padding-left-90': subModel.level == 3,
					'padding-left-120': subModel.level == 4,
					'padding-left-150': subModel.level == 5}">
					<span @click="toggle(subModel, index)" class="mouse-pointer">
						<i v-bind:class="{
						'icon-plus': !subModel.open && subModel.hasChildren,
						'icon-minus': subModel.open && subModel.hasChildren}"></i>
					</span>
					<span @click="detailCallback(subModel)">
						{{ subModel.resourceName }}
					</span>
				</td>
        		<td @click="detailCallback(subModel)">
					{{ subModel.designation['DESCRIPTION_' + lang] | fallbackstring(subModel.designation['NAME_' + lang]) }}
        		</td>
				<td v-if="association">
					<div class="c-tooltip" >
						<i v-if="subModel.hasAssociations" class="icon icon-link" aria-hidden="true"></i>
						<div v-bind:class="tooltipPosition" style="width:250px">
							<div class="text-content">
								<strong> {{$t('message.labelIsAssociated', subModel.defLang) }} </strong>
							</div>
						</div>
					</div>
				</td>
				<td v-if="tooltipPosition">
					<div class="c-tooltip">
						<span class="icon icon-info-sign"></span>
						<div v-bind:class="tooltipPosition">
							<div class="text-content">
								<h5><strong> {{$t("message.labelCode", subModel.defLang) }} {{ subModel.namespace }}: </strong>&nbsp;{{ subModel.resourceName }}</h5>
								<ul>
									<li v-if="subModel.designation['NAME_'+lang]" >
										<strong>{{$t("icd9cm.labelName", subModel.defLang) }}: </strong>&nbsp;{{ subModel.designation['NAME_'+lang] }}
									</li>
									<li v-if="subModel.designation['VERSION']" >
										<strong>{{$t("message.labelVersion", subModel.defLang) }}: </strong>&nbsp;{{ subModel.designation['VERSION'] | clearVersionForView}}
									</li>
								</ul>
							</div>
						</div>
					</div>
				</td>	
			</tr>
		</tbody>
	</table>
</script>


<!-- LOINC navigation table -->
<script type="text/x-template" id="loinc-navigation-template">
	<table class="table table-bordered table-striped table-condensed table-sti overflow-x-visible">
		<thead>
			<tr>
				<th></th>
				<th>{{ $t("message.labelCode", lang) }}</th>
				<th> {{ $t("message.labelDescription", lang) }}</th>
				<th v-if="association">{{ $t("message.labelMapping", lang) }}</th>
				<th v-if="tooltipPosition"></th>
			</tr>
		</thead>
		<tbody>
			<tr v-for="searchResult in results" class="mouse-pointer" v-bind:class="{ 'success': isAssociated(searchResult, side)}" >

				<td v-on:click="toggleAssociation(searchResult, side)">
					<i class="icon-ok"></i>
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.resourceName }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.designation['COMPONENT_'+searchResult.defLang] }}
				</td>
				<td v-if="association">
					<div class="c-tooltip" >
						<i v-if="searchResult.hasAssociations" class="icon icon-link" aria-hidden="true"></i>
						<div v-bind:class="tooltipPosition" style="width:250px">
							<div class="text-content">
								<strong> {{$t('message.labelIsAssociated', searchResult.defLang) }} </strong>
							</div>
						</div>
					</div>
				</td>
				<td v-if="tooltipPosition">
					<div class="c-tooltip">
    					<span class="icon icon-info-sign"></span>
   						<div v-bind:class="tooltipPosition">
        					<div class="text-content">
           						<h5><strong>{{$t("loinc.labelCode", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.resourceName }}</h5>
           						<ul>
                					<li v-if="searchResult.designation['COMPONENT_'+searchResult.defLang]" >
										<strong>{{$t("loinc.labelComponent", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation['COMPONENT_'+searchResult.defLang] }}
									</li>
									<li v-if="searchResult.designation['PROPERTY_'+searchResult.defLang]" >
										<strong>{{$t("message.labelProperty", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation['PROPERTY_'+searchResult.defLang] }}
									</li>
									<li v-if="searchResult.designation['TIME_ASPECT_'+searchResult.defLang]" >
										<strong>{{$t("message.labelTime", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation['TIME_ASPECT_'+searchResult.defLang] }}
									</li>
									<li v-if="searchResult.designation['SYSTEM_'+searchResult.defLang]" >
										<strong>{{$t("message.labelSystem", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation['SYSTEM_'+searchResult.defLang] }}
									</li>
									<li v-if="searchResult.designation['SCALE_TYP_'+searchResult.defLang]" >
										<strong>{{$t("message.labelScale", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation['SCALE_TYP_'+searchResult.defLang] }}
									</li>
									<li v-if="searchResult.designation['METHOD_TYP_'+searchResult.defLang]" >
										<strong>{{$t("message.labelMethod", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation['METHOD_TYP_'+searchResult.defLang] }}
									</li>
									<li v-if="searchResult.designation['CLASS_'+searchResult.defLang]" >
										<strong>{{$t("message.labelClass", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation['CLASS_'+searchResult.defLang] }}
									</li>
									<li v-if="searchResult.designation['VERSION']" >
										<strong>{{$t("message.labelVersion", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation['VERSION'] | clearVersionForView}}
									</li>
           						</ul>
        					</div>
    					</div>
					</div>
				</td>
			</tr>
		</tbody>
	</table>
</script>

<!-- ATC navigation table -->
<script type="text/x-template" id="atc-navigation-template">
	<table class="table table-bordered table-striped table-hover table-condensed table-sti overflow-x-visible">
		<thead>
			<tr>
				<th v-for="header in headers">{{ header }}</th>
			</tr>
		</thead>
		<tbody>
			<tr v-for="(subModel, index) in flatData" v-show="isShown(subModel)" v-bind:class="{
				'success': isAssociated(subModel, side)}" class="mouse-pointer">
				<td v-on:click="toggleAssociationCallback(subModel, side)" v-if="association">
					<i class="icon-ok"></i>
				</td>
				<td v-bind:class="{
					'padding-left-30': subModel.level == 1,
					'padding-left-60': subModel.level == 2,
					'padding-left-90': subModel.level == 3,
					'padding-left-120': subModel.level == 4,
					'padding-left-150': subModel.level == 5}">
					<span @click="toggle(subModel, index)" class="mouse-pointer">
						<i v-bind:class="{
						'icon-plus': !subModel.open && subModel.hasChildren,
						'icon-minus': subModel.open && subModel.hasChildren}"></i>
					</span>
					<span @click="detailCallback(subModel)">
						{{ subModel.resourceName }}
					</span>
				</td>
        		<td @click="detailCallback(subModel)">
					{{ subModel.designation.NAME_it }}
        		</td>
				
				<td v-if="association">
					<div class="c-tooltip" >
						<i v-if="subModel.hasAssociations" class="icon icon-link" aria-hidden="true"></i>
						<div v-bind:class="tooltipPosition" style="width:250px">
							<div class="text-content">
								<strong> {{$t('message.labelIsAssociated', subModel.defLang) }} </strong>
							</div>
						</div>
					</div>
				</td>
				<td v-if="tooltipPosition">
					<div class="c-tooltip">
						<span class="icon icon-info-sign"></span>
						<div v-bind:class="tooltipPosition">
							<div class="text-content">
								<h5><strong> {{$t("message.labelCode", subModel.defLang) }} {{ subModel.namespace }}: </strong>&nbsp;{{ subModel.resourceName }}</h5>
								<ul>
									<li v-if="subModel.designation['NAME_'+lang]" >
										<strong>{{$t("icd9cm.labelName", subModel.defLang) }}: </strong>&nbsp;{{ subModel.designation['NAME_'+lang] }}
									</li>
									<li>
										<strong>{{$t("message.labelVersion", subModel.defLang) }}: </strong>&nbsp;{{ subModel.codeSystemVersion | clearVersionForView}}
									</li>
								</ul>
							</div>
						</div>
					</div>
				</td>	
			</tr>
		</tbody>
	</table>
</script>

<!-- AIC navigation table -->
<script type="text/x-template" id="aic-navigation-template">
	<table class="table table-bordered table-striped table-condensed table-sti overflow-x-visible">
		<thead>
			<tr>
				<th v-if="association"></th>
				<th>{{ $t("message.labelCode", lang) }}</th>
				<th>{{ $t("message.labelDescription", lang) }}</th>
				<th>{{ $t("message.labelMedicineType", lang) }}</th>
				<th v-if="association">{{ $t("message.labelMapping", lang) }}</th>
				<th v-if="tooltipPosition"></th>
			</tr>
		</thead>
		<tbody>
			<tr v-for="searchResult in results"
				class="mouse-pointer" v-bind:class="{
					'success': isAssociated(searchResult, side)}">
				<td v-on:click="toggleAssociation(searchResult, side)" v-if="association">
					<i class="icon-ok"></i>
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.resourceName }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.designation.DENOMINAZIONE }}
				</td>
				<td v-on:click="openDetail(searchResult)">
					{{ searchResult.designation.TIPO_FARMACO }}
				</td>
				<td v-if="association">
					<div class="c-tooltip" >
						<i v-if="searchResult.hasAssociations" class="icon icon-link" aria-hidden="true"></i>
						<div v-bind:class="tooltipPosition" style="width:250px">
							<div class="text-content">
								<strong> {{$t('message.labelIsAssociated', searchResult.defLang) }} </strong>
							</div>
						</div>
					</div>
				</td>
				<td v-if="tooltipPosition">
					<div class="c-tooltip">
						<span class="icon icon-info-sign"></span>
						<div v-bind:class="tooltipPosition">
							<div class="text-content">
								<h5><strong> {{$t("message.labelCode", searchResult.defLang) }} {{ searchResult.namespace }}: </strong>&nbsp;{{ searchResult.resourceName }}</h5>
								<ul>
									<li v-if="searchResult.designation.DENOMINAZIONE" >
										<strong>{{$t("message.labelDenomination", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation.DENOMINAZIONE }}
									</li>
									<li v-if="searchResult.designation.CONFEZIONE" >
										<strong>{{$t("message.labelPackage", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation.CONFEZIONE }}
									</li>
									<li v-if="searchResult.designation.PRINCIPIO_ATTIVO" >
										<strong>{{$t("message.labelActiveIngredient", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation.PRINCIPIO_ATTIVO }}
									</li>
									<li v-if="searchResult.designation.CLASSE" >
										<strong>{{$t("message.labelClass", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation.CLASSE }}
									</li>
									<li v-if="searchResult.designation.DITTA" >
										<strong>{{$t("message.labelCompany", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation.DITTA }}
									</li>
									<li v-if="searchResult.designation.CODICE_GRUPPO_EQ" >
										<strong>{{$t("message.labelEquivalenceGroupCode", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation.CODICE_GRUPPO_EQ }}
									</li>
									<li v-if="searchResult.designation.DESCR_GRUPPO_EQ" >
										<strong>{{$t("message.labelEquivalenceGroupDescription", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation.DESCR_GRUPPO_EQ }}
									</li>
									<li v-if="searchResult.designation.TIPO_FARMACO" >
										<strong>{{$t("message.labelMedicineType", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation.TIPO_FARMACO }}
									</li>																				
									<li v-if="searchResult.designation.CODICE_ATC" >
										<strong>{{$t("message.labelAtcCode", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.designation.CODICE_ATC }}
									</li>										
									<li>
										<strong>{{$t("message.labelVersion", searchResult.defLang) }}: </strong>&nbsp;{{ searchResult.codeSystemVersion | clearVersionForView}}
									</li>
								</ul>
							</div>
						</div>
					</div>
				</td>	
			</tr>
		</tbody>
	</table>
</script>




<!-- LOCAL navigation table -->
<script type="text/x-template" id="local-navigation-template">
	<table class="table table-bordered table-striped table-hover table-condensed table-sti overflow-x-visible">
		<thead>
			<tr>
				<th v-if="activeToggleSelection"></th>
				<th>{{ $t("message.labelCode", lang) }}</th>
				<th>{{ $t("icd9cm.labelName", lang) }}</th>
				<th v-if="association">{{ $t("message.labelMapping", lang) }}</th>
				<th v-if="tooltipPosition"></th>
			</tr>
		</thead>
		<tbody>
			<tr v-for="(subModel, index) in flatData" v-show="isShown(subModel)" v-bind:class="{
				'success': isAssociated(subModel, side)}" class="mouse-pointer">
				<td v-on:click="toggleAssociationCallback(subModel, side)" v-if="association" v-if="activeToggleSelection">
					<i class="icon-ok"></i>
				</td>
				<td v-bind:class="{
					'padding-left-30': subModel.level == 1,
					'padding-left-60': subModel.level == 2,
					'padding-left-90': subModel.level == 3,
					'padding-left-120': subModel.level == 4,
					'padding-left-150': subModel.level == 5}">
					<span @click="toggle(subModel, index)" class="mouse-pointer">
						<i v-bind:class="{
						'icon-plus': !subModel.open && subModel.hasChildren,
						'icon-minus': subModel.open && subModel.hasChildren}"></i>
					</span>
					<span @click="detailCallback(subModel)">
						{{ subModel.resourceName }}
					</span>
				</td>
        		<td @click="detailCallback(subModel)">
					<span v-if="subModel.designation['NAME_'+lang]">{{ subModel.designation['NAME_'+lang] }}</span>
					<span v-else-if="subModel.designation['CS_DESCRIPTION_'+lang]">{{  subModel.designation['CS_DESCRIPTION_'+lang]}}</span>
					<span v-else-if="lang=='it' && subModel.designation['NAME_en']">{{  subModel.designation['NAME_en']}}</span>
					<span v-else-if="lang=='it'">{{  subModel.designation['CS_DESCRIPTION_en']}}</span>
					<span v-else-if="lang=='en' && subModel.designation['NAME_it']">{{  subModel.designation['NAME_it']}}</span>
					<span v-else-if="lang=='en'">{{  subModel.designation['CS_DESCRIPTION_it']}}</span>
        		</td>
				<td v-if="association">
					<div class="c-tooltip" >
						<i v-if="subModel.hasAssociations" class="icon icon-link" aria-hidden="true"></i>
						<div v-bind:class="tooltipPosition" style="width:250px">
							<div class="text-content">
								<strong> {{$t('message.labelIsAssociated', subModel.defLang) }} </strong>
							</div>
						</div>
					</div>
				</td>
				<td v-if="tooltipPosition">
					<div class="c-tooltip">
						<span class="icon icon-info-sign"></span>
						<div v-bind:class="tooltipPosition">
							<div class="text-content">
								<h5><strong> {{$t("message.labelCode", subModel.defLang) }} {{ subModel.namespace }}: </strong>&nbsp;{{ subModel.resourceName }}</h5>
								<ul>
									<li>
										<strong>{{$t("message.labelCode", subModel.defLang) }}: </strong>&nbsp;{{  subModel.resourceName }}
									</li>
									<li>
										<strong>{{$t("icd9cm.labelName", subModel.defLang) }}: </strong>
										<span v-if="subModel.designation['NAME_'+lang]">{{ subModel.designation['NAME_'+lang] }}</span>
										<span v-else-if="subModel.designation['CS_DESCRIPTION_'+lang]">{{  subModel.designation['CS_DESCRIPTION_'+lang]}}</span>
										<span v-else-if="lang=='it' && subModel.designation['NAME_en']">{{  subModel.designation['NAME_en']}}</span>
										<span v-else-if="lang=='it'">{{  subModel.designation['CS_DESCRIPTION_en']}}</span>
										<span v-else-if="lang=='en' && subModel.designation['NAME_it']">{{  subModel.designation['NAME_it']}}</span>
										<span v-else-if="lang=='en'">{{  subModel.designation['CS_DESCRIPTION_it']}}</span>
									</li>
									<li>
										<strong>{{$t("message.labelVersion", subModel.defLang) }}: </strong>&nbsp;{{ subModel.codeSystemVersion | clearVersionForView}}
									</li>
									<li v-for="(val,field) in subModel.designation" v-if="_.endsWith(field,'_'+lang) && !_.startsWith(field,'CS_') && subModel.designation[field]!==undefined">
										<span v-if="_.startsWith(field, 'DF_D_')"><strong>{{field | clearHeader}}: </strong>&nbsp;{{  moment(subModel.designation[field]).locale('it').format('DD/MM/YYYY') }}</span>
										<span v-else><strong>{{field | clearHeader}}: </strong>&nbsp;{{ subModel.designation[field] }}<span>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</td>	
			</tr>
		</tbody>
	</table>
</script>


<!-- VALUESET navigation table -->
<script type="text/x-template" id="valueset-navigation-template">
	<table class="table table-bordered table-striped table-hover table-condensed table-sti overflow-x-visible">
		<thead>
			<tr>
				<th v-if="activeToggleSelection"></th>
				<th>{{ $t("message.labelCode", lang) }}</th>
				<th>{{ $t("icd9cm.labelName", lang) }}</th>
			</tr>
		</thead>
		<tbody>
			<tr v-for="(subModel, index) in flatData" class="mouse-pointer">
				<td @click="detailCallback(subModel)">
					<span>
						{{ subModel.resourceName }}
					</span>
				</td>
        		<td @click="detailCallback(subModel)">
					<span v-if="subModel.designation['NAME_'+lang]">{{ subModel.designation['NAME_'+lang] }}</span>
					<span v-else-if="subModel.designation['VALUESET_DESCRIPTION_'+lang]">{{  subModel.designation['VALUESET_DESCRIPTION_'+lang]}}</span>
					<span v-else-if="lang=='it' && subModel.designation['NAME_en']">{{  subModel.designation['NAME_en']}}</span>
					<span v-else-if="lang=='it'">{{  subModel.designation['VALUESET_DESCRIPTION_en']}}</span>
					<span v-else-if="lang=='en' && subModel.designation['NAME_it']">{{  subModel.designation['NAME_it']}}</span>
					<span v-else-if="lang=='en'">{{  subModel.designation['VALUESET_DESCRIPTION_it']}}</span>
        		</td>
			</tr>
		</tbody>
	</table>
</script>


<!-- no-result template -->
<script type="text/x-template" id="no-result-template">
	<div class="alert alert-info">{{ $t("message.noResults", lang) }}</div>
</script>

<!-- pagination template -->
<script type="text/x-template" id="pagination-template">
	<div class="pagination pagination-right">
		<ul>
			<li
				v-if="page.currentPage != 0 && page.totalPages > 1"
				v-bind:class="{ disabled : page.currentPage == 0 }"
				v-on:click="executeSearch(lang, page.currentPage -1, pageVar, searchResultsVar)"><a
				href="#">&laquo;</a>
			</li>
			<li v-if="hasPreviousHidePages(pageVar)" class="disabled"><span>...</span></li>
			<li v-for="p in filteredPages(pageVar)"
				v-bind:class="{ active : page.currentPage + 1 == p  }"
				v-on:click="executeSearch(lang, p-1, pageVar, searchResultsVar)"><a href="#">{{p}}</a></li>
				<li v-if="hasNextHidePages(pageVar)" class="disabled"><span>...</span></li>
				<li v-if="hasNextHidePages(pageVar)"><a href="#">{{page.totalPages}}</a>
			</li>
			<li v-if="page.currentPage +1 != page.totalPages "
				v-bind:class="{ disabled : page.currentPage +1 == page.totalPages }"
				v-on:click="executeSearch(lang, page.currentPage + 1, pageVar, searchResultsVar)">
					<a href="#">&raquo;</a>
			</li>
		</ul>
	</div>
</script>

<div id="app">









	<!-- LOINC -->
	<div class="modal modal-hide detail-modal" id="detailModalLoinc">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>
				{{ pageComponents.detailObj.resourceName }}
				({{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.name') }}) - {{ pageComponents.detailObj.info.codeSystemVersion }}
				<span v-bind:class="{
			            'label-important' : pageComponents.detailObj.info.status == 'DEPRECATED',
			            'label-success' : pageComponents.detailObj.info.status == 'ACTIVE' ,
			            'label-warning' : pageComponents.detailObj.info.status == 'DISCOURAGED' }"
					class="label"> {{ $t(buildStatusCode(pageComponents.detailObj.info.status), pageComponents.detailObj.defLang) }} </span>
				<span class="redirect-to" v-if="pageComponents.detailObj.info.mapTo">
					{{ $t("message.redirectedTo", lang) }}
					<a href="#" v-on:click="openLoincDetailModal(pageComponents.detailObj.info.mapToDetails, false)">{{ pageComponents.detailObj.info.mapTo}}</a>
				</span>
			</h3>
														
										 
										 
			<div class="row-fluid">
   			 	<div class="span6"></div>
				<div class="span4 pull-right margin-left-10">
					<div class="row-fluid">
						<button v-if="pageComponents.detailObj.hrefPrev" class="btn btn-primary btn-xs" v-on:click="prevVersion(pageComponents.detailObj,'LOINC')">
							{{ $t("message.labelVersion", lang) }} {{ pageComponents.detailObj.prevVersionName | clearVersionForView}}
						</button>
						<button v-if="pageComponents.detailObj.hrefNext" class="btn btn-primary btn-xs" v-on:click="nextVersion(pageComponents.detailObj,'LOINC')">
							{{ $t("message.labelVersion", lang) }} {{ pageComponents.detailObj.nextVersionName | clearVersionForView}}
						</button>
					</div>
				</div>
			</div>
		</div>
		<div class="modal-body">
			<ul class="nav nav-tabs">
				<li v-bind:class="{ active: detailsTab=='tab-details' }"
					v-on:click="detailsTab='tab-details'"><a href="#tab-details">{{ $t("message.labelDetails", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-additional-info' }" v-on:click="detailsTab='tab-additional-info'">
					<a href="#tab-further-data">{{ $t("message.labelAdditionalInfo", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-units' }" v-on:click="detailsTab='tab-units'">
					<a href="#tab-further-data">{{ $t("message.labelUnits", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-status' }" v-on:click="detailsTab='tab-status'">
					<a href="#translations">{{ $t("message.labelStatus", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-other' }" v-on:click="detailsTab='tab-other'">
					<a href="#translations">{{ $t("message.labelOthers", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-mapping' }" v-on:click="detailsTab='tab-mapping'">
					<a href="#tab-mapping">{{ $t("message.labelMapping", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-versioning' }" v-on:click="detailsTab='tab-versioning'" class="hidden;">
					<a href="#translations">{{ $t("message.labelVersioning", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-hl7specs' }" v-on:click="detailsTab='tab-hl7specs'">
					<a href="#translations">{{ $t("message.labelHL7Specs", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-ontology' }" v-on:click="detailsTab='tab-ontology'" >
					<a href="#translations">{{ $t("message.labelOntology", lang) }}</a>
				</li>

			</ul>

			<div class="tab-content">

				<div class="tab-pane"
					v-bind:class="{ active: detailsTab=='tab-details' }"
					id="tab-details">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail"><strong>{{$t("loinc.labelCode",lang) }} </strong></td>
									<td>{{pageComponents.detailObj.resourceName}}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelComponent", lang) }}</strong></td>
									<td>{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.name') }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("message.labelProperty", lang) }}</strong></td>
									<td>{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.property') }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("message.labelTime", lang) }}</strong></td>
									<td>{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.time') }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("message.labelSystem", lang) }}</strong></td>
									<td>{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.system') }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("message.labelScale", lang) }}</strong></td>
									<td>{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.scale') }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("message.labelMethod", lang) }}</strong></td>
									<td>{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.method') }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("message.labelClass", lang) }}</strong></td>
									<td>{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.class') }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-additional-info"
					v-bind:class="{ active: detailsTab=='tab-additional-info' }">
					<div class="row-fluid">
						<div class="span6">
							<p>
								<strong>{{ $t("message.labelAdditionalInfo", lang) }}</strong>
							</p>
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelLongCommonName", lang) }}</strong></td>
									<td>{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.longCommonName')
										| fallbackstring(pageComponents.detailObj.en.longCommonName)
										}}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelVersionLastChanged", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.versionLastChanged }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelDefinitionDescription", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.definitionDescription
										}}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelOrderObs", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.orderObs }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-units"
					v-bind:class="{ active: detailsTab=='tab-units' }">
					<div class="row-fluid">
						<div class="span6">
							<p>
								<strong>{{ $t("message.labelUnits", lang) }}</strong>
							</p>
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelUnitsRequired", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.unitsRequired }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelExampleUnits", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.exampleUnits }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelExampleUcumUnits", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.exampleUcumUnits }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelExampleSiUcumUnits", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.exampleSiUcumUnits }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-status"
					v-bind:class="{ active: detailsTab=='tab-status' }">
					<div class="row-fluid">
						<div class="span6">
							<p>
								<strong>{{ $t("message.labelStatus", lang) }}</strong>
							</p>
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail"><strong>{{ $t("message.labelStatus", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.status }}</td>
								</tr>
								<tr v-if="pageComponents.detailObj.info.mapTo">
									<td class="td-label-detail">
										<strong>
											{{ $t("message.labelMapTo", lang) }}
										</strong>
									</td>
									<td>
										<a href="#" v-on:click="openLoincDetailModal(pageComponents.detailObj.info.mapToDetails, false)">{{ pageComponents.detailObj.info.mapTo }}</a>
									</td>
								</tr>
								<tr v-if="pageComponents.detailObj.info.mapToComment">
									<td class="td-label-detail">
										<strong>
											{{ $t("message.labelComment", lang) }}
										</strong>
									</td>
									<td>{{ pageComponents.detailObj.info.mapToComment }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelStatusReason", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.statusReason }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelStatusText", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.StatusText }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelChangeReasonPublic", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.changeReasonPublic }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-other"
					v-bind:class="{ active: detailsTab=='tab-other' }">
					<div class="row-fluid">
						<div class="span6">
							<p>
								<strong>{{ $t("message.labelOthers", lang) }}</strong>
							</p>
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCommonTestRank", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.commonTestRank }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCommonOrderRank", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.commonOrderRank }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCommonSiRank", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.commonSiRank }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelAssociatedObservations", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.associatedObservations }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>


				<div class="tab-pane" id="tab-hl7specs" v-bind:class="{ active: detailsTab=='tab-hl7specs' }">
					<div class="row-fluid">
						<div class="span6">
							<p>
								<strong>{{ $t("message.labelHL7Specs", lang) }}</strong>
							</p>
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCode", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.resourceName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCodeSystem", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.codeSystem }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCodeSystemName", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.codeSystemName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCodeSystemVersion", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.codeSystemVersion }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelDisplayName", lang) }}</strong></td>
									<td>{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.name') }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-mapping"
					v-bind:class="{ active: detailsTab=='tab-mapping' }">
					<div class="row-fluid">
						<div class="span6">
							<h4 v-show="pageComponents.detailObj.info.localMappingList && pageComponents.detailObj.info.localMappingList.length > 0">
								{{ $t("message.labelMappingToLocalCode", lang) }}
							</h4>
							<div v-for="localMapping in pageComponents.detailObj.info.localMappingList">
								<h5>
									{{ $t("loinc.labelCodeSystemName", lang) }}:
									{{ $t("message.labelCatalog", lang) }} {{ localMapping.name | clearUnderscore}}
								</h5>
								<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
									<tr>
										<td class="td-label-detail">
											<strong>
												{{ $t("message.labelCode", lang) }}
											</strong>
										</td>
										<td>{{localMapping.code}}</td>
									</tr>
									<tr>
										<td class="td-label-detail">
											<strong>
												{{ $t("message.labelDescription", lang) }}
											</strong>
										</td>
										<td>{{localMapping.description}}</td>
									</tr>
									<tr>
										<td class="td-label-detail">
											<strong>
												{{ $t("message.labelBatteryCode", lang) }}
											</strong>
										</td>
										<td>{{localMapping.batteryCode}}</td>
									</tr>
									<tr>
										<td class="td-label-detail">
											<strong>
												{{ $t("message.labelBatteryDescription", lang) }}
											</strong>
										</td>
										<td>{{localMapping.batteryDescription}}</td>
									</tr>
									<tr>
										<td class="td-label-detail">
											<strong>
												{{ $t("message.labelUnits", lang) }}
											</strong>
										</td>
										<td>{{localMapping.units}}</td>
									</tr>
								</table>
							</div>

							<div v-if="!isEmptyMappingRelations()">
								<h4>{{ $t("message.labelMappingToOtherCodingSystems", lang) }}</h4>
							</div>

							<div v-for="(mappings, key) in pageComponents.mappingToOtherCodingSystems">
								<div v-if="mappings.length > 0">
									<h5>{{ $t("loinc.labelCodeSystemName", lang) }}: {{ key }}</h5>

									<div v-for="mapping in mappings">
										<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
											<tr>
												<td class="td-label-detail"><strong> {{ $t("message.labelCode", lang) }}
												</strong></td>
												<td>
													<a href="#" v-on:click="openDetailByCodeSystem(key, mapping, 'LOINC', 'detailModalLoinc')" v-if="mapping.subject.name !== pageComponents.detailObj.resourceName">{{ mapping.subject.name }}</a>
													<a href="#" v-on:click="openDetailByCodeSystem(key, mapping, 'LOINC', 'detailModalLoinc')" v-else="">{{ mapping.predicate.name }}</a>
												</td>
											</tr>
											<tr>
												<td class="td-label-detail"><strong> {{ $t("message.labelDescription", lang) }} </strong></td>
												<td>
													<span v-if="mapping.subject.name !== pageComponents.detailObj.resourceName">{{ mapping['sourceTitle_' + pageComponents.detailObj.defLang] }}</span>
													<span v-else>{{ mapping['targetTitle_' + pageComponents.detailObj.defLang] }}</span>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- VERSIONING -->
				<div class="tab-pane" id="tab-versioning"
					v-bind:class="{ active: detailsTab=='tab-versioning' }">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelActualVersion", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.info.codeSystemVersion }}</td>
									<td>{{ pageComponents.detailObj.info.releaseDate }}</td>
								</tr>
								<tr v-for="(otherVersion, index) in pageComponents.detailObj.info.otherVersions" v-if="otherVersion.name !== pageComponents.detailObj.info.codeSystemVersion">
									<td class="td-label-detail">
										<strong v-if="index === 0">{{ $t("message.labelOtherVersions", lang) }}</strong>
									</td>
									<td>{{ otherVersion.name }}</td>
									<td>{{ otherVersion.releaseDate }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-ontology"
					v-bind:class="{ active: detailsTab=='tab-ontology' }">
					<div class="row-fluid">
						<div class="span2">
							<a v-bind:href="getLodViewHref"
							class="btn btn-info btn-block" target="_blank">{{ $t("message.labelOpenLodView", lang) }}</a>
						</div>
						<div class="span2">
							<a v-bind:href="getLodLiveHref"
							class="btn btn-info btn-block" target="_blank">{{ $t("message.labelOpenLodLive", lang) }}</a>
						</div>

					</div>

				</div>


			</div>
			<!--End modal body -->

		</div>
		<div class="modal-footer">
			<div class="flag flag-it flag-clickable" alt="Italian" v-if="pageComponents.detailObj.defLang=='en'" v-on:click="pageComponents.detailObj.defLang='it'"></div>
			<div class="flag flag-gb flag-clickable" alt="English" v-if="pageComponents.detailObj.defLang=='it'" v-on:click="pageComponents.detailObj.defLang='en'"></div>
			<!--<a href="#" class="btn btn-primary" data-dismiss="modal">Chiudi</a> -->
		</div>
	</div>
	
	











	<!-- ICD9-CM -->
	<div class="modal modal-hide detail-modal" id="detailModalIcd9Cm">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"
				aria-hidden="true">&times;</button>
			<h3>
				{{ pageComponents.detailObj.resourceName }}
				({{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.name') }}) - {{ pageComponents.detailObj.info.codeSystemVersion }}
			</h3>
			<div class="row-fluid">
   			 	<div class="span6"></div>
				<div class="span4 pull-right margin-left-10">
					<div class="row-fluid">
						<button v-if="pageComponents.detailObj.hrefPrev" class="btn btn-primary btn-xs" v-on:click="prevVersion(pageComponents.detailObj,'ICD9-CM')">
							{{ $t("message.labelVersion", lang) }} {{ pageComponents.detailObj.prevVersionName | clearVersionForView}}
						</button>
						<button v-if="pageComponents.detailObj.hrefNext" class="btn btn-primary btn-xs" v-on:click="nextVersion(pageComponents.detailObj,'ICD9-CM')">
							{{ $t("message.labelVersion", lang) }} {{ pageComponents.detailObj.nextVersionName | clearVersionForView}}
						</button>
					</div>
				</div>
			</div>
		</div>
		<div class="modal-body">
			<ul class="nav nav-tabs">
				<li v-bind:class="{ active: detailsTab=='tab-details' }" v-on:click="detailsTab='tab-details'">
					<a href="#tab-details">{{ $t("message.labelDetails", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-additional-info' }" v-on:click="detailsTab='tab-additional-info'">
					<a href="#additional-info">{{$t("message.labelAdditionalInfo", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-hierarchical-relationships' }" v-on:click="detailsTab='tab-hierarchical-relationships'">
					<a href="#labelHierarchicalRelationships">{{$t("message.labelHierarchicalRelationships", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-mapping' }" v-on:click="detailsTab='tab-mapping'">
					<a href="#translations">{{ $t("message.labelMapping", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-versions' }" v-on:click="detailsTab='tab-versions'">
					<a href="#translations">{{ $t("message.labelVersions", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-hl7-specs' }" v-on:click="detailsTab='tab-hl7-specs'">
					<a href="#translations">{{$t("message.labelHL7Specs", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-ontology' }" v-on:click="detailsTab='tab-ontology'">
					<a href="#translations">{{ $t("message.labelOntology", lang) }}</a>
				</li>
			</ul>

			<div class="tab-content">

				<div class="tab-pane"
					v-bind:class="{ active: detailsTab=='tab-details' }"
					id="tab-details">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail"><strong>{{$t("message.labelCode", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.resourceName}}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{$t("message.labelDescription", lang)}}</strong></td>
									<td>
										{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.description') | fallbackstring(getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.name'))}}
									</td>
								</tr>
								<tr v-for="(otherDescription, index) in getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.otherDescription')">
									<td class="td-label-detail">
										<strong v-if="index === 0">{{ $t("icd9cm.labelOtherDescriptions", lang) }}</strong>
									</td>
									<td>{{ otherDescription }}</td>
								</tr>
								<tr v-for="(include, index) in getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.include')">
									<td class="td-label-detail">
										<strong v-if="index === 0">{{ $t("icd9cm.labelInclusions", lang) }}</strong>
									</td>
									<td>{{ include }}</td>
								</tr>
								<tr v-for="(esclude, index) in getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.esclude')">
									<td class="td-label-detail">
										<strong v-if="index === 0">{{ $t("icd9cm.labelExclusions", lang) }}</strong>
									</td>
									<td>{{ esclude }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-additional-info"
					v-bind:class="{ active: detailsTab=='tab-additional-info' }">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0"
								v-if="getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.note')">
								<tr v-for="note in getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.note')">
									<td>{{ note }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-hierarchical-relationships"
					v-bind:class="{ active: detailsTab=='tab-hierarchical-relationships' }">
					<div class="row-fluid">
						<div class="span-12">
							<!-- RELATIONSHIPS -->
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<thead>
									<th class="span3">{{ $t("message.labelCode", lang) }}</th>
									<th class="span9">{{ $t("message.labelDescription", lang) }}</th>
								</thead>
								<tbody>
									<tr v-for="relationship in pageComponents.detailObj.info.relationships">
										<td v-bind:class="{
											'padding-left-30': relationship.level == 1,
											'padding-left-60': relationship.level == 2,
											'padding-left-90': relationship.level == 3,
											'padding-left-120': relationship.level == 4,
											'padding-left-150': relationship.level == 5}">
											<a href="#" v-if="!relationship.current" v-on:click="openIcd9CmDetailModal(relationship.detailObj, false)">{{ relationship.name }}</a>
											<strong v-else>{{ relationship.name }}</strong>
										</td>
										<td>{{ relationship['name_' + pageComponents.detailObj.defLang] }}</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-hl7-specs"
					v-bind:class="{ active: detailsTab=='tab-hl7-specs' }">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail"><strong>{{ $t("message.labelCode", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.resourceName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCodeSystem", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.codeSystem }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCodeSystemName", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.codeSystemName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCodeSystemVersion", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.codeSystemVersion }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelDisplayName", lang) }}</strong></td>
									<td>{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.name') }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-mapping"
					v-bind:class="{ active: detailsTab=='tab-mapping' }">
					<div class="row-fluid">
						<div class="span-12">
							<!-- CROSS MAPPING -->
							<div v-if="!isEmptyMappingRelations()">
								<h4>{{ $t("message.labelMappingToOtherCodingSystems", lang) }}</h4>
							</div>

							<div v-for="(mappings, key) in pageComponents.mappingToOtherCodingSystems">
								<div v-if="mappings.length > 0">
									<h5>{{ $t("loinc.labelCodeSystemName", lang) }}: {{ key | clearUnderscore}}</h5>

									<div v-for="mapping in mappings">
										<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
											<tr>
												<td class="td-label-detail"><strong> {{ $t("message.labelCode", lang) }}
												</strong></td>
												<td>
													<a href="#" v-on:click="openDetailByCodeSystem(key, mapping, 'ICD9-CM', 'detailModalIcd9Cm')" v-if="mapping.subject.name !== pageComponents.detailObj.resourceName">{{ mapping.subject.name }}</a>
													<a href="#" v-on:click="openDetailByCodeSystem(key, mapping, 'ICD9-CM', 'detailModalIcd9Cm')" v-else="">{{ mapping.predicate.name }}</a>
												</td>
											</tr>
											<tr>
												<td class="td-label-detail"><strong> {{ $t("message.labelDescription", lang) }} </strong></td>
												<td>
													<span v-if="mapping.subject.name !== pageComponents.detailObj.resourceName">{{ mapping['sourceTitle_' + pageComponents.detailObj.defLang] }}</span>
													<span v-else>{{ mapping['targetTitle_' + pageComponents.detailObj.defLang] }}</span>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- VERSIONS -->
				<div class="tab-pane" id="tab-versions"
					v-bind:class="{ active: detailsTab=='tab-versions' }">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelActualVersion", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.info.codeSystemVersion }}</td>
									<td>{{ pageComponents.detailObj.info.releaseDate }}</td>
								</tr>
								<tr v-for="(otherVersion, index) in pageComponents.detailObj.info.otherVersions"
									v-if="otherVersion.name !== pageComponents.detailObj.info.codeSystemVersion">
									<td class="td-label-detail">
										<strong v-if="index === 0">{{ $t("message.labelOtherVersions", lang) }}</strong>
									</td>
									<td>{{ otherVersion.name }}</td>
									<td>{{ otherVersion.releaseDate }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-ontology"
					v-bind:class="{ active: detailsTab=='tab-ontology' }">
					<div class="row-fluid">
						<div class="span2">
							<a v-bind:href="getLodViewHref" class="btn btn-info btn-block" target="_blank">{{ $t("message.labelOpenLodView", lang) }}</a>
						</div>
						<div class="span2">
							<a v-bind:href="getLodLiveHref" class="btn btn-info btn-block" target="_blank">{{ $t("message.labelOpenLodLive", lang) }}</a>
						</div>
					</div>
				</div>
			</div>
			<!--End modal body -->

		</div>
		<div class="modal-footer">
			<div class="flag flag-it flag-clickable" alt="Italian" v-if="pageComponents.detailObj.defLang=='en'" v-on:click="pageComponents.detailObj.defLang='it'"></div>
			<div class="flag flag-gb flag-clickable" alt="English" v-if="pageComponents.detailObj.defLang=='it'" v-on:click="pageComponents.detailObj.defLang='en'"></div>
			<!--<a href="#" class="btn btn-primary" data-dismiss="modal">Chiudi</a> -->
		</div>
	</div>
	
	
	
	

	
	

	<!-- ATC -->
	<div class="modal modal-hide detail-modal" id="detailModalAtc">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"
				aria-hidden="true">&times;</button>
			<h3>
				{{ pageComponents.detailObj.resourceName }} - {{ pageComponents.detailObj.info.name }} - {{ pageComponents.detailObj.info.codeSystemVersion }}
			</h3>
			<div class="row-fluid">
   			 	<div class="span6"></div>
				<div class="span4 pull-right margin-left-10">
					<div class="row-fluid">
						<button v-if="pageComponents.detailObj.hrefPrev" class="btn btn-primary btn-xs" v-on:click="prevVersion(pageComponents.detailObj,'ATC')">
							{{ $t("message.labelVersion", lang) }} {{ pageComponents.detailObj.prevVersionName | clearVersionForView}}
						</button>
						<button v-if="pageComponents.detailObj.hrefNext" class="btn btn-primary btn-xs" v-on:click="nextVersion(pageComponents.detailObj,'ATC')">
							{{ $t("message.labelVersion", lang) }} {{ pageComponents.detailObj.nextVersionName | clearVersionForView}}
						</button>
					</div>
				</div>
			</div>
		</div>
		<div class="modal-body">
			<ul class="nav nav-tabs">
				<li v-bind:class="{ active: detailsTab=='tab-details' }"
					v-on:click="detailsTab='tab-details'"><a href="#tab-details">{{ $t("message.labelDetails", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-hierarchical-relationships' }" v-on:click="detailsTab='tab-hierarchical-relationships'">
					<a href="#labelHierarchicalRelationships">{{$t("message.labelHierarchicalRelationships", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-mapping' }" v-on:click="detailsTab='tab-mapping'">
					<a href="#translations">{{ $t("message.labelMapping", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-versions' }" v-on:click="detailsTab='tab-versions'">
					<a href="#translations">{{ $t("message.labelVersions", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-hl7-specs' }" v-on:click="detailsTab='tab-hl7-specs'">
					<a href="#translations">{{$t("message.labelHL7Specs", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-ontology' }" v-on:click="detailsTab='tab-ontology'">
					<a href="#translations">{{ $t("message.labelOntology", lang) }}</a>
				</li>
			</ul>

			<div class="tab-content">

				<div class="tab-pane"
					v-bind:class="{ active: detailsTab=='tab-details' }"
					id="tab-details">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelAtcCode", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.resourceName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelDenomination", lang) }}</strong>
									</td>
									<td>
										{{ pageComponents.detailObj.info.name }}
									</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelAnatomicalGroup", lang) }}</strong>
									</td>
									<td>
										{{ pageComponents.detailObj.info.gruppoAnatomico }}
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-hierarchical-relationships"
					v-bind:class="{ active: detailsTab=='tab-hierarchical-relationships' }">
					<div class="row-fluid">
						<div class="span-12">
							<!-- RELATIONSHIPS -->
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<thead>
									<th class="span3">{{ $t("message.labelCode", lang) }}</th>
									<th class="span9">{{ $t("message.labelDescription", lang) }}</th>
								</thead>
								<tbody>
									<tr v-for="relationship in pageComponents.detailObj.info.relationships">
										<td v-bind:class="{
											'padding-left-30': relationship.level == 1,
											'padding-left-60': relationship.level == 2,
											'padding-left-90': relationship.level == 3,
											'padding-left-120': relationship.level == 4,
											'padding-left-150': relationship.level == 5}">
											<a href="#" v-if="!relationship.current" v-on:click="openAtcDetailModal(relationship.detailObj, false)">{{ relationship.name }}</a>
											<strong v-else>{{ relationship.name }}</strong>
										</td>
										<td>{{ relationship['name_' + pageComponents.detailObj.defLang] }} {{ relationship.level }}</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-hl7-specs"
					v-bind:class="{ active: detailsTab=='tab-hl7-specs' }">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail"><strong>{{ $t("message.labelCode", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.resourceName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCodeSystem", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.codeSystem }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCodeSystemName", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.codeSystemName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCodeSystemVersion", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.codeSystemVersion }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelDisplayName", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.name }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-mapping"
					v-bind:class="{ active: detailsTab=='tab-mapping' }">
					<div class="row-fluid">
						<div class="span-12">
							<!-- CROSS MAPPING -->
							<div v-if="!isEmptyMappingRelations()">
								<h4>{{ $t("message.labelMappingToOtherCodingSystems", lang) }}</h4>
							</div>

							<div v-for="(mappings, key) in pageComponents.mappingToOtherCodingSystems">
								<div v-if="mappings.length > 0">
									<h5>{{ $t("loinc.labelCodeSystemName", lang) }}: {{ key | clearUnderscore}}</h5>

									<div v-for="mapping in mappings">
										<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
											<tr>
												<td class="td-label-detail"><strong> {{ $t("message.labelCode", lang) }}
												</strong></td>
												<td>
													<a href="#" v-on:click="openDetailByCodeSystem(key, mapping, 'ATC', 'detailModalAtc')" v-if="mapping.subject.name !== pageComponents.detailObj.resourceName">{{ mapping.subject.name }}</a>
													<a href="#" v-on:click="openDetailByCodeSystem(key, mapping, 'ATC', 'detailModalAtc')" v-else="">{{ mapping.predicate.name }}</a>
												</td>
											</tr>
											<tr>
												<td class="td-label-detail"><strong> {{ $t("message.labelDescription", lang) }} </strong></td>
												<td>
													<span v-if="mapping.subject.name !== pageComponents.detailObj.resourceName">{{ mapping['sourceTitle_' + pageComponents.detailObj.defLang] }}</span>
													<span v-else>{{ mapping['targetTitle_' + pageComponents.detailObj.defLang] }}</span>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- VERSIONS -->
				<div class="tab-pane" id="tab-versions"
					v-bind:class="{ active: detailsTab == 'tab-versions' }">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelActualVersion", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.info.codeSystemVersion }}</td>
									<td>{{ pageComponents.detailObj.info.releaseDate }}</td>
								</tr>
								<tr v-for="(otherVersion, index) in pageComponents.detailObj.info.otherVersions"
									v-if="otherVersion.name !== pageComponents.detailObj.info.codeSystemVersion">
									<td class="td-label-detail">
										<strong v-if="index === 0">{{ $t("message.labelOtherVersions", lang) }}</strong>
									</td>
									<td>{{ otherVersion.name }}</td>
									<td>{{ otherVersion.releaseDate }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-ontology"
					v-bind:class="{ active: detailsTab=='tab-ontology' }">
					<div class="row-fluid">
						<div class="span2">
							<a v-bind:href="getLodViewHref" class="btn btn-info btn-block" target="_blank">{{ $t("message.labelOpenLodView", lang) }}</a>
						</div>
						<div class="span2">
							<a v-bind:href="getLodLiveHref" class="btn btn-info btn-block" target="_blank">{{ $t("message.labelOpenLodLive", lang) }}</a>
						</div>
					</div>
				</div>
			</div>
			<!--End modal body -->

		</div>
		<div class="modal-footer">
			<div class="flag flag-it flag-clickable" alt="Italian" v-if="pageComponents.detailObj.defLang=='en' && (itIsPresent && enIsPresent)" v-on:click="pageComponents.detailObj.defLang='it'"></div>
			<div class="flag flag-gb flag-clickable" alt="English" v-if="pageComponents.detailObj.defLang=='it' && (itIsPresent && enIsPresent)" v-on:click="pageComponents.detailObj.defLang='en'"></div>
			<!--<a href="#" class="btn btn-primary" data-dismiss="modal">Chiudi</a> -->
		</div>
	</div>

	
	
	
	
	
	
	

	<!-- AIC -->
	<div class="modal modal-hide detail-modal" id="detailModalAic">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"
				aria-hidden="true">&times;</button>
			<h3>
				{{ pageComponents.detailObj.resourceName }} -
				{{ pageComponents.detailObj.info.name }}*{{ pageComponents.detailObj.info.confezione }} - {{ pageComponents.detailObj.info.codeSystemVersion }}
			</h3>
			
			 <div class="row-fluid">
   			 	<div class="span6"></div>
				<div class="span4 pull-right margin-left-10">
					<div class="row-fluid">
						<button v-if="pageComponents.detailObj.hrefPrev" class="btn btn-primary btn-xs" v-on:click="prevVersion(pageComponents.detailObj,'AIC')">
							{{ $t("message.labelVersion", lang) }} {{ pageComponents.detailObj.prevVersionName | clearVersionForView}}
						</button>
						<button v-if="pageComponents.detailObj.hrefNext" class="btn btn-primary btn-xs" v-on:click="nextVersion(pageComponents.detailObj,'AIC')">
							{{ $t("message.labelVersion", lang) }} {{ pageComponents.detailObj.nextVersionName | clearVersionForView}}
						</button>
					</div>
				</div>
			</div>
		</div>
		<div class="modal-body">
			<ul class="nav nav-tabs">
				<li v-bind:class="{ active: detailsTab=='tab-details' }" v-on:click="detailsTab='tab-details'">
					<a href="#tab-details">{{ $t("message.labelDetails", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-additional-info' }" v-on:click="detailsTab='tab-additional-info'">
					<a href="#labelAdditionalInfo">{{ $t("message.labelAdditionalInfo", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-units' }" v-on:click="detailsTab='tab-units'">
					<a href="#labelUnits">{{ $t("message.labelUnits", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-mapping' }" v-on:click="detailsTab='tab-mapping'">
					<a href="#translations">{{ $t("message.labelMapping", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-versions' }" v-on:click="detailsTab='tab-versions'">
					<a href="#translations">{{ $t("message.labelVersions", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-hl7-specs' }" v-on:click="detailsTab='tab-hl7-specs'">
					<a href="#translations">{{ $t("message.labelHL7Specs", lang) }}</a>
				</li>
			</ul>

			<div class="tab-content">

				<div class="tab-pane"
					v-bind:class="{ active: detailsTab=='tab-details' }"
					id="tab-details">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelAicCode", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.resourceName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelDenomination", lang) }}</strong>
									</td>
									<td>
										{{ pageComponents.detailObj.info.name }}
									</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelPackage", lang) }}</strong>
									</td>
									<td>
										{{ pageComponents.detailObj.info.confezione }}
									</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelActiveIngredient", lang) }}</strong>
									</td>
									<td>
										{{ pageComponents.detailObj.info.principioAttivo }}
									</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelAtcCode", lang) }}</strong>
									</td>
									<td>
										<span v-if="pageComponents.detailObj.info.codiceAtc">{{ pageComponents.detailObj.info.codiceAtc }}</span>
										<span v-else>{{ $t("message.labelNotPresent", pageComponents.detailObj.defLang) }}</span>
									</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelClass", lang) }}</strong>
									</td>
									<td>
										{{ pageComponents.detailObj.info.classe }}
									</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelCompany", lang) }}</strong>
									</td>
									<td>
										{{ pageComponents.detailObj.info.ditta }}
									</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelEquivalenceGroupCode", lang) }}</strong>
									</td>
									<td>
										{{ pageComponents.detailObj.info.codiceGruppoEq }}
									</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelEquivalenceGroupDescription", lang) }}</strong>
									</td>
									<td>
										{{ pageComponents.detailObj.info.descrGruppoEq }}
									</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelCubicMetersOxygen", lang) }}</strong>
									</td>
									<td>
										{{ pageComponents.detailObj.info.metriCubiOssigeno }}
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-additional-info"
					v-bind:class="{ active: detailsTab=='tab-additional-info' }">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelRetailPrice", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.info.prezzoAlPubblico }}</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelExFactoryPrice", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.info.prezzoExFactory }}</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelMaximumSalePrice", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.info.prezzoMassimoCessione }}</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelInAifaTransparencyList", lang) }}</strong>
									</td>
									<td>{{ $t(pageComponents.detailObj.info.inListaTrasparenzaAifa, pageComponents.detailObj.defLang) }}</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelOnlyInTheRegionList", lang) }}</strong>
									</td>
									<td>{{ $t(pageComponents.detailObj.info.inListaRegione, pageComponents.detailObj.defLang) }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-units"
					v-bind:class="{ active: detailsTab=='tab-units' }">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelDosageUnit", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.info.unitaPosologica }}</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelPricePerDosageUnit", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.info.prezzoUnitaPosologica }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-hl7-specs"
					v-bind:class="{ active: detailsTab=='tab-hl7-specs' }">
					<div class="row-fluid">
						<div class="span6">
							<!-- AIC -->
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail"><strong>{{ $t("message.labelAicCode", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.resourceName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCodeSystem", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.codeSystem }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCodeSystemName", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.codeSystemName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelCodeSystemVersion", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.codeSystemVersion }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("loinc.labelDisplayName", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.name }}*{{ pageComponents.detailObj.info.confezione }}</td>
								</tr>
							</table>

							<!-- ATC -->
							<!--
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail"><strong>{{
											$t("message.labelAtcCode",
											pageComponents.detailObj.defLang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.codiceAtc }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{
											$t("loinc.labelCodeSystem",
											pageComponents.detailObj.defLang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.atcCodeSystem }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{
											$t("loinc.labelCodeSystemName",
											pageComponents.detailObj.defLang) }}</strong></td>
									<td>{{ $t("message.labelAtc", pageComponents.detailObj.defLang) }}</td>
								</tr>
							</table>
							-->
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-mapping"
					v-bind:class="{ active: detailsTab=='tab-mapping' }">
					<div class="row-fluid">
						<div class="span-12">
							<!-- CROSS MAPPING -->
							<div v-if="!isEmptyMappingRelations()">
								<h4>{{ $t("message.labelMappingToOtherCodingSystems", lang) }}</h4>
							</div>

							<div v-for="(mappings, key) in pageComponents.mappingToOtherCodingSystems">
								<div v-if="mappings.length > 0">
									<h5>{{ $t("loinc.labelCodeSystemName", lang) }}: {{ key | clearUnderscore}}</h5>

									<div v-for="mapping in mappings">
										<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
											<tr>
												<td class="td-label-detail"><strong> {{ $t("message.labelCode", lang) }}
												</strong></td>
												<td>
													<a href="#" v-on:click="openDetailByCodeSystem(key, mapping, 'AIC', 'detailModalAic')" v-if="mapping.subject.name !== pageComponents.detailObj.resourceName">{{ mapping.subject.name }}</a>
													<a href="#" v-on:click="openDetailByCodeSystem(key, mapping, 'AIC', 'detailModalAic')" v-else="">{{ mapping.predicate.name }}</a>
												</td>
											</tr>
											<tr>
												<td class="td-label-detail"><strong> {{ $t("message.labelDescription", lang) }} </strong></td>
												<td>
													<span v-if="mapping.subject.name !== pageComponents.detailObj.resourceName">{{ mapping['sourceTitle_' + pageComponents.detailObj.defLang] }}</span>
													<span v-else>{{ mapping['targetTitle_' + pageComponents.detailObj.defLang] }}</span>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- VERSIONS -->
				<div class="tab-pane" id="tab-versions"
					v-bind:class="{ active: detailsTab == 'tab-versions' }">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelActualVersion", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.info.codeSystemVersion }}</td>
									<td>{{ pageComponents.detailObj.info.releaseDate }}</td>
								</tr>
								<tr v-for="(otherVersion, index) in pageComponents.detailObj.info.otherVersions"
									v-if="otherVersion.name !== pageComponents.detailObj.info.codeSystemVersion">
									<td class="td-label-detail">
										<strong v-if="index === 0">{{ $t("message.labelOtherVersions", lang) }}</strong>
									</td>
									<td>{{ otherVersion.name }}</td>
									<td>{{ otherVersion.releaseDate }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
			<!--End modal body -->

		</div>
		<div class="modal-footer">
			<div class="flag flag-it flag-clickable" alt="Italian" v-if="pageComponents.detailObj.defLang=='en' && (itIsPresent && enIsPresent)" v-on:click="pageComponents.detailObj.defLang='it'"></div>
			<div class="flag flag-gb flag-clickable" alt="English" v-if="pageComponents.detailObj.defLang=='it' && (itIsPresent && enIsPresent)" v-on:click="pageComponents.detailObj.defLang='en'"></div>
			<!--<a href="#" class="btn btn-primary" data-dismiss="modal">Chiudi</a> -->
		</div>
	</div>
	
	
	
	
	
	

	
	
		<!-- STANDARD/LOCAL -->
	<div class="modal modal-hide detail-modal"  id="detailModalStandardLocal">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			
			<h3>
				{{ pageComponents.detailObj.resourceName }} - {{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.description') }} - {{ pageComponents.detailObj.info.codeSystemVersion | clearVersionForView(pageComponents.detailObj.info.namespace)}}
			</h3>
			    
   			 <div class="row-fluid">
   			 	<div class="span6"></div>
				<div class="span4 pull-right margin-left-10">
					<div class="row-fluid">
						<button v-if="pageComponents.detailObj.hrefPrev" class="btn btn-primary btn-xs" v-on:click="prevVersion(pageComponents.detailObj)">
							{{ $t("message.labelVersion", lang) }} {{ pageComponents.detailObj.prevVersionName | clearVersionForView}}
						</button>
						<button v-if="pageComponents.detailObj.hrefNext" class="btn btn-primary btn-xs" v-on:click="nextVersion(pageComponents.detailObj)">
							{{ $t("message.labelVersion", lang) }} {{ pageComponents.detailObj.nextVersionName | clearVersionForView}}
						</button>
					</div>
				</div>
			</div>
		</div>
		<div class="modal-body">
			<ul class="nav nav-tabs">
				<li v-bind:class="{ active: detailsTab=='tab-details' }" v-on:click="detailsTab='tab-details'">
					<!-- <a href="#tab-details">{{ $t("message.labelDetails", pageComponents.detailObj.defLang) }}</a> -->
					<a href="#tab-details">{{ $t("message.labelDetails", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-additional-info' }" v-on:click="detailsTab='tab-additional-info'">
					<!-- <a href="#labelAdditionalInfo">{{$t("message.labelAdditionalInfo", pageComponents.detailObj.defLang) }}</a> -->
					<a href="#labelAdditionalInfo">{{$t("message.labelAdditionalInfo", lang) }}</a>
				</li>
				<li v-if="pageComponents.detailObj.info.isClassification" v-bind:class="{ active: detailsTab=='tab-hierarchical-relationships' }" v-on:click="detailsTab='tab-hierarchical-relationships'">
					<!-- <a href="#labelHierarchicalRelationships">{{$t("message.labelHierarchicalRelationships", pageComponents.detailObj.defLang) }}</a>-->
					<a href="#labelHierarchicalRelationships">{{$t("message.labelHierarchicalRelationships", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-mapping' }" v-on:click="detailsTab='tab-mapping'">
					<!-- <a href="#translations">{{ $t("message.labelMapping", pageComponents.detailObj.defLang) }}</a>-->
					<a href="#translations">{{ $t("message.labelMapping", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-versions' }" v-on:click="detailsTab='tab-versions'">
					<!-- <a href="#translations">{{ $t("message.labelVersions", pageComponents.detailObj.defLang) }}</a>-->
					<a href="#translations">{{ $t("message.labelVersions", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-hl7specs' }" v-on:click="detailsTab='tab-hl7specs'">
					<!-- <a href="#translations">{{ $t("message.labelHL7Specs", pageComponents.detailObj.defLang) }}</a>-->
					<a href="#translations">{{ $t("message.labelHL7Specs", lang) }}</a>
				</li>
				<li v-bind:class="{ active: detailsTab=='tab-ontology' }" v-on:click="detailsTab='tab-ontology'" >
					<!-- <a href="#translations">{{ $t("message.labelOntology", pageComponents.detailObj.defLang) }}</a>-->
					<a href="#translations">{{ $t("message.labelOntology", lang) }}</a>
				</li>
			</ul>

			<div class="tab-content">

				<div class="tab-pane" v-bind:class="{ active: detailsTab=='tab-details' }" id="tab-details">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelCode", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.resourceName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelDescription", lang) }}</strong>
									</td>
									<td>
										{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.description') }}
									</td>
								</tr>
								<tr v-if="pageComponents.detailObj.defLang==additionalInfo.lang" v-for="(additionalInfo, key) in pageComponents.detailObj.info.additionalInfo" :key="key">
									<td class="td-label-detail">
										<strong>{{ additionalInfo.key | clearUnderscore}}</strong>
									</td>
									<td>{{ additionalInfo.value }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="tab-pane" id="tab-additional-info" v-bind:class="{ active: detailsTab=='tab-additional-info' }">
					<div class="row-fluid">
						
						<div class="span6">
<!-- 							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0"> -->
<!-- 						  		<tbody> -->
<!-- 						  			<tr v-if="pageComponents.detailObj.defLang==additionalInfo.lang" v-for="(additionalInfo, key) in pageComponents.detailObj.info.additionalInfo" :key="key"> -->
<!-- 										<td class="td-label-detail"> -->
<!-- 											<strong>{{ additionalInfo.key }}</strong> -->
<!-- 										</td> -->
<!-- 										<td>{{ additionalInfo.value }}</td> -->
<!-- 									</tr> -->
<!-- 								</tbody> -->
<!-- 							</table> -->
						</div>
					</div>
				</div>
				
				<div class="tab-pane" id="tab-hierarchical-relationships"
					v-bind:class="{ active: detailsTab=='tab-hierarchical-relationships' }"
					v-if="pageComponents.detailObj.info.isClassification">
					<div class="row-fluid">
						<div class="span-12">
							<!-- RELATIONSHIPS -->
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<thead>
									<th class="span3">{{ $t("message.labelCode", lang) }}</th>
									<th class="span9">{{ $t("message.labelDescription", lang) }}</th>
								</thead>
								<tbody>
									<tr v-for="relationship in pageComponents.detailObj.info.relationships">
										<td v-bind:class="{
											'padding-left-30': relationship.level == 1,
											'padding-left-60': relationship.level == 2,
											'padding-left-90': relationship.level == 3,
											'padding-left-120': relationship.level == 4,
											'padding-left-150': relationship.level == 5}">
											<a href="#" v-if="!relationship.current" v-on:click="openStandardLocalDetailModal(relationship.detailObj, false, true)">{{ relationship.name }}</a>
											<strong v-else>{{ relationship.name }}</strong>
										</td>
										<td>{{ relationship['name_' + pageComponents.detailObj.defLang] }}</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				
				
				
				<div class="tab-pane" id="tab-hl7specs" v-bind:class="{ active: detailsTab=='tab-hl7specs' }">
					<div class="row-fluid">
						<div class="span6">
							<p>
								<strong>{{ $t("message.labelHL7Specs", lang) }}</strong>
							</p>
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail"><strong>{{ $t("message.labelCode", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.resourceName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("valueset.labelOid", lang) }}</strong></td>
									<td>{{ pageComponents.detailObj.info.csOid }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("valueset.labelName", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.codeSystemName }}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("valueset.labelVersion", lang) }}</strong></td>
									<td>{{pageComponents.detailObj.info.codeSystemVersion | clearVersionForView(pageComponents.detailObj.info.namespace)}}</td>
								</tr>
								<tr>
									<td class="td-label-detail"><strong>{{ $t("valueset.labelDisplayName", lang) }}</strong></td>
									<td>{{ getValue(pageComponents.detailObj, pageComponents.detailObj.defLang + '.description') }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
				
				
				
				
				
				
				
				

				<div class="tab-pane" id="tab-mapping" v-bind:class="{ active: detailsTab=='tab-mapping' }">
					<div class="row-fluid">
						<div class="span-12">
							<!-- CROSS MAPPING -->
							<div v-if="!isEmptyMappingRelations()">
								<h4>{{ $t("message.labelMappingToOtherCodingSystems", lang) }}</h4>
							</div>

							<div v-for="(mappings, key) in pageComponents.mappingToOtherCodingSystems">
								<div v-if="mappings.length > 0">
									<h5>{{ $t("loinc.labelCodeSystemName", lang) }}: {{ key | clearUnderscore}}</h5>

									<div v-for="mapping in mappings">
										<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
											<tr>
												<td class="td-label-detail">
													<strong> {{ $t("message.labelCode", lang) }} </strong>
												</td>
												<td>
													<a href="#" v-on:click="openDetailByCodeSystem(key, mapping, pageComponents.detailObj.info.namespace, 'detailModalStandardLocal')" v-if="mapping.subject.name !== pageComponents.detailObj.resourceName">{{ mapping.subject.name }}</a>
													<a href="#" v-on:click="openDetailByCodeSystem(key, mapping, pageComponents.detailObj.info.namespace, 'detailModalStandardLocal')" v-else="">{{ mapping.predicate.name }}</a>
												</td>
											</tr>
											<tr>
												<td class="td-label-detail">
													<strong> {{ $t("message.labelDescription", lang) }} </strong>
												</td>
												<td>
													<span v-if="mapping.subject.name !== pageComponents.detailObj.resourceName">{{ mapping['sourceTitle_' + pageComponents.detailObj.defLang] }}</span>
													<span v-else>{{ mapping['targetTitle_' + pageComponents.detailObj.defLang] }}</span>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- VERSIONS -->
				<div class="tab-pane" id="tab-versions"
					v-bind:class="{ active: detailsTab == 'tab-versions' }">
					<div class="row-fluid">
						<div class="span6">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<tr>
									<td class="td-label-detail">
										<strong>{{ $t("message.labelActualVersion", lang) }}</strong>
									</td>
									<td>{{ pageComponents.detailObj.info.codeSystemVersion | clearVersionForView(pageComponents.detailObj.info.namespace)}}</td>
									<td>{{ pageComponents.detailObj.info.releaseDate }}</td>
								</tr>
								<tr v-for="(otherVersion, index) in pageComponents.detailObj.info.otherVersions"
									v-if="otherVersion.name !== pageComponents.detailObj.info.codeSystemVersion">
									<td class="td-label-detail">
										<strong v-if="index === 0">{{ $t("message.labelOtherVersions", pageComponents.detailObj.defLang) }}</strong>
									</td>
									<td>{{ otherVersion.name | clearVersionForView(pageComponents.detailObj.info.namespace) }}</td>
									<td>{{ otherVersion.releaseDate }}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
				
				<div class="tab-pane" id="tab-ontology" v-bind:class="{ active: detailsTab=='tab-ontology' }">
					<div class="row-fluid" v-if=" pageComponents.detailObj.info.hasOntology=='Y'">
						<div class="span2">
							<a v-bind:href="getLodViewHref" class="btn btn-info btn-block" target="_blank">
								{{ $t("message.labelOpenLodView", lang) }}
							</a>
						</div>
						<div class="span2">
							<a v-bind:href="getLodLiveHref" class="btn btn-info btn-block" target="_blank">
								{{ $t("message.labelOpenLodLive", lang) }}
							</a>
						</div>
					</div>

				</div>
			</div>
			<!--End modal body -->

		</div>
		<div class="modal-footer">
<!-- 			<div class="flag flag-it flag-clickable" alt="Italian" v-if="pageComponents.detailObj.defLang=='en'" v-on:click="pageComponents.detailObj.defLang='it'"></div> -->
<!-- 			<div class="flag flag-gb flag-clickable" alt="English" v-if="pageComponents.detailObj.defLang=='it' && pageComponents.detailObj.info.type!='LOCAL'" v-on:click="pageComponents.detailObj.defLang='en'"></div> -->
			<div class="flag flag-it flag-clickable" alt="Italian" v-if="pageComponents.detailObj.defLang=='en' && (itIsPresent && enIsPresent)" v-on:click="pageComponents.detailObj.defLang='it'"></div>
			<div class="flag flag-gb flag-clickable" alt="English" v-if="pageComponents.detailObj.defLang=='it' && (itIsPresent && enIsPresent)" v-on:click="pageComponents.detailObj.defLang='en'"></div>
			<!--<a href="#" class="btn btn-primary" data-dismiss="modal">Chiudi</a> -->
		</div>
	</div>
	
	
	
	
	

	<!-- Top menu -->
	<ul class="nav nav-tabs">
		<li v-bind:class="{ active: selectedMode == 'navigation' }" v-on:click="selectedMode = 'navigation'; changeSelectedMode(); handleNavigationSubsection(); selectedCsType = 'STANDARD_NATIONAL_STATIC'; selectFirstCodeSystemAsNavigationStandard();">
			<a href="#tab-navigation">{{ $t("message.labelResourceNavigations", lang) }}</a>
		</li>
		<li v-bind:class="{ active: selectedMode == 'normal' }" v-on:click="selectedMode = 'normal'; changeSelectedMode();">
			<a href="#tab-normal">{{ $t("message.labelSearch", lang) }}</a>
		</li>
		<li v-if="isCrossMappingSti()" v-bind:class="{ active: selectedMode == 'cross-mapping' }" v-on:click="selectedMode = 'cross-mapping'; changeSelectedMode(); changeLeftCodeSystem(); changeRightCodeSystem()">
			<a href="#tab-cross-mapping">{{ $t("message.labelCrossMapping", lang) }}</a>
		</li>
		<li v-bind:class="{ active: selectedMode == 'export' }" v-on:click="selectedMode = 'export'; changeSelectedMode(); selectFirstCodeSystemAsExport('codesystem-group-1');">
			<a href="#tab-export">{{ $t("message.labelExportAction", lang) }}</a> 
		</li>
	</ul>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	<div class="tab-content">
		<!-- ###############################################################-->
		<!-- ##################### TAB NAVIGAZIONE RISORSE  ################-->
		<!-- ###############################################################-->
		<div class="tab-pane" v-bind:class="{ active: selectedMode == 'navigation' }" id="tab-navigation-disabled">
			<div class="row-fluid">
			
			
				<div class="span4">
					<!-- Navigation tabs -->
					
<!-- 					<ul class="nav nav-pills"> -->
<!-- 						<li v-bind:class="{ active: navigationMode == 'code-system' }"  v-on:click="selectFirstCodeSystemAsNavigationStandard();"> -->
<!-- 							<a href="#tab-navigation-code-system">{{ $t("loinc.labelCodeSystem", lang) }}</a> -->
<!-- 						</li> -->
<!-- 						<li v-bind:class="{ active: navigationMode == 'value-set' }" -->
<!-- 							v-on:click="loadValueSets(); selectFirstValueSetAsNavigationStandard(); "> -->
<!-- 							<a href="#tab-navigation-value-set">{{ $t("message.labelValueSet", lang) }}</a> -->
<!-- 						</li> -->
<!-- 						<li v-bind:class="{ active: navigationMode == 'mapping' }" -->
<!-- 							v-on:click="navigationMode = 'mapping'; goToMappingNavigationMode(); loadVersions()"> -->
<!-- 							<a href="#tab-navigation-mapping">{{ $t("message.labelMapping", lang) }}</a> -->
<!-- 						</li> -->
<!-- 					</ul> -->


					<div class="row-fluid" >
						<ul class="c_dropdown nav nav-pills">
							<li class="c_dropdown_item"  title='Seleziona una tipologia'>
							  <a v-bind:class="{ c_dropdown_active: navigationMode == 'code-system' }">{{ $t("message.labelCodeSystem", lang) }}</a>
							  <div class="c_dropdown_item_list">
							    <a href="#tab-navigation-code-system" v-bind:class="{ c_dropdown_active: subNavigationMode == 'codesystem-group-1' }" v-on:click="selectFirstCodeSystemAsNavigationStandard('codesystem-group-1');">{{ $t("message.labelCodeSystemStandardNational", lang) }}</a>
							    <a href="#tab-navigation-code-system" v-bind:class="{ c_dropdown_active: subNavigationMode == 'codesystem-group-2' }" v-on:click="selectFirstCodeSystemAsNavigationStandard('codesystem-group-2');">{{ $t("message.labelCodeSystemLocals", lang) }}</a>
							  </div>
							</li> 
							<li class="c_dropdown_item">
							 	<a href="#tab-navigation-value-set" v-bind:class="{ c_dropdown_active: navigationMode == 'value-set' }" v-on:click="loadValueSets(); selectFirstValueSetAsNavigationStandard();">{{ $t("message.labelValueSet", lang) }}</a>
							</li> 
							<li class="c_dropdown_item"  title='Seleziona una tipologia'>
							  <a  v-bind:class="{ c_dropdown_active: navigationMode == 'mapping' }">{{ $t("message.labelMapping", lang) }}</a>
							   <div class="c_dropdown_item_list">
							    <a href="#tab-navigation-mapping" v-bind:class="{ c_dropdown_active: subNavigationMode == 'mapping-group-1' }" v-on:click=" goToMappingNavigationMode('mapping-group-1'); initilizeLoincMappingNavigation();">{{ $t("message.labelMappingG1", lang) }}</a>
							    <a href="#tab-navigation-mapping" v-bind:class="{ c_dropdown_active: subNavigationMode == 'mapping-group-2' }" v-on:click=" goToMappingNavigationMode('mapping-group-2'); loadVersions()">{{ $t("message.labelMappingG2", lang) }}</a>
							  </div>
							</li> 
						</ul>
					</div>
					  
					


					<div class="row-fluid"  v-show="navigationMode == 'code-system' || navigationMode == 'value-set' || navigationMode == 'mapping'">
						<div class="form-group">
							<label for="selectDomain"><strong>{{ $t("message.labelDomain", lang) }}</strong></label>
							<select class="form-control" v-model="localSearchFormDomain" v-on:change="codeSystemDomainFilter()" style="min-width: 50%">
								<option value="TUTTI">TUTTI</option>
								<option v-for="option in domains" v-bind:value="option.value">{{option.label}}</option>
							</select>
						</div>
					</div>
					
					
					<div class="form-group">
						<label class="text-primary">{{ getLabelFromSubNavigationMode }}</label>
					</div>
					
					
					
					<div class="tab-content">
						<!-- ################### LEFT CODE-SYSTEM ####################-->
						<div class="tab-pane" id="tab-navigation-code-system-disabled" v-bind:class="{ active: navigationMode == 'code-system' }">
							<div class="row-fluid">
								<div class="span12">
									<div v-show="subNavigationMode=='codesystem-group-1'">
									  <ul class="nav nav-pills nav-stacked">
											<li v-bind:class="{ active: loincSearchForm.selectedNavigationStandard == 'ICD9-CM' }"
												v-on:click="loincSearchForm.selectedNavigationStandard = 'ICD9-CM'; changeCodeSystem()"
												v-if="localSearchFormDomain=='TUTTI' || localSearchFormDomain=='salute'">
												<a href="#tab-navigation-code-system-ICD9-CM">{{ $t("message.labelIcd9Cm", lang) }}</a>
											</li>
											<li v-bind:class="{ active: loincSearchForm.selectedNavigationStandard == 'LOINC' }"
												v-on:click="loincSearchForm.selectedNavigationStandard = 'LOINC'; changeCodeSystem()"
												v-if="localSearchFormDomain=='TUTTI' || localSearchFormDomain=='salute'">
												<a href="#tab-navigation-code-system-loinc">{{ $t("message.labelLoinc", lang) }}</a>
											</li>
											<li v-bind:class="{ active: loincSearchForm.selectedNavigationStandard == 'ATC' }"
												v-on:click="loincSearchForm.selectedNavigationStandard = 'ATC'; changeCodeSystem()"
												v-if="localSearchFormDomain=='TUTTI' || localSearchFormDomain=='salute'">
												<a href="#tab-navigation-code-system-atc">{{ $t("message.labelAtc", lang) }}</a>
											</li>
											<li v-bind:class="{ active: loincSearchForm.selectedNavigationStandard == 'AIC' }"
												v-on:click="loincSearchForm.selectedNavigationStandard = 'AIC'; changeCodeSystem()"
												v-if="localSearchFormDomain=='TUTTI' || localSearchFormDomain=='salute'">
												<a href="#tab-navigation-code-system-aic">{{ $t("message.labelAic", lang) }}</a>
											</li>
											
											
											<li v-for="code in localsCode" 
												v-if=" _.indexOf(codeSystemsNotStandardLocal, code.members.codeSystemName.value)==-1 
														&& code.members.type.value == 'STANDARD_NATIONAL'
														&& (localSearchFormDomain=='TUTTI' || code.members.domain.value==localSearchFormDomain)"
												v-bind:class="{ active: loincSearchForm.selectedNavigationStandard == code.members.codeSystemName.value }"
												v-on:click="changeCodeSystemLocal(code)">
												<a href="#tab-navigation-code-system-local">{{ code.members.codeSystemName.value | clearUnderscore}}</a>
											</li>
									  </ul>
									</div>
									
									
									<div v-show="subNavigationMode=='codesystem-group-2'">
									  <ul class="nav nav-pills nav-stacked">
											<li v-for="code in localsCode" 
												v-if=" _.indexOf(codeSystemsNotStandardLocal, code.members.codeSystemName.value)==-1 && code.members.type.value == 'LOCAL'
												&& (localSearchFormDomain=='TUTTI' || code.members.domain.value==localSearchFormDomain)"
												v-bind:class="{ active: loincSearchForm.selectedNavigationStandard == code.members.codeSystemName.value }"
												v-on:click="changeCodeSystemLocal(code)">
												<a href="#tab-navigation-code-system-local">{{ code.members.codeSystemName.value | clearUnderscore }}</a>
											</li>
									  </ul>
									</div>
								</div>
							</div>
						</div>
						
						
						<!-- ################### LEFT VALUE-SET #########################-->
						<div class="tab-pane" id="tab-navigation-value-set-disabled" v-bind:class="{ active: navigationMode == 'value-set' }">
							
							<div class="row-fluid">
								<div class="span12">
									<div class="">
									  <ul class="nav nav-pills nav-stacked">
											<li v-for="code in valueSets" v-bind:class="{ active: loincSearchForm.selectedNavigationStandard == code.members.valueSetName.value }"
												v-on:click="changeValueSet(code)"
												v-if="localSearchFormDomain=='TUTTI' || code.members.domain.value==localSearchFormDomain">
												<a href="#tab-navigation-value-set-list">{{ code.members.valueSetName.value | clearUnderscore}}</a>
											</li>
									  </ul>
									</div>
								</div>
							</div>
							
						</div>
						
						
						<!-- ################### LEFT MAPPING #########################-->
						<div class="tab-pane" id="tab-navigation-mapping-disabled" v-bind:class="{ active: navigationMode == 'mapping' }">
							<div class="row-fluid">
								<div class="span12">
									<div v-show="subNavigationMode=='mapping-group-1'">
										<ul class="nav nav-pills nav-stacked">
											<li v-bind:class="{ active: loincSearchForm.selectedMappingStandard == 'LOINC' }"
												v-on:click="initilizeLoincMappingNavigation();"
												v-if="localSearchFormDomain=='TUTTI' || localSearchFormDomain=='salute'">
												<a href="#tab-navigation-mapping-loinc">{{ $t("message.labelMappingG1", lang) }}</a>
											</li>
										</ul>
									</div>
									
									<div v-show="subNavigationMode=='mapping-group-2'">
											<ul class="nav nav-pills nav-stacked">
											<li v-bind:class="{ active: loincSearchForm.selectedMappingStandard == 'ATC' }"
												v-on:click="loincSearchForm.selectedMappingStandard = 'ATC'; loadVersions()"
												v-if="localSearchFormDomain=='TUTTI' || localSearchFormDomain=='salute'">
												<a href="#tab-navigation-mapping-atc">{{ $t("message.labelAtc", lang) }} - {{ $t("message.labelAic", lang) }}</a>
											</li>


											<li v-for="mapping in mappingList"
												v-bind:class="{ active: loincSearchForm.selectedMappingStandard == 'mapping-' + mapping.fullname }"
												v-on:click="loincSearchForm.selectedMappingStandard = 'mapping-' + mapping.fullname; executeMappingSearchNavigatorByButton(lang,0);"
												v-if="localSearchFormDomain=='TUTTI' || localSearchFormDomain==mapping.domainSrc || localSearchFormDomain==mapping.domainTrg">
												<a href="#tab-navigation-mapping-general">{{ mapping.fullname | clearNameMapping | clearUnderscore}}</a>
											</li>
											
										</ul>
									</div>
								</div>
								
									
							</div>
						</div>
					</div>
				</div>
				
				
				
				
				

				
				<div class="span8">
					<div class="row-fluid " v-if="navigationMode == 'code-system' || navigationMode == 'value-set'">
						<div class="row-fluid" >
							<h4 v-if="navigationMode == 'code-system'">{{ $t('loinc.labelCodeSystem', lang) }} {{ loincSearchForm.selectedNavigationStandard | clearUnderscore}}</h4>
							<h4 v-if="navigationMode == 'value-set'">{{ $t('message.labelValueSet', lang) }} {{ loincSearchForm.selectedNavigationStandard | clearUnderscore }}</h4>
						</div>
						<div class="row-fluid">
														
						
							<div class="span3">
								<div class="form-group">
									<label for="selectVersion"><strong>{{ $t("message.labelVersion", lang) }}</strong></label>
									
									<select id="selectVersion" class="form-control" v-model="loincSearchForm.version"
										v-on:change="executeSearchByButton(lang, 0)" v-show="selectedCsType == 'STANDARD_NATIONAL_STATIC' || navigationMode == 'value-set'">
										<option v-for="version in versions" v-bind:value="version.value">
											{{ version.label | clearVersionForView}}
										</option>
									</select>
									
									<select id="selectVersion" class="form-control" v-model="localSearchFormVersion"
										v-on:change="executeSearchByButton(lang, 0)" v-show="selectedCsType == 'STANDARD_NATIONAL' || selectedCsType == 'LOCAL'">
										<option v-for="version in localCsVersions" v-bind:value="version.name">
											{{ version.name | clearVersionForView}}
										</option>
									</select>
									
								</div>
							</div>
						</div>

						<div class="tab-content">
							<div class="tab-pane margin-top-10" id="tab-navigation-code-system-disabled"  
								v-bind:class="{ active: loincSearchForm.selectedNavigationStandard == 'ICD9-CM' }">
								<no-result v-if="searchExecuted && pageComponents.loincSearchResults.length == 0" :lang="lang"> </no-result>
								<div v-if="searchExecuted && pageComponents.loincSearchResults.length > 0">
									<icd9-cm-navigation-table
										:model="pageComponents.loincSearchResults" :lang="lang" :search-url="getSearchUrl"
										:headers="[$t('message.labelCode', lang), $t('message.labelDescription', lang), '']"
										:detail-callback="openIcd9CmDetailModal" :association="false" :toggle-association-callback="emptyFunction"
										:is-associated="emptyFunction" :side="''" :show-loading="showLoading" :hide-loading="hideLoading" >
									</icd9-cm-navigation-table>

									<pagination :page="pageComponents.page" :lang="lang" :execute-search="executeSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
									</pagination>
								</div>
							</div>
							
							
							<div class="tab-pane margin-top-10" id="tab-navigation-code-system-disabled" 
								v-bind:class="{ active: loincSearchForm.selectedNavigationStandard == 'LOINC' }">
								<no-result v-if="searchExecuted && pageComponents.loincSearchResults.length == 0" :lang="lang"> </no-result>

								<div v-if="searchExecuted && pageComponents.loincSearchResults.length > 0">
									<table
										class="table table-bordered table-striped table-hover table-condensed table-sti">
										<thead>
											<tr>
												<th>{{ $t("loinc.labelCode", lang) }}</th>
												<th>{{ $t("loinc.labelComponent", lang) }}</th>
												<!-- <th>{{ $t("message.labelVersion", lang) }}</th> -->
											</tr>
										</thead>
										<tbody>
											<tr v-for="searchResult in pageComponents.loincSearchResults"
												class="mouse-pointer" v-on:click="openLoincDetailModal(searchResult)">
												<td><i class="icon-warning-sign red" v-if="searchResult.designation.MAP_TO"></i>
													{{ searchResult.resourceName }}
												</td>
												<td>{{ searchResult.designation['COMPONENT_'+searchResult.defLang] }}</td>
												<!-- <td>{{ searchResult.codeSystemVersion }}</td> -->
											</tr>
										</tbody>
									</table>

									<pagination :page="pageComponents.page" :lang="lang" :execute-search="executeSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
									</pagination>
								</div>
							</div>
							
							
							<div class="tab-pane margin-top-10" id="tab-navigation-code-system-disabled" 
							v-bind:class="{ active: loincSearchForm.selectedNavigationStandard == 'ATC' }">
								<no-result v-if="searchExecuted && pageComponents.loincSearchResults.length == 0" :lang="lang"> </no-result>
								<div v-if="searchExecuted && pageComponents.loincSearchResults.length > 0">
									<atc-navigation
										:model="pageComponents.loincSearchResults" :lang="lang" :search-url="getSearchUrl"
										:headers="[$t('message.labelCode', lang), $t('message.labelDescription', lang)]"
										:detail-callback="openAtcDetailModal" :association="false" :toggle-association-callback="emptyFunction"
										:is-associated="emptyFunction" :side="''" :show-loading="showLoading" :hide-loading="hideLoading">
									</atc-navigation>

									<pagination :page="pageComponents.page" :lang="lang" :execute-search="executeSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
									</pagination>
								</div>
							</div>
							
							
							<div class="tab-pane margin-top-10" id="tab-navigation-code-system-disabled" v-bind:class="{ active: loincSearchForm.selectedNavigationStandard == 'AIC' }">
								<no-result v-if="searchExecuted && pageComponents.loincSearchResults.length == 0" :lang="lang"> </no-result>
								<div v-if="searchExecuted && pageComponents.loincSearchResults.length > 0">
									<aic-navigation :results="pageComponents.loincSearchResults" :is-associated="isAssociated"
										:toggle-association="toggleAssociation" :association="false" :open-detail="openAicDetailModal" :lang="lang"
										:side="''">
									</aic-navigation>

									<pagination :page="pageComponents.page" :lang="lang" :execute-search="executeSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
									</pagination>
								</div>
							</div>
							
							<div class="tab-pane margin-top-10" id="tab-navigation-code-system-disabled" v-bind:class="{ active: (selectedCsType == 'STANDARD_NATIONAL' || selectedCsType == 'LOCAL') }">
								<no-result v-if="searchExecuted && pageComponents.loincSearchResults.length == 0" :lang="lang"> </no-result>
								<div v-if="searchExecuted && pageComponents.loincSearchResults.length > 0">
									
									<p v-if="pageComponents.domain!=''"><strong>{{ $t('message.labelDomain', lang) }}:</strong> {{pageComponents.domain}}</p>
									<p v-if="pageComponents.organization!=''"><strong>{{ $t('message.labelOrganization', lang) }}:</strong> {{pageComponents.organization}}</p>
									<p v-if="pageComponents.description!=''"><strong>{{ $t('message.labelDescription', lang) }}:</strong> {{pageComponents.description}}</p>
								
									<local-navigation v-if="selectedCsType == 'STANDARD_NATIONAL' || selectedCsType == 'LOCAL'"
											:model="pageComponents.loincSearchResults" :lang="lang" :search-url="getSearchUrl"
						          			:detail-callback="openStandardLocalDetailModal" :association="false" :toggle-association-callback="toggleAssociation"
											:is-associated="isAssociated" :side="'left'" :active-toggle-selection="false"
											:show-loading="showLoading" :hide-loading="hideLoading">
						        	</local-navigation>
								</div>
								<pagination :page="pageComponents.page" :lang="lang" :execute-search="executeSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
								</pagination>
							</div>
							
							
							
							<div class="tab-pane margin-top-10" id="tab-navigation-value-set-list-disabled" v-bind:class="{ active: selectedCsType == 'VALUE_SET' }">
								<no-result v-if="searchExecuted && pageComponents.loincSearchResults.length == 0" :lang="lang"> </no-result>
								<div v-if="searchExecuted && pageComponents.loincSearchResults.length > 0">
								
									<p v-if="pageComponents.domain!=''"><strong>{{ $t('message.labelDomain', lang) }}:</strong> {{pageComponents.domain}}</p>
									<p v-if="pageComponents.organization!=''"><strong>{{ $t('message.labelOrganization', lang) }}:</strong> {{pageComponents.organization}}</p>
									<p v-if="pageComponents.description!=''"><strong>{{ $t('message.labelDescription', lang) }}:</strong> {{pageComponents.description}}</p>
								
									<valueset-navigation v-if="selectedCsType == 'VALUE_SET'"
											:model="pageComponents.loincSearchResults" :lang="lang" :search-url="getSearchUrl"
						          			:detail-callback="openStandardLocalDetailModal" :association="true" side="'left'" :active-toggle-selection="false"
											:show-loading="showLoading" :hide-loading="hideLoading">
						        	</valueset-navigation>
								</div>
								<pagination :page="pageComponents.page" :lang="lang" :execute-search="executeSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
								</pagination>
							</div>
							
						</div>
					</div>





					<!-- Local code system -->
					<div v-if="navigationMode == 'mapping'">
						<div class="tab-content">

							<!-- LOINC -->
							<div class="tab-pane margin-top-10" id="tab-navigation-code-system-disabled" 
								v-bind:class="{ active: loincSearchForm.selectedMappingStandard == 'LOINC' }">
								<h4>{{ $t('message.labelSelectLoincVersion', lang) }}</h4>
								
								<label>Seleziona una delle segueti versioni:</label>	
								<ul class="nav nav-pills" v-if="versions.length > 0">
									<li v-for="version in versions" v-if="version.value != -1"
										v-bind:class="{ active: loincSearchForm.version == version.value }"
										v-on:click="loincSearchForm.version = version.value; changeLoincMappingVersion();">
										<a href="#tab-navigation-local-code-system">{{ version.label | clearVersionForView}}</a>
									</li>
								</ul>


								<div  v-if="localCodeSystems.length > 0" >
									<label v-if="localCodeSystems.length > 0">
										{{ $t('message.labelSelectOneLocalCodeSystem', lang) }}
									</label>
									
									<select class="form-control" v-model="loincSearchForm.selectedLocalCodeSystem"  v-on:change="changeLocalCodeSystem();" style="min-width: 50%;">	
										<option v-for="localCodeSystem in localCodeSystems" v-bind:value="localCodeSystem.value">
											Catalogo locale {{ localCodeSystem.value | clearUnderscore}}
										</option>
									</select>

								</div>

								<div v-if="localCodes.length > 0 && searchExecuted">
									<h5>{{ loincSearchForm.selectedLocalCodeSystem | clearUnderscore}} - {{ $t('message.labelLoinc', lang) }}</h5>
									<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
										<thead>
											<tr>
												<th>{{ $t('message.localCodeLabel', lang) }}</th>
												<th>{{ $t('message.localDescription', lang) }}</th>
												<th>{{ $t('loinc.labelCode', lang) }}</th>
												<th>{{ $t('message.labelBatteryCode', lang) }}</th>
												<th>{{ $t('message.labelBatteryDescription', lang) }}</th>
												<th>{{ $t('message.labelUnits', lang) }}</th>
											</tr>
										</thead>
										<tbody>
											<tr v-for="localCode in localCodes" v-on:click="openLoincDetailModal(localCode.detailObj)" class="mouse-pointer">
												<td>{{ localCode.localCode }}</td>
												<td>{{ localCode.localDescription }}</td>
												<td>{{ localCode.resourceName }}</td>
												<td>{{ localCode.batteryCode }}</td>
												<td>{{ localCode.batteryDescription }}</td>
												<td>{{ localCode.units }}</td>
											</tr>
										</tbody>
									</table>
								</div>

								<no-result v-if="localCodes.length === 0 && searchExecuted"></no-result>
							</div>

							<!-- AIC -->
							<div class="tab-pane margin-top-10" id="tab-navigation-code-system-disabled"
								v-bind:class="{ active: loincSearchForm.selectedMappingStandard == 'AIC' || loincSearchForm.selectedMappingStandard == 'ATC' }">
								<ul class="nav nav-pills" v-if="versions.length > 0">
									<li v-for="version in versions" v-if="version.value != -1"
										v-bind:class="{ active: loincSearchForm.version == version.value }"
										v-on:click="loincSearchForm.version = version.value; changeLocalCodeSystem();">
										<a href="#tab-navigation-mapping-atc">{{ version.label | clearVersionForView}}</a>
									</li>
								</ul>

								<div v-if="localCodes.length > 0 && searchExecuted">
									<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
										<thead>
											<tr>
												<th>{{ $t('message.labelAtcCode', lang) }}</th>
												<th>{{ $t('message.labelActiveIngredient', lang) }}</th>
												<th>{{ $t('message.labelAicCode', lang) }}</th>
												<th>{{ $t('message.labelDenomination', lang) }}</th>
												<th>{{ $t('message.labelPackage', lang) }}</th>
												<th>{{ $t('message.labelMedicineType', lang) }}</th>
											</tr>
										</thead>
										<tbody>
											<tr v-for="localCode in localCodes" v-on:click="openAtcDetailModal(localCode.detailObj)" class="mouse-pointer">
												<td>{{ localCode.CODICE_ATC }}</td>
												<td>{{ localCode.PRINCIPIO_ATTIVO }}</td>
												<td>{{ localCode.CODICE_AIC }}</td>
												<td>{{ localCode.DENOMINAZIONE }}</td>
												<td>{{ localCode.CONFEZIONE }}</td>
												<td>{{ localCode.TIPO_FARMACO }}</td>
											</tr>
										</tbody>
									</table>

									<pagination :page="pageComponents.page" :lang="lang" :execute-search="executeLocalCodesSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
									</pagination>
								</div>
								<no-result v-if="localCodes.length === 0 && searchExecuted"></no-result>
							</div>






							<!-- MAPPING -->
							<div class="tab-pane margin-top-10" id="tab-navigation-code-system-disabled"
								v-for="mapping in mappingList"
								v-bind:class="{ active: loincSearchForm.selectedMappingStandard == 'mapping-' + mapping.fullname}"
								v-if="loincSearchForm.selectedMappingStandard == 'mapping-' + mapping.fullname">

								<ul class="nav nav-pills">
									<li class="active ">
										<a href="#tab-navigation-mapping-general">
											{{ (loincSearchForm.selectedMappingStandard.replace('mapping-','')) | clearNameMapping | clearUnderscore }}
										</a>
									</li>
								</ul>
								
								<div v-if="localCodes.length > 0 && searchExecuted">
								
									<h5 v-if="mapping.description!==undefined">{{ $t('message.labelDescription', lang) }}: {{mapping.description}}</h5>
									<h5 v-if="mapping.organization!==undefined">{{ $t('message.labelOrganization', lang) }}: {{mapping.organization}}</h5>
									<!-- <h5 v-if="mapping.releaseDate!==undefined">{{ $t('message.labelReleaseDate', lang) }}: {{moment(mapping.releaseDate).locale('it').format('DD/MM/YYYY')}}</h5> -->
								
								
									<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
										<thead>
											<tr>
												<th>{{ $t('message.labelCodeSystemCode', lang) }} 1</th>
												<th>{{ $t('message.labelDescriptionCodeSystemCode', lang) }} 1</th>
												<th>{{ $t('message.labelCodeSystemCode', lang) }} 2</th>
												<th>{{ $t('message.labelDescriptionCodeSystemCode', lang) }} 2</th>
											</tr>
										</thead>
										<tbody>
											<tr v-for="localCode in localCodes" v-on:click="openDetailByCodeSystem(localCode.namespace, localCode, 'key')" class="mouse-pointer">
												<td>{{ localCode.subject.name }}</td>
												<td>{{ localCode.sourceTitle[lang] }}</td>
												<td>{{ localCode.predicate.name }}</td>
												<td>{{ localCode.targetTitle[lang] }}</td>
											</tr>
										</tbody>
									</table>
									
									<pagination :page="pageComponents.page" :lang="langSearch" :execute-search="executeMappingSearchNavigatorByButton" 
										:page-var="'page'" :search-results-var="'mappingList'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
									</pagination>
									
								</div>
								<no-result v-if="localCodes.length === 0 && searchExecuted"></no-result>
							</div>
							
							
						</div>
					</div>
					
					
					
					
				</div>
			</div>
		</div>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
		
		
		<!-- ###############################################################-->
		<!-- ##################### TAB RICERCA  ############################-->
		<!-- ###############################################################-->
		<div class="tab-pane" id="tab-normal-disabled" v-bind:class="{ active: selectedMode == 'normal' }">
		
			<div class="row-fluid">
				<div class="span6">
					<div class="form-group">
						<label for="typeSearch">
							{{ $t("message.labelSelectTypeSearch", lang) }}
						</label>
						<select id="typeSearch" class="form-control" v-model="loincSearchForm.typeSearch" v-on:change="changeTypeSearch">
							<option value="CODESYSTEM">CodeSystem</option>
		        			<option value="VALUESET">ValueSet</option>
							<option value="MAPPING">Mapping</option>
						</select>
					</div>
				</div>
			</div>		
		
		
		
			<!-- START CODE SYSTEM SEARCH	-->
			<div v-show="loincSearchForm.typeSearch == 'CODESYSTEM'">
				<div class="row-fluid">
					<div class="span6">
						<div class="form-group">
							
							<label for="selectedSearchStandardCodeSystem">{{ $t("message.labelSelectCodeSystem", lang) }}</label>
							<select id="selectedSearchStandardCodeSystem" class="form-control"  v-model="loincSearchForm.selectedSearchStandardCodeSystem" v-on:change="changeCodeSystemSearchSelect">
								<option value="TUTTI">TUTTI</option>
								<option v-for="cs in codeSystemsRemote" v-bind:value="cs.name">
									{{ cs.name | clearUnderscore}}
								</option>
							</select>
							
						</div>
					</div>
				</div>
	
				<div class="row-fluid">
					<label for="">{{ $t("message.labelLanguage", lang) }}</label>
					<label class="radio inline">
						<input type="radio" name="optionsRadios" value="it" v-model="langSearch"> ITA
					</label>
					<label class="radio inline">
						<input type="radio" name="optionsRadios" value="en" v-model="langSearch"> ENG
					</label>
				</div>
	
				<div class="row-fluid margin-top-10">
					<div class="span9">
						<label for="textQuery">{{ $t("message.labelMatchValue", lang) }}</label>
						<input type="text" id="textQuery" class="width-99" v-model="loincSearchForm.matchValue"
							placeholder="Es. Immunoglobulina sierica , somministrato">
					</div>
				</div>
	
				<div class="row-fluid">
					<div class="span3" v-show="loincSearchForm.selectedSearchStandardCodeSystem != '-1' && loincSearchForm.selectedSearchStandardCodeSystem != 'TUTTI'">
						<div class="form-group">
							<label for="normalSelectVersion">{{ $t("message.labelVersion", lang) }}</label>
							<select id="normalSelectVersion" class="form-control"
								v-model="loincSearchForm.normalVersion">
								<option v-for="version in versions" v-bind:value="version.value">
									{{ version.label | clearVersionForView}}
								</option>
							</select>
						</div>
					</div>
				</div>
				
				
				<!-- START  FILTER -->
				<div class="row-fluid top-buffer">
					<div class="row-fluid" v-show="loincSearchForm.selectedSearchStandardCodeSystem != 'TUTTI'">
						<div class="span9">
							<div class="row-fluid">
								<div class="span2">
									<button class="btn btn-info btn-block" v-on:click="jQuery('#collapseFilter').slideToggle(400);" >
										{{ $t("message.labelAdvancedSearch", lang) }}
									</button>
									<br>
								</div>
							</div>
						</div>
					</div>
					
					
					<div class="row-fluid" id="collapseFilter" style="display:none">
						<!-- START LOINC FORM -->
						<div class="searchForm" v-show="loincSearchForm.selectedSearchStandardCodeSystem == 'LOINC'">
							<div class="row-fluid">
								<div class="span2">
									<div class="form-group">
										<label for="selectStatus">{{ $t("message.labelStatus", lang) }}</label>
										<select id="selectStatus" class="form-control" v-model="loincSearchForm.status">
											<option v-for="status in statuses" v-bind:value="status.value">
												{{ status.label }}
											</option>
										</select>
									</div>
								</div>
				
								<div class="span2">
									<div class="form-group">
										<label for="selectClass">{{ $t("message.labelClass", lang) }}</label>
										<select id="selectClass" class="form-control" v-model="loincSearchForm.class">
											<option v-for="classItem in classes" v-bind:value="classItem.value">
												{{ classItem.label }}
											</option>
										</select>
									</div>
								</div>
								
								<div class="span2">
									<div class="form-group">
										<label for="selectScale">{{ $t("message.labelScale", lang) }}</label>
										<select id="selectScale" class="form-control" v-model="loincSearchForm.scale">
											<option v-for="scale in scales" v-bind:value="scale.value">
												{{ scale.label }}
											</option>
										</select>
									</div>
								</div>
								
								<div class="span2">
									<div class="form-group">
										<label for="selectSystem">{{ $t("message.labelSystem", lang) }}</label>
										<select id="selectSystem" class="form-control" v-model="loincSearchForm.system">
											<option v-for="system in systems" v-bind:value="system.value">
												{{ system.label }}
											</option>
										</select>
									</div>
								</div>
							</div>
						
						
							<div class="row-fluid">
								<div class="span2">
									<div class="form-group">
										<label for="selectProperty">{{ $t("message.labelProperty", lang) }}</label>
										<select id="selectProperty" class="form-control" v-model="loincSearchForm.property">
											<option v-for="property in properties" v-bind:value="property.value">
												{{ property.label }}
											</option>
										</select>
									</div>
								</div>
			
								<div class="span2">
									<div class="form-group">
										<label for="selectMethod">{{ $t("message.labelMethod", lang) }}</label>
										<select id="selectMethod" class="form-control" 	v-model="loincSearchForm.method">
											<option v-for="method in methods" v-bind:value="method.value">
												{{ method.label }}
											</option>
										</select>
									</div>
								</div>
								
								<div class="span2">
									<div class="form-group">
										<label for="selectTime">{{ $t("message.labelTime", lang) }}</label>
										<select id="selectTime" class="form-control" v-model="loincSearchForm.time">
											<option v-for="time in times" v-bind:value="time.value">
												{{ time.label }}
											</option>
										</select>
									</div>
								</div>
							</div>
							
						</div>
						<!-- END LOINC FORM -->
			
			
						<!-- START ICD9-CM -->
						<div class="searchForm" v-show="loincSearchForm.selectedSearchStandardCodeSystem == 'ICD9-CM'">
							<div class="row-fluid">
								<div class="span6">
									<div class="form-group">
										<label for="selectChapter">{{ $t("message.labelChapter", lang) }}</label>
										<select id="selectChapter" class="form-control max-width" v-model="loincSearchForm.chapter">
											<option v-for="chapter in chapters" v-bind:value="chapter.value">
												{{ chapter.label }}
											</option>
										</select>
									</div>
								</div>
							</div>
						</div>
						<!-- END ICD9-CM -->
			
						<!-- START ATC -->
						<div class="searchForm" v-show="loincSearchForm.selectedSearchStandardCodeSystem == 'ATC'">
							<div class="row-fluid">
								<div class="span3">
									<div class="form-group">
										<label for="selectAnatomicalGroup">{{ $t("message.labelAnatomicalGroup", lang) }}</label>
										<select id="selectAnatomicalGroup" class="form-control"
											v-model="loincSearchForm.anatomicalGroup">
											<option v-for="anatomicalGroup in anatomicalGroups" v-bind:value="anatomicalGroup.value">
												{{ anatomicalGroup.label }}
											</option>
										</select>
									</div>
								</div>
							</div>
						</div>
						<!-- END ATC -->
			
						<!-- START AIC -->
						<div class="searchForm" v-show="loincSearchForm.selectedSearchStandardCodeSystem == 'AIC'">
							<div class="row-fluid">
								<div class="span3">
									<div class="form-group">
										<label for="selectActivePrinciple">{{ $t("message.labelActiveIngredient", lang) }}</label>
										<select id="selectActivePrinciple" class="form-control"
											v-model="loincSearchForm.activePrinciple">
											<option v-for="activePrinciple in activePrinciples" v-bind:value="activePrinciple.value">
												{{ activePrinciple.label }}
											</option>
										</select>
									</div>
								</div>
								<div class="span3">
									<div class="form-group">
										<label for="selectCompany">{{ $t("message.labelCompany", lang) }}</label>
										<select id="selectCompany" class="form-control"
											v-model="loincSearchForm.company">
											<option v-for="company in companies" v-bind:value="company.value">
												{{ company.label }}
											</option>
										</select>
									</div>
								</div>
			
								<div class="span3">
									<div class="form-group">
										<label for="selectAicClass">{{ $t("message.labelClass", lang) }}</label>
										<select id="selectAicClass" class="form-control"
											v-model="loincSearchForm.class">
											<option v-for="classItem in classes" v-bind:value="classItem.value">
												{{ classItem.label }}
											</option>
										</select>
									</div>
								</div>
							</div>
						</div>
						<!-- END AIC -->
						
						
						<!-- START LOCAL FILTER -->
						<div class="searchForm"  v-show="currentCsSelectedIsClassification && _.indexOf(codeSystemsNotStandardLocal, loincSearchForm.selectedSearchStandardCodeSystem)==-1 ">
							<div class="row-fluid" >
								<div class="span6">
									<div class="form-group">
										<label for="selectChapter">{{ $t("message.labelChapter", lang) }}</label>
										<select id="selectChapter" class="form-control max-width" v-model="loincSearchForm.chapter">
											<option v-for="chapter in chapters" v-bind:value="chapter.value">
												{{ chapter.label }}
											</option>
										</select>
									</div>
								</div>
							</div>
						</div>
						
						
						<div class="searchForm" v-show="_.indexOf(codeSystemsNotStandardLocal, loincSearchForm.selectedSearchStandardCodeSystem)==-1 && this.dynamicHeaderTable.length>0">
							<div class="row-fluid">
								<div class="span12">
									<div class="form-group">
										<local-filter
											:dynamic-fields="dynamicHeaderTable" :element-form="loincSearchForm" :lang="langSearch" 
											:get-values="getListOfValuesForField" :dynamic-field-value="loincSearchForm.dynamicFieldValue" >
										</local-filter>
									</div>
								</div>
							</div>
						</div>
						<!-- END LOCAL FILTER -->											
					</div>
				</div>
				<!-- END FILTER -->
				
	
	
			
				<!-- Buttons search -->
				<div class="row-fluid" v-show="selectedMode != 'cross-mapping' && loincSearchForm.selectedSearchStandardCodeSystem != -1">
					<div class="span9">
						<div class="row-fluid">
							<div class="span2 pull-right margin-left-10">
								<button class="btn btn-primary btn-block" v-on:click="executeSearchByButton(langSearch, 0)">{{ $t("message.labelSearch", lang) }}</button>
							</div>
							<div class="span2 pull-right">
								<button class="btn btn-block" v-on:click="resetLoincForm()">Reset</button>
							</div>
						</div>
					</div>
				</div>
	
	
				<!-- Buttons export -->
				<div class="row-fluid" v-show="selectedMode != 'cross-mapping' && loincSearchForm.selectedSearchStandardCodeSystem !== 'TUTTI'">
					<div class="span9">
						<div class="row-fluid">
							<!-- Format -->
							<div class="control-group">
								<label for="">{{ $t("message.labelFormat", lang) }}</label>
								<label class="radio inline">
									<input type="radio" name="exportFormat" id="exportFormatJson" value="json" v-model="exportFormat" :disabled="disableExportOnSearch">
										{{ $t("message.labelJsonFormat", lang) }}
								</label>
								<label class="radio inline">
									<input type="radio" name="exportFormat" id="exportFormatCsv" value="csv" v-model="exportFormat" :disabled="disableExportOnSearch">
										{{ $t("message.labelCsvFormat", lang) }}
								</label>
							</div>
							
							<div class="span2">
								<button class="btn btn-block" v-on:click="executeSearchExportByButton(langSearch)" :disabled="disableExportOnSearch">
									{{ $t("message.labelExportAction", lang) }} 
								</button>
							</div>
						</div>
					</div>
				</div>
	
	
				
				<div id="results-div">
					<!--TAB RESULT LIST -->
					<div class="row-fluid" v-if="loincSearchForm.selectedSearchStandardCodeSystem === 'TUTTI'">
						<ul class="nav nav-tabs"  >
							<li v-for="cs in codeSystemsRemote" v-bind:value="cs.name" v-if="_.indexOf(codeSystemsNotStandardLocal, cs.name)!=-1"
								v-bind:class="{ active: loincSearchForm.selectedMultiStandardCodeSystem == cs.name  }"
								v-on:click="loincSearchForm.selectedMultiStandardCodeSystem = cs.name; changeMultiStandard();">
								<a href="#tab-normal-{{ cs.name | lowercase}}" >{{ cs.name | clearUnderscore}}</a>
							</li>
							
							<li v-for="cs in codeSystemsRemote" v-bind:value="cs.name" v-if="_.indexOf(codeSystemsNotStandardLocal, cs.name)==-1"
								v-bind:class="{ active: loincSearchForm.selectedMultiStandardCodeSystem == cs.name  }"
								v-on:click="loincSearchForm.selectedMultiStandardCodeSystem = cs.name; changeMultiStandard();">
								<a href="#tab-normal-local" >{{ cs.name | clearUnderscore }}</a>
							</li>
						</ul>
						
						
						<div class="tab-content">
							<div class="tab-pane" id="tab-normal-icd9-cm-disabled"  v-bind:class="{ active: loincSearchForm.selectedMultiStandardCodeSystem == 'ICD9-CM' }">
								<!-- ICD9-CM -->
								<div class="row-fluid">
									<no-result :lang="lang"
										v-if="pageComponents.loincSearchResults && pageComponents.loincSearchResults.length == 0 && searchExecuted">
									</no-result>
								</div>
								<div v-if="pageComponents.loincSearchResults.length > 0">
									<icd9-cm-table :results="pageComponents.loincSearchResults" :open-detail="openIcd9CmDetailModal" :lang="langSearch"
										:change-language-property="changeLanguageProperty">
									</icd9-cm-table>
	
									<pagination :page="pageComponents.page" :lang="langSearch" :execute-search="executeSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
									</pagination>
								</div>
							</div>
						</div>
						
						<div class="tab-content">
							<div class="tab-pane" id="tab-normal-loinc-disabled" v-bind:class="{ active: loincSearchForm.selectedMultiStandardCodeSystem == 'LOINC' }">
								<!-- LOINC -->
								<div class="row-fluid">
									<no-result :lang="lang"
										v-if="pageComponents.loincSearchResults && pageComponents.loincSearchResults.length == 0 && searchExecuted">
									</no-result>
								</div>
	
								<div v-if="pageComponents.loincSearchResults.length > 0">
									<loinc-table :results="pageComponents.loincSearchResults" :open-detail="openLoincDetailModal" :lang="langSearch"
										:change-language-property="changeLanguageProperty" :build-status-code="buildStatusCode">
									</loinc-table>
	
									<pagination :page="pageComponents.page" :lang="langSearch" :execute-search="executeSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
									</pagination>
								</div>
							</div>
						</div>
						
						<div class="tab-content">
							<div class="tab-pane" id="tab-normal-aic-disabled" v-bind:class="{ active: loincSearchForm.selectedMultiStandardCodeSystem == 'AIC' }" >
								<!-- AIC -->
								<div class="row-fluid">
									<no-result :lang="lang"
										v-if="pageComponents.loincSearchResults && pageComponents.loincSearchResults.length == 0 && searchExecuted">
									</no-result>
								</div>
	
								<div v-if="pageComponents.loincSearchResults.length > 0">
									<aic-table :results="pageComponents.loincSearchResults" :open-detail="openAicDetailModal" :lang="langSearch"> </aic-table>
	
									<pagination :page="pageComponents.page" :lang="langSearch" :execute-search="executeSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
									</pagination>
								</div>
							</div>
						</div>
						
						<div class="tab-content">
							<div class="tab-pane" id="tab-normal-atc-disabled" v-bind:class="{ active: loincSearchForm.selectedMultiStandardCodeSystem == 'ATC' }" >
								<!-- ATC -->
								<div class="row-fluid">
									<no-result :lang="lang" 
											v-if="pageComponents.loincSearchResults && pageComponents.loincSearchResults.length == 0 && searchExecuted">
									</no-result>
								</div>
	
								<div v-if="pageComponents.loincSearchResults.length > 0">
									<atc-table :results="pageComponents.loincSearchResults"  :open-detail="openAtcDetailModal"  :lang="langSearch"> </atc-table>
	
									<pagination :page="pageComponents.page" :lang="langSearch" :execute-search="executeSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
									</pagination>
								</div>
							</div>
						</div>
						
						
						
						<div  class="tab-content" v-for="cs in codeSystemsRemote" v-if="_.indexOf(codeSystemsNotStandardLocal, cs.name)==-1">
							<div class="tab-pane" id="tab-normal-local-disabled" v-bind:class="{ active: loincSearchForm.selectedMultiStandardCodeSystem == cs.name }" >
								<!-- CODESYSTEM STANDARD/LOCAL -->
								<div class="row-fluid">
									<no-result :lang="lang" 
											v-if="pageComponents.loincSearchResults && pageComponents.loincSearchResults.length == 0 && searchExecuted">
									</no-result>
								</div>
								
								<div v-if="pageComponents.loincSearchResults.length > 0">
									<local-table :results="pageComponents.loincSearchResults"
										:default-headers="defaultHeaderTable" :dynamic-headers="dynamicHeaderTable"
										:change-language-property="changeLanguageProperty"
										:open-detail="openStandardLocalDetailModal" :lang="langSearch">
									</local-table>
	
									<pagination :page="pageComponents.page" :lang="lang" :execute-search="executeSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
									</pagination>
								</div>
							</div>
						</div>
						
					</div>
					<!-- FINE TAB RESULT LIST -->
					
				
					
					
					
					
					<!--START RESULT LIST -->
					<div class="row-fluid" v-if="loincSearchForm.selectedSearchStandardCodeSystem !== 'TUTTI'">
						<div class="row-fluid">
							<no-result :lang="lang"
								v-if="pageComponents.loincSearchResults && pageComponents.loincSearchResults.length == 0 && searchExecuted">
							</no-result>
						</div>
						
						
						<div class="row-fluid" id="table-results-loinc"
							v-if="pageComponents.loincSearchResults && pageComponents.loincSearchResults.length > 0">
							<h6>{{ $t("message.labelSearchResults", lang) }} {{pageComponents.page.totalElements}}</h6>
	
							<div>
								<!-- LOINC -->
								<loinc-table :results="pageComponents.loincSearchResults"
									:open-detail="openLoincDetailModal" :lang="langSearch"
									:change-language-property="changeLanguageProperty" :build-status-code="buildStatusCode"
									v-if="loincSearchForm.selectedSearchStandardCodeSystem == 'LOINC'">
								</loinc-table>
	
								<!-- ICD9-CM -->
								<icd9-cm-table :results="pageComponents.loincSearchResults"
									:open-detail="openIcd9CmDetailModal" :lang="langSearch"
									:change-language-property="changeLanguageProperty"
									v-if="loincSearchForm.selectedSearchStandardCodeSystem == 'ICD9-CM'">
								</icd9-cm-table>
	
								<!-- ATC -->
								<atc-table :results="pageComponents.loincSearchResults"
									:open-detail="openAtcDetailModal" :lang="langSearch"
									v-if="loincSearchForm.selectedSearchStandardCodeSystem == 'ATC'">
								</atc-table>
	
								<!-- ATC -->
								<aic-table :results="pageComponents.loincSearchResults"
									:open-detail="openAicDetailModal" :lang="langSearch"
									v-if="loincSearchForm.selectedSearchStandardCodeSystem == 'AIC'">
								</aic-table>
								
								
								<!-- LOCAL -->
								<local-table :results="pageComponents.loincSearchResults"
									:default-headers="defaultHeaderTable" :dynamic-headers="dynamicHeaderTable"
									:open-detail="openStandardLocalDetailModal" :lang="langSearch"
									:change-language-property="changeLanguageProperty"
									v-if="_.indexOf(codeSystemsNotStandardLocal, loincSearchForm.selectedSearchStandardCodeSystem)==-1">
								</local-table>
							</div>
	
							<pagination :page="pageComponents.page" :lang="lang" :execute-search="executeSearch"
								:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
								:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
							</pagination>
						</div>
					</div>
					<!-- END RESULT LIST -->
				</div>			
			</div>
			<!-- END CODE SYSTEM SEARCH	-->
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
			<!-- START VALUE SET SEARCH	-->
			<div v-show="loincSearchForm.typeSearch == 'VALUESET'">
				<div class="row-fluid">
					<div class="span6">
						<div class="form-group">
							<label for="selectedSearchStandardValueSet">
								{{ $t("message.labelSelectValueSet", lang) }}
							</label>
							<select id="selectedSearchStandardValueSet" class="form-control" v-model="loincSearchForm.selectedSearchStandardValueSet" v-on:change="changeValueSetSearchSelect">
								<option value="TUTTI">TUTTI</option>
								<option v-for="vs in valueSets" v-bind:value="vs.members.valueSetName.value">
									{{vs.members.valueSetName.value}}
								</option>
							</select>
						</div>
					</div>
				</div>
				<div class="row-fluid">
					<label for="">{{ $t("message.labelLanguage", lang) }}</label>
					<label class="radio inline">
						<input type="radio" name="optionsValueSetRadios" value="it" v-model="langSearch"> ITA
					</label>
					<label class="radio inline">
						<input type="radio" name="optionsValueSetRadios" value="en" v-model="langSearch"> ENG
					</label>
				</div>
	
				<div class="row-fluid margin-top-10">
					<div class="span9">
						<label for="textQuery">{{ $t("message.labelMatchValue", lang) }}</label>
						<input type="text" id="textQuery" class="width-99" v-model="loincSearchForm.matchValue" placeholder="Es. Immunoglobulina sierica , somministrato">
					</div>
				</div>
	
				<div class="row-fluid">
					<div class="span3" v-show="loincSearchForm.selectedSearchStandardValueSet != '-1' && loincSearchForm.selectedSearchStandardValueSet != 'TUTTI'">
						<div class="form-group">
							<label for="normalSelectVersion">{{ $t("message.labelVersion", lang) }}</label>
							<select id="normalSelectVersion" class="form-control" v-model="loincSearchForm.normalVersion">
								<option v-for="version in versions" v-bind:value="version.value">
									{{ version.label | clearVersionForView}}
								</option>
							</select>
						</div>
					</div>
				</div>
				
				
				<!-- START  FILTER -->
				<div class="row-fluid top-buffer">
					<div class="row-fluid" v-show="loincSearchForm.selectedSearchStandardValueSet != 'TUTTI'">
						<div class="span9">
							<div class="row-fluid">
								<div class="span2">
									<button class="btn btn-info btn-block" v-on:click="jQuery('#collapseFilterValueSet').slideToggle(400);" >
										{{ $t("message.labelAdvancedSearch", lang) }}
									</button>
									<br>
								</div>
							</div>
						</div>
					</div>
					
					
					<div class="row-fluid" id="collapseFilterValueSet" style="display:none">
						<!-- START LOCAL FILTER -->
						<div class="searchForm" v-show="_.indexOf(codeSystemsNotStandardLocal, loincSearchForm.selectedSearchStandardValueSet)==-1 && this.dynamicHeaderTable.length>0">
							<div class="row-fluid">
								<div class="span12">
									<div class="form-group">
										<local-filter
											:dynamic-fields="dynamicHeaderTable" :element-form="loincSearchForm" :lang="langSearch" 
											:get-values="getListOfValuesForField" :dynamic-field-value="loincSearchForm.dynamicFieldValue" >
										</local-filter>
									</div>
								</div>
							</div>
						</div>
						<!-- END LOCAL FILTER -->											
					</div>
				</div>
				<!-- END FILTER -->
				
				
				
					
				<!-- Buttons search -->
				<div class="row-fluid" v-show="selectedMode != 'cross-mapping' && loincSearchForm.selectedSearchStandardValueSet != -1">
					<div class="span9">
						<div class="row-fluid">
							<div class="span2 pull-right margin-left-10">
								<button class="btn btn-primary btn-block" v-on:click="executeSearchByButton(langSearch, 0)">{{ $t("message.labelSearch", lang) }}</button>
							</div>
							<div class="span2 pull-right">
								<button class="btn btn-block" v-on:click="resetLoincForm()">Reset</button>
							</div>
						</div>
					</div>
				</div>
				

				<!-- Buttons export -->
				<div class="row-fluid" v-show="selectedMode != 'cross-mapping' && loincSearchForm.selectedSearchStandardValueSet !== 'TUTTI'">
					<div class="span9">
						<div class="row-fluid">
							<!-- Format -->
							<div class="control-group">
								<label for="">{{ $t("message.labelFormat", lang) }}</label>
								<label class="radio inline">
									<input type="radio" name="exportFormat" id="exportFormatJson" value="json" v-model="exportFormat" :disabled="disableExportOnSearch">
										{{ $t("message.labelJsonFormat", lang) }}
								</label>
								<label class="radio inline">
									<input type="radio" name="exportFormat" id="exportFormatCsv" value="csv" v-model="exportFormat" :disabled="disableExportOnSearch">
										{{ $t("message.labelCsvFormat", lang) }}
								</label>
							</div>
							
							<div class="span2">
								<button class="btn btn-block" v-on:click="executeSearchExportByButton(langSearch)" :disabled="disableExportOnSearch">
									{{ $t("message.labelExportAction", lang) }} 
								</button>
							</div>
						</div>
					</div>
				</div>				
				
				
				<div id="results-div">
					<div class="row-fluid" v-if="loincSearchForm.selectedSearchStandardValueSet === 'TUTTI'">
						<ul class="nav nav-tabs"  >
							
							<li v-for="vs in valueSets" v-bind:value="vs.members.valueSetName.value" v-if="_.indexOf(codeSystemsNotStandardLocal, vs.members.valueSetName.value)==-1"
								v-bind:class="{ active: loincSearchForm.selectedMultiStandardValueSet == vs.members.valueSetName.value  }"
								v-on:click="loincSearchForm.selectedMultiStandardValueSet = vs.members.valueSetName.value; changeMultiStandard();">
								<a href="#tab-normal-valueset" >{{ vs.members.valueSetName.value }}</a>
							</li>
						</ul>
						
						<div  class="tab-content" v-for="vs in valueSets" v-if="_.indexOf(codeSystemsNotStandardLocal, vs.members.valueSetName.value)==-1">
							<div class="tab-pane" id="tab-normal-valueset-disabled" v-bind:class="{ active: loincSearchForm.selectedMultiStandardValueSet == vs.members.valueSetName.value }" >
								<!-- VALUESET  -->
								<div class="row-fluid">
									<no-result :lang="lang" 
											v-if="pageComponents.loincSearchResults && pageComponents.loincSearchResults.length == 0 && searchExecuted">
									</no-result>
								</div>
								
								<div v-if="pageComponents.loincSearchResults.length > 0">
									<valueset-table :results="pageComponents.loincSearchResults"
										:default-headers="defaultHeaderTable" :dynamic-headers="dynamicHeaderTable"
										:open-detail="openStandardLocalDetailModal" :lang="langSearch"
										:change-language-property="changeLanguageProperty">
									</valueset-table>
	
									<pagination :page="pageComponents.page" :lang="langSearch" :execute-search="executeSearch"
										:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
										:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
									</pagination>
								</div>
							</div>
						</div>
						
					</div>
				</div>
				
				
				<!--START RESULT LIST -->
				<div class="row-fluid" v-if="loincSearchForm.selectedSearchStandardValueSet !== 'TUTTI'">
					<div class="row-fluid">
						<no-result :lang="lang"
							v-if="pageComponents.loincSearchResults && pageComponents.loincSearchResults.length == 0 && searchExecuted">
						</no-result>
					</div>
					
					
					<div class="row-fluid" id="table-results-loinc"
						v-if="pageComponents.loincSearchResults && pageComponents.loincSearchResults.length > 0">
						<h6>{{ $t("message.labelSearchResults", lang) }} {{pageComponents.page.totalElements}}</h6>

						<div>
							<!-- LOCAL -->
							<valueset-table :results="pageComponents.loincSearchResults"
								:default-headers="defaultHeaderTable" :dynamic-headers="dynamicHeaderTable"
								:open-detail="openStandardLocalDetailModal" :lang="langSearch"
								v-if="_.indexOf(codeSystemsNotStandardLocal, loincSearchForm.selectedSearchStandardValueSet)==-1"
								:change-language-property="changeLanguageProperty">
							</valueset-table>
						</div>

						<pagination :page="pageComponents.page" :lang="langSearch" :execute-search="executeSearch"
							:page-var="'page'" :search-results-var="'loincSearchResults'" :filtered-pages="filteredPages"
							:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
						</pagination>
					</div>
				</div>
				<!-- END RESULT LIST -->
				
				
			</div>
			<!-- END VALUE SET SEARCH	-->
			
			
			
			
			
			
			
			
			
			
			
			
			
			<!-- START MAPPING SEARCH	-->
			<div v-show="loincSearchForm.typeSearch == 'MAPPING'">
				<div class="row-fluid">
					<div class="span6">
						<div class="form-group">
							<label for="selectedSearchStandardMapping">
								{{ $t("message.labelSelectMapping", lang) }}
							</label>
							<select id="selectedSearchStandardMapping" class="form-control" v-model="loincSearchForm.selectedSearchStandardMapping" v-on:change="changeMappingSearchSelect">
								<option value="TUTTI">TUTTI	</option>
								<option value="ATC-AIC">ATC-AIC</option>
								<option v-for="localMapping in listMappingLocalCodesLoinc" v-bind:value="localMapping.value">
									{{ localMapping.label | clearNameMapping | clearUnderscore}}
								</option>
								<option v-for="mapping in mappingList" v-bind:value="mapping.fullname">
									{{ mapping.fullname | clearNameMapping | clearUnderscore}}
								</option>
							</select>
						</div>
					</div>
				</div>
				
				
				<div class="row-fluid">
					<label for="">{{ $t("message.labelLanguage", lang) }}</label>
					<label class="radio inline">
						<input type="radio" name="optionsMappingRadios" value="it" v-model="langSearch"> ITA
					</label>
					<label class="radio inline">
						<input type="radio" name="optionsMappingRadios" value="en" v-model="langSearch"> ENG
					</label>
				</div>
				
				<div class="row-fluid margin-top-10">
					<div class="span9">
						<label for="textQuery">{{ $t("message.labelMatchValue", lang) }}</label>
						<input type="text" id="textQuery" class="width-99" v-model="loincSearchForm.matchValue" placeholder="Es. Codice, Descrizione">
					</div>
				</div>
				
				
				
				
				<!-- Buttons search -->
				<div class="row-fluid" v-show="selectedMode != 'cross-mapping' && loincSearchForm.selectedSearchStandardMapping != -1">
					<div class="span9">
						<div class="row-fluid">
							<div class="span2 pull-right margin-left-10">
								<button class="btn btn-primary btn-block" v-on:click="executeMappingSearchByButton(langSearch, 0)">{{ $t("message.labelSearch", lang) }}</button>
							</div>
							<div class="span2 pull-right">
								<button class="btn btn-block" v-on:click="resetLoincForm()">Reset</button>
							</div>
						</div>
					</div>
				</div>
				

				<!-- Buttons export -->
				<div class="row-fluid" v-show="selectedMode != 'cross-mapping' && loincSearchForm.selectedSearchStandardMapping !== 'TUTTI'">
					<div class="span9">
						<div class="row-fluid">
							<!-- Format -->
							<div class="control-group">
								<label for="">{{ $t("message.labelFormat", lang) }}</label>
								<label class="radio inline">
									<input type="radio" name="exportFormat" id="exportFormatJson" value="json" v-model="exportFormat" :disabled="disableExportOnSearchMapping">
										{{ $t("message.labelJsonFormat", lang) }}
								</label>
								<label class="radio inline">
									<input type="radio" name="exportFormat" id="exportFormatCsv" value="csv" v-model="exportFormat" :disabled="disableExportOnSearchMapping">
										{{ $t("message.labelCsvFormat", lang) }}
								</label>
							</div>
							
							<div class="span2">
								<button class="btn btn-block" v-on:click="executeSearchExportByButton(langSearch)" :disabled="disableExportOnSearchMapping">
									{{ $t("message.labelExportAction", lang) }} 
								</button>
							</div>
						</div>
					</div>
				</div>			
				
				
				
				<!-- TAB SELECT MAPPING   -->
				<div id="results-div">
					<div class="row-fluid" v-if="loincSearchForm.selectedSearchStandardMapping === 'TUTTI'">
						<ul class="nav nav-tabs"  >
							
							<li v-bind:class="{ active: loincSearchForm.selectedMultiStandardMapping == 'ATC-AIC'  }"
								v-on:click="loincSearchForm.selectedMultiStandardMapping = 'ATC-AIC'; executeMappingSearchByButton('ATC-AIC', 0);">
								<a href="#tab-atc-aic-mapping" >ATC-AIC</a>
							</li>
								
								
							<li v-for="localMapping in listMappingLocalCodesLoinc" v-bind:value="localMapping.value"
								v-bind:class="{ active: loincSearchForm.selectedMultiStandardMapping == localMapping.value  }"
								v-on:click="loincSearchForm.selectedMultiStandardMapping = localMapping.value; executeMappingSearchByButton(localMapping.value, 0);">
								<a href="#tab-mapping-locale-loinc" >{{localMapping.label | clearNameMapping | clearUnderscore}}</a>
							</li>
							
							
							<li v-for="mapping in mappingList" v-bind:value="mapping.fullname"
								v-bind:class="{ active: loincSearchForm.selectedMultiStandardMapping == mapping.fullname  }"
								v-on:click="loincSearchForm.selectedMultiStandardMapping = mapping.fullname; executeMappingSearchByButton(mapping.fullname, 0);">
								<a href="#tab-generic-mapping" >{{ mapping.fullname | clearNameMapping | clearUnderscore}}</a>
							</li>
							
						</ul>
					</div>
				</div>
				
				<!--START RESULT LIST MAPPING ATC-AIC-->
				<div class="tab-pane margin-top-10" id="tab-atc-aic-disabled" 
					v-if="(loincSearchForm.selectedSearchStandardMapping == 'TUTTI' && loincSearchForm.selectedMultiStandardMapping == 'ATC-AIC')
					 || loincSearchForm.selectedSearchStandardMapping == 'ATC-AIC'
					">
					
					<h6 v-if="loincSearchForm.selectedSearchStandardMapping != 'TUTTI'">{{ $t("message.labelSearchResults", lang) }} {{pageComponents.page.totalElements}}</h6>
					
					
						<div v-if="localCodes.length > 0 && searchExecuted">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<thead>
									<tr>
										<th>{{ $t('message.labelAtcCode', lang) }}</th>
										<th>{{ $t('message.labelActiveIngredient', lang) }}</th>
										<th>{{ $t('message.labelAicCode', lang) }}</th>
										<th>{{ $t('message.labelDenomination', lang) }}</th>
										<th>{{ $t('message.labelPackage', lang) }}</th>
										<th>{{ $t('message.labelMedicineType', lang) }}</th>
									</tr>
								</thead>
								<tbody>
									<tr v-for="localCode in localCodes" v-on:click="openAtcDetailModal(localCode.detailObj)" class="mouse-pointer">
										<td>{{ localCode.CODICE_ATC }}</td>
										<td>{{ localCode.PRINCIPIO_ATTIVO }}</td>
										<td>{{ localCode.CODICE_AIC }}</td>
										<td>{{ localCode.DENOMINAZIONE }}</td>
										<td>{{ localCode.CONFEZIONE }}</td>
										<td>{{ localCode.TIPO_FARMACO }}</td>
									</tr>
								</tbody>
							</table>
						
						</div>
				</div>
				
				
				<!--START RESULT LIST MAPPING-CODIFICA_LOCALE-LOINC-->
				<div class="tab-pane margin-top-10" id="tab-mapping-locale-loinc-disabled"
						v-for="localMapping in listMappingLocalCodesLoinc"
						v-bind:class="{ active: loincSearchForm.selectedSearchStandardMapping == localMapping.value 
								|| (loincSearchForm.selectedSearchStandardMapping == 'TUTTI' && loincSearchForm.selectedMultiStandardMapping ==  localMapping.value) }"
						v-if="loincSearchForm.selectedSearchStandardMapping == localMapping.value 
								|| (loincSearchForm.selectedSearchStandardMapping == 'TUTTI' && loincSearchForm.selectedMultiStandardMapping == localMapping.value) ">
					
						<h6 v-if="loincSearchForm.selectedSearchStandardMapping != 'TUTTI'">{{ $t("message.labelSearchResults", lang) }} {{pageComponents.page.totalElements}}</h6>
					
					
						<div v-if="localCodes.length > 0 && searchExecuted">
							<table class="table table-bordered table-striped table-condensed table-sti margin-left-0">
								<thead>
									<tr>
										<th>{{ $t('message.localCodeLabel', lang) }}</th>
										<th>{{ $t('message.localDescription', lang) }}</th>
										<th>{{ $t('loinc.labelCode', lang) }}</th>
										<th>{{ $t('message.labelBatteryCode', lang) }}</th>
										<th>{{ $t('message.labelBatteryDescription', lang) }}</th>
										<th>{{ $t('message.labelUnits', lang) }}</th>
									</tr>
								</thead>
								<tbody>
									<tr v-for="localCode in localCodes" v-on:click="openLoincDetailModal(localCode.detailObj)" class="mouse-pointer">
										<td>{{ localCode.localCode }}</td>
										<td>{{ localCode.localDescription }}</td>
										<td>{{ localCode.resourceName }}</td>
										<td>{{ localCode.batteryCode }}</td>
										<td>{{ localCode.batteryDescription }}</td>
										<td>{{ localCode.units }}</td>
									</tr>
								</tbody>
							</table>
						</div>	
						<no-result v-if="localCodes.length === 0 && searchExecuted"></no-result>
				</div> 
				
				

				<!--START RESULT LIST GENERIC-MAPPING-->
				<div class="tab-pane margin-top-10" id="tab-normal-generic-disabled"
						v-for="mapping in mappingList"
						v-bind:class="{ active: loincSearchForm.selectedSearchStandardMapping == mapping.fullname 
								|| (loincSearchForm.selectedSearchStandardMapping == 'TUTTI' && loincSearchForm.selectedMultiStandardMapping ==  mapping.fullname) }"
						v-if="loincSearchForm.selectedSearchStandardMapping == mapping.fullname 
								|| (loincSearchForm.selectedSearchStandardMapping == 'TUTTI' && loincSearchForm.selectedMultiStandardMapping ==  mapping.fullname) ">

						<h6 v-if="loincSearchForm.selectedSearchStandardMapping != 'TUTTI'">{{ $t("message.labelSearchResults", lang) }} {{pageComponents.page.totalElements}}</h6>

						<div v-if="localCodes.length > 0 && searchExecuted">
							<div>
							<!-- MAPPING -->
								<mapping-table :results="localCodes"
									:default-headers="defaultHeaderTable" :change-language-property="changeLanguageProperty"
									:open-detail="openDetailByCodeSystem" :lang="langSearch">
								</mapping-table>
							</div>
						</div>
						<no-result v-if="localCodes.length === 0 && searchExecuted"></no-result>
				</div>
				
				
					<pagination :page="pageComponents.page" :lang="langSearch" :execute-search="executeMappingSearchByButton" 
						:page-var="'page'" :search-results-var="'mappingList'" :filtered-pages="filteredPages"
						:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages">
					</pagination>
				<!--END RESULT LIST -->
				
			</div>
			<!-- END MAPPING SEARCH	-->
			
			
		</div>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
		
		
		
		<!-- ###############################################################-->
		<!-- ##################### TAB CROSS MAPPING  ######################-->
		<!-- ###############################################################-->
		<div class="tab-pane" id="tab-cross-mapping-disabled" v-bind:class="{ active: selectedMode == 'cross-mapping' }">
			<div class="row-fluid">

				<!-- LEFT COLUMN -->
				<div class="span4">

					<div class="row-fluid">
						<div class="span6">
							<div class="form-group">
								<label for="selectLeftStandard">{{ $t("message.labelSelectCodeSystem", lang) }}</label>
								<select id="selectLeftStandard" class="span12" v-model="loincSearchForm.leftStandard" v-on:change="changeLeftCodeSystem">
									<option v-for="cs in codeSystemsRemote" v-bind:value="cs.name">
										{{ cs.name | clearUnderscore}}
									</option>
								</select>
							</div>
						</div>
						

						<div class="span6">
							<div class="form-group" v-if="loincSearchForm.leftStandard != '-1'">
								<label for="selectLeftVersion">{{ $t("message.labelVersion", lang) }}</label>
								<select id="selectLeftVersion" class="span12" v-model="loincSearchForm.leftVersion">
									<option v-for="version in leftVersions" v-bind:value="version.value">
										{{ version.label | clearVersionForView}}
									</option>
								</select>
							</div>
						</div>
					</div>

					<div class="row-fluid" v-if="loincSearchForm.leftStandard != '-1'">
						<div class="span6">
							<div class="form-group">
								<label for="selectLeftSearch">{{ $t("message.labelMatchValue", lang) }}</label>
								<input type="text" id="selectLeftSearch" class="span12" v-model="loincSearchForm.selectLeftSearch" placeholder="Es. Immunoglobulina sierica , somministrato">
							</div>
						</div>

						<div class="span6">
							<div class="form-group">
								<label>&nbsp;</label>
								<button class="btn btn-primary btn-block" v-on:click="leftSearch(lang, 0)">{{ $t("message.labelSearch", lang) }}</button>
							</div>
						</div>
					</div>

					<div v-if="leftSearchExecuted">
						<div class="row-fluid">
							<no-result :lang="lang"
								v-if="pageComponents.leftSearchResults && pageComponents.leftSearchResults.length == 0">
							</no-result>
						</div>
						<div class="row-fluid" v-if="pageComponents.leftSearchResults && pageComponents.leftSearchResults.length > 0">
							<div class="table-responsive overflow-x-visible">
								<!-- LOINC -->
								<loinc-navigation-table :results="pageComponents.leftSearchResults" :is-associated="isAssociated"
									:toggle-association="toggleAssociation" :association="true" :open-detail="openLoincDetailModal" 
									:lang="lang" :side="'left'" :tooltip-position="'right'" 
									v-if="loincSearchForm.leftStandard == 'LOINC'">
								</loinc-navigation-table>

								<!-- ICD9-CM -->
						        <icd9-cm-navigation-table v-if="loincSearchForm.leftStandard == 'ICD9-CM' && leftSearchExecuted"
											:model="pageComponents.leftSearchResults" :lang="lang" :search-url="getSearchUrl"
						         			:headers="['', $t('message.labelCode', lang), $t('icd9cm.labelName', lang), $t('message.labelMapping', lang), '', '']"
						          			:detail-callback="openIcd9CmDetailModal" :association="true" :toggle-association-callback="toggleAssociation"
											:is-associated="isAssociated" :side="'left'" :tooltip-position="'right'"  
											:show-loading="showLoading" :hide-loading="hideLoading">
						        </icd9-cm-navigation-table>

								<!-- ATC -->
								<atc-navigation v-if="loincSearchForm.leftStandard == 'ATC' && leftSearchExecuted"
											:model="pageComponents.leftSearchResults" :lang="lang" :search-url="getSearchUrl"
						          			:headers="['', $t('message.labelCode', lang), $t('icd9cm.labelName', lang), $t('message.labelMapping', lang), '', '']"
						          			:detail-callback="openAtcDetailModal" :association="true" :toggle-association-callback="toggleAssociation"
											:is-associated="isAssociated" :side="'left'" :tooltip-position="'right'"
											:show-loading="showLoading" :hide-loading="hideLoading">
						        </atc-navigation>

								<!-- AIC -->
								<aic-navigation :results="pageComponents.leftSearchResults" :is-associated="isAssociated"
									:toggle-association="toggleAssociation" :association="true" :open-detail="openAicDetailModal" :lang="lang"
									:side="'left'" :tooltip-position="'right'" 
									 v-if="loincSearchForm.leftStandard == 'AIC'">
								</aic-navigation>
								
								
								<!-- LOCAL -->
								<local-navigation v-if="_.indexOf(codeSystemsNotStandardLocal, loincSearchForm.leftStandard)==-1"
											:model="pageComponents.leftSearchResults" :lang="lang" :search-url="getSearchUrl"
						          			:detail-callback="openStandardLocalDetailModal" :association="true" :toggle-association-callback="toggleAssociation"
											:is-associated="isAssociated" :side="'left'" :tooltip-position="'right'" :active-toggle-selection="true"
											:show-loading="showLoading" :hide-loading="hideLoading">
						        </local-navigation>
							</div>

							<pagination :page="pageComponents.leftPage" :lang="lang" :execute-search="executeSearch"
								:page-var="'leftPage'" :search-results-var="'leftSearchResults'" :filtered-pages="filteredPages"
								:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages"
								v-if="loincSearchForm.leftStandard != '-1' && pageComponents.leftSearchResults && pageComponents.leftSearchResults.length > 0">
							</pagination>
						</div>
					</div>
				</div>

				<!-- CENTER COLUMN -->
				<div class="span4">
					<div class="row-fluid">
						<div class="span-12">
							<div class="form-group">
								<label for="selectRightStandard">{{ $t("message.labelRelation", lang) }}</label>
								<select
									id="selectRightStandard" class="span12"
									v-model="loincSearchForm.relation">
									<option v-for="relation in relations" v-bind:value="relation">
										{{ relation.label }}
									</option>
								</select>
							</div>

							<button class="btn btn-primary btn-block" v-on:click="createAssociations(lang, 0)"
								:disabled="tempAssociations.length < 2 || !loincSearchForm.relation">
								{{ $t("message.labelCreateAssociation", lang) }}
							</button>

							<div v-if="associations.length > 0" class="margin-top-10">
								<div class="table-responsive">
									<table class="table table-bordered table-striped table-condensed table-sti">
										<thead>
											<tr>
												<th>{{ $t("message.labelCode", lang) }}</th>
												<th>{{ $t("message.labelRelation", lang) }}</th>
												<th>{{ $t("message.labelCode", lang) }}</th>
												<th></th>
											</tr>
										</thead>
										<tbody>
											<tr v-for="(association, index) in associations">
												<td>
													{{ association.left.resourceName }}
												</td>
												<td>
													{{ association.relationLabel }}
												</td>
												<td>
													{{ association.right.resourceName }}
												</td>
												<td>
													<button class="btn btn-danger" v-on:click="deleteAssociation(index)">
														<i class="icon-remove"></i>
													</button>
												</td>
											</tr>
										</tbody>
									</table>
								</div>

								<button class="btn btn-primary btn-block" v-on:click="saveAssociations()">
									{{ $t("message.labelSaveAssociations", lang) }}
								</button>
							</div>

							<div class="margin-top-10">
								<div class="alert alert-info">
									<button type="button" class="close" data-dismiss="alert">×</button>
									<strong>{{ $t("message.labelNotice", lang) }}</strong> {{ $t("message.crossMappingNotice", lang) }}
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="span4">
					<div class="row-fluid">
						<div class="span6">
							<div class="form-group">
								<label for="selectRightStandard">{{ $t("message.labelSelectCodeSystem", lang) }}</label>
								<select id="selectRightStandard" class="span12" v-model="loincSearchForm.rightStandard" v-on:change="changeRightCodeSystem">
									<option v-for="cs in codeSystemsRemote" v-bind:value="cs.name">
										{{ cs.name | clearUnderscore}}
									</option>
								</select>
							</div>
						</div>

						<div class="span6">
							<div class="form-group" v-if="loincSearchForm.rightStandard != -1">
								<label for="selectRightVersion">{{ $t("message.labelVersion", lang) }}</label>
								<select id="selectRightVersion" class="span12"
									v-model="loincSearchForm.rightVersion">
									<option v-for="version in rightVersions" v-bind:value="version.value">
										{{ version.label | clearVersionForView}}
									</option>
								</select>
							</div>
						</div>
					</div>

					<div class="row-fluid" v-if="loincSearchForm.rightStandard != '-1'">
						<div class="span6">
							<div class="form-group">
								<label for="selectRightSearch">{{ $t("message.labelMatchValue", lang) }}</label>
								<input type="text" id="selectRightSearch" class="span12" v-model="loincSearchForm.selectRightSearch" placeholder="Es. Immunoglobulina sierica , somministrato">
							</div>
						</div>

						<div class="span6">
							<div class="form-group">
								<label>&nbsp;</label>
								<button class="btn btn-primary btn-block" v-on:click="rightSearch(lang, 0)">{{ $t("message.labelSearch", lang) }}</button>
							</div>
						</div>
					</div>

					<div v-if="rightSearchExecuted">
						<div class="row-fluid">
							<no-result :lang="lang"
								v-if="pageComponents.rightSearchResults && pageComponents.rightSearchResults.length == 0">
							</no-result>
						</div>
						<div class="row-fluid" v-if="pageComponents.rightSearchResults && pageComponents.rightSearchResults.length > 0">
							<div class="table-responsive overflow-x-visible">
								<!-- LOINC -->
								<loinc-navigation-table :results="pageComponents.rightSearchResults" :is-associated="isAssociated" 
									:side="'right'" :tooltip-position="'left'" :lang="lang"
									:toggle-association="toggleAssociation" :association="true" :open-detail="openLoincDetailModal" 
									v-if="loincSearchForm.rightStandard == 'LOINC' && pageComponents.rightSearchResults && pageComponents.rightSearchResults.length > 0">
								</loinc-navigation-table>

								<!-- ICD9-CM -->
								<icd9-cm-navigation-table v-if="loincSearchForm.rightStandard == 'ICD9-CM' && rightSearchExecuted"
									:model="pageComponents.rightSearchResults" :lang="lang" :search-url="getSearchUrl"
				         			:headers="['', $t('message.labelCode', lang), $t('icd9cm.labelName', lang), $t('message.labelMapping', lang), '', '']"
				          			:detail-callback="openIcd9CmDetailModal" :association="true" :toggle-association-callback="toggleAssociation"
									:is-associated="isAssociated" :side="'right'" :tooltip-position="'left'" 
									:show-loading="showLoading" :hide-loading="hideLoading">
				        		</icd9-cm-navigation-table>

								<!-- ATC -->
								<atc-navigation v-if="loincSearchForm.rightStandard == 'ATC' && rightSearchExecuted"
									:model="pageComponents.rightSearchResults" :lang="lang" :search-url="getSearchUrl"
				          			:headers="['', $t('message.labelCode', lang), $t('icd9cm.labelName', lang), $t('message.labelMapping', lang), '', '']"
				          			:detail-callback="openAtcDetailModal" :association="true" :toggle-association-callback="toggleAssociation"
									:is-associated="isAssociated" :side="'right'" :tooltip-position="'left'" :async-tooltip="asyncTooltip"  :tooltipObj="tooltip"
									:show-loading="showLoading" :hide-loading="hideLoading">
				        		</atc-navigation>

								<!-- AIC -->
								<aic-navigation :results="pageComponents.rightSearchResults" :is-associated="isAssociated" :side="'right'" :tooltip-position="'left'"
									:toggle-association="toggleAssociation" :association="true" :open-detail="openAicDetailModal" :lang="lang"
									v-if="loincSearchForm.rightStandard == 'AIC' && pageComponents.rightSearchResults && pageComponents.rightSearchResults.length > 0">
								</aic-navigation>
									
									
								<!-- LOCAL -->
								<local-navigation v-if="_.indexOf(codeSystemsNotStandardLocal, loincSearchForm.rightStandard)==-1"
											:model="pageComponents.rightSearchResults" :lang="lang" :search-url="getSearchUrl" 
						          			:detail-callback="openStandardLocalDetailModal" :association="true" :toggle-association-callback="toggleAssociation"
											:is-associated="isAssociated" :side="'right'" :tooltip-position="'left'" :active-toggle-selection="true"
											:show-loading="showLoading" :hide-loading="hideLoading">
						        </local-navigation>
							</div>
								

							<pagination :page="pageComponents.rightPage" :lang="lang" :execute-search="executeSearch"
								:page-var="'rightPage'" :search-results-var="'rightSearchResults'" :filtered-pages="filteredPages"
								:has-previous-hide-pages="hasPreviousHidePages" :has-next-hide-pages="hasNextHidePages"
								v-if="loincSearchForm.rightStandard != '-1'">
							</pagination>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		
		<!-- ###############################################################-->
		<!-- ##################### TAB ESPORTA  ############################-->
		<!-- ###############################################################-->
		<div class="tab-pane" v-bind:class="{ active: selectedMode == 'export' }" id="tab-export-disabled">
			<div class="row-fluid">
				<div class="span4">
					<!-- Export tabs -->
<!-- 					<ul class="nav nav-pills"> -->
<!-- 						<li v-bind:class="{ active: exportMode == 'code-system' }" -->
<!-- 							v-on:click="exportMode = 'code-system'; exportResource = 'ICD9-CM'; loadExportProperties(); loadVersions();"> -->
<!-- 							<a href="#tab-export-code-system">{{ $t("loinc.labelCodeSystem", lang) }}</a> -->
<!-- 						</li> -->
<!-- 						<li v-bind:class="{ active: exportMode == 'value-set' }" -->
<!-- 							v-on:click="exportMode = 'value-set'"> -->
<!-- 							<a href="#tab-export-value-set">{{ $t("message.labelValueSet", lang) }}</a> -->
<!-- 						</li> -->
<!-- 						<li v-bind:class="{ active: exportMode == 'mapping' }" -->
<!-- 							v-on:click="exportMode = 'mapping'; exportResource = 'LOCAL-LOINC'; goToMappingNavigationMode(); loadVersions(); readAllLocalCodes();"> -->
<!-- 							<a href="#tab-export-mapping">{{ $t("message.labelMapping", lang) }}</a> -->
<!-- 						</li> -->
<!-- 					</ul> -->
					
					
					
					
					
					<div class="row-fluid" >
						<ul class="c_dropdown nav nav-pills">
							<li class="c_dropdown_item" title='Seleziona una tipologia'>
							  <a v-bind:class="{ c_dropdown_active: exportMode == 'code-system' }">{{ $t("message.labelCodeSystem", lang) }}</a>
							  <div class="c_dropdown_item_list">
							    <a href="#tab-export-code-system" v-bind:class="{ c_dropdown_active: exportMode == 'codesystem-group-1' }" v-on:click="selectFirstCodeSystemAsExport('codesystem-group-1');">{{ $t("message.labelCodeSystemStandardNational", lang) }}</a>
							    <a href="#tab-export-code-system" v-bind:class="{ c_dropdown_active: exportMode == 'codesystem-group-2' }" v-on:click="selectFirstCodeSystemAsExport('codesystem-group-2');">{{ $t("message.labelCodeSystemLocals", lang) }}</a>
							  </div>
							</li> 
							<li class="c_dropdown_item">
							 	<a href="#tab-export-value-set" v-bind:class="{ c_dropdown_active: exportMode == 'value-set' }"  v-on:click="loadValueSets(); selectFirstValueSetAsExport()">
							 		{{ $t("message.labelValueSet", lang) }}
							 	</a>
							</li> 
							<li class="c_dropdown_item" title='Seleziona una tipologia'>
							  <a  v-bind:class="{ c_dropdown_active: exportMode == 'mapping' }" >{{ $t("message.labelMapping", lang) }}</a>
							   <div class="c_dropdown_item_list">
							    <a href="#tab-navigation-mapping" v-bind:class="{ c_dropdown_active: exportResource == 'LOCAL-LOINC' }" v-on:click="exportMode = 'mapping'; exportResource = 'LOCAL-LOINC';  exportResourceType='MAPPING';  loadVersions(); readAllLocalCodes();">{{ $t("message.labelMappingG1", lang) }}</a>
							    <a href="#tab-navigation-mapping" v-bind:class="{ c_dropdown_active: exportResource == 'genericMapping' }" v-on:click="exportMode = 'mapping'; exportResource = 'genericMapping';  exportResourceType='MAPPING';  loadMappingList(); ">{{ $t("message.labelMappingG2", lang) }}</a>
							  </div>
							</li> 
							
						</ul>
					</div>
					
					<div class="row-fluid" >
						<div class="form-group">
							<label class="text-primary">{{ getLabelFromExportMode }}</label>
						</div>
					</div>
					
					<div class="tab-content">
						<div class="tab-pane" id="tab-export-code-system-disabled" v-bind:class="{ active: exportMode == 'code-system' }">
							<div class="row-fluid">
								<div class="span12">
									<div v-show="subExportMode=='codesystem-group-1'">
									  <ul class="nav nav-pills nav-stacked">
											<li v-bind:class="{ active: exportResource == 'ICD9-CM' }"
												v-on:click="exportResource = 'ICD9-CM'; exportResourceType='STANDARD_NATIONAL_STATIC'; loadExportProperties(); ">
												<a href="#tab-export-code-system-ICD9-CM">{{ $t("message.labelIcd9Cm", lang) }}</a>
											</li>
											<li v-bind:class="{ active: exportResource == 'LOINC' }"
												v-on:click="exportResource = 'LOINC'; exportResourceType='STANDARD_NATIONAL_STATIC'; loadExportProperties(); ">
												<a href="#tab-export-code-system-loinc">{{ $t("message.labelLoinc", lang) }}</a>
											</li>
											<li v-bind:class="{ active: exportResource == 'ATC' }"
												v-on:click="exportResource = 'ATC'; exportResourceType='STANDARD_NATIONAL_STATIC'; loadExportProperties(); ">
												<a href="#tab-export-code-system-atc">{{ $t("message.labelAtc", lang) }}</a>
											</li>
											<li v-bind:class="{ active: exportResource == 'AIC' }"
												v-on:click="exportResource = 'AIC'; exportResourceType='STANDARD_NATIONAL_STATIC'; loadExportProperties(); ">
												<a href="#tab-export-code-system-aic">{{ $t("message.labelAic", lang) }}</a>
											</li>
											
											<li v-for="code in localsCode" 
												v-if="_.indexOf(codeSystemsNotStandardLocal, code.members.codeSystemName.value)==-1 && code.members.type.value == 'STANDARD_NATIONAL'"  
												v-bind:class="{ active: exportResource == code.members.codeSystemName.value }"
												v-on:click="exportResource = code.members.codeSystemName.value; exportResourceType=code.members.type.value; loadExportProperties(); ">
												<a href="#tab-export-code-system-local">{{ code.members.codeSystemName.value | clearUnderscore}}</a>
											</li>
									  </ul>
									</div>
									
									<div v-show="subExportMode=='codesystem-group-2'">
										<ul class="nav nav-pills nav-stacked">
											<li v-for="code in localsCode" 
												v-if="_.indexOf(codeSystemsNotStandardLocal, code.members.codeSystemName.value)==-1 && code.members.type.value == 'LOCAL'"  
												v-bind:class="{ active: exportResource == code.members.codeSystemName.value }"
												v-on:click="exportResource = code.members.codeSystemName.value; exportResourceType=code.members.type.value; loadExportProperties(); ">
												<a href="#tab-export-code-system-local">{{ code.members.codeSystemName.value | clearUnderscore}}</a>
											</li>
									  	</ul>
									</div>
								</div>
							</div>
						</div>
						
						<div class="tab-pane" id="tab-export-value-set-disabled" v-bind:class="{ active: exportMode == 'value-set' }">
						
							<div class="row-fluid">
								<div class="span12">
									<div class="">
									  <ul class="nav nav-pills nav-stacked">
											<li v-for="code in valueSets" v-bind:class="{ active: exportResource == code.members.valueSetName.value }"
												v-on:click="exportResource = code.members.valueSetName.value; exportResourceType=code.members.type.value; loadExportProperties(); loadVersions();" >
												<a href="#tab-export-value-set-list">{{ code.members.valueSetName.value | clearUnderscore}}</a>
											</li>
									  </ul>
									</div>
								</div>
							</div>
						
						</div>
						
						
						
						<div class="tab-pane" id="tab-export-mapping-disabled" v-bind:class="{ active: exportMode == 'mapping' }">
							<div class="row-fluid">
								<div class="span12">
									<ul class="nav nav-pills nav-stacked">
										<li v-bind:class="{ active: exportResource == 'LOCAL-LOINC' }" v-on:click="exportResource = 'LOCAL-LOINC';  loadVersions()">
											<a href="#tab-export-mapping-loinc">{{ $t("message.labelMappingG1", lang) }}</a>
										</li>
										<li v-bind:class="{ active: exportResource == 'genericMapping' }" v-on:click="exportResource = 'genericMapping';  loadMappingList();">
											<a href="#tab-export-mapping-generic">{{ $t("message.labelMappingG2", lang) }}</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				
				
				
				
				
				<div class="span8">
					<div v-if="exportMode == 'code-system' || exportMode == 'value-set'">
						<div class="row-fluid margin-top-10">
							<div class="span12">

								<!-- Version -->
								<div class="control-group">
									<label for="selectVersion">{{ $t("message.labelVersion", lang) }}</label>
									<select id="selectVersion" class="form-control" v-model="loincSearchForm.version">
										<option v-for="version in versions" v-bind:value="version.value">
											{{ version.label | clearVersionForView}}
										</option>
									</select>
								</div>

								<!-- Language -->
								<div class="control-group" v-if="exportLanguages.length > 0">
									<label for="">{{ $t("message.labelLanguage", lang) }}</label>
									<label class="radio inline" v-for="language in exportLanguages">
										<input type="radio" name="exportLanguages" v-bind:value="language.value" v-model="exportLanguage"> {{ language.label }}
									</label>
								</div>

								<!-- Type -->
								<div class="control-group" v-if="exportTypes.length > 0">
									<label for="">{{ $t("message.labelType", lang) }}</label>
									<label class="radio inline" v-for="type in exportTypes">
										<input type="radio" name="exportTypes" v-bind:value="type.value" v-model="exportType" :disabled="exportResource === 'AIC' && exportFormat === 'json'">
											{{ type.label }}
									</label>
								</div>

								<div v-if="exportResource === 'AIC'" class="control-group">
									*La selezione della classe è possibile solo per il formato CSV. Il formato JSON comprende tutte le classi.
								</div>

								<!-- Format -->
								<div class="control-group">
									<label for="">{{ $t("message.labelFormat", lang) }}</label>
									<label class="radio inline">
										<input type="radio" name="exportFormat" id="exportFormatJson" value="json" v-model="exportFormat">
										{{ $t("message.labelJsonFormat", lang) }}
									</label>
									<label class="radio inline">
										<input type="radio" name="exportFormat" id="exportFormatCsv" value="csv" v-model="exportFormat">
										{{ $t("message.labelCsvFormat", lang) }}
									</label>
								</div>

								<!-- Buttons -->
								<div class="control-group">
							    <div class="controls">
							      	<button type="button" class="btn" v-on:click="exportResources()" :disabled="exportDisabled()">
										{{ $t("message.labelExportAction", lang) }}
									</button>
							    </div>
							  </div>
							</div>
						</div>
					</div>
					
					
					
					
					
					
					
					
					
					
					
					
					

					<!-- Local code system -->
					<div v-if="exportMode == 'mapping'">
						<div class="tab-content">

							<!-- LOINC -->
							<div class="tab-pane margin-top-10" id="tab-export-code-system-disabled" v-bind:class="{ active: exportResource == 'LOCAL-LOINC' }">
								<form class="form-horizontal">
									<!-- Local code -->
									<div class="control-group">
										<label class="control-label" for="exportLocalCode">{{ $t("message.labelLocalCodeSystem", lang) }}*:</label>
										<div class="controls">
											<select id="exportLocalCode" class="form-control" v-model="exportLocalCode">
												<option v-for="exportLocalCode in listMappingLocalCodesLoinc" v-bind:value="exportLocalCode">{{ exportLocalCode.label | clearUnderscore}}</option>
											</select>
										</div>
									</div>

									<!-- Format -->
									<div class="control-group">
										<label class="control-label">{{ $t("message.labelFormat", lang) }}</label>
										<div class="controls">
											<label class="radio inline">
												<input type="radio" name="exportFormat" id="exportFormatJson" value="json" v-model="exportFormat">
													{{ $t("message.labelJsonFormat", lang) }}
											</label>
											<label class="radio inline">
												<input type="radio" name="exportFormat" id="exportFormatCsv" value="csv" v-model="exportFormat">
													{{ $t("message.labelCsvFormat", lang) }}
											</label>
										</div>
									</div>

									<!-- Buttons -->
									<div class="control-group">
								    <div class="controls">
								      <button type="button" class="btn" v-on:click="exportMappingCodificaLocalLoinc()" :disabled="exportMappingCodificaLocalLoincDisabled()">
												{{ $t("message.labelExportAction", lang) }}
									 </button>
								    </div>
								  </div>
								</form>
							</div>

							<!-- Generic Mapping -->
							<div class="tab-pane margin-top-10" id="tab-export-code-system-disabled"
								v-bind:class="{ active: exportResource == 'genericMapping' }">
								<form class="form-horizontal">

									<!-- Map code -->
									<div class="control-group">
										<label class="control-label" for="exportMapName">{{ $t("message.labelMapping", lang) }}*:</label>
										<div class="controls">
											<select id="exportMapName" class="form-control" v-model="exportMapName">
												<option value="ATC-AIC">ATC-AIC</option>
												<option v-for="mapping in mappingList" v-bind:value="mapping.fullname">{{ mapping.fullname | clearNameMapping | clearUnderscore}}</option>
											</select>
										</div>
									</div>

									<!-- Format -->
									<div class="control-group">
										<label class="control-label">{{ $t("message.labelFormat", lang) }}</label>
										<div class="controls">
											<label class="radio inline">
												<input type="radio" name="exportFormat" id="exportFormatJson" value="json" v-model="exportFormat">
													{{ $t("message.labelJsonFormat", lang) }}
											</label>
											<label class="radio inline">
												<input type="radio" name="exportFormat" id="exportFormatCsv" value="csv" v-model="exportFormat">
													{{ $t("message.labelCsvFormat", lang) }}
											</label>
										</div>
									</div>

									<!-- Buttons -->
									<div class="control-group">
								    <div class="controls">
								      	<button type="button" class="btn" v-on:click="exportGenericMapping()" :disabled="exportGenericMappingDisabled()">
											{{ $t("message.labelExportAction", lang) }}
										</button>
								    </div>
								  </div>
								</form>
							</div>
						</div>
					</div>
					
					
				</div>
			</div>
		</div>
	</div>
</div>

