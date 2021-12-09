package it.linksmt.cts2.portlet.search.util;

import it.linksmt.cts2.portlet.search.StiAppConfig;

import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.log4j.Logger;


public class EmailUtil {

	private static Logger log = Logger.getLogger(EmailUtil.class.getName());
	
	private static Session session = null;
	
	private static void prepare(){
		Properties properties = new Properties();
		
		String smtpHost = StiAppConfig.getProperty("sti.mail.smtp.host");
		String port = StiAppConfig.getProperty("sti.mail.smtp.port");
		final String username = StiAppConfig.getProperty("sti.mail.username").replace("%40", "@");
		final String password = StiAppConfig.getProperty("sti.mail.password");


		try {
			properties.put("mail.smtp.host", smtpHost);
			properties.put("mail.smtp.port", port);
			properties.put("mail.smtp.socketFactory.port", port);
			
			properties.put("mail.smtp.auth", "true");
			properties.put("mail.smtp.starttls.enable", "true");
			properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
			properties.put("mail.smtp.ssl.enable", "true");
			properties.put("mail.smtp.ssl.protocols", "TLSv1.2");
			properties.put("mail.smtp.ssl.checkserveridentity", "true");
			properties.put("mail.smtp.socketFactory.fallback", "true");
			properties.put("mail.smtp.ssl.trust", "*");

			session = Session.getInstance(properties, new javax.mail.Authenticator() {
				@Override
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(username, password);
				}
			});

		}
		catch (Exception e) {
			log.error("createSession :: " + e.getMessage(), e);
		}
	}
	
	
	/**
	 * Utility method to send simple HTML email
	 * 
	 * @param session
	 * @param toEmail
	 * @param subject
	 * @param body
	 */
	public static void sendEmail(List<String> toEmail, String fromEmail,String fromName, String subject, String body) {
		try {
			prepare();
			
			MimeMessage msg = new MimeMessage(session);
			// set message headers
			msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
			msg.addHeader("format", "flowed");
			msg.addHeader("Content-Transfer-Encoding", "8bit");

			msg.setFrom(new InternetAddress(fromEmail, fromName));
			msg.setReplyTo(InternetAddress.parse(fromEmail, false));
			msg.setSubject(subject, "UTF-8");
			msg.setContent(body, "text/html; charset=utf-8");
			msg.setSentDate(new Date());

			InternetAddress[] to = new InternetAddress[toEmail.size()];
			for (int idx = 0; idx < toEmail.size(); idx++) {
				to[idx] = new InternetAddress(toEmail.get(idx));
			}
			msg.addRecipients(Message.RecipientType.TO, to);
			Transport.send(msg);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
