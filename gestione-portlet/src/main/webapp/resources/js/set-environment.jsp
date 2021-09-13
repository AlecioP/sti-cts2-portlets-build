<%@page import="it.linksmt.cts2.portlet.search.StiAppConfig"%>
<%@ page contentType="text/javascript" %>

var ENV_PROPERTIES = {
	basePath : "<%= StiAppConfig.getProperty("cts2.sti.server.address", "") %>",
	solr: "<%= StiAppConfig.getProperty("cts2.sti.solr.address", "") %>/",	
};