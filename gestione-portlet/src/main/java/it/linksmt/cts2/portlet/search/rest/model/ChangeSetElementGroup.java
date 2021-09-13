package it.linksmt.cts2.portlet.search.rest.model;

/**
 * The ChangeSetElementGroup attribute of the request.
 * 
 * @author Davide Pastore
 *
 */
public class ChangeSetElementGroup {
	
	private ChangeInstructions changeInstructions;

	public ChangeInstructions getChangeInstructions() {
		return changeInstructions;
	}

	public void setChangeInstructions(ChangeInstructions changeInstructions) {
		this.changeInstructions = changeInstructions;
	}
}