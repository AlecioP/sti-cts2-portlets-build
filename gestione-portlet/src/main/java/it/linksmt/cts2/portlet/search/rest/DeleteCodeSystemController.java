package it.linksmt.cts2.portlet.search.rest;

import it.linksmt.cts2.portlet.search.Message;
import it.linksmt.cts2.portlet.search.rest.model.Status;

import java.util.logging.Logger;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Delete code system controller for every code system.
 * @author Davide Pastore
 *
 */
@Controller
@RequestMapping(value = "/delete")
public class DeleteCodeSystemController {

	private static final Logger logger = Logger
			.getLogger(DeleteCodeSystemController.class.getName());

	@RequestMapping(value = "/loinc", method = RequestMethod.POST)
	@ResponseBody
	public Message loincDelete(@RequestParam("version") final String version) {
		Message msg = new Message();
		String title = "";
		Status status = Status.OK;
		try {
			// TODO Call a service?
			status = Status.OK;
			title = "You successfully deleted a code system";
		} catch (Exception e) {
			title = e.getMessage();
			status = Status.ERROR;
		}
		logger.info("Parameters are: " + version);

		msg.setTitle(title);
		msg.setStatus(status);

		return msg;
	}
	
	@RequestMapping(value = "/icd9-cm", method = RequestMethod.POST)
	@ResponseBody
	public Message icd9CmDelete(@RequestParam("version") final String version) {
		Message msg = new Message();
		String title = "";
		Status status = Status.OK;
		try {
			// TODO Call a service?
			status = Status.OK;
			title = "You successfully deleted a code system";
		} catch (Exception e) {
			title = e.getMessage();
			status = Status.ERROR;
		}
		logger.info("Parameters are: " + version);

		msg.setTitle(title);
		msg.setStatus(status);

		return msg;
	}
	
	@RequestMapping(value = "/atc", method = RequestMethod.POST)
	@ResponseBody
	public Message atcDelete(@RequestParam("version") final String version) {
		Message msg = new Message();
		String title = "";
		Status status = Status.OK;
		try {
			// TODO Call a service?
			status = Status.OK;
			title = "You successfully deleted a code system";
		} catch (Exception e) {
			title = e.getMessage();
			status = Status.ERROR;
		}
		logger.info("Parameters are: " + version);

		msg.setTitle(title);
		msg.setStatus(status);

		return msg;
	}
	
	@RequestMapping(value = "/aic", method = RequestMethod.POST)
	@ResponseBody
	public Message aicDelete(@RequestParam("version") final String version) {
		Message msg = new Message();
		String title = "";
		Status status = Status.OK;
		try {
			// TODO Call a service?
			status = Status.OK;
			title = "You successfully deleted a code system";
		} catch (Exception e) {
			title = e.getMessage();
			status = Status.ERROR;
		}
		logger.info("Parameters are: " + version);

		msg.setTitle(title);
		msg.setStatus(status);

		return msg;
	}
}