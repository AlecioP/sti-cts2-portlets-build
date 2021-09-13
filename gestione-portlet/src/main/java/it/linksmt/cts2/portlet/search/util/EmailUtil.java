package it.linksmt.cts2.portlet.search.util;

import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.liferay.portal.kernel.util.PropsUtil;

public class EmailUtil {

	
	private static Session session = null;
	
	private static void prepare(){
		Properties props = System.getProperties();

		final String smtpHost = PropsUtil.get("sti.mail.smtp.host");
		final String port = PropsUtil.get("sti.mail.smtp.port");
		final String username = PropsUtil.get("sti.mail.username");
		final String password = PropsUtil.get("sti.mail.password");
		
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.host", smtpHost);
		props.put("mail.smtp.port", port);

		session = Session.getInstance(props, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});
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
