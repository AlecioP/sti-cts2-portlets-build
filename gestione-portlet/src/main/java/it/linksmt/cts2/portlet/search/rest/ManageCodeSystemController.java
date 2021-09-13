package it.linksmt.cts2.portlet.search.rest;


import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.mail.internet.AddressException;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.velocity.app.VelocityEngine;
import org.codehaus.jackson.JsonProcessingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.velocity.VelocityEngineUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.model.Layout;
import com.liferay.portal.model.LayoutTypePortlet;
import com.liferay.portal.model.Portlet;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.User;
import com.liferay.portal.service.LayoutLocalServiceUtil;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portal.util.PortletKeys;
import com.liferay.portlet.journal.model.JournalArticle;
import com.liferay.portlet.journal.model.JournalArticleConstants;

import it.linksmt.cts2.portlet.search.StiAppConfig;
import it.linksmt.cts2.portlet.search.rest.dtos.ChangelogDto;
import it.linksmt.cts2.portlet.search.rest.dtos.CodeSystemDto;
import it.linksmt.cts2.portlet.search.util.ChangelogUtils;
import it.linksmt.cts2.portlet.search.util.EmailUtil;
import it.linksmt.cts2.portlet.search.util.StiUtil;

@Controller
@RequestMapping("/manage")
public class ManageCodeSystemController {
	private static final Logger logger = Logger.getLogger(ManageCodeSystemController.class);

	@Autowired
	private VelocityEngine velocityEngine;
	
	
	@RequestMapping("/codeSystems")
	@ResponseBody
	public ResponseEntity<List<CodeSystemDto>> getCodeSystems() throws URISyntaxException, JsonProcessingException, IOException {
		String requestUrl = StiUtil.buildGetExtraCodeSystemsUrl();
		URI url = new URI(requestUrl);
		List<CodeSystemDto> codeSystems = StiUtil.getCodeSystems(url);
		return new ResponseEntity<List<CodeSystemDto>>(codeSystems, HttpStatus.OK);
	}


	@RequestMapping(value="/changelogs", method=RequestMethod.POST)
	@ResponseBody ResponseEntity<String> createChangelogJa(@RequestBody final ChangelogDto changelog, HttpServletRequest request) throws Exception {
		logger.debug("ManageCodeSystemController::createChangelogJa");

		long groupId = Long.parseLong(StiAppConfig.getProperty("sti.group.id", "20181")); //20181;
		long userId =  Long.parseLong(StiAppConfig.getProperty("sti.changelog.user.id", "23401")); //21305;
		long folderId = Long.parseLong(StiAppConfig.getProperty("sti.changelog.folder.id", "23301")); //21314;
		long structureId = Long.parseLong(StiAppConfig.getProperty("sti.changelog.structure.id", "23206")); //21319;
		
		JournalArticle article = ChangelogUtils.createChangelogJournalArticle(groupId, userId, structureId, folderId, changelog);
		sentEmail(request, article);
		return new ResponseEntity<String>(article.getArticleId(), HttpStatus.CREATED);
	}
	
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void sentEmail(HttpServletRequest request, JournalArticle article) throws PortalException, SystemException, AddressException {
		List<String> emailTo = new ArrayList<String>();
		
		String active = StiAppConfig.getProperty("sti.mail.active", "false");
		if(active.equals("true")) {
			logger.debug("ManageCodeSystemController::send email enabked");
			
			String roleName = StiAppConfig.getProperty("sti.changelog.role.alert.name","ChangelogAlert");
			String subject = StiAppConfig.getProperty("sti.changelog.email.subject","STI: Nuovo Aggiornamento");
			String pageChangelogName = StiAppConfig.getProperty("sti.changelog.page.name","history-aggiornamento");
			String emailFrom = StiAppConfig.getProperty("sti.mail.from.default","");
			String nameFrom = StiAppConfig.getProperty("sti.mail.name.from.default","ChangeLog");
			
			Role role = RoleLocalServiceUtil.getRole(PortalUtil.getDefaultCompanyId(), roleName);
			List<User> users = UserLocalServiceUtil.getRoleUsers(role.getRoleId());
			for (User user : users) {
				emailTo.add(user.getEmailAddress());
			}
//			emailTo.add(emailFrom);
			
			
		    Layout articleLayout = LayoutLocalServiceUtil.getFriendlyURLLayout(article.getGroupId(), false, "/"+pageChangelogName);
		    LayoutTypePortlet articleLayoutTypePortlet = (LayoutTypePortlet)articleLayout.getLayoutType();
		    List<Portlet> allPortlets = articleLayoutTypePortlet.getAllPortlets("column-1");
		    String portletId ="";
		    for (Portlet p: allPortlets) {
		    	if (PortletKeys.ASSET_PUBLISHER.equals(p.getRootPortletId())) {
		    		portletId = p.getInstanceId();
		    		break;
		    	}
		    }
		    
		    
		    if(!"".equals(portletId)){
		    	 String url = PortalUtil.getHomeURL(request)+"/"+pageChangelogName+JournalArticleConstants.CANONICAL_URL_SEPARATOR+"asset_publisher/"+portletId+"/content/"+article.getUrlTitle();
		 	    
		 		String template = "email-changelog.vm";
		 		Map model = new HashMap();
		 		model.put("data", new SimpleDateFormat("dd/MM/yyyy").format(new Date()));
		 		model.put("title", article.getTitle(Locale.ITALY));
		 		model.put("url", url);
		 		
		 		String body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, template, "UTF-8", model);
		 	    EmailUtil.sendEmail(emailTo,emailFrom,nameFrom,subject, body);
		    }
					
		}
		else {
			logger.debug("ManageCodeSystemController::send email disabled");
		}
		
	}
	
}
