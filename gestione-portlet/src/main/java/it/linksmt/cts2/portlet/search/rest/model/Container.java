package it.linksmt.cts2.portlet.search.rest.model;

/**
 * Container in the request to import the mapping.
 * 
 * @author Davide Pastore
 *
 */
public class Container {
	private String content;

	public Container(String content) {
		super();
		this.content = content;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
}
