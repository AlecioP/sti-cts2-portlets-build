package it.linksmt.cts2.portlet.search.rest.dtos;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;

public class CodeSystemDto implements Serializable {

	private static final long serialVersionUID = 4494300383865311470L;

	private String name;
	private String currentVersion;
	private Long id;
	private boolean isClassification;
	private String domain;
	private String organization;
	private String type;
	private String subType;
	private String hasOntology;
	private String ontologyName;
	private String description;
	private String releaseDate;
	
	private HashMap<String, String> typeMapping = new HashMap<String, String>();
	
	public CodeSystemDto() {
		
	}
	
	public CodeSystemDto(String name, String currentVersion) {
		this.name = name;
		this.currentVersion = currentVersion;
	}
	
	public String getCurrentVersion() {
		return currentVersion;
	}
	public void setCurrentVersion(String currentVersion) {
		this.currentVersion = currentVersion;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public HashMap<String, String> getTypeMapping() {
		return typeMapping;
	}

	public void setTypeMapping(HashMap<String, String> typeMapping) {
		this.typeMapping = typeMapping;
	}

	public boolean getIsClassification() {
		return isClassification;
	}

	public void setIsClassification(boolean isClassification) {
		this.isClassification = isClassification;
	}

	public String getDomain() {
		return domain;
	}

	public void setDomain(String domain) {
		this.domain = domain;
	}

	public String getOrganization() {
		return organization;
	}

	public void setOrganization(String organization) {
		this.organization = organization;
	}
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getSubType() {
		return subType;
	}

	public void setSubType(String subType) {
		this.subType = subType;
	}

	public void setClassification(boolean isClassification) {
		this.isClassification = isClassification;
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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	public String getReleaseDate() {
		return releaseDate;
	}

	public void setReleaseDate(String releaseDate) {
		this.releaseDate = releaseDate;
	}
	

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("CodeSystemDto [name=");
		builder.append(name);
		builder.append(", currentVersion=");
		builder.append(currentVersion);
		builder.append(", id=");
		builder.append(id);
		builder.append(", isClassification=");
		builder.append(isClassification);
		builder.append(", domain=");
		builder.append(domain);
		builder.append(", organization=");
		builder.append(organization);
		builder.append(", type=");
		builder.append(type);
		builder.append(", subType=");
		builder.append(subType);
		builder.append(", hasOntology=");
		builder.append(hasOntology);
		builder.append(", ontologyName=");
		builder.append(ontologyName);
		builder.append(", description=");
		builder.append(description);
		builder.append(", releaseDate=");
		builder.append(releaseDate);
		builder.append(", typeMapping=");
		builder.append(typeMapping);
		builder.append("]");
		return builder.toString();
	}

}
