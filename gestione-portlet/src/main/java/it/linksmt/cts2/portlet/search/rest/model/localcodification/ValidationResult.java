package it.linksmt.cts2.portlet.search.rest.model.localcodification;

import it.linksmt.cts2.portlet.search.rest.model.Status;

import java.io.Serializable;
import java.util.HashMap;

public class ValidationResult implements Serializable {

	private static final long serialVersionUID = -3793590330726197744L;
	private boolean valid = true;
	private HashMap<String, String> validationsFields = new HashMap<String, String>(0);
	private String title;
	private Status status;	
	
	public boolean isValid() {
		return valid;
	}
	public void setValid(boolean valid) {
		this.valid = valid;
	}
	public HashMap<String, String> getValidationsFields() {
		return validationsFields;
	}
	public void setValidationsFields(HashMap<String, String> validationsFields) {
		this.validationsFields = validationsFields;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public Status getStatus() {
		return status;
	}
	public void setStatus(Status status) {
		this.status = status;
	}
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("ValidationResult [valid=");
		builder.append(valid);
		builder.append(", validationsFields=");
		builder.append(validationsFields);
		builder.append(", title=");
		builder.append(title);
		builder.append(", status=");
		builder.append(status);
		builder.append("]");
		return builder.toString();
	}
	
}
