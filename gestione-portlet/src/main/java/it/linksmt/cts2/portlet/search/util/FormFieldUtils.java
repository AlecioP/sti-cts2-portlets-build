package it.linksmt.cts2.portlet.search.util;

import it.linksmt.cts2.portlet.search.rest.dtos.CodeSystemDto;
import it.linksmt.cts2.portlet.search.rest.model.localcodification.StandardLocalCodificationForm;
import it.linksmt.cts2.portlet.search.rest.model.localcodification.ValidationResult;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.logging.Logger;

import org.codehaus.jackson.JsonProcessingException;

public class FormFieldUtils {


	
	
	/******************* VALIDATOR 
	 * @throws IOException 
	 * @throws JsonProcessingException *************************************/
	public static ValidationResult validateForm(StandardLocalCodificationForm form) throws Exception{
		ValidationResult result = new ValidationResult();
		HashMap<String, String> validationsFields = new HashMap<String, String>(0);
		boolean error =  true;

		CodeSystemDto codeSystemDto=null;
		if(null != form.getCodeSystemId() && !"".equals(form.getCodeSystemId())){
			codeSystemDto = StiUtil.getCodeSystemById(form.getCodeSystemId(),form.isValueSet());
		}
		
		if(null == form.getName() || "".equals(form.getName())){
			error =  false;
			validationsFields.put("Nome", "oblbigatorio");
		}
		if(null == form.getVersion() || "".equals(form.getVersion())){
			error =  false;
			validationsFields.put("Versione", "oblbigatorio");
		}
		if(null == form.getReleaseDate() || "".equals(form.getReleaseDate())){
			error =  false;
			validationsFields.put("Release Date", "oblbigatorio");
		}
		else{
			if(codeSystemDto!=null && codeSystemDto.getReleaseDate()!=null){
				DateFormat format1 = new SimpleDateFormat("dd/MM/yyyy");
				DateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
				try {
					Date releaseDate = format1.parse(codeSystemDto.getReleaseDate());
					Date isertDateDate = format2.parse(form.getReleaseDate());
					if(isertDateDate.equals(releaseDate) || isertDateDate.before(releaseDate)){
						error =  false;
						validationsFields.put("Release Date", "deve essere successiva alla precedente versione["+codeSystemDto.getReleaseDate()+"]");
					}
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
		}
//		if(null == form.getDomain() || "".equals(form.getDomain())){
//			error =  false;
//			validationsFields.put("Dominio", "oblbigatorio");
//		}
		
		if(null != form.getHasOntology() && "Y".equals(form.getHasOntology()) && "".equals(form.getOntologyName())){
			error =  false;
			validationsFields.put("Nome ontologia ", "oblbigatorio");
		}
		if(null == form.getDescription() || "".equals(form.getDescription())){
			error =  false;
			validationsFields.put("Descrizione", "oblbigatorio");
		}
		
		
		if(!form.getImportMode().equals("newVersion")){
			if(null == form.getOrganization() || "".equals(form.getOrganization())){
				error =  false;
				validationsFields.put("Organizzazione", "oblbigatorio");
			}
		}
		
		if(!form.isValueSet()){
			if(null == form.getType() || "".equals(form.getType())){
				error =  false;
				validationsFields.put("Tipo di code system", "oblbigatorio");
			}
			if(null == form.getSubtype() || "".equals(form.getSubtype())){
				error =  false;
				validationsFields.put("Tipo", "oblbigatorio");
			}
		}
		
		
		
		
		result.setValidationsFields(validationsFields);
		result.setValid(error);
		return result;
	}
}
