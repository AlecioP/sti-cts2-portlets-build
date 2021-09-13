package it.linksmt.cts2.portlet.search.rest.model;

import org.codehaus.jackson.annotate.JsonProperty;

/**
 * The ChangeSet request.
 * @author Davide Pastore
 *
 */
public class ChangeSetRequest {

	private ChangeSet changeSet;

	@JsonProperty("ChangeSet")
	public ChangeSet getChangeSet() {
		return changeSet;
	}

	public void setChangeSet(ChangeSet changeSet) {
		this.changeSet = changeSet;
	}
}
