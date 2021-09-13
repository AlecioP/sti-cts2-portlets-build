package it.linksmt.cts2.portlet.search.rest.dtos;

import java.io.Serializable;

public class ChangelogDto implements Serializable {

	private static final long serialVersionUID = 4730144413615516874L;

	private String codeSystem;
	private String version;
	private String previousVersion;
	private String dateCreate;
	private Integer newCodes;
	private Integer deletedCodes;
	private Integer importedRow;
	private String changedCodes;
	private String type;
	private String languages;
	private String title;
	private String codeSystemTo;
	private String versionTo;
	
	
	public String getCodeSystem() {
		return codeSystem;
	}

	public void setCodeSystem(String codeSystem) {
		this.codeSystem = codeSystem;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getPreviousVersion() {
		return previousVersion;
	}

	public void setPreviousVersion(String previousVersion) {
		this.previousVersion = previousVersion;
	}

	public String getDateCreate() {
		return dateCreate;
	}

	public void setDateCreate(String dateCreate) {
		this.dateCreate = dateCreate;
	}

	public Integer getNewCodes() {
		return newCodes;
	}

	public void setNewCodes(Integer newCodes) {
		this.newCodes = newCodes;
	}

	public Integer getDeletedCodes() {
		return deletedCodes;
	}

	public void setDeletedCodes(Integer deletedCodes) {
		this.deletedCodes = deletedCodes;
	}

	public String getChangedCodes() {
		return changedCodes;
	}

	public void setChangedCodes(String changedCodes) {
		this.changedCodes = changedCodes;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getLanguages() {
		return languages;
	}

	public void setLanguages(String languages) {
		this.languages = languages;
	}
	
	public Integer getImportedRow() {
		return importedRow;
	}

	public void setImportedRow(Integer importedRow) {
		this.importedRow = importedRow;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getCodeSystemTo() {
		return codeSystemTo;
	}

	public void setCodeSystemTo(String codeSystemTo) {
		this.codeSystemTo = codeSystemTo;
	}

	public String getVersionTo() {
		return versionTo;
	}

	public void setVersionTo(String versionTo) {
		this.versionTo = versionTo;
	}

}
