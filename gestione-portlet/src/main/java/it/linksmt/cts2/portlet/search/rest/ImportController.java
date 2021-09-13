package it.linksmt.cts2.portlet.search.rest;

import it.linksmt.cts2.portlet.search.Message;
import it.linksmt.cts2.portlet.search.StiAppConfig;
import it.linksmt.cts2.portlet.search.StiConstant;
import it.linksmt.cts2.portlet.search.rest.model.MapImportRequest;
import it.linksmt.cts2.portlet.search.rest.model.Status;
import it.linksmt.cts2.portlet.search.rest.model.localcodification.HeaderField;
import it.linksmt.cts2.portlet.search.rest.model.localcodification.HeaderValidationResult;
import it.linksmt.cts2.portlet.search.rest.model.localcodification.StandardLocalCodificationForm;
import it.linksmt.cts2.portlet.search.rest.model.localcodification.StandardLocalCodificationInspectResponse;
import it.linksmt.cts2.portlet.search.rest.model.localcodification.ValidationResult;
import it.linksmt.cts2.portlet.search.util.Constants;
import it.linksmt.cts2.portlet.search.util.FormFieldUtils;
import it.linksmt.cts2.portlet.search.util.HeaderFieldUtils;
import it.linksmt.cts2.portlet.search.util.StiUtil;

import java.io.File;
import java.io.FileReader;
import java.io.Reader;
import java.lang.reflect.Type;
import java.net.URI;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Logger;

import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;

@Controller
@RequestMapping(value = "/import")
public class ImportController {

	private static final Logger logger = Logger.getLogger(ImportController.class.getName());

	private static String uploadFilePath = StiAppConfig.getProperty("filesystem.import.base.path", "");
	
	private static final char SEPARATOR = ';';
	
	

	@RequestMapping(value = "/loinc", method = RequestMethod.POST)
	@ResponseBody
	public Message loincImport(
			@RequestParam("fileLoincItalia") final MultipartFile fileLoincItalia,
			@RequestParam("fileLoincInternational") final MultipartFile fileLoincInternational,
			@RequestParam("fileLoincMapTo") final MultipartFile fileLoincMapTo,
			@RequestParam("version") final String version,
			@RequestParam("releaseDate") final String releaseDateString,
			@RequestParam("oid") final String oid,
			@RequestParam("description") final String description) {
		Message msg = new Message();
		String title = "";
		Status status = Status.OK;
		try {
			String fileLoincItaliaPath = StiUtil.loadFileInDirectory(
					fileLoincItalia, uploadFilePath, StiConstant.LOINC, StiConstant.CODE_SYSTEM);
			String fileLoincInternationalPath = StiUtil.loadFileInDirectory(
					fileLoincInternational, uploadFilePath, StiConstant.LOINC, StiConstant.CODE_SYSTEM);
			String fileLoincMapToPath = StiUtil.loadFileInDirectory(
					fileLoincMapTo, uploadFilePath, StiConstant.LOINC, StiConstant.CODE_SYSTEM);

			// Call the service
			String changeSetUrl = StiUtil.generateUrl(StiConstant.LOINC, version);
			String changeSetURI = StiUtil.generateChangeSetURI(StiConstant.LOINC, version);
			URI url = new URI(changeSetUrl);
			String[] value = new String[] { "CODE_SYSTEM_OID: " + oid,
					"CODE_SYSTEM_DESCRIPTION: " + description,
					"LOINC_EN_FILE: " + fileLoincInternationalPath,
					"LOINC_IT_FILE: " + fileLoincItaliaPath,
					"LOINC_MAPTO_FILE: " + fileLoincMapToPath };
			ResponseEntity<String> response = StiUtil.sendRequest(url, value, releaseDateString, changeSetURI);
			status = Status.OK;
			title = "You successfully imported files";
			logger.info("Response" + response);
		} catch (HttpServerErrorException e) {
			title = e.getMessage();
			String responseBody = e.getResponseBodyAsString();
			logger.info("Error importing " + responseBody);
			title = "Error importing data";
			status = Status.ERROR;
		} catch (Exception e) {
			title = e.getMessage();
			status = Status.ERROR;
		}
		logger.info("Parameters are: " + version + ", " + releaseDateString
				+ ", " + oid);

		msg.setTitle(title);
		msg.setStatus(status);

		return msg;
	}

	@RequestMapping(value = "/icd9-cm", method = RequestMethod.POST)
	@ResponseBody
	public Message icd9CmImport(
			@RequestParam("fileItaIcd9Cm") final MultipartFile fileItaIcd9Cm,
			@RequestParam("fileEnIcd9Cm") final MultipartFile fileEnIcd9Cm,
			@RequestParam("version") final String version,
			@RequestParam("releaseDate") final String releaseDateString,
			@RequestParam("oid") final String oid,
			@RequestParam("description") final String description) {
		Message msg = new Message();
		String title = "";
		Status status = Status.OK;
		try {
			String fileItaIcd9CmPath = StiUtil.loadFileInDirectory(
					fileItaIcd9Cm, uploadFilePath, StiConstant.ICD9CM, StiConstant.CODE_SYSTEM);
			String fileEnIcd9CmPath = StiUtil.loadFileInDirectory(fileEnIcd9Cm,
					uploadFilePath, StiConstant.ICD9CM, StiConstant.CODE_SYSTEM);

			// Call the service
			String changeSetUrl = StiUtil.generateUrl(StiConstant.ICD9CM, version);
			String changeSetURI = StiUtil.generateChangeSetURI(StiConstant.ICD9CM, version);
			URI url = new URI(changeSetUrl);
			String[] value = new String[] {
					"CODE_SYSTEM_OID: " + oid,
					"CODE_SYSTEM_DESCRIPTION: " + description,
					"ICD9_CM_OWL_EN: " + fileEnIcd9CmPath,
					"ICD9_CM_OWL_IT: " + fileItaIcd9CmPath,
			};
			ResponseEntity<String> response = StiUtil.sendRequest(url, value, releaseDateString, changeSetURI);
			status = Status.OK;
			title = "You successfully imported files";
			logger.info("Response" + response);
		} catch (HttpServerErrorException e) {
			title = e.getMessage();
			String responseBody = e.getResponseBodyAsString();
			logger.info("Error importing " + responseBody);
			title = "Error importing data";
			status = Status.ERROR;
		} catch (Exception e) {
			title = e.getMessage();
			status = Status.ERROR;
		}
		logger.info("Parameters are: " + version + ", " + releaseDateString
				+ ", " + oid);

		msg.setTitle(title);
		msg.setStatus(status);

		return msg;
	}

	@RequestMapping(value = "/aic", method = RequestMethod.POST)
	@ResponseBody
	public Message aicImport(
			@RequestParam("fileFarmaciClasseA") final MultipartFile fileFarmaciClasseA,
			@RequestParam("fileFarmaciClasseH") final MultipartFile fileFarmaciClasseH,
			@RequestParam("fileFarmaciClasseC") final MultipartFile fileFarmaciClasseC,
			@RequestParam("fileFarmaciEquivalenti") final MultipartFile fileFarmaciEquivalenti,
			@RequestParam("version") final String version,
			@RequestParam("releaseDate") final String releaseDateString,
			@RequestParam("oid") final String oid,
			@RequestParam("description") final String description) {
		Message msg = new Message();
		String title = "";
		Status status = Status.OK;
		try {
			String fileFarmaciClasseAPath = StiUtil.loadFileInDirectory(
					fileFarmaciClasseA, uploadFilePath, StiConstant.AIC, StiConstant.CODE_SYSTEM);
			String fileFarmaciClasseHPath = StiUtil.loadFileInDirectory(
					fileFarmaciClasseH, uploadFilePath, StiConstant.AIC, StiConstant.CODE_SYSTEM);
			String fileFarmaciClasseCPath = StiUtil.loadFileInDirectory(
					fileFarmaciClasseC, uploadFilePath, StiConstant.AIC, StiConstant.CODE_SYSTEM);
			String fileFarmaciEquivalentiPath = StiUtil.loadFileInDirectory(
					fileFarmaciEquivalenti, uploadFilePath, StiConstant.AIC, StiConstant.CODE_SYSTEM);

			// Call the service
			String changeSetUrl = StiUtil.generateUrl(StiConstant.AIC, version);
			String changeSetURI = StiUtil.generateChangeSetURI(StiConstant.AIC, version);
			URI url = new URI(changeSetUrl);
			String[] value = new String[] { "CODE_SYSTEM_OID: " + oid,
					"CODE_SYSTEM_DESCRIPTION: " + description,
					"AIC_CLASSE_A_FILE: " + fileFarmaciClasseAPath,
					"AIC_CLASSE_H_FILE: " + fileFarmaciClasseHPath,
					"AIC_CLASSE_C_FILE: " + fileFarmaciClasseCPath,
					"EQUIVALENTI_AIC_ATC_FILE: " + fileFarmaciEquivalentiPath};
			ResponseEntity<String> response = StiUtil.sendRequest(url, value, releaseDateString, changeSetURI);
			status = Status.OK;
			title = "You successfully imported files";
			logger.info("Response" + response);
		} catch (HttpServerErrorException e) {
			title = e.getMessage();
			String responseBody = e.getResponseBodyAsString();
			logger.info("Error importing " + responseBody);
			title = "Error importing data";
			status = Status.ERROR;
		} catch (Exception e) {
			title = e.getMessage();
			status = Status.ERROR;
		}
		logger.info("Parameters are: " + version + ", " + releaseDateString
				+ ", " + oid);

		msg.setTitle(title);
		msg.setStatus(status);

		return msg;
	}

	@RequestMapping(value = "/atc", method = RequestMethod.POST)
	@ResponseBody
	public Message atcImport(
			@RequestParam("fileFarmaciAtc") final MultipartFile fileFarmaciAtc,
			@RequestParam("version") final String version,
			@RequestParam("releaseDate") final String releaseDateString,
			@RequestParam("oid") final String oid,
			@RequestParam("description") final String description) {
		Message msg = new Message();
		String title = "";
		Status status = Status.OK;
		try {
			String fileFarmaciAtcPath = StiUtil.loadFileInDirectory(
					fileFarmaciAtc, uploadFilePath, StiConstant.ATC, StiConstant.CODE_SYSTEM);

			// Call the service
			String changeSetUrl = StiUtil.generateUrl(StiConstant.ATC, version);
			String changeSetURI = StiUtil.generateChangeSetURI(StiConstant.ATC, version);
			URI url = new URI(changeSetUrl);
			String[] value = new String[] { "CODE_SYSTEM_OID: " + oid,
					"CODE_SYSTEM_DESCRIPTION: " + description,
					"ATC_CSV_FILE: " + fileFarmaciAtcPath};
			ResponseEntity<String> response = StiUtil.sendRequest(url, value, releaseDateString, changeSetURI);
			status = Status.OK;
			title = "You successfully imported files";
			logger.info("Response" + response);
		} catch (HttpServerErrorException e) {
			title = e.getMessage();
			String responseBody = e.getResponseBodyAsString();
			logger.info("Error importing " + responseBody);
			title = "Error importing data";
			status = Status.ERROR;
		} catch (Exception e) {
			title = e.getMessage();
			status = Status.ERROR;
		}
		logger.info("Parameters are: " + version + ", " + releaseDateString
				+ ", " + oid);

		msg.setTitle(title);
		msg.setStatus(status);

		return msg;
	}

	/**
	 * Import mapping.
	 * @param codeSystem1
	 * @param version1
	 * @param codeSystem2
	 * @param version2
	 * @param resourceMappingFile
	 * @param releaseDate
	 * @return
	 */
	@RequestMapping(value = "/mapping", method = RequestMethod.POST)
	@ResponseBody
	public Message mappingImport(
			@RequestParam("codeSystem1") final String codeSystem1,
			@RequestParam("version1") final String version1,
			@RequestParam("codeSystem2") final String codeSystem2,
			@RequestParam("version2") final String version2,
			@RequestParam("resourceMappingFile") final MultipartFile resourceMappingFile,
			@RequestParam("releaseDate") final String releaseDate,
			final String mappingDescription,
			final String mappingOrganization) {
		Message msg = new Message();
		String title = "";
		Status status = Status.OK;
		try {
			String resourceMappingFilePath = StiUtil.loadFileInDirectory(
					resourceMappingFile, uploadFilePath, StiConstant.MAPPING, StiConstant.MAPPING);

			// Call the service
			MapImportRequest mapImportRequest = StiUtil.buildMapImportRequest(codeSystem1, version1, codeSystem2, version2, resourceMappingFilePath, releaseDate, mappingDescription, mappingOrganization);
			String requestUrl = StiUtil.buildImportMappingUrl();
			URI url = new URI(requestUrl);
			ResponseEntity<String> response = StiUtil.sendMappingImportRequest(url, mapImportRequest);
			status = Status.OK;
			title = "You successfully imported mapping file";
			logger.info("Response" + response);
		} catch (HttpServerErrorException e) {
			title = e.getMessage();
			String responseBody = e.getResponseBodyAsString();
			logger.info("Error importing " + responseBody);
			title = "Error importing data";
			status = Status.ERROR;
		} catch (Exception e) {
			title = e.getMessage();
			status = Status.ERROR;
		}
		logger.info("Parameters are: " + codeSystem1 + ", " + version1
				+ ", " + codeSystem2 + "," + version2 + "," + releaseDate);

		msg.setTitle(title);
		msg.setStatus(status);

		return msg;
	}

	
	
	
	
//	@RequestMapping(value="/local/import" , method=RequestMethod.POST)
//	@ResponseBody
//	public ResponseEntity<Message> localImport(@RequestBody StandardLocalCodificationForm form) {
	
	@RequestMapping(value="/local/inspect", method=RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<StandardLocalCodificationInspectResponse> inspectLocal(
			final MultipartFile localCodFileIt,final MultipartFile localCodFileEn, 
			final String codeSystemId,final boolean isValueSet,
			@RequestParam(value="typeMapping", required=false) String typeMappingString ) throws Exception{

		
		StandardLocalCodificationInspectResponse response = new StandardLocalCodificationInspectResponse();
		HttpStatus status = null;
		
		
		try {
			/*File IT*/
			File convFileIt = null;
			List<String[]> rowsIt = new ArrayList<String[]>(0);
			Reader readerIt = null;
			CSVReader csvReaderIt = null;
			
			if(localCodFileIt!=null && localCodFileIt.getOriginalFilename()!=null && !"".equals(localCodFileIt.getOriginalFilename())){
				convFileIt = new File("/tmp", localCodFileIt.getOriginalFilename().replaceAll("\\W", ""));
				localCodFileIt.transferTo(convFileIt);
				readerIt = new FileReader(convFileIt);
				csvReaderIt = new CSVReader(readerIt, SEPARATOR, CSVWriter.DEFAULT_QUOTE_CHARACTER);
				rowsIt = csvReaderIt.readAll();
			}
			
			/*File EN*/
			File convFileEn = null;
			List<String[]> rowsEn = new ArrayList<String[]>(0);
			Reader readerEn = null;
			CSVReader csvReaderEn = null;
			if(localCodFileEn!=null && localCodFileEn.getOriginalFilename()!=null && !"".equals(localCodFileEn.getOriginalFilename())){
				convFileEn = new File("/tmp", localCodFileEn.getOriginalFilename().replaceAll("\\W", ""));
				localCodFileEn.transferTo(convFileEn);
				
				readerEn = new FileReader(convFileEn);
				csvReaderEn = new CSVReader(readerEn, SEPARATOR, CSVWriter.DEFAULT_QUOTE_CHARACTER);
				rowsEn = csvReaderEn.readAll();
			}

			
			boolean error = false;
			if(rowsIt.isEmpty() && rowsEn.isEmpty()){
				error=true;
				status = HttpStatus.UNPROCESSABLE_ENTITY;
			}
			else{
				
				if(!error){
					
					String langPrimary = Constants.LANG_IT;
					String[] headerPrimary = new String[0];
					String[] headerTranslate = new String[0];
					
					if(!rowsIt.isEmpty() && !rowsEn.isEmpty()){
						headerPrimary = rowsIt.get(0);
						headerTranslate = rowsEn.get(0);
					}
					else if(!rowsIt.isEmpty()){
						headerPrimary = rowsIt.get(0);
					}
					else if(!rowsEn.isEmpty()){
						headerPrimary = rowsEn.get(0);
						langPrimary=Constants.LANG_EN;
					}
					
					int rowsCount = rowsIt.size() - 1;
					
					HashMap<String, String> typeMapping = null;
					HeaderValidationResult headerValidation = new HeaderValidationResult();
					boolean flagError = false;
					
					
					/*Controllo sulla precedente versione*/
					if(StringUtils.isNotBlank(typeMappingString) && StringUtils.isNotBlank(codeSystemId)){
						Type typeMap = new TypeToken<HashMap<String, String>>(){}.getType();
						typeMapping = new Gson().fromJson(typeMappingString, typeMap);
						if(null != typeMapping) {
							headerValidation = HeaderFieldUtils.validateHeader(codeSystemId, isValueSet, langPrimary, Arrays.asList(headerPrimary), Arrays.asList(headerTranslate), typeMapping);
						}
						
						if(!headerValidation.isValid()){
							flagError = true;
							response.setRowsCount(rowsCount);
							response.setHeaderValidationResult(headerValidation);
							status = HttpStatus.BAD_REQUEST;
						}
					}
					
					/*TODO CONTROLLO SUL NUMERO DI RIGHE DEL CSV: ACCORPARE NEL PRIMO*/
					if(!flagError){
						if(headerPrimary.length>0 && headerTranslate.length>0){
							if(rowsIt.size()!=rowsEn.size()){
								flagError = true;
								response.setRowsCount(rowsCount);
								status = HttpStatus.BAD_REQUEST; 
								response.setErrorMessage("error_lenght_row");
								return new ResponseEntity<StandardLocalCodificationInspectResponse>(response, status);
							}
						}
					}
					
					
					/*TODO */
					if(!flagError){
						String requestUrl = StiUtil.buildGetCodeSystemsUrl();
						URI url = new URI(requestUrl);
						List<String> codeSystems = StiUtil.getCodeSystemsNames(url);
						
						List<HeaderField> headersField = new ArrayList<HeaderField>();
						for(String h : headerPrimary){
							HeaderField hf = HeaderFieldUtils.getHeaderField(h, codeSystems);
							headersField.add(hf);
						}
						response.setHeader(headersField);
						response.setRowsCount(rowsCount);
						if(convFileIt!=null && convFileIt.getAbsolutePath()!=null){
							response.setTmpFileNameIt(convFileIt.getAbsolutePath());
						}
						if(convFileEn!=null && convFileEn.getAbsolutePath()!=null){
							response.setTmpFileNameEn(convFileEn.getAbsolutePath());
						}
						response.setCodeSystemOptions(HeaderFieldUtils.getMappingOptions(codeSystems));
						status = HttpStatus.OK;
					}
					
				}
			}
			
			if(readerIt!=null){
				readerIt.close();
			}
			if(csvReaderIt!=null){
				csvReaderIt.close();
			}
			
			if(readerEn!=null){
				readerEn.close();
			}
			if(csvReaderEn!=null){
				csvReaderEn.close();
			}
			
			return new ResponseEntity<StandardLocalCodificationInspectResponse>(response, status);
		}catch(Exception e) {
			logger.severe("Errore durante l'ispezione del file " + e.getMessage());
			throw new Exception(e);
		}
	}
	
		
	@RequestMapping(value="/local/import" , method=RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<ValidationResult> localImport(@RequestBody StandardLocalCodificationForm form) {
		logger.info(form.toString());
		
//		Message msg = new Message();
		ValidationResult validationResult = new ValidationResult();
		String title = "";
		Status status = Status.OK;
		try {

			HeaderValidationResult headerValidation = HeaderFieldUtils.validateMapping(form.getTypeMapping());
			validationResult = FormFieldUtils.validateForm(form);
			if(headerValidation.isValid() && validationResult.isValid()){
				
				String localFileIt = "";
				String localFileEn = "";
				
				if(form.getTmpFileNameIt()!=null){
					localFileIt = StiUtil.loadFileInDirectory(new File(form.getTmpFileNameIt()), uploadFilePath, StiConstant.STANDARD_LOCAL, StiConstant.CODE_SYSTEM);
				}
				if(form.getTmpFileNameEn()!=null){
					localFileEn = StiUtil.loadFileInDirectory(new File(form.getTmpFileNameEn()), uploadFilePath, StiConstant.STANDARD_LOCAL, StiConstant.CODE_SYSTEM);
				}
				
				// Call the service
				
				String codeName = StiUtil.generateOfficialEffectiveName(form.getName());
//				String codeName = StringUtils.replace(StringUtils.trim(form.getName()), " ", "_");
//				String codeName =  StringUtils.trim(form.getName());
				
				String changeSetUrl = StiUtil.generateUrl(codeName, form.getVersion());
				String changeSetURI = StiUtil.generateChangeSetURI(codeName, form.getVersion());
				URI url = new URI(changeSetUrl);
				
				/**
				 * TODO
				 * AGGIUNGERE ORGANIZZAZIONE, DOMINIO E TUTTE LE ALTRE PROPRIETÀ
				 * PRESENTI NEL FORM
				 */
				
				
				String FILE_PARAM_NAME_IT = form.isValueSet() ? "VALUESET_CSV_FILE_IT: " : "STANDARD_LOCAL_CSV_FILE_IT: ";
				String FILE_PARAM_NAME_EN = form.isValueSet() ? "VALUESET_CSV_FILE_EN: " : "STANDARD_LOCAL_CSV_FILE_EN: ";
				
				Gson gson = new Gson();
				String[] value = new String[] { "CODE_SYSTEM_OID: " + form.getOid(),
						"CODE_SYSTEM_DESCRIPTION: " + form.getDescription(),
						FILE_PARAM_NAME_IT + localFileIt,
						FILE_PARAM_NAME_EN + localFileEn,
						"DOMAIN: " + form.getDomain(),
						"ORGANIZATION: " + form.getOrganization(),
						"TYPE: " + form.getType(),
						"SUBTYPE: " + form.getSubtype(),
						"TYPE_MAPPING: " + gson.toJson(form.getTypeMapping()),
						"CODIFICATION_MAPPING: " + gson.toJson(form.getCodificationMapping()),
						"VERSION_DESCRIPTION: " + form.getDescription(),
						"NAME: " + codeName,
						"HAS_ONTOLOGY: "+form.getHasOntology(),
						"ONTOLOGY_NAME: "+form.getOntologyName()}; 
				
				
				
				ResponseEntity<String> response = StiUtil.sendRequest(url, value, form.getReleaseDate(), changeSetURI);
				logger.info("Response" + response);
				status = Status.OK;
				title = "You successfully imported files";
			}else {
				if(!validationResult.isValid()){
					status = Status.BAD_REQUEST;
					title = "importLocalBadRequestFormField";
				}
				if(!headerValidation.isValid()){
					status = Status.BAD_REQUEST;
					title = "importLocalBadRequestCsvField";
				}
			}
		} catch (HttpServerErrorException e) {
			title = e.getMessage();
			String responseBody = e.getResponseBodyAsString();
			logger.info("Error importing " + responseBody);
			title = "importError";
			status = Status.ERROR;
		} catch (Exception e) {
			title = e.getMessage();
			status = Status.ERROR;
		}
//		logger.info("Parameters are: " + form.getVersion() + ", " + form.getReleaseDate() + ", " + form.getOid());

		validationResult.setTitle(title);
		validationResult.setStatus(status);
		
		return new ResponseEntity<ValidationResult>(validationResult, HttpStatus.OK);
	}

}