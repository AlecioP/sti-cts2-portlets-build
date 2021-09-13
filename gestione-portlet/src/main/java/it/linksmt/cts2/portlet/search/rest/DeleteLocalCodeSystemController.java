package it.linksmt.cts2.portlet.search.rest;

import it.linksmt.cts2.portlet.search.Message;
import it.linksmt.cts2.portlet.search.rest.model.Status;
import it.linksmt.cts2.portlet.search.util.StiUtil;

import java.net.URI;
import java.util.logging.Logger;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.HttpServerErrorException;

/**
 * Delete local code system controller for every code system.
 * @author Davide Pastore
 *
 */
@Controller
@RequestMapping(value = "/deleteLocalCode")
public class DeleteLocalCodeSystemController {

	private static final Logger logger = Logger
			.getLogger(DeleteLocalCodeSystemController.class.getName());

	@RequestMapping(value = "/loinc", method = RequestMethod.POST)
	@ResponseBody
	public Message loincDelete(@RequestParam("version") final String version,
			@RequestParam("localCodeSystemName") final String localCodeSystemName) {
		Message msg = new Message();
		String title = "";
		Status status = Status.OK;
		try {
			//Call the service?
			String url = StiUtil.generateDeleteLocalCodeSystemUrl(localCodeSystemName, version);
			URI deleteUrl = new URI(url);
			ResponseEntity<String> response = StiUtil.deleteLocalCodeRequest(deleteUrl);
			status = Status.OK;
			title = "You successfully deleted a local code system";
			logger.info("Response" + response);
		} catch (HttpServerErrorException e) {
			title = e.getMessage();
			String responseBody = e.getResponseBodyAsString();
			logger.info("Error deleting local code system " + responseBody);
			title = "Error deleting local code system";
			status = Status.ERROR;
		} catch (Exception e) {
			title = e.getMessage();
			status = Status.ERROR;
		}
		logger.info("Parameters are: " + version + ", " + localCodeSystemName);

		msg.setTitle(title);
		msg.setStatus(status);

		return msg;
	}
}