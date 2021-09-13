package it.linksmt.cts2.portlet.search.rest.model.localcodification;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class HeaderField implements Serializable {

	private static final long serialVersionUID = -8377594236402923861L;

	private String columnName;
	private boolean selectable;
	
	private List<HeaderFieldOption> options = new ArrayList<HeaderFieldOption>();
	private HeaderFieldOption defaultOption;
	
	public HeaderField(){
		
	}
	
	public HeaderField(String columnName, boolean selectable,
			List<HeaderFieldOption> options, HeaderFieldOption defaultOption) {
		super();
		this.columnName = columnName;
		this.selectable = selectable;
		this.options = options;
		this.defaultOption = defaultOption;
	}
	public String getColumnName() {
		return columnName;
	}
	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}
	public boolean isSelectable() {
		return selectable;
	}
	public void setSelectable(boolean selectable) {
		this.selectable = selectable;
	}
	public List<HeaderFieldOption> getOptions() {
		return options;
	}
	public void setOptions(List<HeaderFieldOption> options) {
		this.options = options;
	}
	public HeaderFieldOption getDefaultOption() {
		return defaultOption;
	}
	public void setDefaultOption(HeaderFieldOption defaultOption) {
		this.defaultOption = defaultOption;
	}
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("HeaderField [columnName=");
		builder.append(columnName);
		builder.append(", selectable=");
		builder.append(selectable);
		builder.append(", options=");
		builder.append(options);
		builder.append(", defaultOption=");
		builder.append(defaultOption);
		builder.append("]");
		return builder.toString();
	}
	
}
