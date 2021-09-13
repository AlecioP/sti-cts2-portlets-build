package it.linksmt.cts2.portlet.search.util;

import it.linksmt.cts2.portlet.search.StiAppConfig;
import it.linksmt.cts2.portlet.search.rest.dtos.CodeSystemDto;
import it.linksmt.cts2.portlet.search.rest.model.ChangeInstructions;
import it.linksmt.cts2.portlet.search.rest.model.ChangeSet;
import it.linksmt.cts2.portlet.search.rest.model.ChangeSetElementGroup;
import it.linksmt.cts2.portlet.search.rest.model.ChangeSetRequest;
import it.linksmt.cts2.portlet.search.rest.model.CodeSystemVersion;
import it.linksmt.cts2.portlet.search.rest.model.Container;
import it.linksmt.cts2.portlet.search.rest.model.MapImportRequest;
import it.linksmt.cts2.portlet.search.rest.model.MapVersion;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.Charset;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.map.LinkedMap;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.JsonProcessingException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class StiUtil {
	
	private static String serverAddress = StiAppConfig.getProperty("cts2.sti.server.address", "");
	
	private static final Logger logger = Logger.getLogger(StiUtil.class);

	/**
	 * Save the given MultipartFile in the configuration directory.
	 *
	 * @param file
	 *            The file to upload.
	 * @param uploadFilePath The upload file path.
	 * @param codeSystem The code system.
	 * @param type The type.
	 * @return Returns the path of the uploaded file.
	 * @throws Exception
	 */
	public static String loadFileInDirectory(final MultipartFile file,
			final String uploadFilePath, String codeSystem, String type) throws Exception {
		File outputFile;
		if (!file.isEmpty()) {
			byte[] bytes = file.getBytes();
			String uuid = UUID.randomUUID().toString();
			
			//Create the directories recursively
			File outputDirectory = new File(uploadFilePath + File.separator + type + File.separator + codeSystem);
			outputDirectory.mkdirs();
			outputFile = new File(outputDirectory, file.getName() + uuid);
			BufferedOutputStream stream = new BufferedOutputStream(
					new FileOutputStream(outputFile));
			stream.write(bytes);
			stream.close();
		} else {
			throw new Exception("You failed to upload " + file.getName() + " because the file was empty.");
		}
		if(outputFile != null){			
			String absolutePath = outputFile.getAbsolutePath();
			File uploadDirectory = new File(uploadFilePath);
			//return absolutePath.replace(File.separator, "/").replace(uploadFilePath, "");
			return absolutePath.replace(uploadDirectory.getAbsolutePath(), "");
		}
		return null;
	}
	
	public static String loadFileInDirectory(final File file, final String uploadFilePath, String codeSystem, String type) throws Exception {
		File outputFile;
		String uuid = UUID.randomUUID().toString();
		
		//Create the directories recursively
		File outputDirectory = new File(uploadFilePath + File.separator + type + File.separator + codeSystem);
		outputDirectory.mkdirs();
		outputFile = new File(outputDirectory, file.getName() + uuid);
		BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(outputFile));
		stream.write(FileUtils.readFileToByteArray(file));
		stream.close();
		
		if(outputFile != null){			
			String absolutePath = outputFile.getAbsolutePath();
			File uploadDirectory = new File(uploadFilePath);
			//return absolutePath.replace(File.separator, "/").replace(uploadFilePath, "");
			return absolutePath.replace(uploadDirectory.getAbsolutePath(), "");
		}
		return null;
	}
	
	
	/**
	 * Generate the change set URI by the given code system and version.
	 * @param codeSystem The code system.
	 * @param version The version.
	 * @return Returns the change set URI generated by the given code system and version.
	 * E.g. LOINC:2.56
	 */
	public static String generateChangeSetURI(String codeSystem, String version){
//		return codeSystem + ":" + version;
		return codeSystem.replace(" ", "%20") + ":" + version.replace(" ", "%20");
	}
	
	
	/**
	 * Generate the url.
	 * @param codeSystem The code system.
	 * @param version The version.
	 * @return Returns the url from the given codeSystem and version.
	 */
	public static String generateUrl(String codeSystem, String version){
		return serverAddress + "/cts2framework/changeset/" + generateChangeSetURI(codeSystem, version) + "?format=json";
	}
	
	/**
	 * Convert the date from request.
	 * @param stringDate The {@link String} to convert in {@link Date} object.
	 * @return Returns the date from the request.
	 * @throws ParseException 
	 */
	public static Date getDateFromRequest(String stringDate) throws ParseException{
		return new SimpleDateFormat("yyyy-MM-dd").parse(stringDate);
	}
	
	/**
	 * Generate official effective date.
	 * @param stringDate The string date to convert.
	 * @return Returns the official effective date.
	 * @throws ParseException
	 */
	public static String generateOfficialEffectiveDate(String stringDate) throws ParseException{
		Date date = getDateFromRequest(stringDate);
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss.SSSZ");
		return df.format(date);
	}
	
	public static String generateOfficialEffectiveName(String name){
		return StringUtils.trim(name).replaceAll("[^a-zA-Z0-9àèìòùÀÈÌÒÙ]+","_");
	}
	
	/**
	 * Send request.
	 * @param url The URL to which send the request.
	 * @param value The value.
	 * @param releaseDateString The release date in a String format.
	 * @param changeSetURI The change set URI.
	 * @return Returns the response from the request.
	 * @throws ParseException 
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonGenerationException 
	 */
	public static ResponseEntity<String> sendRequest(URI url, String[] value, String releaseDateString, String changeSetURI) throws ParseException, JsonGenerationException, JsonMappingException, IOException{
		RestTemplate restTemplate = new RestTemplate();
		restTemplate.getMessageConverters().add(0, new StringHttpMessageConverter(Charset.forName("UTF-8")));
		
		ChangeSetRequest request = new ChangeSetRequest();
		ChangeSet changeSet = new ChangeSet();
		ChangeSetElementGroup changeSetElementGroup = new ChangeSetElementGroup();
		ChangeInstructions changeInstructions = new ChangeInstructions();
		
		changeInstructions.setValue(value);
		changeSetElementGroup.setChangeInstructions(changeInstructions);
		changeSet.setChangeSetElementGroup(changeSetElementGroup);
		changeSet.setChangeSetURI(changeSetURI);

		// Generate the date from the given releaseDate
		String officialEffectiveDate = StiUtil.generateOfficialEffectiveDate(releaseDateString);

		changeSet.setOfficialEffectiveDate(officialEffectiveDate);
		request.setChangeSet(changeSet);

		ObjectMapper mapper = new ObjectMapper();
		String jsonBody = mapper.writeValueAsString(request);
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json");
		HttpEntity<String> entity = new HttpEntity<String>(jsonBody, headers);
		return restTemplate.exchange(url, HttpMethod.PUT, entity, String.class);
	}
	
	/**
	 * Send local code system import request.
	 * @param url The URL to which send the request.
	 * @param value The value.
	 * @param changeSetURI The change set URI.
	 * @return Returns the response from the request.
	 * @throws ParseException 
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonGenerationException 
	 */
	public static ResponseEntity<String> sendLocalRequest(URI url, String[] value, String changeSetURI) throws ParseException, JsonGenerationException, JsonMappingException, IOException{
		RestTemplate restTemplate = new RestTemplate();
		ChangeSetRequest request = new ChangeSetRequest();
		ChangeSet changeSet = new ChangeSet();
		ChangeSetElementGroup changeSetElementGroup = new ChangeSetElementGroup();
		ChangeInstructions changeInstructions = new ChangeInstructions();
		
		changeInstructions.setValue(value);
		changeSetElementGroup.setChangeInstructions(changeInstructions);
		changeSet.setChangeSetElementGroup(changeSetElementGroup);
		changeSet.setChangeSetURI(changeSetURI);
		request.setChangeSet(changeSet);

		ObjectMapper mapper = new ObjectMapper();
		String jsonBody = mapper.writeValueAsString(request);
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json");
		HttpEntity<String> entity = new HttpEntity<String>(jsonBody,
				headers);
		return restTemplate.exchange(url,
				HttpMethod.PUT, entity, String.class);
	}
	
	/**
	 * Send a request to delete the local code.
	 * @param localName The URL to which send the request.
	 * @param value The value.
	 * @param changeSetURI The change set URI.
	 * @return Returns the response from the request.
	 * @throws ParseException 
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonGenerationException 
	 */
	public static ResponseEntity<String> deleteLocalCodeRequest(URI url) throws ParseException, JsonGenerationException, JsonMappingException, IOException{
		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json");
		HttpEntity<String> entity = new HttpEntity<String>(headers);
		return restTemplate.exchange(url,
				HttpMethod.DELETE, entity, String.class);
	}
	
	
	/**
	 * Generate the url to delete local code system.
	 * @param localCodeSystemName The local code system name.
	 * @param version The version.
	 * @return Returns the url from the given local code system name and version.
	 */
	public static String generateDeleteLocalCodeSystemUrl(String localCodeSystemName, String version){
		return serverAddress + "/cts2framework/changeset/" + localCodeSystemName + ":" + version + "?format=json";
	}
	
	/**
	 * Build import mapping url.
	 * @return Returns the build import mapping url.
	 */
	public static String buildImportMappingUrl(){
		return serverAddress + "/cts2framework/mapversion?changesetcontext=123&format=json";
	}
	
	/**
	 * Build the {@link MapImportRequest} by the given parameters.
	 * @param codeSystem1 The first code system.
	 * @param version1 The first version.
	 * @param codeSystem2 The second code system.
	 * @param version2 The second version.
	 * @param resourceMappingFile The resource mapping file.
	 * @param releaseDate The release date.
	 * @return Returns the built {@link MapImportRequest} by the given parameters.
	 * @throws ParseException 
	 */
	public static MapImportRequest buildMapImportRequest(String codeSystem1, String version1, String codeSystem2,
			String version2, String resourceMappingFile, String releaseDate, String mappingDescription, String mappingOrganization) throws ParseException{
		MapImportRequest mapImportRequest = new MapImportRequest();
		MapVersion mapVersion = new MapVersion();
		CodeSystemVersion fromCodeSystemVersion = new CodeSystemVersion();
		
		//Set from code system version
		fromCodeSystemVersion.setCodeSystem(new Container(codeSystem1));
		fromCodeSystemVersion.setVersion(new Container(version1));
		mapVersion.setFromCodeSystemVersion(fromCodeSystemVersion);
		
		mapVersion.setOfficialReleaseDate(StiUtil.generateOfficialEffectiveDate(releaseDate));
		mapVersion.setSourceStatements(resourceMappingFile);
		
		//Set to code system version
		CodeSystemVersion toCodeSystemVersion = new CodeSystemVersion();
		toCodeSystemVersion.setCodeSystem(new Container(codeSystem2));
		toCodeSystemVersion.setVersion(new Container(version2));
		mapVersion.setToCodeSystemVersion(toCodeSystemVersion);
		
		Gson gson = new Gson();
		Map<String,String> map = new HashMap<String,String>(0);
		map.put("mappingDescription", mappingDescription);
		map.put("mappingOrganization", mappingOrganization);
		mapVersion.setMapVersionName(gson.toJson(map));
		
		mapImportRequest.setMapVersion(mapVersion);
		return mapImportRequest;
	}


	/**
	 * Send the mapping import request.
	 * @param url The url to contact.
	 * @param mapImportRequest The ma import request.
	 * @return Returns the response from the server.
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonGenerationException 
	 */
	public static ResponseEntity<String> sendMappingImportRequest(URI url,
			MapImportRequest mapImportRequest) throws JsonGenerationException, JsonMappingException, IOException {
		RestTemplate restTemplate = new RestTemplate();
		ObjectMapper mapper = new ObjectMapper();
		String jsonBody = mapper.writeValueAsString(mapImportRequest);
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "application/json");
		HttpEntity<String> entity = new HttpEntity<String>(jsonBody, headers);
		return restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
	}
	
	
	public static String buildGetCodeSystemsUrl(){
		return serverAddress + "/cts2framework/codesystems?format=json";
	}
	
	public static String buildGetCodeSystemByIdUrl(String id,boolean isValueSet){
//		http://web30.linksmt.it/cts2framework/extras/cs/459?format=json
		if(isValueSet){
			return serverAddress + "/cts2framework/extras/vs/"+id+"?format=json";
		}
		else{
			return serverAddress + "/cts2framework/extras/cs/"+id+"?format=json";
		}
	}
	
	public static String buildGetExtraCodeSystemsUrl(){
		return serverAddress + "/cts2framework/extras/cs?format=json&listCsType=['LOCAL','STANDARD_NATIONAL']";
	}
	
//	public static String buildGetParamsUrl(Integer id,boolean isValueSet){
//		if(!isValueSet){
//			return serverAddress + "/cts2framework/extras/cs/"+id+"/parameters?format=json";
//		}
//		else{
//			return serverAddress + "/cts2framework/extras/vs/"+id+"/parameters?format=json";
//		}
//	}
	
	public static String buildGetParamsUrl(String nameOrId,boolean isValueSet){
		if(!isValueSet){
			return serverAddress + "/cts2framework/extras/cs/"+nameOrId+"/parameters?format=json";
		}
		else{
			return serverAddress + "/cts2framework/extras/vs/"+nameOrId+"/parameters?format=json";
		}
	}

	private static JsonNode getCodeSystemsCatalogEntries(URI url) throws JsonProcessingException, IOException {
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> codeSystemsResponse = restTemplate.getForEntity(url, String.class);
		JsonNode jNode = new ObjectMapper().readTree(codeSystemsResponse.getBody());
		JsonNode entries =  jNode.get("CodeSystemCatalogEntryDirectory").get("entry");
		return entries;
	}
	
	public static List<String> getCodeSystemsNames(URI url) throws JsonProcessingException, IOException {
		JsonNode entries =  getCodeSystemsCatalogEntries(url);
		List<String> codeSystems = new ArrayList<String>();
		if(null != entries && entries.isArray()){
			for(JsonNode cs : entries) {
				codeSystems.add(cs.get("codeSystemName").asText());
			}
		}
		return codeSystems;
	}
	
	
	
//	http://web30.linksmt.it/cts2framework/extras/cs/459?format=json
	
	public static CodeSystemDto getCodeSystemById(String id,boolean isValueSet) throws JsonProcessingException, IOException {
		CodeSystemDto codeSystemDto = new CodeSystemDto();
		
		String requestUrl = StiUtil.buildGetCodeSystemByIdUrl(id,isValueSet);
		URI url = null;
		try {
			url = new URI(requestUrl);
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> codeSystemsResponse = restTemplate.getForEntity(url, String.class);
		JsonParser parser = new JsonParser();
		JsonObject obj = parser.parse(codeSystemsResponse.getBody()).getAsJsonObject();
		if(obj!=null){
			JsonObject members =  obj.get("JsonObject").getAsJsonObject().get("members").getAsJsonObject();
			if(isValueSet){
				codeSystemDto = parseJsonVs(members);
			}
			else{
				codeSystemDto = parseJsonCs(members);
			}
		}
		
		return codeSystemDto;
	}	
		
	public static List<CodeSystemDto> getCodeSystems(URI url) throws JsonProcessingException, IOException {
		List<CodeSystemDto> codeSystems = new ArrayList<CodeSystemDto>();
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> codeSystemsResponse = restTemplate.getForEntity(url, String.class);
		JsonParser parser = new JsonParser();
		JsonObject obj = parser.parse(codeSystemsResponse.getBody()).getAsJsonObject();
		JsonArray array = obj.get("JsonArray").getAsJsonObject().get("elements").getAsJsonArray();
		Iterator<JsonElement> it = array.iterator();
		while(it.hasNext()) {
			JsonObject element = it.next().getAsJsonObject();
			JsonObject members = element.get("members").getAsJsonObject();
			CodeSystemDto dto = parseJsonCs(members);
			if(dto!=null){
				codeSystems.add(dto);
			}
		}
		
		return codeSystems;
	}

	private static CodeSystemDto parseJsonCs(JsonObject members) {
		CodeSystemDto dto = null;
		if(members!=null){
			dto = new CodeSystemDto();
			String csName = members.get("codeSystemName").getAsJsonObject().get("value").getAsString();
			Long csId = members.get("codeSystemId").getAsJsonObject().get("value").getAsLong();
			String currentVersion = members.get("currentVersion").getAsJsonObject().get("value").getAsString();
			boolean isClassification = members.get("isClassification").getAsJsonObject().get("value").getAsBoolean();
			String domain = members.get("domain").getAsJsonObject().get("value").getAsString();
			String organization = members.get("organization").getAsJsonObject().get("value").getAsString();
			String type = members.get("type").getAsJsonObject().get("value").getAsString();
			String subType = members.get("subType").getAsJsonObject().get("value").getAsString();
			String hasOntology = members.get("hasOntology").getAsJsonObject().get("value").getAsString();
			String ontologyName = members.get("ontologyName").getAsJsonObject().get("value").getAsString();
			String description = members.get("description").getAsJsonObject().get("value").getAsString();
			String releaseDate = members.get("releaseDate").getAsJsonObject().get("value").getAsString();
			
			
			
			dto.setName(csName);
			dto.setId(csId);
			dto.setCurrentVersion(currentVersion);
			dto.setIsClassification(isClassification);
			dto.setDomain(domain);
			dto.setOrganization(organization);
			dto.setType(type);
			dto.setSubType(subType);
			dto.setHasOntology(hasOntology);
			dto.setOntologyName(ontologyName);
			dto.setDescription(description);
			dto.setReleaseDate(releaseDate);
			
			
			LinkedHashMap<String, String> typeMapping = new LinkedHashMap<String, String>();
			try {
				JsonObject typeMappingMembers = members.get("typeMapping").getAsJsonObject().get("members").getAsJsonObject();
				for (LinkedMap.Entry<String,JsonElement> entry : typeMappingMembers.entrySet()) {
					typeMapping.put(entry.getKey(), entry.getValue().getAsJsonObject().get("value").getAsString());
				}
			}catch(Exception e) {
				
			}
			dto.setTypeMapping(typeMapping);
		}
		return dto;
	}
	
	private static CodeSystemDto parseJsonVs(JsonObject members) {
		CodeSystemDto dto = null;
		if(members!=null){
			dto = new CodeSystemDto();
			String csName = members.get("valueSetName").getAsJsonObject().get("value").getAsString();
			Long csId = members.get("valueSetId").getAsJsonObject().get("value").getAsLong();
			String currentVersion = members.get("currentVersion").getAsJsonObject().get("value").getAsString();
			String domain = members.get("domain").getAsJsonObject().get("value").getAsString();
			String organization = members.get("organization").getAsJsonObject().get("value").getAsString();
			String type = members.get("type").getAsJsonObject().get("value").getAsString();
			String description = members.get("description").getAsJsonObject().get("value").getAsString();
			String releaseDate = members.get("releaseDate").getAsJsonObject().get("value").getAsString();
			
			
			dto.setName(csName);
			dto.setId(csId);
			dto.setCurrentVersion(currentVersion);
			dto.setDomain(domain);
			dto.setOrganization(organization);
			dto.setType(type);
			dto.setDescription(description);
			dto.setReleaseDate(releaseDate);
			
			LinkedHashMap<String, String> typeMapping = new LinkedHashMap<String, String>();
			try {
				JsonObject typeMappingMembers = members.get("typeMapping").getAsJsonObject().get("members").getAsJsonObject();
				for (LinkedMap.Entry<String,JsonElement> entry : typeMappingMembers.entrySet()) {
					typeMapping.put(entry.getKey(), entry.getValue().getAsJsonObject().get("value").getAsString());
				}
			}catch(Exception e) {
				
			}
			dto.setTypeMapping(typeMapping);
		}
		return dto;
	}
	
	
	public static Map<String,List<String>> getCodeSystemParams(URI url) throws JsonProcessingException, IOException {
		Map<String,List<String>> response = new HashMap<String,List<String>>();
		List<String> fieldIt = new ArrayList<String>(0);
		List<String> fieldEn = new ArrayList<String>(0);
		
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> codeSystemsResponse = restTemplate.getForEntity(url, String.class);
		if(codeSystemsResponse!=null){
			JsonObject obj = new JsonParser().parse(codeSystemsResponse.getBody()).getAsJsonObject();
			
			if(obj!=null){
				JsonObject jsonArray = obj.get("JsonArray").getAsJsonObject();
				if(jsonArray!=null && jsonArray.get("elements")!=null){
					JsonArray array = jsonArray.get("elements").getAsJsonArray();
					
					Iterator<JsonElement> it = array.iterator();
					while(it.hasNext()) {
						JsonObject element = it.next().getAsJsonObject();
						JsonObject members = element.get("members").getAsJsonObject();
						String name = members.get("name").getAsJsonObject().get("value").getAsString();
						String lang = members.get("lang").getAsJsonObject().get("value").getAsString();
						//Integer position = members.get("position").getAsJsonObject().get("value").getAsInt();
						
						if(lang.equals(Constants.LANG_IT)){
							fieldIt.add(name.toUpperCase());
						}
						else if(lang.equals(Constants.LANG_EN)){
							fieldEn.add(name.toUpperCase());
						}
						
					}
					
					response.put(Constants.LANG_IT, fieldIt);
					response.put(Constants.LANG_EN, fieldEn);
				}
			}
		}
		return response;
	}
	
}
