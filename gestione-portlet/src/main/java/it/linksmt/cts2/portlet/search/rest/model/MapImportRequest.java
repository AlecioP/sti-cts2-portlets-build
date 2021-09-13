package it.linksmt.cts2.portlet.search.rest.model;

import org.codehaus.jackson.annotate.JsonProperty;

/**
 * Map import request.
 * @author Davide Pastore
 *
 */
public class MapImportRequest {

	
	private MapVersion mapVersion;

	@JsonProperty("MapVersion")
	public MapVersion getMapVersion() {
		return mapVersion;
	}

	public void setMapVersion(MapVersion mapVersion) {
		this.mapVersion = mapVersion;
	}
}
