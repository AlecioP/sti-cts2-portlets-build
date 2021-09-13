package it.linksmt.cts2.portlet.search.rest.model.localcodification;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class StandardLocalCodificationInspectResponse implements Serializable {

	private static final long serialVersionUID = -6146695195155481280L;

	private int rowsCount = 0;
	private List<HeaderField> header;
	
	private String tmpFileNameIt;
	private String tmpFileNameEn;
	
	private List<HeaderFieldOption> codeSystemOptions = new ArrayList<HeaderFieldOption>();
	
	private HeaderValidationResult headerValidationResult;
	private String errorMessage;
	
	public int getRowsCount() {
		return rowsCount;
	}
	public void setRowsCount(int rowsCount) {
		this.rowsCount = rowsCount;
	}
	public List<HeaderField> getHeader() {
		return header;
	}
	public void setHeader(List<HeaderField> header) {
		this.header = header;
	}
	public String getTmpFileNameIt() {
		return tmpFileNameIt;
	}
	public void setTmpFileNameIt(String tmpFileNameIt) {
		this.tmpFileNameIt = tmpFileNameIt;
	}
	public String getTmpFileNameEn() {
		return tmpFileNameEn;
	}
	public void setTmpFileNameEn(String tmpFileNameEn) {
		this.tmpFileNameEn = tmpFileNameEn;
	}
	public void setHeaderValidationResult(
			HeaderValidationResult headerValidationResult) {
		this.headerValidationResult = headerValidationResult;
	}
	public HeaderValidationResult getHeaderValidationResult() {
		return headerValidationResult;
	}
	public List<HeaderFieldOption> getCodeSystemOptions() {
		return codeSystemOptions;
	}
	public void setCodeSystemOptions(List<HeaderFieldOption> codeSystemOptions) {
		this.codeSystemOptions = codeSystemOptions;
	}
	
	public String getErrorMessage() {
		return errorMessage;
	}
	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("StandardLocalCodificationInspectResponse [rowsCount=");
		builder.append(rowsCount);
		builder.append(", header=");
		builder.append(header);
		builder.append(", tmpFileNameIt=");
		builder.append(tmpFileNameIt);
		builder.append(", tmpFileNameEn=");
		builder.append(tmpFileNameEn);
		builder.append(", codeSystemOptions=");
		builder.append(codeSystemOptions);
		builder.append(", headerValidationResult=");
		builder.append(headerValidationResult);
		builder.append(", errorMessage=");
		builder.append(errorMessage);
		builder.append("]");
		return builder.toString();
	}
}
