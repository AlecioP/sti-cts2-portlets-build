package it.linksmt.cts2.portlet.search;

import it.linksmt.cts2.portlet.search.rest.model.Status;

/**
 * The response message.
 * @author Davide Pastore
 *
 */
public class Message {

	private String title;
	private Status status;

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

}
