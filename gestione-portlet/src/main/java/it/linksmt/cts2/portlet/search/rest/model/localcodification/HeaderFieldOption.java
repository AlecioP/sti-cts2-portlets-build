package it.linksmt.cts2.portlet.search.rest.model.localcodification;

import java.io.Serializable;

public class HeaderFieldOption implements Serializable {

	private static final long serialVersionUID = -630511126730665442L;

	private String name;
	private String type;
	private String translateKey;
	private String format;
	
	public HeaderFieldOption() {
		
	}
	
	public HeaderFieldOption(String name, String type, String format, String translateKey) {
		super();
		this.name = name;
		this.type = type;
		this.format = format;
		this.translateKey = translateKey;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getTranslateKey() {
		return translateKey;
	}
	public void setTranslateKey(String translateKey) {
		this.translateKey = translateKey;
	}
	public String getFormat() {
		return format;
	}
	public void setFormat(String format) {
		this.format = format;
	}
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("HeaderFieldOption [name=");
		builder.append(name);
		builder.append(", type=");
		builder.append(type);
		builder.append(", translateKey=");
		builder.append(translateKey);
		builder.append(", format=");
		builder.append(format);
		builder.append("]");
		return builder.toString();
	}
	
}
