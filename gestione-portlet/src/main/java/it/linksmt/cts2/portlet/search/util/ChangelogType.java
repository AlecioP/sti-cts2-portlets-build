package it.linksmt.cts2.portlet.search.util;

public enum ChangelogType {
	
	STANDARD_NATIONAL_STATIC("STANDARD_NATIONAL_STATIC","CodeSytemStatic"),
	STANDARD_NATIONAL("STANDARD_NATIONAL","CodeSytem"),
	LOCAL("LOCAL","CodeSytem"),
	VALUE_SET("VALUE_SET","ValueSet"),
	MAPPING("MAPPING","Mapping");
	
	private String key;
	private String value;
	
	private ChangelogType(String key, String value) {
		this.key = key;
		this.value = value;
	}

	public String getKey() {
		return key;
	}

	public String getValue() {
		return value;
	}
	
	public static String getValueByKey(String key) {
		String result ="";
		for(ChangelogType cst : ChangelogType.values()){
			if(cst.key.equals(key)){
				result = cst.value;
				break;
			}
		}
		return result;
	}
	
	
}
