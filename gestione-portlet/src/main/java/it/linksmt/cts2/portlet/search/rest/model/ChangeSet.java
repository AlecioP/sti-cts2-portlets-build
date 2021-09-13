package it.linksmt.cts2.portlet.search.rest.model;

/**
 * The ChangeSet attribute of the request.
 * @author Davide Pastore
 *
 */
public class ChangeSet {
	
	private String officialEffectiveDate;
	private String changeSetURI;
	private ChangeSetElementGroup changeSetElementGroup;

	public String getOfficialEffectiveDate() {
		return officialEffectiveDate;
	}

	public void setOfficialEffectiveDate(String officialEffectiveDate) {
		this.officialEffectiveDate = officialEffectiveDate;
	}

	public ChangeSetElementGroup getChangeSetElementGroup() {
		return changeSetElementGroup;
	}

	public void setChangeSetElementGroup(ChangeSetElementGroup changeSetElementGroup) {
		this.changeSetElementGroup = changeSetElementGroup;
	}

	public String getChangeSetURI() {
		return changeSetURI;
	}

	public void setChangeSetURI(String changeSetURI) {
		this.changeSetURI = changeSetURI;
	}
	

}
