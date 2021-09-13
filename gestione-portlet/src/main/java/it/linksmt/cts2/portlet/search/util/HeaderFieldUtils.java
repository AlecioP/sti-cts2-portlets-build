package it.linksmt.cts2.portlet.search.util;

import it.linksmt.cts2.portlet.search.rest.model.localcodification.HeaderField;
import it.linksmt.cts2.portlet.search.rest.model.localcodification.HeaderFieldOption;
import it.linksmt.cts2.portlet.search.rest.model.localcodification.HeaderValidationResult;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.codehaus.jackson.JsonProcessingException;

public class HeaderFieldUtils {

	public static final String FIELD_CODICE = "code";
	public static final String FIELD_DESCRIZIONE = "description";
	public static final String FIELD_VERSIONE = "versione";
//	public static final String FIELD_COMPONENTE = "componente";
//	public static final String FIELD_PROPRIETA = "proprieta";
	public static final String FIELD_MAPPING = "mapping";

	private final static HeaderFieldOption OPTION_CODE = new HeaderFieldOption("Code", "code", null, "headerTypeCode");
	private final static HeaderFieldOption OPTION_DESCRIPTION = new HeaderFieldOption("Description", "description", null, "headerTypeDescription");
	private final static HeaderFieldOption OPTION_STRING = new HeaderFieldOption("String", "java.lang.String", null, "headerTypeString");
	private final static HeaderFieldOption OPTION_NUMBER = new HeaderFieldOption("Number", "java.lang.Double", null, "headerTypeNumber");
	private final static HeaderFieldOption OPTION_DATE = new HeaderFieldOption("Date", "java.util.Date", "yyyy-MM-dd", "headerTypeDate");
	private final static HeaderFieldOption OPTION_MAPPING = new HeaderFieldOption("Mapping", "it.linksmt.cts2.portlet.search.rest.model.localcodification.HeaderFieldOption", null, "headerTypeMapping");

//	private final static String[] DEFAULT_HEADERS = new String[]{FIELD_CODICE, FIELD_DESCRIZIONE, FIELD_VERSIONE, FIELD_MAPPING};
	private final static String[] REQUIRED_HEADERS = new String[]{FIELD_CODICE, FIELD_DESCRIZIONE};

	public static HeaderField getHeaderField(String columnName, List<String> codeSystems) {
		return new HeaderField(columnName, true, getDefaultOptions(codeSystems), null);
//		return new HeaderField(headerToUpperCase(columnName), true, getDefaultOptions(codeSystems), null);
	}


	
	public static List<HeaderFieldOption> getDefaultOptions(List<String> codeSystems) {
		List<HeaderFieldOption> options = new ArrayList<HeaderFieldOption>();
		options.add(OPTION_CODE);
		options.add(OPTION_DESCRIPTION);
		options.add(OPTION_STRING);
		options.add(OPTION_NUMBER);
		options.add(OPTION_DATE);
		options.add(OPTION_MAPPING);
		return options;
	}
	
	public static List<HeaderFieldOption> getMappingOptions(List<String> codeSystems) {
		List<HeaderFieldOption> options = new ArrayList<HeaderFieldOption>();
		if(null != codeSystems) {
			for (String cs : codeSystems){
				options.add(new HeaderFieldOption(cs, cs, null, null));
			}
		}
		return options;
	}
	
	
	
	/******************* VALIDATOR *************************************/
	public static HeaderValidationResult validateMapping(HashMap<String, String> fieldsMapping){
		HeaderValidationResult result = new HeaderValidationResult();
		List<String> header = new ArrayList<String>(fieldsMapping.values());
		for(String h : REQUIRED_HEADERS){
			boolean contains = header.contains(h);
			if(!contains){
				result.setValid(false);
			}
		}

		return result;
	}
	
	
	public static HeaderValidationResult validateHeader(final String codeSystemId, final boolean isValueSet,
			final  String langPrimary, final List<String> headerPrimary, final List<String> headerTranslate, final HashMap<String, String> typeMapping){
		
		
		HeaderValidationResult result = new HeaderValidationResult();
		
		/*Recupera i campi salvati nelle versioni precedenti*/
		String requestUrl = StiUtil.buildGetParamsUrl(codeSystemId,isValueSet);
		List<String> previousVersionHeaderIt = new ArrayList<String>(0);
		List<String> previousVersionHeaderEn = new ArrayList<String>(0);
		try {
			Map<String,List<String>> mapParams = StiUtil.getCodeSystemParams( new URI(requestUrl));
			previousVersionHeaderIt = mapParams.get(Constants.LANG_IT);
			previousVersionHeaderEn = mapParams.get(Constants.LANG_EN);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}
		
		
		
		/*Uniforma le liste in UPPERCASE*/
		List<String> headerPrimaryClean = paramNameToUpperCaseAndClean(headerPrimary);
		List<String> headerTranslateClean = paramNameToUpperCaseAndClean(headerTranslate);
		previousVersionHeaderIt = paramNameToUpperCaseAndClean(previousVersionHeaderIt);
		previousVersionHeaderEn = paramNameToUpperCaseAndClean(previousVersionHeaderEn);
		
		/*Uniforma le liste in PRIMARY e TRANSLATE per ottimizzare il check successivo*/
		List<String> previousVersionHeaderPrimary = new ArrayList<String>(0);
		List<String> previousVersionHeaderTranslate = new ArrayList<String>(0);
		if(langPrimary.equals(Constants.LANG_IT)){
			previousVersionHeaderPrimary = previousVersionHeaderIt;
			previousVersionHeaderTranslate = previousVersionHeaderEn;
		}else if(langPrimary.equals(Constants.LANG_EN)){
			previousVersionHeaderPrimary = previousVersionHeaderEn;
			previousVersionHeaderTranslate = previousVersionHeaderIt;
		}
		
		
		HashMap<String, Boolean> validationResultPrimary = new HashMap<String, Boolean>();
		HashMap<String, Boolean> validationResultTranslate = new HashMap<String, Boolean>();
		List<String> messages = new ArrayList<String>(0);
		if(headerPrimaryClean.size()==0){
			result.setValid(false);
			messages.add("error_headerPrimary_not_present");
		}
		else{
			if(headerPrimaryClean.size()>0 && headerTranslateClean.size()>0){
				if(headerPrimaryClean.size() != headerTranslateClean.size()){
					result.setValid(false);
					messages.add("error_lenght_header");
				}
				else{
					for(String h : previousVersionHeaderPrimary){
						boolean contains = headerPrimaryClean.contains(h);
						if(!contains){
							validationResultPrimary.put(h, contains);
							result.setValid(false);
						}
					}
					
					for(String h : previousVersionHeaderTranslate){
						boolean contains = headerTranslateClean.contains(h);
						if(!contains){
							validationResultTranslate.put(h, contains);
							result.setValid(false);
						}
					}
					
//					if(validationResultPrimary.size()>0 && validationResultTranslate.size()>0 
//							&& validationResultPrimary.size() == validationResultTranslate.size()
//							&& previousVersionHeaderPrimary.containsAll(validationResultPrimary.keySet()) 
//							&& previousVersionHeaderTranslate.containsAll(validationResultTranslate.keySet())){
//						result.setValid(false);
//						messages.add("error_invert");
//					}
				}
			}
			else if(headerPrimaryClean.size()>0 && headerTranslateClean.size()==0){
				
				if(previousVersionHeaderPrimary.size() >= previousVersionHeaderTranslate.size()){
					if(previousVersionHeaderPrimary.size()>0 && previousVersionHeaderPrimary.size()!=(headerPrimaryClean.size()-2)){
						result.setValid(false);
						messages.add("error_lenght_primary_header");
					}
					
					for(String h : previousVersionHeaderPrimary){
						boolean contains = headerPrimaryClean.contains(h);
						if(!contains){
							validationResultPrimary.put(h, contains);
							result.setValid(false);
						}
					}
					
				}
				else if(previousVersionHeaderTranslate.size()>0 && previousVersionHeaderTranslate.size()!=(headerPrimaryClean.size()-2)){
						result.setValid(false);
						messages.add("error_lenght_primary_header");
				}
				else{
					for(String h : previousVersionHeaderPrimary){
						boolean contains = headerPrimaryClean.contains(h);
						if(!contains){
							validationResultPrimary.put(h, contains);
							result.setValid(false);
						}
					}
				}
			}
		}
		
		result.setValidationsPrimary(validationResultPrimary);
		result.setValidationsTranslate(validationResultTranslate);
		result.setMessages(messages);
		result.setLangPrimary(langPrimary);
		return result;
	}



	
	
	public static HeaderValidationResult validateLenghtContent(List<String> headerIt,List<String> headerEn){
		HeaderValidationResult result = new HeaderValidationResult();
		if(headerIt.size() != headerEn.size()){
			result.setValid(false);
		}  
		return result;
	}
	
	
	private static List<String> paramNameToUpperCaseAndClean(List<String> header) {
		List<String> r = new ArrayList<String>(0);
		if(header!=null){
			for (String string : header) {
				r.add(paramNameToUpperCaseAndClean(string));
			}
		}
		return r;
	}
	
	private static String paramNameToUpperCaseAndClean(String s) {
		if(s!=null){
			s = s.toUpperCase().trim().replaceAll("\\s","_").replaceAll("\\(","").replaceAll("\\)","").replaceAll("\"","");
//			s = s.toUpperCase();
		}
		return s;
	}
	

}
