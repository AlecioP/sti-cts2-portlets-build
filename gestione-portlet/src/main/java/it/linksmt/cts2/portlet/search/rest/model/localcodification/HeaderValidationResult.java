package it.linksmt.cts2.portlet.search.rest.model.localcodification;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class HeaderValidationResult implements Serializable {

	private static final long serialVersionUID = 8498109057929262260L;

	private boolean valid = true;
	private HashMap<String, Boolean> validationsPrimary = new HashMap<String, Boolean>(0);
	private HashMap<String, Boolean> validationsTranslate = new HashMap<String, Boolean>(0);
	private List<String> messages = new ArrayList<String>(0);
	private String langPrimary = "";
	
	public boolean isValid() {
		return valid;
	}

	public void setValid(boolean valid) {
		this.valid = valid;
	}

	public HashMap<String, Boolean> getValidationsPrimary() {
		return validationsPrimary;
	}

	public void setValidationsPrimary(HashMap<String, Boolean> validationsPrimary) {
		this.validationsPrimary = validationsPrimary;
	}

	public HashMap<String, Boolean> getValidationsTranslate() {
		return validationsTranslate;
	}

	public void setValidationsTranslate(HashMap<String, Boolean> validationsTranslate) {
		this.validationsTranslate = validationsTranslate;
	}

	public List<String> getMessages() {
		return messages;
	}

	public void setMessages(List<String> messages) {
		this.messages = messages;
	}
	public String getLangPrimary() {
		return langPrimary;
	}

	public void setLangPrimary(String langPrimary) {
		this.langPrimary = langPrimary;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("HeaderValidationResult [valid=");
		builder.append(valid);
		builder.append(", validationsPrimary=");
		builder.append(validationsPrimary);
		builder.append(", validationsTranslate=");
		builder.append(validationsTranslate);
		builder.append(", messages=");
		builder.append(messages);
		builder.append(", langPrimary=");
		builder.append(langPrimary);
		builder.append("]");
		return builder.toString();
	}

}
