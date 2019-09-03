package com.tops.model.operation;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("ViewTableModel")
public class ViewTableModel extends BaseObject
{
	private String tableName;
	private String ownerId;
	private String columnName;
	private String columnPk;
	private String dataType;
	private int startRow;
	private int endRow;
	private int allRow;
	private String db;

	private String searchWord;
	private String beforeJsonData;
	private String jsonData;

	private String updateJsonData;
	private String insertValue;
	
	public String getBeforeJsonData() {
		return beforeJsonData;
	}
	
	public void setBeforeJsonData(String beforeJsonData) {
		this.beforeJsonData = beforeJsonData;
	}
	
	public String getUpdateJsonData() {
		return updateJsonData;
	}
	
	public void setUpdateJsonData(String updateJsonData) {
		this.updateJsonData = updateJsonData;
	}
	
	public String getDb() {
		return db;
	}
	
	public void setDb(String db) {
		this.db = db;
	}
	
	public String getTableName() {
		return tableName;
	}
	
	public String getOwnerId() {
		return ownerId;
	}
	
	public String getColumnName() {
		return columnName;
	}
	
	public String getColumnPk() {
		return columnPk;
	}
	
	public String getDataType() {
		return dataType;
	}
	
	public int getStartRow() {
		return startRow;
	}
	
	public int getEndRow() {
		return endRow;
	}
	
	public int getAllRow() {
		return allRow;
	}
	
	public String getSearchWord() {
		return searchWord;
	}
	
	public String getJsonData() {
		return jsonData;
	}
	
	public String getInsertValue() {
		return insertValue;
	}
	
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	
	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}
	
	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}
	
	public void setColumnPk(String columnPk) {
		this.columnPk = columnPk;
	}
	
	public void setDataType(String dataType) {
		this.dataType = dataType;
	}
	
	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}
	
	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}
	
	public void setAllRow(int allRow) {
		this.allRow = allRow;
	}
	
	public void setSearchWord(String searchWord) {
		this.searchWord = searchWord;
	}
	
	public void setJsonData(String jsonData) {
		this.jsonData = jsonData;
	}
	
	public void setInsertValue(String insertValue) {
		this.insertValue = insertValue;
	}

}
