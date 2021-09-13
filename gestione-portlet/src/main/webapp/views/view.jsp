<div id="app">
	<!-- Delete confirm modal -->
	<div class="modal modal-hide fade" id="deleteConfirmModal">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3 v-if="!localCodificationValueSet">
				{{ $t("message.deleteCodeSystem", lang) }}
			</h3>
			<h3 v-if="localCodificationValueSet">
				{{ $t("message.deleteValueSet", lang) }}
			</h3>
		</div>
		<div class="modal-body" v-if="!localCodificationValueSet">
			{{ $t("message.deleteCodeSystem", lang) }} 
			<strong >{{ subSection | clearUnderscore}} v. {{ versionToDelete.name | clearVersionForView}}</strong>
		</div>
		<div class="modal-body" v-if="localCodificationValueSet">
			{{ $t("message.deleteValueSet", lang) }} 
			<strong>{{ subSection | clearUnderscore }} v. {{ vsVersionToDelete.name | clearVersionForView}}</strong>
		</div>
		<div class="modal-footer">
			<button class="btn" data-dismiss="modal" aria-hidden="true">{{ $t("message.close", lang) }}</button>
    		<button class="btn btn-danger" v-on:click="deleteCodeSystem()" v-if="!localCodificationValueSet">{{ $t("message.deleteCodeSystem", lang) }}</button>
    		<button class="btn btn-danger" v-on:click="deleteCodeSystem()" v-if="localCodificationValueSet">{{ $t("message.deleteValueSet", lang) }}</button>
		</div>
	</div>

	<ul class="nav nav-tabs">
		<li v-bind:class="{ active: section == 'manage-code-system' }"
			v-on:click="section = 'manage-code-system'; localCodificationValueSet=false; resetVersionsToDelete(); importMode =''; resetImportLocal();">
			<a href="#tab-manage-code-system">{{ $t("message.manageCodeSystems", lang) }}</a>
		</li>
		<li v-bind:class="{ active: section == 'import-value-set' }"
			v-on:click="getValueSets(); section = 'import-value-set'; localCodificationValueSet=true;  resetVersionsToDelete(); importMode =''; resetImportLocal();" >
			<a href="#tab-import-value-set">{{ $t("message.manageValueSet", lang) }}</a>
		</li>
		<!-- <li v-bind:class="{ active: section == 'import-code-system' }"
			v-on:click="section = 'import-code-system'; subSection = 'LOINC'; importMode ='';">
			<a href="#tab-import-code-system">{{ $t("message.codeImport", lang) }}</a>
		</li> -->
		<li v-bind:class="{ active: section == 'import-of-mapping-resources' }"
			v-on:click="section = 'import-of-mapping-resources'; loadVersions();  resetVersionsToDelete(); importMode ='';">
			<a href="#tab-import-of-mapping-resources">{{ $t("message.manageMapping", lang) }}</a>
		</li>
		<!-- <li v-bind:class="{ active: section == 'delete-code-system' }"
			v-on:click="section = 'delete-code-system'; subSection = 'LOINC'; loadVersions() importMode ='';">
			<a href="#tab-delete-code-system">{{ $t("message.deleteCodeSystem", lang) }}</a>
		</li> -->
		<li v-bind:class="{ active: section == 'locale-code-upload' }"
			v-on:click="section = 'locale-code-upload';  readAllLocalCodes(); resetVersionsToDelete(); importMode ='';">
			<a href="#tab-locale-code-upload">{{ $t("message.localeCodeManageMapping", lang) }}</a>
		</li>
<!-- 		<li v-bind:class="{ active: section == 'local-code-delete' }" -->
<!-- 			v-on:click="section = 'local-code-delete'; subSection = 'LOINC'; readAllLocalCodes();  resetVersionsToDelete(); importMode ='';" > -->
<!-- 			<a href="#tab-local-code-delete">{{ $t("message.localCodeDelete", lang) }}</a> -->
<!-- 		</li> -->
<!-- 		<li v-bind:class="{ active: section == 'mapping-delete' }" v-on:click="section = 'mapping-delete'; readMapping();  resetVersionsToDelete();  importMode ='';"> -->
<!-- 			<a href="#tab-mapping-delete">{{ $t("message.mappingDelete", lang) }}</a> -->
<!-- 		</li> -->
		<!-- <li v-bind:class="{ active: section == 'value-set-delete' }"
			v-on:click="section = 'value-set-delete'; importMode ='';" >
			<a href="#tab-value-set-delete">{{ $t("message.valueSetDelete", lang) }}</a>
		</li> -->
		<li v-bind:class="{ active: section == 'cross-mapping-approval' }"
			v-on:click="section = 'cross-mapping-approval'; readAssociations();  resetVersionsToDelete(); importMode ='';">
			<a href="#tab-cross-mapping-approval">{{ $t("message.crossMappingApproval", lang) }}</a>
		</li>
	</ul>
	
	
	
	<!-- CODE SYSTEM MANAGEMENT -->
	<div class="tab-content">
		<div class="tab-pane" v-bind:class="{ active: section == 'manage-code-system' }" id="tab-manage-code-system">
			<div class="row-fluid">
				<!-- CONTENITORE SX TABELLA CODESYSTEMS-->
				<div class="span5">
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>{{ $t("message.codeSystem", lang) }}</th>
								<th>{{ $t("message.currentVersion", lang) }}</th>
								<th>{{ $t("message.tipology", lang) }}</th>
								<th class="th-actions">{{ $t("message.actions", lang) }}</th>
							</tr>
						</thead>
						<tbody>
							<tr v-for="cs in codeSystemsRemote">
								<td>{{cs.name | clearUnderscore}}</td>
								<td>{{cs.currentVersion | clearVersionForView}}</td>
								<td v-if="cs.type!=''">{{ $t("message."+cs.type, lang) }}</td>
								<td v-if="cs.type==''"></td>
									
								<td>
									<button class="btn btn-small" v-on:click="setSubSection(cs.name, 'newVersion', cs.domain); setSelectedCs(cs); currentTypeObj=cs.type;" v-bind:title='$t("message.newVersion", lang)'><i class="icon-plus-sign"></i></button> 
									<button class="btn btn-small btn-danger" v-on:click="setSubSection(cs.name, 'deleteCsVersion'); loadCsVersions(cs.id,'csDeleteVersions');" v-bind:title='$t("message.chooseVersionDelete", lang)'><i class=" icon-minus-sign"></i></button>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="row-fluid">
						<div class="span5">
							<button class="btn btn-primary btn-block btn-new-cs" v-on:click="setSubSection('local', 'newCs'); setSelectedCs(); currentTypeObj='LOCAL'">{{ $t("message.newCodeSystemLocal", lang) }}</button>
						</div>
						<div class="span5">
							<button class="btn btn-primary btn-block btn-new-cs" v-on:click="setSubSection('standard', 'newCs'); setSelectedCs(); currentTypeObj='STANDARD_NATIONAL'">{{ $t("message.newCodeSystemStandard", lang) }}</button>
						</div>
					</div>
				</div>
				<!-- contenitore sx tabella codesystems -->
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				<!-- CONTENITORE DX -->
				<div class="span7" v-show="importMode === 'newVersion' || importMode === 'newCs'">
					<div v-if="!canImport && statusChecked">
						<div class="alert alert-block">
						  <h4>{{ $t("message.warning", lang) }}!</h4>  {{ $t("message.cantImport", lang) }}
						</div>
					</div>
					<div v-if="canImport && statusChecked">
						<!-- LOINC -->
						<div v-show="subSection === 'LOINC'">
								<h4>{{ $t("message.codeImport", lang) }} {{ $t("message.loinc", lang) }}</h4>
								<div class="row-fluid">
									<form class="form-horizontal">
										<div class="control-group" v-bind:class="{ error: hasErrorByName('version', 'import-code-system-loinc') }">
									    <label class="control-label" for="majorVersion">{{ $t("message.version", lang) }}*:</label>
									    <div class="controls">
												<div class="input-append">
												  <input class="span2" id="majorVersion" type="number" minlength="1" maxlength="1" placeholder="X" v-model="majorVersion" v-on:input="onLoincVersionChange">
												  <span class="add-on">.</span>
													<input class="span3" id="minorVersion" type="number" minlength="2" maxlength="2" placeholder="XX" v-model="minorVersion" v-on:input="onLoincVersionChange">
												</div>
												<span class="help-inline" v-show="hasErrorByName('version', 'import-code-system-loinc')">{{ getErrorByName('version', 'import-code-system-loinc') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileLoincItalia', 'import-code-system-loinc') }">
									    <label class="control-label" for="fileLoincItalia">{{ $t("message.fileLoincItalia", lang) }}*:</label>
									    <div class="controls">
									      <input type="file" id="fileLoincItalia" @change="onFileChangeLoincItalia">
												<span class="help-inline" v-show="hasErrorByName('fileLoincItalia', 'import-code-system-loinc')">{{ getErrorByName('fileLoincItalia', 'import-code-system-loinc') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileLoincInternational', 'import-code-system-loinc') }">
									    <label class="control-label" for="fileLoincInternational">{{ $t("message.fileLoincInternational", lang) }}*:</label>
									    <div class="controls">
									      <input type="file" id="fileLoincInternational" @change="onFileChangeLoincInternational">
												<span class="help-inline" v-show="hasErrorByName('fileLoincInternational', 'import-code-system-loinc')">{{ getErrorByName('fileLoincInternational', 'import-code-system-loinc') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileLoincMapTo', 'import-code-system-loinc') }">
									    <label class="control-label" for="fileLoincMapTo">{{ $t("message.fileLoincMapTo", lang) }}*:</label>
									    <div class="controls">
									      <input type="file" id="fileLoincMapTo" @change="onFileChangeLoincMapTo">
												<span class="help-inline" v-show="hasErrorByName('fileLoincMapTo', 'import-code-system-loinc')">{{ getErrorByName('fileLoincMapTo', 'import-code-system-loinc') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('releaseDate', 'import-code-system-loinc') }">
									    <label class="control-label" for="releaseDate">
												<a href="#" id="releaseDateTooltip" data-toggle="tooltip" :title="$t('message.releaseDateInfo', lang)" v-on:mouseover="showReleaseDateTooltip()">
													{{ $t("message.releaseDate", lang) }}
												</a>*:
											</label>
									    <div class="controls">
									      <input type="date" id="releaseDate" v-model="releaseDate" v-on:input="onDateChange('releaseDate', 'import-code-system-loinc')">
												<span class="help-inline" v-show="hasErrorByName('releaseDate', 'import-code-system-loinc')">
													{{ getErrorByName('releaseDate', 'import-code-system-loinc') }}
												</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('oid', 'import-code-system-loinc') }">
									    <label class="control-label" for="oid">{{ $t("message.oid", lang) }}*:</label>
									    <div class="controls">
									      <input type="text" id="oid" v-model="oid" v-on:input="onOidChange('oid', 'import-code-system-loinc')">
												<span class="help-inline" v-show="hasErrorByName('oid', 'import-code-system-loinc')">{{ getErrorByName('oid', 'import-code-system-loinc') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('description', 'import-code-system-loinc') }">
									    <label class="control-label" for="description">{{ $t("message.description", lang) }}*:</label>
									    <div class="controls">
									      <textarea id="description" v-model="description" v-on:input="onDescriptionChange('description', 'import-code-system-loinc')"></textarea>
												<span class="help-inline" v-show="hasErrorByName('description', 'import-code-system-loinc')">{{ getErrorByName('description', 'import-code-system-loinc') }}</span>
									    </div>
									  </div>
									</form>
								</div>
	
								<div class="row-fluid">
									<div class="span3">
										<button class="btn btn-primary" v-on:click="">
											{{ $t("message.cancel", lang) }}
										</button>
									</div>
									<div class="span3">
										<button class="btn btn-primary" v-on:click="importFiles" :disabled="importDisabled()">
											{{ $t("message.save", lang) }}
										</button>
									</div>
								</div>
							</div>
							<!-- loinc -->
							
							<!-- ICD9-CM -->
							<div v-show="subSection === 'ICD9-CM'">
								<h4>{{ $t("message.codeImport", lang) }} {{ $t("message.icd9-cm", lang) }}</h4>
								<div class="row-fluid">
									<form class="form-horizontal">
										<div class="control-group" v-bind:class="{ error: hasErrorByName('icd9CmVersion', 'import-code-system-icd9-cm') }">
									    <label class="control-label" for="icd9CmVersion">{{ $t("message.version", lang) }}*:</label>
									    <div class="controls">
											  <input class="span2" id="icd9CmVersion" type="text"
													v-model="icd9CmVersion" v-on:input="onVersionChange('icd9CmVersion', 'import-code-system-icd9-cm')">
												<span class="help-inline" v-show="hasErrorByName('icd9CmVersion', 'import-code-system-icd9-cm')">{{ getErrorByName('icd9CmVersion', 'import-code-system-icd9-cm') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileItaIcd9Cm', 'import-code-system-icd9-cm') }">
									    <label class="control-label" for="fileItaIcd9Cm">{{ $t("message.fileItaIcd9Cm", lang) }}*:</label>
									    <div class="controls">
									      <input type="file" id="fileItaIcd9Cm" @change="onFileChangeItaIcd9Cm">
												<span class="help-inline" v-show="hasErrorByName('fileItaIcd9Cm', 'import-code-system-icd9-cm')">{{ getErrorByName('fileItaIcd9Cm', 'import-code-system-icd9-cm') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileEnIcd9Cm', 'import-code-system-icd9-cm') }">
									    <label class="control-label" for="fileEnIcd9Cm">{{ $t("message.fileEnIcd9Cm", lang) }}*:</label>
									    <div class="controls">
									      <input type="file" id="fileEnIcd9Cm" @change="onFileChangeEnIcd9Cm">
												<span class="help-inline" v-show="hasErrorByName('fileEnIcd9Cm', 'import-code-system-icd9-cm')">{{ getErrorByName('fileEnIcd9Cm', 'import-code-system-icd9-cm') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('icd9CmReleaseDate', 'import-code-system-icd9-cm') }">
									    <label class="control-label" for="icd9CmReleaseDate">
												<a href="#" id="icd9CmReleaseDateTooltip" data-toggle="tooltip" :title="$t('message.releaseDateInfo', lang)" v-on:mouseover="showIcd9CmReleaseDateTooltip()">
													{{ $t("message.releaseDate", lang) }}
												</a>*:
											</label>
									    <div class="controls">
									      <input type="date" id="icd9CmReleaseDate" v-model="icd9CmReleaseDate" v-on:input="onDateChange('icd9CmReleaseDate', 'import-code-system-icd9-cm')">
												<span class="help-inline" v-show="hasErrorByName('icd9CmReleaseDate', 'import-code-system-icd9-cm')">
													{{ getErrorByName('icd9CmReleaseDate', 'import-code-system-icd9-cm') }}
												</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('icd9CmOid', 'import-code-system-icd9-cm') }">
									    <label class="control-label" for="icd9CmOid">{{ $t("message.oid", lang) }}*:</label>
									    <div class="controls">
									      <input type="text" id="icd9CmOid" v-model="icd9CmOid" v-on:input="onOidChange('icd9CmOid', 'import-code-system-icd9-cm')">
												<span class="help-inline" v-show="hasErrorByName('icd9CmOid', 'import-code-system-icd9-cm')">{{ getErrorByName('icd9CmOid', 'import-code-system-icd9-cm') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('icd9CmDescription', 'import-code-system-icd9-cm') }">
									    <label class="control-label" for="icd9CmDescription">{{ $t("message.description", lang) }}*:</label>
									    <div class="controls">
									      <textarea id="icd9CmDescription" v-model="icd9CmDescription" v-on:input="onDescriptionChange('icd9CmDescription', 'import-code-system-icd9-cm')"></textarea>
												<span class="help-inline" v-show="hasErrorByName('icd9CmDescription', 'import-code-system-icd9-cm')">{{ getErrorByName('icd9CmDescription', 'import-code-system-icd9-cm') }}</span>
									    </div>
									  </div>
	
										<div class="row-fluid">
											<div class="span3">
												<button class="btn btn-primary" v-on:click="cancelIcd9CmFiles">
													{{ $t("message.cancel", lang) }}
												</button>
											</div>
											<div class="span3">
												<button class="btn btn-primary" v-on:click="importIcd9CmFiles" :disabled="importIcd9CmDisabled()">
													{{ $t("message.save", lang) }}
												</button>
											</div>
										</div>
									</form>
								</div>
							</div>
							<!-- icd9-cm -->
							
							<!-- AIC -->
							<div v-show="subSection === 'AIC'">
								<h4>{{ $t("message.codeImport", lang) }} {{ $t("message.aic", lang) }}</h4>
								<div class="row-fluid">
									<form class="form-horizontal form-medium">
										<div class="control-group" v-bind:class="{ error: hasErrorByName('aicVersion', 'import-code-system-aic') }">
									    <label class="control-label" for="aicVersion">{{ $t("message.aicVersion", lang) }}*:</label>
									    <div class="controls">
											  <input class="span2" id="aicVersion" type="text"
													v-model="aicVersion" v-on:input="onVersionChange('aicVersion', 'import-code-system-aic')">
												<span class="help-inline" v-show="hasErrorByName('aicVersion', 'import-code-system-aic')">{{ getErrorByName('aicVersion', 'import-code-system-aic') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileFarmaciClasseA', 'import-code-system-aic') }">
									    <label class="control-label" for="fileFarmaciClasseA">{{ $t("message.fileFarmaciClasseA", lang) }}*:</label>
									    <div class="controls">
									      <input type="file" id="fileFarmaciClasseA" @change="onFileChangeFarmaciClasseA">
												<span class="help-inline" v-show="hasErrorByName('fileFarmaciClasseA', 'import-code-system-aic')">{{ getErrorByName('fileFarmaciClasseA', 'import-code-system-aic') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileFarmaciClasseH', 'import-code-system-aic') }">
									    <label class="control-label" for="fileFarmaciClasseH">{{ $t("message.fileFarmaciClasseH", lang) }}*:</label>
									    <div class="controls">
									      <input type="file" id="fileFarmaciClasseH" @change="onFileChangeFarmaciClasseH">
												<span class="help-inline" v-show="hasErrorByName('fileFarmaciClasseH', 'import-code-system-aic')">{{ getErrorByName('fileFarmaciClasseH', 'import-code-system-aic') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileFarmaciClasseC', 'import-code-system-aic') }">
									    <label class="control-label" for="fileFarmaciClasseC">{{ $t("message.fileFarmaciClasseC", lang) }}*:</label>
									    <div class="controls">
									      <input type="file" id="fileFarmaciClasseC" @change="onFileChangeFarmaciClasseC">
												<span class="help-inline" v-show="hasErrorByName('fileFarmaciClasseC', 'import-code-system-aic')">{{ getErrorByName('fileFarmaciClasseC', 'import-code-system-aic') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileFarmaciEquivalenti', 'import-code-system-aic') }">
									    <label class="control-label" for="fileFarmaciEquivalenti">{{ $t("message.fileFarmaciEquivalenti", lang) }}*:</label>
									    <div class="controls">
									      <input type="file" id="fileFarmaciEquivalenti" @change="onFileChangeFarmaciEquivalenti">
												<span class="help-inline" v-show="hasErrorByName('fileFarmaciEquivalenti', 'import-code-system-aic')">{{ getErrorByName('fileFarmaciEquivalenti', 'import-code-system-aic') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('aicReleaseDate', 'import-code-system-aic') }">
									    <label class="control-label" for="aicReleaseDate">
												<a href="#" id="aicReleaseDateTooltip" data-toggle="tooltip" :title="$t('message.releaseDateInfo', lang)" v-on:mouseover="showAicReleaseDateTooltip()">
													{{ $t("message.releaseDate", lang) }}
												</a>*:
											</label>
									    <div class="controls">
									      <input type="date" id="aicReleaseDate" v-model="aicReleaseDate" v-on:input="onDateChange('aicReleaseDate', 'import-code-system-aic')">
												<span class="help-inline" v-show="hasErrorByName('aicReleaseDate', 'import-code-system-aic')">
													{{ getErrorByName('aicReleaseDate', 'import-code-system-aic') }}
												</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('aicOid', 'import-code-system-aic') }">
									    <label class="control-label" for="aicOid">{{ $t("message.oid", lang) }}*:</label>
									    <div class="controls">
									      <input type="text" id="aicOid" v-model="aicOid" v-on:input="onOidChange('aicOid', 'import-code-system-aic')">
												<span class="help-inline" v-show="hasErrorByName('aicOid', 'import-code-system-aic')">{{ getErrorByName('aicOid', 'import-code-system-aic') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('aicDescription', 'import-code-system-aic') }">
									    <label class="control-label" for="aicDescription">{{ $t("message.description", lang) }}*:</label>
									    <div class="controls">
									      <textarea id="aicDescription" v-model="aicDescription" v-on:input="onDescriptionChange('aicDescription', 'import-code-system-aic')"></textarea>
												<span class="help-inline" v-show="hasErrorByName('aicDescription', 'import-code-system-aic')">{{ getErrorByName('aicDescription', 'import-code-system-aic') }}</span>
									    </div>
									  </div>
	
										<div class="row-fluid">
											<div class="span3">
												<button class="btn btn-primary" v-on:click="cancelAicFiles">
													{{ $t("message.cancel", lang) }}
												</button>
											</div>
											<div class="span3">
												<button class="btn btn-primary" v-on:click="importAicFiles" :disabled="importAicDisabled()">
													{{ $t("message.save", lang) }}
												</button>
											</div>
										</div>
									</form>
								</div>
							</div>
							<!-- aic -->
							
							<!-- ATC -->
							<div v-show="subSection === 'ATC'">
								<h4>{{ $t("message.codeImport", lang) }} {{ $t("message.atc", lang) }}</h4>
								<div class="row-fluid">
									<form class="form-horizontal">
										<div class="control-group" v-bind:class="{ error: hasErrorByName('atcVersion', 'import-code-system-atc') }">
									    <label class="control-label" for="atcVersion">{{ $t("message.version", lang) }}*:</label>
									    <div class="controls">
											  <input class="span2" id="atcVersion" type="text"
													v-model="atcVersion" v-on:input="onVersionChange('atcVersion', 'import-code-system-atc')">
												<span class="help-inline" v-show="hasErrorByName('atcVersion', 'import-code-system-atc')">{{ getErrorByName('atcVersion', 'import-code-system-atc') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileFarmaciAtc', 'import-code-system-atc') }">
									    <label class="control-label" for="fileFarmaciAtc">{{ $t("message.fileFarmaciAtc", lang) }}*:</label>
									    <div class="controls">
									      <input type="file" id="fileFarmaciAtc" @change="onFileChangeAtc">
												<span class="help-inline" v-show="hasErrorByName('fileFarmaciAtc', 'import-code-system-atc')">{{ getErrorByName('fileFarmaciAtc', 'import-code-system-atc') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('atcReleaseDate', 'import-code-system-atc') }">
									    <label class="control-label" for="atcReleaseDate">
												<a href="#" id="atcReleaseDateTooltip" data-toggle="tooltip" :title="$t('message.releaseDateInfo', lang)" v-on:mouseover="showAtcReleaseDateTooltip()">
													{{ $t("message.releaseDate", lang) }}
												</a>*:
											</label>
									    <div class="controls">
									      <input type="date" id="atcReleaseDate" v-model="atcReleaseDate" v-on:input="onDateChange('atcReleaseDate', 'import-code-system-atc')">
												<span class="help-inline" v-show="hasErrorByName('atcReleaseDate', 'import-code-system-atc')">
													{{ getErrorByName('atcReleaseDate', 'import-code-system-atc') }}
												</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('atcOid', 'import-code-system-atc') }">
									    <label class="control-label" for="atcOid">{{ $t("message.oid", lang) }}*:</label>
									    <div class="controls">
									      <input type="text" id="atcOid" v-model="atcOid" v-on:input="onOidChange('atcOid', 'import-code-system-atc')">
												<span class="help-inline" v-show="hasErrorByName('atcOid', 'import-code-system-atc')">{{ getErrorByName('atcOid', 'import-code-system-atc') }}</span>
									    </div>
									  </div>
	
										<div class="control-group" v-bind:class="{ error: hasErrorByName('atcDescription', 'import-code-system-atc') }">
									    <label class="control-label" for="atcDescription">{{ $t("message.description", lang) }}*:</label>
									    <div class="controls">
									      <textarea id="aicDescription" v-model="atcDescription" v-on:input="onDescriptionChange('atcDescription', 'import-code-system-atc')"></textarea>
												<span class="help-inline" v-show="hasErrorByName('atcDescription', 'import-code-system-atc')">{{ getErrorByName('atcDescription', 'import-code-system-atc') }}</span>
									    </div>
									  </div>
	
										<div class="row-fluid">
											<div class="span3">
												<button class="btn btn-primary" v-on:click="cancelAtcFiles">
													{{ $t("message.cancel", lang) }}
												</button>
											</div>
											<div class="span3">
												<button class="btn btn-primary" v-on:click="importAtcFiles" :disabled="importAtcDisabled()">
													{{ $t("message.save", lang) }}
												</button>
											</div>
										</div>
									</form>
								</div>
							</div>
							<!-- atc -->
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
						<!-- CODIFICA STANDARD NAZIONALE -->
							<div v-show="isStandard">
								<h4 v-if="isNewCs">{{ $t("message.importCodeSystemStandard", lang) }}</h4>
								<h4 v-if="isNewVersion">{{ localCodificationName | clearUnderscore}} </h4>
								
								<div v-if="selectedCs && selectedCs.typeMapping">
									<p>Formato file</p>
								
									<ul>
										<li v-for="(item, key, index) in selectedCs.typeMapping">
											{{key}}
										</li>
									</ul>
									
									<hr>
								</div>
								<div class="row-fluid">
								
									<form class="form-horizontal" v-show="standardLocalImport.status === 'blank'">
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileItStandardLocal', 'import-code-system-standard') }">
										    <label class="control-label"style="width: auto">{{ $t("message.fileItStandardLocal", lang) }}*:</label>
										    <div class="controls">
										      <input type="file" id="fileItStandardLocal" @change="onFileChangeStandardLocalIt" >
											  <span class="help-inline" v-show="hasErrorByName('fileItStandardLocal', 'import-code-system-standard')">{{ getErrorByName('fileItStandardLocal', 'import-code-system-standard') }}</span>
										    </div>
										</div>
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileEnStandardLocal', 'import-code-system-standard') }">
										    <label class="control-label" style="width: auto">{{ $t("message.fileEnStandardLocal", lang) }}*:</label>
										    <div class="controls">
										      <input type="file" id="fileEnStandardLocal" @change="onFileChangeStandardLocalEn" >
											  <span class="help-inline" v-show="hasErrorByName('fileEnStandardLocal', 'import-code-system-standard')">{{ getErrorByName('fileEnStandardLocal', 'import-code-system-standard') }}</span>
										    </div>
										</div>
										<div class="row-fluid">
											<div class="span3">
												<button class="btn btn-primary" v-on:click="inspectStandardLocalFile" :disabled="inspectStandardLocalDisabled()">
													{{ $t("message.upload", lang) }}
												</button>
											</div>
										</div>
									</form>
									
									<div v-show="standardLocalImport.status === 'ready'">
										
										<!-- DATI GENERICI -->
										<div class="row-fluid">
											<div class="row-fluid">
												<div class="span4">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationName', 'import-code-system-standard') }">
													    <label class="control-label" for="localName">{{ $t("message.name", lang) }}*:</label>
													    <div class="controls">
															  <input class="" id="localName" type="text"
																	v-model="localCodificationName" v-on:input="onFieldChange('localCodificationName', 'import-code-system-standard')" v-bind:disabled="isNewVersion">
																<span class="help-inline" v-show="hasErrorByName('localCodificationName', 'import-code-system-standard')">{{ getErrorByName('localCodificationName', 'import-code-system-standard') }}</span>
													    </div>
													  </div>
											  	</div>
										
												<div class="span4">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationVersion', 'import-code-system-standard') }">
												    <label class="control-label" for="localVersion">{{ $t("message.version", lang) }}*:</label>
												    <div class="controls">
														  <input class="" id="localVersion" type="text"
																v-model="localCodificationVersion" v-on:input="onVersionChange('localCodificationVersion', 'import-code-system-standard')">
															<span class="help-inline" v-show="hasErrorByName('localCodificationVersion', 'import-code-system-standard')">{{ getErrorByName('localCodificationVersion', 'import-code-system-standard') }}</span>
												    </div>
												  </div>
											  	</div>
			
												<div class="span4">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localReleaseDate', 'import-code-system-standard') }">
													    <label class="control-label" for="localCodificationReleaseDate">
																<a href="#" id="localCodificationReleaseDateTooltip" data-toggle="tooltip" :title="$t('message.releaseDateInfo', lang)" v-on:mouseover="showAtcReleaseDateTooltip()">
																	{{ $t("message.releaseDate", lang) }}
																</a>*:
															</label>
													    <div class="controls">
													      <input type="date" id=localCodificationReleaseDate" v-model="localCodificationReleaseDate" v-on:input="onDateChange('localCodificationReleaseDate', 'import-code-system-standard')">
																<span class="help-inline" v-show="hasErrorByName('localCodificationReleaseDate', 'import-code-system-standard')">
																	{{ getErrorByName('localCodificationReleaseDate', 'import-code-system-standard') }}
																</span>
													    </div>
													  </div>
												 </div>
											</div>
										
										
											<div class="row-fluid">
												<div class="span4">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationDomain', 'import-code-system-standard') }">
													   <label class="control-label" for="localDomain">{{ $t("message.domain", lang) }}*:</label>
													    <div class="controls">
<!-- 															<select v-model="localCodificationDomain" v-on:change="onFieldChange('localCodificationDomain', 'import-code-system-standard'); changeDomine(); " id="localDomain" v-bind:disabled="isNewVersion"> -->
<!-- 																<option v-for="option in domains" v-bind:value="option.key">{{option.name}}</option> -->
<!-- 															</select> -->
															<select v-model="localCodificationDomain" v-on:change="changeDomine(); " id="localDomain" v-bind:disabled="isNewVersion">
																<option v-for="option in domains" v-bind:value="option.key">{{option.name}}</option>
															</select>
															<span class="help-inline" v-show="hasErrorByName('localCodificationDomain', 'import-code-system-standard')">{{ getErrorByName('localCodifictionDomain', 'import-code-system-standard') }}</span>
													    </div>
													  </div>
												</div>
												
												
												<div class="span4">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationOid', 'import-code-system-standard') }">
												    <label class="control-label" for="localCodificationOid">{{ $t("message.oid", lang) }}: 
												    	<a href="#"  v-if="localCodificationOidPrefix!=''"><i>prefix: {{localCodificationOidPrefix }}</i></a>
												    </label> 
												    <div class="controls">
												      	<input type="text" id="localCodificationOid" v-model="localCodificationOid">
														<span class="help-inline" v-show="hasErrorByName('localCodificationOid', 'import-code-system-standard')">{{ getErrorByName('localCodificationOid', 'import-code-system-standard') }}</span>
												    </div>
												  </div>
											  	</div>
											  	
											  	<div class="span4" v-if="isNewCs">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationCodeSystemHasOntology', 'import-code-system-standard') }">
													   <label class="control-label" for="localCodificationCodeSystemHasOntology">{{ $t("message.hasOntology", lang) }}*:</label>
													    <div class="controls">
														  	<select v-model="localCodificationCodeSystemHasOntology" id="localCodificationCodeSystemHasOntology">
															  <option value="Y">SI</option>
															  <option value="N">NO</option>
															</select>
															<span class="help-inline" v-show="hasErrorByName('localCodificationCodeSystemHasOntology', 'import-code-system-standard')">{{ getErrorByName('localCodificationCodeSystemHasOntology', 'import-code-system-standard') }}</span>
													    </div>
													  </div>
												</div>
											  	
											</div>
										
										
										
											<div class="row-fluid" v-if="isNewCs">	
												<div class="span4" >
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationCodeSystemType', 'import-code-system-standard') }">
													   <label class="control-label" for="localCodificationCodeSystemType">{{ $t("message.codeSystemType", lang) }}*:</label>
													    <div class="controls">
														  	<select v-model="localCodificationCodeSystemType" id="localCodificationCodeSystemType" v-on:input="onFieldChange('localCodificationCodeSystemType', 'import-code-system-standard')" >
															  <option value="STANDARD_NATIONAL">{{ $t("message.STANDARD_NATIONAL", lang) }}</option>
															</select>
															<span class="help-inline" v-show="hasErrorByName('localCodificationCodeSystemType', 'import-code-system-standard')">{{ getErrorByName('localCodificationCodeSystemType', 'import-code-system-standard') }}</span>
													    </div>
													  </div>
												</div>
												
												<div class="span4" >
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationCodeSystemSubType', 'import-code-system-standard') }">
													   <label class="control-label" for="localCodificationCodeSystemSubType">{{ $t("message.type", lang) }}*:</label>
													    <div class="controls">
														  	<select v-model="localCodificationCodeSystemSubType" id="localCodificationCodeSystemSubType">
															  <option value="classification">{{ $t("message.classification", lang) }}</option>
															  <option value="nomenclature">{{ $t("message.nomenclature", lang) }}</option>
															</select>
															<span class="help-inline" v-show="hasErrorByName('localCodificationCodeSystemSubType', 'import-code-system-standard')">{{ getErrorByName('localCodificationCodeSystemSubType', 'import-code-system-standard') }}</span>
													    </div>
													  </div>
												</div>
												
												<div class="span4" >
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationOrganization', 'import-code-system-standard') }">
													   <label class="control-label" for="localCodificationOrganization">{{ $t("message.organization", lang) }}*:</label>
													    <div class="controls">
															  <input class="" id="localOrganization" type="text"
																	v-model="localCodificationOrganization" v-on:input="onFieldChange('localCodificationOrganization', 'import-code-system-standard')">
																<span class="help-inline" v-show="hasErrorByName('localCodificationOrganization', 'import-code-system-standard')">{{ getErrorByName('localCodificationOrganization', 'import-code-system-standard') }}</span>
													    </div>
													  </div>
												</div>
												
											</div>
											
											
											<div class="row-fluid">
												<div class="span4" v-if="localCodificationCodeSystemHasOntology=='Y' && isNewCs">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationCodeSystemOntologyName', 'import-code-system-standard') }">
												    <label class="control-label" for="localCodificationCodeSystemOntologyName">{{ $t("message.ontologyName", lang) }}  </label> 
												    <div class="controls">
												      	<input type="text" id="localCodificationCodeSystemOntologyName" v-model="localCodificationCodeSystemOntologyName">
														<span class="help-inline" v-show="hasErrorByName('localCodificationCodeSystemOntologyName', 'import-code-system-standard')">{{ getErrorByName('localCodificationOid', 'import-code-system-standard') }}</span>
												    </div>
												  </div>
											  	</div>
											</div>
											
											
											
										
											<div class="row-fluid">
												<div class="span8">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationDescription', 'import-code-system-standard') }">
													    <label class="control-label" for="localCodificationDescription">{{ $t("message.description", lang) }}*:</label>
													    <div class="controls">
													      <textarea id="localCodificationDescription" v-model="localCodificationDescription" v-on:input="onDescriptionChange('localCodificationDescription', 'import-code-system-standard')" class="codification-local-input" rows="5"></textarea>
														<span class="help-inline" v-show="hasErrorByName('localCodificationDescription', 'import-code-system-standard')">{{ getErrorByName('localCodificationDescription', 'import-code-system-standard') }}</span>
													    </div>
													  </div>
												  </div>
										  	</div>
										</div>
										<!-- Dati generici -->
										
									
										<h5>{{$t("message.localCsvInfo", lang)}}</h5>
										<ul>
											<li>{{standardLocalImport.header.length}} {{$t("message.columns", lang)}}</li>
											<li>{{standardLocalImport.rowsCount}} {{$t("message.rows", lang)}}</li>
										</ul>
										
										<h5>{{$t("message.typing", lang)}} 
											<button class="btn btn-small btn-link" type="button">
												<span v-show="hideTyping" v-on:click="hideTyping = false">Mostra</span>
												<span v-show="!hideTyping" v-on:click="hideTyping = true">Nascondi</span>
											</button>
										</h5>
										<p>{{ $t("message.mappingInfos", lang) }}</p>
										
										<table class="table" v-show="!hideTyping">
											<thead>
												<tr>
													<th style="width: 10%;">#</th>
													<th style="width: 30%;">{{ $t("message.csvCol", lang) }}</th>
													<th style="width: 60%;">{{ $t("message.type", lang) }}</th>
												</tr>
											</thead>
											<tbody>
												<tr v-for="(h, index) in standardLocalImport.header">
													<td>{{index +1}}</td>
													<td>{{h.columnName}}</td>
													<td>
														  	<select v-if="h.selectable === true" v-model="localTypeMapping[h.columnName]" v-on:input="changeMappingType(h.columnName, $event)" v-bind:disabled="isNewVersion">
																<option v-for="option in h.options" v-bind:value="option.type">{{option.name}}</option>
															</select>
															<select v-show="localTypeMappingSubOptionsVisibility[h.columnName]" v-model="localCodificationsMapping[h.columnName]">
																<option v-for="option in standardLocalImport.codeSystemOptions" :value="option.type">{{option.name}}</option>
															</select>
															
														  	<p v-if="h.selectable === false">{{h.defaultOption.name}}</p>
													</td>
												</tr>
											</tbody>
										</table>
										<div class="row-fluid">
											<div class="span2">
												<button class="btn btn-small btn-block" v-on:click="resetImportLocal">
													{{ $t("message.cancel", lang) }}
												</button>
											</div>
											<div class="span2">
												<button class="btn btn-primary btn-block" v-on:click="importLocal">
													{{ $t("message.save", lang) }}
												</button>
											</div>
										</div>
									</div>
									
								</div>
							</div>
							<!-- codifica standard nazionale -->
							
							
							
							
							
							
							
							
							
							
							
							
							
							<!-- CODIFICA LOCALE -->
							<div v-show="isLocal">
								<h4 v-if="isNewCs">{{ $t("message.importCodeSystemLocal", lang) }}</h4>
								<h4 v-if="isNewVersion">{{ localCodificationName | clearUnderscore }}</h4>
								
								<div v-if="selectedCs && selectedCs.typeMapping">
									<p>Formato file</p>
								
									<ul>
										<li v-for="(item, key, index) in selectedCs.typeMapping">
											{{key}}
										</li>
									</ul>
									
									<hr>
								</div>
								<div class="row-fluid">
									<form class="form-horizontal" v-show="standardLocalImport.status === 'blank'">
										<div class="control-group" v-bind:class="{ error: hasErrorByName('fileItStandardLocal', 'import-code-system-locale') }">
										    <label class="control-label"style="width: auto">{{ $t("message.fileLocale", lang) }}*:</label>
										    <div class="controls">
										      <input type="file" id="fileItLocal" @change="onFileChangeStandardLocalIt">
													<span class="help-inline" v-show="hasErrorByName('fileItStandardLocal', 'import-code-system-locale')">{{ getErrorByName('fileItStandardLocal', 'import-code-system-locale') }}</span>
										    </div>
										</div>
										<div class="row-fluid">
											<div class="span3">
												<button class="btn btn-primary" v-on:click="inspectStandardLocalFile" :disabled="inspectStandardLocalDisabled()">
													{{ $t("message.upload", lang) }}
												</button>
											</div>
										</div>
									</form>
									
									<div v-show="standardLocalImport.status === 'ready'">
										
										<!-- DATI GENERICI -->
										<div>
											<div class="row-fluid">
												<div class="span4">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationName', 'import-code-system-locale') }">
													    <label class="control-label" for="localName">{{ $t("message.name", lang) }}*:</label>
													    <div class="controls">
															<input class="" id="localName" type="text" v-model="localCodificationName" v-on:input="onFieldChange('localCodificationName', 'import-code-system-locale')" v-bind:disabled="isNewVersion">
															<span class="help-inline" v-show="hasErrorByName('localCodificationName', 'import-code-system-locale')">{{ getErrorByName('localCodificationName', 'import-code-system-locale') }}</span>
														</div>
													</div>
											  	</div>
											
												<div class="span4">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationVersion', 'import-code-system-locale') }">
												    <label class="control-label" for="localVersion">{{ $t("message.version", lang) }}*:</label>
												    <div class="controls">
														<input class="" id="localVersion" type="text" v-model="localCodificationVersion" v-on:input="onVersionChange('localCodificationVersion', 'import-code-system-locale')">
														<span class="help-inline" v-show="hasErrorByName('localCodificationVersion', 'import-code-system-locale')">{{ getErrorByName('localCodificationVersion', 'import-code-system-locale') }}</span>
												    </div>
												  </div>
											  	</div>
			
												<div class="span4">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localReleaseDate', 'import-code-system-locale') }">
													    <label class="control-label" for="localCodificationReleaseDate">
																<a href="#" id="localCodificationReleaseDateTooltip" data-toggle="tooltip" :title="$t('message.releaseDateInfo', lang)" v-on:mouseover="showAtcReleaseDateTooltip()">
																	{{ $t("message.releaseDate", lang) }}
																</a>*:
															</label>
													    <div class="controls">
													      <input type="date" id=localCodificationReleaseDate" v-model="localCodificationReleaseDate" v-on:input="onDateChange('localCodificationReleaseDate', 'import-code-system-locale')">
																<span class="help-inline" v-show="hasErrorByName('localCodificationReleaseDate', 'import-code-system-locale')">
																	{{ getErrorByName('localCodificationReleaseDate', 'import-code-system-locale') }}
																</span>
													    </div>
													  </div>
												</div>
											</div>
											
											
											
											
											<div class="row-fluid">
												<div class="span4" >
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationDomain', 'import-code-system-locale') }">
													   <label class="control-label" for="localDomain">{{ $t("message.domain", lang) }}*:</label>
													    <div class="controls">
<!-- 															<select v-model="localCodificationDomain" v-on:change="onFieldChange('localCodificationDomain', 'import-code-system-locale'); changeDomine();" id="localDomain"  v-bind:disabled="isNewVersion"> -->
<!-- 																<option v-for="option in domains" v-bind:value="option.key">{{option.name}}</option> -->
<!-- 															</select> -->
															<select v-model="localCodificationDomain" v-on:change="changeDomine();" id="localDomain"  v-bind:disabled="isNewVersion">
																<option v-for="option in domains" v-bind:value="option.key">{{option.name}}</option>
															</select>
															<span class="help-inline" v-show="hasErrorByName('localCodificationDomain', 'import-code-system-locale')">{{ getErrorByName('localCodifictionDomain', 'import-code-system-locale') }}</span>
													    </div>
													  </div>
												</div>
												
												<div class="span4">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationOid', 'import-code-system-locale') }">
												    <label class="control-label" for="localCodificationOid">{{ $t("message.oid", lang) }}: 
												    	<a href="#"  v-if="localCodificationOidPrefix!=''"><i>prefix: {{localCodificationOidPrefix }}</i></a>
												    </label>
												    <div class="controls">
												      <input type="text" id="localCodificationOid" v-model="localCodificationOid">
															<span class="help-inline" v-show="hasErrorByName('localCodificationOid', 'import-code-system-locale')">{{ getErrorByName('localCodificationOid', 'import-code-system-locale') }}</span>
												    </div>
												  </div>
											  	</div>
											  	
											  	<div class="span4" v-if="isNewCs">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationCodeSystemHasOntology', 'import-code-system-locale') }">
													   <label class="control-label" for="localCodificationCodeSystemHasOntology">{{ $t("message.hasOntology", lang) }}*:</label>
													    <div class="controls">
														  	<select v-model="localCodificationCodeSystemHasOntology" id="localCodificationCodeSystemHasOntology">
															  <option value="Y">SI</option>
															  <option value="N">NO</option>
															</select>
															<span class="help-inline" v-show="hasErrorByName('localCodificationCodeSystemHasOntology', 'import-code-system-locale')">{{ getErrorByName('localCodificationCodeSystemHasOntology', 'import-code-system-locale') }}</span>
													    </div>
													  </div>
												</div>
												
												
											</div>
											
												
											<div class="row-fluid"  v-if="isNewCs">	
												<div class="span4">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationCodeSystemType', 'import-code-system-locale') }">
													   <label class="control-label" for="localDomain">{{ $t("message.codeSystemType", lang) }}*:</label>
													    <div class="controls">
															  	<select v-model="localCodificationCodeSystemType" v-on:input="onFieldChange('localCodificationCodeSystemType', 'import-code-system-locale')" >
																  <option value="LOCAL">{{ $t("message.LOCAL", lang) }}</option>
																</select>
																<span class="help-inline" v-show="hasErrorByName('localCodificationCodeSystemType', 'import-code-system-locale')">{{ getErrorByName('localCodificationCodeSystemType', 'import-code-system-locale') }}</span>
													    </div>
													  </div>
												</div>
												
												<div class="span4" >
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationCodeSystemSubType', 'import-code-system-locale') }">
													   <label class="control-label" for="localDomain">{{ $t("message.type", lang) }}*:</label>
													    <div class="controls">
															  <select v-model="localCodificationCodeSystemSubType" >
																  <option value="classification">{{ $t("message.classification", lang) }}</option>
																  <option value="nomenclature">{{ $t("message.nomenclature", lang) }}</option>
																</select>
																<span class="help-inline" v-show="hasErrorByName('localCodificationCodeSystemSubType', 'import-code-system-locale')">{{ getErrorByName('localCodificationCodeSystemSubType', 'import-code-system-locale') }}</span>
													    </div>
													  </div>
												</div>
												
												<div class="span4" >
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationOrganization', 'import-code-system-locale') }">
													   <label class="control-label" for="localCodificationOrganization">{{ $t("message.organization", lang) }}*:</label>
													    <div class="controls">
															  <input class="" id="localOrganization" type="text"
																	v-model="localCodificationOrganization" v-on:input="onFieldChange('localCodificationOrganization', 'import-code-system-locale')">
																<span class="help-inline" v-show="hasErrorByName('localCodificationOrganization', 'import-code-system-locale')">{{ getErrorByName('localCodificationOrganization', 'import-code-system-locale') }}</span>
													    </div>
													  </div>
												</div>
												
											</div>
											
											
											<div class="row-fluid">
												<div class="span4" v-if="localCodificationCodeSystemHasOntology=='Y' && isNewCs">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationCodeSystemOntologyName', 'import-code-system-locale') }">
												    <label class="control-label" for="localCodificationCodeSystemOntologyName">{{ $t("message.ontologyName", lang) }}  </label> 
												    <div class="controls">
												      	<input type="text" id="localCodificationCodeSystemOntologyName" v-model="localCodificationCodeSystemOntologyName">
														<span class="help-inline" v-show="hasErrorByName('localCodificationCodeSystemOntologyName', 'import-code-system-locale')">{{ getErrorByName('localCodificationOid', 'import-code-system-locale') }}</span>
												    </div>
												  </div>
											  	</div>
											</div>
										
											<div class="row-fluid">
												<div class="span8">
													<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationDescription', 'import-code-system-locale') }">
													    <label class="control-label" for="localCodificationDescription">{{ $t("message.description", lang) }}*:</label>
													    <div class="controls">
													      <textarea id="localCodificationDescription" v-model="localCodificationDescription" v-on:input="onDescriptionChange('localCodificationDescription', 'import-code-system-locale')" class="codification-local-input" rows="5"></textarea>
																<span class="help-inline" v-show="hasErrorByName('localCodificationDescription', 'import-code-system-locale')">{{ getErrorByName('localCodificationDescription', 'import-code-system-locale') }}</span>
													    </div>
													  </div>
												  </div>
											</div>
										</div>
									<!-- Dati generici -->
										
									
										<h5>{{$t("message.localCsvInfo", lang)}}</h5>
										<ul>
											<li>{{standardLocalImport.header.length}} {{$t("message.columns", lang)}}</li>
											<li>{{standardLocalImport.rowsCount}} {{$t("message.rows", lang)}}</li>
										</ul>
										
										<h5>{{$t("message.typing", lang)}} 
											<button class="btn btn-small btn-link" type="button">
												<span v-show="hideTyping" v-on:click="hideTyping = false">Mostra</span>
												<span v-show="!hideTyping" v-on:click="hideTyping = true">Nascondi</span>
											</button>
										</h5>
										<p>{{ $t("message.mappingInfos", lang) }}</p>
										
										<table class="table" v-show="!hideTyping">
											<thead>
												<tr>
													<th style="width: 10%;">#</th>
													<th style="width: 30%;">{{ $t("message.csvCol", lang) }}</th>
													<th style="width: 60%;">{{ $t("message.type", lang) }}</th>
												</tr>
											</thead>
											<tbody>
												<tr v-for="(h, index) in standardLocalImport.header">
													<td>{{index +1}}</td>
													<td>{{h.columnName}}</td>
													<td>
														  	<select v-if="h.selectable === true" v-model="localTypeMapping[h.columnName]" v-on:input="changeMappingType(h.columnName, $event)" v-bind:disabled="isNewVersion">
																<option v-for="option in h.options" v-bind:value="option.type">{{option.name}}</option>
															</select>
															<select v-show="localTypeMappingSubOptionsVisibility[h.columnName]" v-model="localCodificationsMapping[h.columnName]">
																<option v-for="option in standardLocalImport.codeSystemOptions" :value="option.type">{{option.name}}</option>
															</select>
															
														  	<p v-if="h.selectable === false">{{h.defaultOption.name}}</p>
													</td>
												</tr>
											</tbody>
										</table>
										<div class="row-fluid">
											<div class="span2">
												<button class="btn btn-small btn-block" v-on:click="resetImportLocal">
													{{ $t("message.cancel", lang) }}
												</button>
											</div>
											<div class="span2">
												<button class="btn btn-primary btn-block" v-on:click="importLocal">
													{{ $t("message.save", lang) }}
												</button>
											</div>
										</div>
									</div>
									
								</div>
							</div>
							<!-- codifica locale -->
						</div>
				</div>
				

				
				<div class="span7" v-show="importMode === 'deleteCsVersion'">
					<h4>{{$t("message.deleteCodeSystem", lang)}} {{subSection | clearUnderscore}}</h4>
					<div class="row-fluid">
						<div class="form-group">
							<label for="versionToDelete">{{ $t("message.version", lang) }}</label>
							<select v-model="versionToDelete">
								<option v-for="option in csDeleteVersions" v-bind:value="option">{{option.name | clearVersionForView}}</option>
							</select>	
						</div>				
					</div>
					<div>					
						<button class="btn btn-danger" v-on:click="askDeleteConfirm()" :disabled="!versionToDelete">{{$t("message.delete", lang)}}</button>
					</div>
				</div>
				
				<!-- contenitore dx -->
			</div>
		</div>
	<!-- CODE SYSTEM MANAGEMENT -->
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


	<!-- VALUE SET -->
		<div class="tab-pane" v-bind:class="{ active: section == 'import-value-set' }" id="tab-import-value-set-disabled">
			<div class="row-fluid">
				<!-- CONTENITORE SX TABELLA CODESYSTEMS-->
				<div class="span5">
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>{{ $t("message.valueSet", lang) }}</th>
								<th>{{ $t("message.currentVersion", lang) }}</th>
								<th class="th-actions"> {{ $t("message.actions", lang) }}</th>
							</tr>
						</thead>
						<tbody>
							<tr v-for="cs in valuesetRemote">
								<td>{{cs.name | clearUnderscore}}</td>
								<td>{{cs.currentVersion | clearVersionForView}}</td>
								<td>
									<button class="btn btn-small" v-on:click="setSubSection(cs.name, 'newVersion', cs.domain); setSelectedCs(cs);" v-bind:title='$t("message.newVersion", lang)'><i class="icon-plus-sign"></i></button>
									<button class="btn btn-small btn-danger" v-on:click="setSubSection(cs.name, 'deleteCsVersion');loadVsVersions(cs.id,'vsDeleteVersions');" v-bind:title='$t("message.chooseVersionDelete", lang)'><i class="icon-minus-sign"></i></button>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="row-fluid">
						<div class="span5">
							<button class="btn btn-primary btn-block btn-new-cs" v-on:click="setSubSection('local', 'newCs'); setSelectedCs(); resetImportLocal();">{{ $t("message.newValueSet", lang) }}</button>
						</div>
					</div>
				</div>
				<!-- contenitore sx tabella codesystems -->
				
				<!-- CONTENITORE DX -->
				
				<div class="span7"  v-if="!canImport && statusChecked">
					<div class="alert alert-block">
					  <h4>{{ $t("message.warning", lang) }}!</h4>
					  {{ $t("message.cantImport", lang) }}
					</div>
				</div>
				
				<div v-if="canImport && statusChecked">
					<div class="offset1 span6" v-show="importMode === 'deleteCsVersion'">
						<h4>{{$t("message.deleteValueSet", lang)}} {{subSection | clearUnderscore}}</h4>
						<div class="row-fluid">
							<div class="form-group">
								<label for="versionToDelete">{{ $t("message.version", lang) }}</label>
								<select v-model="vsVersionToDelete">
									<option v-for="option in vsDeleteVersions" v-bind:value="option">{{option.name | clearVersionForView}}</option>
								</select>	
							</div>				
						</div>
						<div>					
							<button class="btn btn-danger" v-on:click="askDeleteConfirm()" :disabled="!vsVersionToDelete">{{$t("message.delete", lang)}}</button>
						</div>
					</div>
				
					<div class="span7" v-show="importMode === 'newVersion' || importMode === 'newCs'">
						<!-- CODIFICA LOCALE -->
						<div >
							<h4 v-if="isNewCs">{{ $t("message.importValueSet", lang) }}</h4>
							<h4 v-if="isNewVersion">{{ localCodificationName | clearUnderscore}}</h4>
							
							<div v-if="selectedCs && selectedCs.typeMapping">
								<p>Formato file</p>
							
								<ul>
									<li v-for="(item, key, index) in selectedCs.typeMapping">
										{{key}}
									</li>
								</ul>
	
								<hr>
							</div>
							<div class="row-fluid">
								<form class="form-horizontal" v-show="standardLocalImport.status === 'blank'">
									<div class="control-group" v-bind:class="{ error: hasErrorByName('fileItStandardLocal', 'import-code-system-valueset') }">
									    <label class="control-label" style="width: auto">{{ $t("message.fileItValueSet", lang) }}*:</label>
									    <div class="controls">
									      <input type="file" id="fileItValueSet" @change="onFileChangeStandardLocalIt">
										  <span class="help-inline" v-show="hasErrorByName('fileItStandardLocal', 'import-code-system-valueset')">{{ getErrorByName('fileItStandardLocal', 'import-code-system-valueset') }}</span>
									    </div>
									</div>
									<div class="control-group" v-bind:class="{ error: hasErrorByName('fileEnStandardLocal', 'import-code-system-valueset') }">
									    <label class="control-label" style="width: auto">{{ $t("message.fileEnValueSet", lang) }}*:</label>
									    <div class="controls">
									      <input type="file" id="fileEnValueSet" @change="onFileChangeStandardLocalEn">
										  <span class="help-inline" v-show="hasErrorByName('fileEnStandardLocal', 'import-code-system-valueset')">{{ getErrorByName('fileEnStandardLocal', 'import-code-system-valueset') }}</span>
									    </div>
									</div>
									<div class="row-fluid">
										<div class="span3">
											<button class="btn btn-primary" v-on:click="inspectStandardLocalFile" :disabled="inspectStandardLocalDisabled()">
												{{ $t("message.upload", lang) }}
											</button>
										</div>
									</div>
								</form>
								
								<div v-show="standardLocalImport.status === 'ready'">
									
									<!-- DATI GENERICI -->
									<div>
										<div class="row-fluid">
									
											<div class="span4">
												<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationName', 'import-code-system-valueset') }">
												    <label class="control-label" for="localName">{{ $t("message.name", lang) }}*:</label>
												    <div class="controls">
														<input class="" id="localName" type="text" v-model="localCodificationName" v-on:input="onFieldChange('localCodificationName', 'import-code-system-valueset')" v-bind:disabled="isNewVersion">
														<span class="help-inline" v-show="hasErrorByName('localCodificationName', 'import-code-system-valueset')">{{ getErrorByName('localCodificationName', 'import-code-system-valueset') }}</span>
												    </div>
												  </div>
										  	</div>
									
											<div class="span4">
												<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationVersion', 'import-code-system-valueset') }">
												    <label class="control-label" for="localVersion">{{ $t("message.version", lang) }}*:</label>
												    <div class="controls">
														<input class="" id="localVersion" type="text" v-model="localCodificationVersion" v-on:input="onVersionChange('localCodificationVersion', 'import-code-system-valueset')">
															<span class="help-inline" v-show="hasErrorByName('localCodificationVersion', 'import-code-system-valueset')">{{ getErrorByName('localCodificationVersion', 'import-code-system-valueset') }}</span>
												    </div>
											  	</div>
										  	</div>
	
											<div class="span4">
												<div class="control-group" v-bind:class="{ error: hasErrorByName('localReleaseDate', 'import-code-system-valueset') }">
												    <label class="control-label" for="localCodificationReleaseDate">
															<a href="#" id="localCodificationReleaseDateTooltip" data-toggle="tooltip" :title="$t('message.releaseDateInfo', lang)" v-on:mouseover="showAtcReleaseDateTooltip()">
																{{ $t("message.releaseDate", lang) }}
															</a>*:
														</label>
												    <div class="controls">
												      <input type="date" id=localCodificationReleaseDate" v-model="localCodificationReleaseDate" v-on:input="onDateChange('localCodificationReleaseDate', 'import-code-system-valueset')">
															<span class="help-inline" v-show="hasErrorByName('localCodificationReleaseDate', 'import-code-system-valueset')">
																{{ getErrorByName('localCodificationReleaseDate', 'import-code-system-valueset') }}
															</span>
												    </div>
												</div>
											</div>
										</div>	
										
										<div class="row-fluid">
											<div class="span4">
												<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationDomain', 'import-code-system-valueset') }">
												   <label class="control-label" for="localDomain">{{ $t("message.domain", lang) }}*:</label>
												    <div class="controls">
<!-- 														<select v-model="localCodificationDomain" v-on:change="onFieldChange('localCodificationDomain', 'import-code-system-valueset'); changeDomine();" id="localDomain"  v-bind:disabled="isNewVersion"> -->
<!-- 															<option v-for="option in domains" v-bind:value="option.key">{{option.name}}</option> -->
<!-- 														</select> -->
														<select v-model="localCodificationDomain" v-on:change="changeDomine();" id="localDomain"  v-bind:disabled="isNewVersion">
															<option v-for="option in domains" v-bind:value="option.key">{{option.name}}</option>
														</select>
														<span class="help-inline" v-show="hasErrorByName('localCodificationDomain', 'import-code-system-valueset')">{{ getErrorByName('localCodifictionDomain', 'import-code-system-valueset') }}</span>
												    </div>
												  </div>
											</div>
											
											<div class="span4">
												<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationOid', 'import-code-system-valueset') }">
												    <label class="control-label" for="localCodificationOid">{{ $t("message.oid", lang) }}: 
												    	<a href="#"  v-if="localCodificationOidPrefix!=''"><i>prefix: {{localCodificationOidPrefix }}</i></a>
												    </label>
												    <div class="controls">
												      	<input type="text" id="localCodificationOid" v-model="localCodificationOid" >
														<span class="help-inline">{{ getErrorByName('localCodificationOid', 'import-code-system-valueset') }}</span>
												    </div>
												</div>
									  		</div>
									  		
									  		
											<div class="span4" v-if="isNewCs">
												<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationCodeSystemHasOntology', 'import-code-system-valueset') }">
												   <label class="control-label" for="localCodificationCodeSystemHasOntology">{{ $t("message.hasOntology", lang) }}*:</label>
												    <div class="controls">
													  	<select v-model="localCodificationCodeSystemHasOntology" id="localCodificationCodeSystemHasOntology">
														  <option value="Y">SI</option>
														  <option value="N">NO</option>
														</select>
														<span class="help-inline" v-show="hasErrorByName('localCodificationCodeSystemHasOntology', 'import-code-system-valueset')">{{ getErrorByName('localCodificationCodeSystemHasOntology', 'import-code-system-valueset') }}</span>
												    </div>
												  </div>
											</div>
											
										</div>
										
										
										
										<div class="row-fluid">
											<div class="span4" v-if="isNewCs">
												<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationOrganization', 'import-code-system-valueset') }">
												   <label class="control-label" for="localCodificationOrganization">{{ $t("message.organization", lang) }}*:</label>
												    <div class="controls">
														<input class="" id="localOrganization" type="text" v-model="localCodificationOrganization" v-on:input="onFieldChange('localCodificationOrganization', 'import-code-system-valueset')">
														<span class="help-inline" v-show="hasErrorByName('localCodificationOrganization', 'import-code-system-valueset')">{{ getErrorByName('localCodificationOrganization', 'import-code-system-valueset') }}</span>
												    </div>
												  </div>
											</div>
											
											<div class="span4" v-if="localCodificationCodeSystemHasOntology=='Y' && isNewCs">
												<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationCodeSystemOntologyName', 'import-code-system-valueset') }">
											    <label class="control-label" for="localCodificationCodeSystemOntologyName">{{ $t("message.ontologyName", lang) }}  </label> 
											    <div class="controls">
											      	<input type="text" id="localCodificationCodeSystemOntologyName" v-model="localCodificationCodeSystemOntologyName">
													<span class="help-inline" v-show="hasErrorByName('localCodificationCodeSystemOntologyName', 'import-code-system-valueset')">{{ getErrorByName('localCodificationOid', 'import-code-system-valueset') }}</span>
											    </div>
											  </div>
											 </div>
										</div>
										
									
										<div class="row-fluid">
											<div class="span8">
												<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodificationDescription', 'import-code-system-valueset') }">
												    <label class="control-label" for="localCodificationDescription">{{ $t("message.description", lang) }}*:</label>
												    <div class="controls">
														<textarea id="localCodificationDescription" v-model="localCodificationDescription" v-on:input="onDescriptionChange('localCodificationDescription', 'import-code-system-valueset')" class="codification-local-input" rows="5"></textarea>
														<span class="help-inline" v-show="hasErrorByName('localCodificationDescription', 'import-code-system-valueset')">{{ getErrorByName('localCodificationDescription', 'import-code-system-valueset') }}</span>
												    </div>
												  </div>
											  </div>
									  	</div>
									</div>
									<!-- Dati generici -->
									
								
									<h5>{{$t("message.localCsvInfo", lang)}}</h5>
									<ul>
										<li>{{standardLocalImport.header.length}} {{$t("message.columns", lang)}}</li>
										<li>{{standardLocalImport.rowsCount}} {{$t("message.rows", lang)}}</li>
									</ul>
									
									<h5>{{$t("message.typing", lang)}} 
										<button class="btn btn-small btn-link" type="button">
											<span v-show="hideTyping" v-on:click="hideTyping = false">Mostra</span>
											<span v-show="!hideTyping" v-on:click="hideTyping = true">Nascondi</span>
										</button>
									</h5>
									<p>{{ $t("message.mappingInfos", lang) }}</p>
									
									<table class="table" v-show="!hideTyping">
										<thead>
											<tr>
												<th style="width: 10%;">#</th>
												<th style="width: 30%;">{{ $t("message.csvCol", lang) }}</th>
												<th style="width: 60%;">{{ $t("message.type", lang) }}</th>
											</tr>
										</thead>
										<tbody>
											<tr v-for="(h, index) in standardLocalImport.header">
												<td>{{index +1}}</td>
												<td>{{h.columnName}}</td>
												<td>
												  	<select v-if="h.selectable === true" v-model="localTypeMapping[h.columnName]" v-on:input="changeMappingType(h.columnName, $event)" v-bind:disabled="isNewVersion">
														<option v-for="option in h.options" v-bind:value="option.type" v-show="option.name!=='Mapping'">{{option.name}}</option>
													</select>
													<select v-show="localTypeMappingSubOptionsVisibility[h.columnName]" v-model="localCodificationsMapping[h.columnName]">
														<option v-for="option in standardLocalImport.codeSystemOptions" :value="option.type">{{option.name}}</option>
													</select>
													
												  	<p v-if="h.selectable === false">{{h.defaultOption.name}}</p>
												</td>
											</tr>
										</tbody>
									</table>
									<div class="row-fluid">
										<div class="span2">
											<button class="btn btn-small btn-block" v-on:click="resetImportLocal">
												{{ $t("message.cancel", lang) }}
											</button>
										</div>
										<div class="span2">
											<button class="btn btn-primary btn-block" v-on:click="importLocal">
												{{ $t("message.save", lang) }}
											</button>
										</div>
									</div>
								</div>
								
							</div>
						</div>
						<!-- codifica locale -->
					</div>
				</div>
				<!-- value set -->
			</div>
		</div>
		
		
		
		
		
		
		
		
		
		
	
		
		

		<div class="tab-pane" id="tab-delete-code-system-disabled" v-bind:class="{ active: section == 'delete-code-system' }">
			<div class="row-fluid">
				<div class="span3">
					<!-- Navigation tabs -->
					<ul class="nav nav-pills nav-stacked">
						<li v-bind:class="{ active: subSection == 'LOINC' }" v-on:click="subSection = 'LOINC'; loadVersions()">
							<a href="#delete-code-system-loinc">{{ $t("message.loinc", lang) }}</a>
						</li>
						<li v-bind:class="{ active: subSection == 'ICD9-CM' }" v-on:click="subSection = 'ICD9-CM'; loadVersions()">
							<a href="#delete-code-system-icd9-cm">{{ $t("message.icd9-cm", lang) }}</a>
						</li>
						<li v-bind:class="{ active: subSection == 'AIC' }" v-on:click="subSection = 'AIC'; loadVersions()">
							<a href="#delete-code-system-aic">{{ $t("message.aic", lang) }}</a>
						</li>
						<li v-bind:class="{ active: subSection == 'ATC' }" v-on:click="subSection = 'ATC'; loadVersions()">
							<a href="#delete-code-system-atc">{{ $t("message.atc", lang) }}</a>
						</li>
					</ul>
				</div>

			</div>
		</div>
		
		
		<!-- MANAGE MAPPING -->
		<div class="tab-pane" id="tab-import-of-mapping-resources-disabled" v-bind:class="{ active: section == 'import-of-mapping-resources' }">
			<div class="row-fluid">
				<!-- CONTENITORE SX TABELLA MAPPING-->
				<div class="span5">
					<div class="row-fluid">
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>{{ $t("message.mapping", lang) }}</th>
								<th class="th-actions">{{ $t("message.actions", lang) }}</th>
							</tr>
						</thead>
						<tbody>
							<tr v-for="mapping in mappingList">
								<td>{{mapping.mapName | clearNameMapping | clearUnderscore}}</td>
								<td>
									<!--  <button class="btn btn-small btn-danger" v-on:click="deleteMappingByName(mapping.mapName);" >{{ $t("message.delete", lang) }}</button> -->
									<button class="btn btn-small btn-danger" v-on:click="deleteMappingByName(mapping.mapName);"  v-bind:title='$t("message.delete", lang)'><i class="icon-trash"></i></button>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="row-fluid">
						<div class="span5">
							<button class="btn btn-primary btn-block" v-on:click="setSubSection('mapping', 'newMapping'); setSelectedCs();">{{ $t("message.newMapping", lang) }}</button>
						</div>
					</div>
					</div>
				</div>
				<!-- CONTENITORE SX TABELLA MAPPING -->
				
				<!-- CONTENITORE DX -->
				<div class="span7" v-show="importMode === 'newMapping'">
					<!-- IMPORT OF MAPPING RESOURCES -->
					<div class="row-fluid">
						<div class="span9 offset1">
							<div v-if="canImport && statusChecked">
								<h4 class="text-left">{{ $t("message.mappingImport", lang) }}</h4>
								
								<form class="form-horizontal">
								
									<div class="control-group">
										<label class="control-label" for="mappingDescription">{{ $t("message.description", lang) }}*:</label>
									    <div class="controls">
											 <input class="" id="mappingDescription" type="text" v-model="mappingDescription" 
											 	v-on:input="onFieldChange('mappingDescription', 'import-of-mapping-resources')">
											<span class="help-inline" v-show="hasErrorByName('mappingDescription', 'import-of-mapping-resources')">{{ getErrorByName('mappingDescription', 'import-of-mapping-resources') }}</span>
									    </div>
									</div>
									    
								   <div class="control-group">
									    <label class="control-label" for="mappingOrganization">{{ $t("message.organization", lang) }}*:</label>
									    <div class="controls">
											 <input class="" id="mappingOrganization" type="text" v-model="mappingOrganization" 
											 	v-on:input="onFieldChange('mappingOrganization', 'import-of-mapping-resources')">
											<span class="help-inline" v-show="hasErrorByName('mappingOrganization', 'import-of-mapping-resources')">{{ getErrorByName('mappingOrganization', 'import-of-mapping-resources') }}</span>
									    </div>
									</div>
								
									<fieldset class="sti-fieldset">
										<legend>{{ $t("message.selectTheTwoCodeSystemToMap", lang) }}</legend>
										
										<div class="control-group" v-bind:class="{ error: hasErrorByName('version1', 'import-of-mapping-resources') }">
											<select id="codeSystem1" class="form-control" v-model="codeSystem1" v-on:change="onCodeSystem1Change">
												<option v-for="codeSystem in codeSystemsRemote" v-bind:value="codeSystem.name">
													{{ codeSystem.name }}
												</option>
											</select>
		
											<select id="version1" class="form-control" v-model="version1" v-on:change="onVersionChange('version1', 'import-of-mapping-resources')">
												<option v-for="version in versions1" v-bind:value="version.name">
													{{ version.name | clearVersionForView}}
												</option>
											</select>
											
											<span class="help-inline" v-show="hasErrorByName('codeSystem1', 'import-of-mapping-resources')">
												{{ getErrorByName('codeSystem1', 'import-of-mapping-resources') }}
											</span>
											<span class="help-inline" v-show="hasErrorByName('version1', 'import-of-mapping-resources')">
												{{ getErrorByName('version1', 'import-of-mapping-resources') }}
											</span>
										</div>

										<div class="control-group" v-bind:class="{ error: hasErrorByName('version2', 'import-of-mapping-resources') }">
											<select id="codeSystem2" class="form-control" v-model="codeSystem2" v-on:change="onCodeSystem2Change">
												<option v-for="codeSystem in codeSystemsRemote" v-bind:value="codeSystem.name">
													{{ codeSystem.name }}
												</option>
											</select>
		
											<select id="version2" class="form-control" v-model="version2" v-on:change="onVersionChange('version2', 'import-of-mapping-resources')">
												<option v-for="version in versions2" v-bind:value="version.name">
													{{ version.name | clearVersionForView}}
												</option>
											</select>
											<span class="help-inline" v-show="hasErrorByName('codeSystem2', 'import-of-mapping-resources')">
												{{ getErrorByName('codeSystem2', 'import-of-mapping-resources') }}
											</span>
											<span class="help-inline" v-show="hasErrorByName('version2', 'import-of-mapping-resources')">
												{{ getErrorByName('version2', 'import-of-mapping-resources') }}
											</span>
										</div>
									</fieldset>
		
									<div class="control-group" v-bind:class="{ error: hasErrorByName('mappingReleaseDate', 'import-of-mapping-resources') }">
										<label class="control-label" for="mappingReleaseDate">{{ $t("message.releaseDate", lang) }}*:</label>
										<div class="controls">
											<input type="date" id="mappingReleaseDate" v-model="mappingReleaseDate" v-on:input="onDateChange('mappingReleaseDate', 'import-of-mapping-resources')">
											<span class="help-inline" v-show="hasErrorByName('mappingReleaseDate', 'import-of-mapping-resources')">
												{{ getErrorByName('mappingReleaseDate', 'import-of-mapping-resources') }}
											</span>
										</div>
									</div>
		
									<div class="control-group" v-bind:class="{ error: hasErrorByName('resourceMappingFile', 'import-of-mapping-resources') }">
										<label class="control-label" for="resourceMappingFile">{{ $t("message.file", lang) }}*:</label>
										<div class="controls">
											<input type="file" id="resourceMappingFile" @change="onFileChangeResourceMapping">
											<span class="help-inline" v-show="hasErrorByName('resourceMappingFile', 'import-of-mapping-resources')">
												{{ getErrorByName('resourceMappingFile', 'import-of-mapping-resources') }}
											</span>
										</div>
									</div>
		
									<div class="control-group">
										<div class="controls">
											<button class="btn btn-primary" v-on:click="resourceMappingImport" :disabled="resourceMappingImportDisabled()">
												{{ $t("message.import", lang) }}
											</button>
										</div>
									</div>
								</form>
							</div>
							<div v-if="!canImport && statusChecked">
								<div class="alert alert-block">
								  <h4>{{ $t("message.warning", lang) }}!</h4>
								  {{ $t("message.cantImport", lang) }}
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- MANAGE LOCAL MAPPING -->
		<div class="tab-pane" id="tab-locale-code-upload-disabled" v-bind:class="{ active: section == 'locale-code-upload' }">
			<!-- CONTENITORE SX TABELLA LOCAL MAPPING-->
			<div class="span5">
				<div class="row-fluid">
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>{{ $t("message.localCatalog", lang) }}</th>
								<th class="th-actions">{{ $t("message.actions", lang) }}</th>
							</tr>
						</thead>
						<tbody>
							<tr v-for="localCode in localCodes">
								<td>{{localCode.label | clearUnderscore}}</td>
								<td>
									<!-- <button class="btn btn-small btn-danger" v-on:click="deleteCodeLocaleLoincByLocalCode(localCode);" >{{ $t("message.delete", lang) }}</button> -->
									<button class="btn btn-small btn-danger" v-on:click="deleteCodeLocaleLoincByLocalCode(localCode);" v-bind:title='$t("message.delete", lang)'><i class="icon-trash"></i></button>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="row-fluid">
						<div class="span5">
							<button class="btn btn-primary btn-block" v-on:click="setSubSection('mapping', 'newLocalMapping'); setSelectedCs('LOINC') ">{{ $t("message.newMapping", lang) }}</button>
						</div>
					</div>
				</div>
			</div>
			<!-- CONTENITORE SX TABELLA LOCAL MAPPING -->
			
			
			<!-- CONTENITORE DX -->
			<div class="span7" v-show="importMode === 'newLocalMapping'">	
				<div class="row-fluid">
					<div class="span9 offset1">
						<div v-if="canImport && statusChecked">
							<h4 class="text-center">{{ $t("message.localeCodeImport", lang) }}</h4>
	
							<!-- Sub section -->
							<form class="form-horizontal">
								<label class="control-group" for="localCodeSystemName">{{ $t("message.codeSystemName", lang) }}*: {{selectedCs}}</label>
<!-- 								<div class="control-group"> -->
<!-- 									<label class="control-label" for="localCodeSystemName">{{ $t("message.codeSystemName", lang) }}*:</label> -->
<!-- 									<div class="controls"> -->
<!-- 										<select id="subSection" class="form-control" v-model="selectedCs"> -->
<!-- 											<option v-for="codeSystem in codeSystemsRemote" v-bind:value="codeSystem.name" v-if="codeSystem.name=='LOINC'"> -->
<!-- 												{{ codeSystem.name }} -->
<!-- 											</option> -->
<!-- 										</select> -->
<!-- 									</div> -->
<!-- 								</div> -->
							</form>
	
							<!-- LOINC LOCALE CODE UPLOAD -->
							<div v-show="selectedCs === 'LOINC'">
								<div v-if="canImport && statusChecked">
									<div class="row-fluid">
										<form class="form-horizontal">
											<div class="control-group" v-bind:class="{ error: hasErrorByName('version', 'locale-code-upload-loinc') }">
												<label class="control-label" for="majorVersionLoinc">{{ $t("message.version", lang) }}</label>
												<div class="controls">
													<div class="input-append">
														<input class="span2" id="majorVersionLoinc" type="number" minlength="1" maxlength="1" placeholder="X" v-model="majorVersion" v-on:input="onLoincVersionChange">
														<span class="add-on">.</span>
														<input class="span3" id="minorVersionLoinc" type="number" minlength="2" maxlength="2" placeholder="XX" v-model="minorVersion" v-on:input="onLoincVersionChange">
													</div>
													<span class="help-inline" v-show="hasErrorByName('version', 'locale-code-upload-loinc')">{{ getErrorByName('version', 'locale-code-upload-loinc') }}</span>
												</div>
											</div>
	
											<div class="control-group" v-bind:class="{ error: hasErrorByName('localCodeSystemName', 'locale-code-upload-loinc') }">
												<label class="control-label" for="localCodeSystemName">
													{{ $t("message.localCodeSystemName", lang) }}*:
												</label>
												<div class="controls">
													<input type="text" id="localCodeSystemName" v-model="localCodeSystemName" v-on:input="onLocalCodeSystemNameChange">
													<span class="help-inline" v-show="hasErrorByName('localCodeSystemName', 'locale-code-upload-loinc')">{{ getErrorByName('localCodeSystemName', 'locale-code-upload-loinc') }}</span>
												</div>
												{{ $t("message.localCodeSystemNameAdditionalInfo", lang) }}
											</div>
	
											<div class="control-group" v-bind:class="{ error: hasErrorByName('fileImport', 'locale-code-upload-loinc') }">
												<label class="control-label" for="file">{{ $t("message.file", lang) }}*:</label>
												<div class="controls">
													<input type="file" id="file" @change="onFileChangeImport">
													<span class="help-inline" v-show="hasErrorByName('fileImport', 'locale-code-upload-loinc')">{{ getErrorByName('fileImport', 'locale-code-upload-loinc') }}</span>
												</div>
											</div>
										</form>
									</div>
	
									<div class="row-fluid">
										<div class="span3">
											<button class="btn btn-primary" v-on:click="">
												{{ $t("message.cancel", lang) }}
											</button>
										</div>
										<div class="span3">
											<button class="btn btn-primary" v-on:click="uploadCodeLocaleLoinc" :disabled="uploadLoincDisabled()">
												{{ $t("message.save", lang) }}
											</button>
										</div>
									</div>
								</div>
								<div v-if="!canImport && statusChecked">
									<div class="alert alert-block">
										<h4>{{ $t("message.warning", lang) }}!</h4>
										{{ $t("message.cantImport", lang) }}
									</div>
								</div>
							</div>
	
							<div v-show="subSection !== 'LOINC' && subSection !== 'mapping'" class="span12">
								<div class="alert alert-info">{{ $t("message.mappingLocalNotAvaiable", lang) }} {{subSection}}</div>
							</div>
	
						</div>
						<div v-if="!canImport && statusChecked">
							<div class="alert alert-block">
							  <h4>{{ $t("message.warning", lang) }}!</h4>
							  {{ $t("message.cantImport", lang) }}
							</div>
	
						</div>
					</div>
				</div>
			</div>
		</div>



		<div class="tab-pane" id="tab-cross-mapping-approval-disabled" v-bind:class="{ active: section == 'cross-mapping-approval' }">
			<!-- CROSS MAPPING APPROVATION -->
			<h4 class="text-center">{{ $t("message.crossMappingApproval", lang) }}</h4>
			<div class="row-fluid">
				<table class="table table-bordered table-striped table-condensed table-centered-th" v-if="associations.length > 0">
					<thead>
						<tr>
							<th>{{ $t("message.localCodeSystemName", lang) }}</th>
							<th>{{ $t("message.code", lang) }}</th>
							<th>{{ $t("message.name", lang) }}</th>
							<th>{{ $t("message.association", lang) }}</th>
							<th>{{ $t("message.codeSystemName", lang) }}</th>
							<th>{{ $t("message.code", lang) }}</th>
							<th>{{ $t("message.name", lang) }}</th>
							<th>{{ $t("message.type", lang) }}</th>
							<th>{{ $t("message.operations", lang) }}</th>
						</tr>
					</thead>
					<tbody>
						<tr v-for="association in associations">
							<td>{{ association.subject.namespace }}</td>
							<td>{{ association.subject.name }}</td>
							<td>{{ association['sourceTitle_' + lang] }}</td>
							<td>
								{{ association.forwardName }} <i class="icon-arrow-right"></i><br/>
								<i class="icon-arrow-left"></i> {{ association.reverseName }}
							</td>
							<td>{{ association.predicate.namespace }}</td>
							<td>{{ association.predicate.name }}</td>
							<td>{{ association['targetTitle_' + lang] }}</td>
							<td>{{ $t(association.textualKind, lang) }}</td>
							<td>
								<div class="text-center">
									<button class="btn btn-primary btn-block btn-small" v-on:click="approve(association)">
										{{ $t("message.approve", lang) }}
									</button>
									<button class="btn btn-danger btn-block btn-small" v-on:click="reject(association)">
										{{ $t("message.reject", lang) }}
									</button>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
				<div v-if="associations.length == 0" class="span12">
					<div class="alert alert-info">
				  	{{ $t("message.noCrossMappings", lang) }}
					</div>
				</div>
			</div>
		</div>





	</div>
</div>
