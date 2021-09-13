package it.linksmt.cts2.portlet.search.rest;

import it.linksmt.cts2.portlet.search.Message;
import it.linksmt.cts2.portlet.search.StiAppConfig;
import it.linksmt.cts2.portlet.search.StiConstant;
import it.linksmt.cts2.portlet.search.rest.model.Status;
import it.linksmt.cts2.portlet.search.util.StiUtil;

import java.net.URI;
import java.util.logging.Logger;

import org.apache.commons.lang3.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping(value = "/importLocal")
public class ImportLocalController {

	private static final Logger logger = Logger
			.getLogger(ImportLocalController.class.getName());

	private static String uploadFilePath = StiAppConfig.getProperty(
			"filesystem.import.base.path", "");

	@RequestMapping(value = "/loinc", method = RequestMethod.POST)
	@ResponseBody
	public Message myMethod(
			@RequestParam("fileImport") final MultipartFile fileImport,
			@RequestParam("version") final String version,
			@RequestParam("localCodeSystemName") final String localCodeSystemName) {
		Message msg = new Message();
		String title = "";
		Status status = Status.OK;
		
		logger.info("Parameters are: " + version + ", " + localCodeSystemName);
		String localCodeSystemNameClean = localCodeSystemName;
		localCodeSystemNameClean = StiUtil.generateOfficialEffectiveName(localCodeSystemNameClean);
		
		try {
			String fileImportPath = StiUtil.loadFileInDirectory(fileImport,uploadFilePath, StiConstant.LOINC, StiConstant.LOCAL);
			String changeSetUrl = StiUtil.generateUrl(StiConstant.LOINC, version);
			String changeSetURI = StiUtil.generateChangeSetURI(StiConstant.LOINC, version);
			URI url = new URI(changeSetUrl);
			String[] value = new String[] {
					"LOCAL_MAPPING_FILE: " + fileImportPath,
					"LOCAL_CS_NAME: " + localCodeSystemNameClean
			};
			
			ResponseEntity<String> response = StiUtil.sendLocalRequest(url, value,changeSetURI);
			title = "You successfully imported files";
			status = Status.OK;
			logger.info("Response" + response);
		} catch (HttpServerErrorException e) {
			title = e.getMessage();
			String responseBody = e.getResponseBodyAsString();
			logger.info("Error importing " + responseBody);
			title = "Error importing data";
			status = Status.ERROR;
		} catch (Exception e) {
			title = e.getMessage();
			status = Status.ERROR;
		}

		msg.setTitle(title);
		msg.setStatus(status);

		return msg;
	}
}
