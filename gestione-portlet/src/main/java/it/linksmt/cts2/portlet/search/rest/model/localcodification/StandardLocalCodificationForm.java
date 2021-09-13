package it.linksmt.cts2.portlet.search.rest.model.localcodification;

import java.io.Serializable;
import java.util.HashMap;
import java.util.LinkedHashMap;

public class StandardLocalCodificationForm implements Serializable {

	private static final long serialVersionUID = -1451805144166378644L;

	private String name;
	private String description;
	private String version;
	private String releaseDate;
	private String oid;
	private String type;
	private String subtype;
	private String domain;
	private String organization;
	private String hasOntology;
	private String ontologyName;
	
	private String tmpFileNameIt;
	private String tmpFileNameEn;
	
	
	private LinkedHashMap<String, String> typeMapping;
	private HashMap<String, String> codificationMapping;
	
	private String importMode;
	private String codeSystemId;
	
	private boolean valueSet;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getReleaseDate() {
		return releaseDate;
	}
	public void setReleaseDate(String releaseDate) {
		this.releaseDate = releaseDate;
	}
	public String getOid() {
		return oid;
	}
	public void setOid(String oid) {
		this.oid = oid;
	}
	public LinkedHashMap<String, String> getTypeMapping() {
		return typeMapping;
	}
	public void setTypeMapping(LinkedHashMap<String, String> typeMapping) {
		this.typeMapping = typeMapping;
	}
	public String getTmpFileNameIt() {
		return tmpFileNameIt;
	}
	public void setTmpFileNameIt(String tmpFileNameIt) {
		this.tmpFileNameIt = tmpFileNameIt;
	}
	public String getTmpFileNameEn() {
		return tmpFileNameEn;
	}
	public void setTmpFileNameEn(String tmpFileNameEn) {
		this.tmpFileNameEn = tmpFileNameEn;
	}
	public String getSubtype() {
		return subtype;
	}
	public void setSubtype(String subtype) {
		this.subtype = subtype;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getDomain() {
		return domain;
	}
	public void setDomain(String domain) {
		this.domain = domain;
	}
	public HashMap<String, String> getCodificationMapping() {
		return codificationMapping;
	}
	public void setCodificationMapping(
			HashMap<String, String> codificationMapping) {
		this.codificationMapping = codificationMapping;
	}
	public String getOrganization() {
		return organization;
	}
	public void setOrganization(String organization) {
		this.organization = organization;
	}
	
	public boolean isValueSet() {
		return valueSet;
	}
	public void setValueSet(boolean valueSet) {
		this.valueSet = valueSet;
	}
	public String getHasOntology() {
		return hasOntology;
	}
	public void setHasOntology(String hasOntology) {
		this.hasOntology = hasOntology;
	}
	public String getOntologyName() {
		return ontologyName;
	}
	public void setOntologyName(String ontologyName) {
		this.ontologyName = ontologyName;
	}
	public String getImportMode() {
		return importMode;
	}
	public void setImportMode(String importMode) {
		this.importMode = importMode;
	}
	
	public String getCodeSystemId() {
		return codeSystemId;
	}
	public void setCodeSystemId(String codeSystemId) {
		this.codeSystemId = codeSystemId;
	}
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("StandardLocalCodificationForm [name=");
		builder.append(name);
		builder.append(", description=");
		builder.append(description);
		builder.append(", version=");
		builder.append(version);
		builder.append(", releaseDate=");
		builder.append(releaseDate);
		builder.append(", oid=");
		builder.append(oid);
		builder.append(", type=");
		builder.append(type);
		builder.append(", subtype=");
		builder.append(subtype);
		builder.append(", domain=");
		builder.append(domain);
		builder.append(", organization=");
		builder.append(organization);
		builder.append(", hasOntology=");
		builder.append(hasOntology);
		builder.append(", ontologyName=");
		builder.append(ontologyName);
		builder.append(", tmpFileNameIt=");
		builder.append(tmpFileNameIt);
		builder.append(", tmpFileNameEn=");
		builder.append(tmpFileNameEn);
		builder.append(", typeMapping=");
		builder.append(typeMapping);
		builder.append(", codificationMapping=");
		builder.append(codificationMapping);
		builder.append(", importMode=");
		builder.append(importMode);
		builder.append(", codeSystemId=");
		builder.append(codeSystemId);
		builder.append(", valueSet=");
		builder.append(valueSet);
		builder.append("]");
		return builder.toString();
	}
	
}
