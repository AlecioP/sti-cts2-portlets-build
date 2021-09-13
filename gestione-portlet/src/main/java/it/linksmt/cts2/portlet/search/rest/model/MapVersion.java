package it.linksmt.cts2.portlet.search.rest.model;

/**
 * MapVersion in the request to import the mapping.
 * 
 * @author Davide Pastore
 *
 */
public class MapVersion {
	private String officialReleaseDate;
	private String sourceStatements;
	private CodeSystemVersion fromCodeSystemVersion;
	private CodeSystemVersion toCodeSystemVersion;
	private String mapVersionName;

	public String getOfficialReleaseDate() {
		return officialReleaseDate;
	}

	public void setOfficialReleaseDate(String mapVersionName) {
		this.officialReleaseDate = mapVersionName;
	}

	public String getSourceStatements() {
		return sourceStatements;
	}

	public void setSourceStatements(String sourceStatements) {
		this.sourceStatements = sourceStatements;
	}

	public CodeSystemVersion getFromCodeSystemVersion() {
		return fromCodeSystemVersion;
	}

	public void setFromCodeSystemVersion(CodeSystemVersion fromCodeSystemVersion) {
		this.fromCodeSystemVersion = fromCodeSystemVersion;
	}

	public CodeSystemVersion getToCodeSystemVersion() {
		return toCodeSystemVersion;
	}

	public void setToCodeSystemVersion(CodeSystemVersion toCodeSystemVersion) {
		this.toCodeSystemVersion = toCodeSystemVersion;
	}

	public String getMapVersionName() {
		return mapVersionName;
	}

	public void setMapVersionName(String mapVersionName) {
		this.mapVersionName = mapVersionName;
	}

}
