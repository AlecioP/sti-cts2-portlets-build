package it.linksmt.cts2.portlet.search.rest.model;

/**
 * CodeSystemVersion in the request to import the mapping.
 * 
 * @author Davide Pastore
 *
 */
public class CodeSystemVersion {
	private Container version;
	private Container codeSystem;

	public Container getVersion() {
		return version;
	}

	public void setVersion(Container version) {
		this.version = version;
	}

	public Container getCodeSystem() {
		return codeSystem;
	}

	public void setCodeSystem(Container codeSystem) {
		this.codeSystem = codeSystem;
	}
}
