package it.linksmt.cts2.portlet.search.util;

import it.linksmt.cts2.portlet.search.rest.dtos.ChangelogDto;

import java.io.Serializable;
import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.liferay.portal.kernel.xml.Document;
import com.liferay.portal.kernel.xml.Element;
import com.liferay.portal.kernel.xml.SAXReader;
import com.liferay.portal.kernel.xml.SAXReaderUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portlet.dynamicdatamapping.model.DDMStructure;
import com.liferay.portlet.dynamicdatamapping.service.DDMStructureLocalServiceUtil;
import com.liferay.portlet.dynamicdatamapping.storage.Field;
import com.liferay.portlet.dynamicdatamapping.storage.Fields;
import com.liferay.portlet.dynamicdatamapping.util.DDMUtil;
import com.liferay.portlet.journal.model.JournalArticle;
import com.liferay.portlet.journal.service.JournalArticleLocalServiceUtil;
import com.liferay.portlet.journal.util.JournalConverterUtil;

public class ChangelogUtils {
	private static String NAME_VERSION_SEPARATOR = "__";

	public static JournalArticle createChangelogJournalArticle(long groupId,  long userId, long structureId, long folderId, ChangelogDto changelog ) throws Exception {
		Locale locale = Locale.ITALY;

		ServiceContext serviceContext = new ServiceContext();
		serviceContext.setScopeGroupId(groupId);
		serviceContext.setAddGroupPermissions(true);
		serviceContext.setWorkflowAction(WorkflowConstants.ACTION_PUBLISH);
		serviceContext.setLanguageId(locale.toString());
		serviceContext.setAttribute("defaultLanguageId", locale.toString());
		
		String tipoOggetto = changelog.getType();
		String categoriaChangelog = ChangelogType.getValueByKey(changelog.getType());
		String title = changelog.getTitle();
		String codeSystem = changelog.getCodeSystem();
		String dataCreate = changelog.getDateCreate();
		String newCodes = String.valueOf(changelog.getNewCodes()!=null ? changelog.getNewCodes() : "0");
		String deletedCodes = String.valueOf(changelog.getDeletedCodes() != null ? changelog.getDeletedCodes() : "0");
		String importedRow = String.valueOf(changelog.getImportedRow() != null ? changelog.getImportedRow() : "0");
		String languages = String.valueOf(changelog.getLanguages() != null ? changelog.getLanguages().toLowerCase() : "");
		String changedCodes = changelog.getChangedCodes();
		String version = changelog.getVersion();
		String previousVersion = changelog.getPreviousVersion();
		String versionLabel = version;
		String previousVersionLabel = previousVersion;
		
		if(version!= null && version.indexOf(NAME_VERSION_SEPARATOR)!=-1){
			String[] tmp = version.split(NAME_VERSION_SEPARATOR);
			versionLabel = tmp[1];
		}
		if(previousVersion!=null && previousVersion.indexOf(NAME_VERSION_SEPARATOR)!=-1){
			String[] tmp = previousVersion.split(NAME_VERSION_SEPARATOR);
			previousVersionLabel = tmp[1];
		}
		
		if(changedCodes!=null){
			changedCodes.replaceAll(",", ";");
		}
		
		if(newCodes.equals("0")){
			newCodes = "Nessun nuovo codice importato rispetto alla precedente versione";
		}
		
		if(deletedCodes.equals("0")){
			deletedCodes = "Nessun codice eliminato rispetto alla precedente versione";
		}
		
		if(previousVersion==null || "".equals(previousVersion)){
			newCodes = "";
			deletedCodes = "";
		}
		
		if(dataCreate!=null){
			SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
			dataCreate = format.format(format.parse(dataCreate));
		}
		
		
		String prefix = "Importazione nuovo "+ChangelogType.getValueByKey(tipoOggetto)+" ";
		if(previousVersion!=null && !"".equals(previousVersion)){
			prefix = "Importata la nuova versione di ";
		}
		
		
		
		String journalArticleTitle = "";
		if(changelog.getType().equals(ChangelogType.MAPPING.getKey())){
			//title = makeMappingName(title);
			journalArticleTitle = dataCreate +": "+prefix +" "+ title.replaceAll("_", " ");
		}
		else{
			journalArticleTitle = dataCreate +": "+prefix +" "+ codeSystem.replaceAll("_", " ") +", "+versionLabel;
		}
		
		Map<Locale, String> titleMap = new HashMap<Locale, String>();
		titleMap.put(Locale.ITALY, journalArticleTitle);
		titleMap.put(Locale.UK, journalArticleTitle);
		titleMap.put(Locale.US, journalArticleTitle);


		DDMStructure ddm = DDMStructureLocalServiceUtil.getDDMStructure(structureId); //DDMStructureLocalServiceUtil.getStructure(groupId, 0L, structureKey);

		setFieldValueToServiceContext(serviceContext, Constants.FIELD_CODESYSTEM , codeSystem!=null?codeSystem:"");
		setFieldValueToServiceContext(serviceContext, Constants.FIELD_VERSIONE , version!=null?version:"");
		setFieldValueToServiceContext(serviceContext, Constants.FIELD_VERSIONE_LABEL , versionLabel!=null?versionLabel:"");
		setFieldValueToServiceContext(serviceContext, Constants.FIELD_PREVIOUSVERSION ,previousVersion!=null?previousVersion:"");
		setFieldValueToServiceContext(serviceContext, Constants.FIELD_PREVIOUSVERSION_LABEL ,previousVersionLabel!=null?previousVersionLabel:"");
		setFieldValueToServiceContext(serviceContext, Constants.FIELD_DATECREATE , dataCreate!=null?dataCreate:"");
		setFieldValueToServiceContext(serviceContext, Constants.FIELD_NEWROWS , newCodes!=null?newCodes:"");
		setFieldValueToServiceContext(serviceContext, Constants.FIELD_DELETEDROWS , deletedCodes!=null?deletedCodes:"");
		setFieldValueToServiceContext(serviceContext, Constants.FIELD_CHANGEDCODES , changedCodes!=null?changedCodes:"");
		setFieldValueToServiceContext(serviceContext, Constants.FIELD_TYPE , tipoOggetto!=null?tipoOggetto:"");
		setFieldValueToServiceContext(serviceContext, Constants.FIELD_LANGUAGES , languages!=null?languages:"");
		setFieldValueToServiceContext(serviceContext, Constants.FIELD_TOTALIMPORTEDROWS , importedRow!=null?importedRow:"");
		setFieldValueToServiceContext(serviceContext, Constants.FIELD_CATEGORY , categoriaChangelog!=null?categoriaChangelog:"");
		

		addFieldValueForFieldsDisplay(serviceContext,ddm);

		//https://svn.linksmt.it/PAL/repo/ASSETS/TURISMO/portale/trunk/portlets/turismo-translations-importer-scheduler-portlet/src/main/java/it/linksmt/turismo/portlet/utils/api/task/TranslationsImporterTaskExecutor.java

		Fields fields = DDMUtil.getFields(ddm.getStructureId(), serviceContext);
		Field displayNameField = new Field();
		displayNameField.setName(Constants.FIELDS_DISPLAY_NAME);
		displayNameField.setValue(getFieldsDisplay());
		displayNameField.setDDMStructureId(ddm.getStructureId());
		fields.put(displayNameField);

		String content = JournalConverterUtil.getContent(ddm, fields );

		SAXReader reader = SAXReaderUtil.getSAXReader();
		Document document = reader.read(new StringReader(content));
		Element root = document.getRootElement();

		document.setRootElement(root);
		content = document.asXML();

		JournalArticle article = JournalArticleLocalServiceUtil.addArticle(userId, groupId, folderId, titleMap, null, content, ddm.getStructureKey(), ddm.getTemplates().get(0).getTemplateKey(), serviceContext);
		return article;
	}

//	private static String makeMappingName(String title) {
//		if(title!=null && title.indexOf(NAME_VERSION_SEPARATOR)!=-1){
//			String[] tmp = title.split(" - ");
//			if(tmp.length==2){
//				String[] src = tmp[0].split("(");
//				String[] trg = tmp[1].split("(");
//
//				String csSrc = src[0];
//				String csTrg = trg[0];
//				String versionSrc = src[1];
//				String versionTrg = trg[1];
//				
//				if(versionSrc.indexOf(NAME_VERSION_SEPARATOR)!=-1){
//					String[] versionSrcTmp = src[1].split(NAME_VERSION_SEPARATOR);
//					versionSrc = versionSrcTmp[1];
//				}
//				
//				if(versionTrg.indexOf(NAME_VERSION_SEPARATOR)!=-1){
//					String[] versionTrgTmp = trg[1].split(NAME_VERSION_SEPARATOR);
//					versionTrg = versionTrgTmp[1];
//				}
//
//				versionSrc = versionSrc.replace(")","");
//				versionTrg = versionTrg.replace(")","");
//				
//				title = csSrc +" ("+versionSrc+")"+" - "+csTrg+" ("+versionTrg+")";
//			}
//		}
//		return title;
//	}

	/*
	 * @param serviceContext
	 * 
	 * @throws SystemException
	 * 
	 * @throws PortalException
	 */
	private static void addFieldValueForFieldsDisplay(ServiceContext serviceContext,DDMStructure ddmStructure) throws PortalException, SystemException {
		serviceContext.setAttribute(Constants.INSTANCE_SEPARATOR + Constants.FIELDS_DISPLAY_NAME, getFieldsDisplay(ddmStructure));
	}

	/**
	 *
	 * @param ddmStructure
	 * @return
	 * @throws PortalException
	 * @throws SystemException
	 */
	private static String getFieldsDisplay(DDMStructure ddmStructure)
			throws PortalException, SystemException {

		StringBuilder stringBuilder = new StringBuilder();

		Set<String> fieldNames = ddmStructure.getFieldNames();
		int count = 0;
		for (String fieldName : fieldNames) {
			if (fieldName.equalsIgnoreCase(Constants.FIELDS_DISPLAY_NAME)) {
				stringBuilder.append(fieldName);
				stringBuilder.append(Constants.INSTANCE_SEPARATOR);
				count = count + 1;
				if (count < fieldNames.size()) {
					stringBuilder.append(StringPool.COMMA);
				}
			}
		}

		return stringBuilder.toString();
	}

	private static String getFieldsDisplay() {
		return Constants.FIELD_CODESYSTEM + Constants.INSTANCE_SEPARATOR + StringPool.COMMA 
				+ Constants.FIELD_VERSIONE + Constants.INSTANCE_SEPARATOR + StringPool.COMMA
				+ Constants.FIELD_PREVIOUSVERSION + Constants.INSTANCE_SEPARATOR + StringPool.COMMA 
				+ Constants.FIELD_DATECREATE + Constants.INSTANCE_SEPARATOR + StringPool.COMMA
				+ Constants.FIELD_NEWROWS + Constants.INSTANCE_SEPARATOR + StringPool.COMMA
				+ Constants.FIELD_DELETEDROWS + Constants.INSTANCE_SEPARATOR + StringPool.COMMA
				+ Constants.FIELD_CHANGEDCODES + Constants.INSTANCE_SEPARATOR + StringPool.COMMA
				+ Constants.FIELD_TYPE + Constants.INSTANCE_SEPARATOR + StringPool.COMMA
				+ Constants.FIELD_LANGUAGES + Constants.INSTANCE_SEPARATOR + StringPool.COMMA
				+ Constants.FIELD_TOTALIMPORTEDROWS + Constants.INSTANCE_SEPARATOR + StringPool.COMMA
				+ Constants.FIELD_CATEGORY + Constants.INSTANCE_SEPARATOR + StringPool.COMMA
				+ Constants.FIELD_VERSIONE_LABEL + Constants.INSTANCE_SEPARATOR + StringPool.COMMA
				+ Constants.FIELD_PREVIOUSVERSION_LABEL + Constants.INSTANCE_SEPARATOR + StringPool.COMMA;
		
	}

	private static void setFieldValueToServiceContext(ServiceContext serviceContext, String fieldName, Serializable fieldValue) {
		serviceContext.setAttribute(fieldName, fieldValue);
	}
	

	
	

}
