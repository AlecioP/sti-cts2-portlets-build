<%@page import="it.linksmt.cts2.portlet.search.StiAppConfig"%>
<%@ page contentType="text/javascript" %>

<%
boolean dispCrossMapping = false;
if (session.getAttribute("CrossMappingSTI") instanceof Boolean) {
	dispCrossMapping = ((Boolean)session.getAttribute("CrossMappingSTI")).booleanValue();
}
%>

var ENV_PROPERTIES = {
	basePath : "<%= StiAppConfig.getProperty("cts2.sti.server.address", "") %>",
	virtuoso: "<%= StiAppConfig.getProperty("virtuoso.server.address", "") %>",
	solr: "<%= StiAppConfig.getProperty("cts2.sti.solr.address", "") %>/",
	isCrossMappingSti: <%= String.valueOf(dispCrossMapping) %>,
};
