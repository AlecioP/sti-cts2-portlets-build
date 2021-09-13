package it.linksmt.cts2.portlet.search;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.GenericPortlet;
import javax.portlet.PortletException;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.PortletSession;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.apache.log4j.Logger;

public class SearchPortlet extends GenericPortlet {

	@Override
	public void destroy() {
		if (_log.isInfoEnabled()) {
			_log.info("Inside of destroy()");
		}

		super.destroy();
	}

	@Override
	public void doEdit(
			final RenderRequest renderRequest, final RenderResponse renderResponse)
					throws IOException, PortletException {

		if (_log.isInfoEnabled()) {
			_log.info("Inside doEdit()");
		}

		include(editTemplate, renderRequest, renderResponse);
	}

	@Override
	public void doHelp(
			final RenderRequest renderRequest, final RenderResponse renderResponse)
					throws IOException, PortletException {

		if (_log.isInfoEnabled()) {
			_log.info("Inside doHelp()");
		}

		include(helpTemplate, renderRequest, renderResponse);
	}

	@Override
	public void doView(
			final RenderRequest renderRequest, final RenderResponse renderResponse)
					throws IOException, PortletException {

		if (_log.isInfoEnabled()) {
			_log.info("Inside doView()");
		}

		boolean hasCrossMapping = renderRequest.isUserInRole("cross-mapping-sti") ||
				renderRequest.isUserInRole("administrator");

		renderRequest.getPortletSession().setAttribute("CrossMappingSTI",
				hasCrossMapping, PortletSession.APPLICATION_SCOPE);

		include(viewTemplate, renderRequest, renderResponse);
	}

	@Override
	public void init() {
		if (_log.isInfoEnabled()) {
			_log.info("Inside of init()");
		}

		editTemplate = getInitParameter("edit-template");
		helpTemplate = getInitParameter("help-template");
		viewTemplate = getInitParameter("view-template");
	}

	@Override
	public void processAction(
			final ActionRequest actionRequest, final ActionResponse actionResponse)
					throws IOException, PortletException {

		if (_log.isInfoEnabled()) {
			_log.info("Inside of processAction()");
		}
	}

	@Override
	public void render(
			final RenderRequest renderRequest, final RenderResponse renderResponse)
					throws IOException, PortletException {

		if (_log.isInfoEnabled()) {
			_log.info("Inside of render()");
		}

		super.render(renderRequest, renderResponse);
	}

	@Override
	public void serveResource(
			final ResourceRequest resourceRequest, final ResourceResponse resourceResponse)
					throws IOException, PortletException {

		if (_log.isInfoEnabled()) {
			_log.info("Inside serveResource()");
		}

		resourceResponse.setContentType("text/html");
		resourceResponse.getWriter().write("Resource served successfully!");
	}

	protected void include(
			final String path, final RenderRequest renderRequest,
			final RenderResponse renderResponse)
					throws IOException, PortletException {

		PortletRequestDispatcher portletRequestDispatcher =
				getPortletContext().getRequestDispatcher(path);

		if (portletRequestDispatcher == null) {
			_log.error(path + " is not a valid include");
		}
		else {
			portletRequestDispatcher.include(renderRequest, renderResponse);
		}
	}

	protected String editTemplate;
	protected String helpTemplate;
	protected String viewTemplate;

	private static Logger _log = Logger.getLogger(SearchPortlet.class);

}
