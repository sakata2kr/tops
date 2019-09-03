package com.tops.mapper.fwk;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.tops.model.operation.ViewTableModel;

@Mapper
public interface FwkViewTableMapper
{
    // 테이블 리스트 조회
    List<ViewTableModel> fwkTableList();

    // 컬럼 리스트 조회
    List<ViewTableModel> fwkColumnList(Map<String, Object> tmpParamMap);

    // 테이블 상세 조회
    List<Map<String, String>> fwkTableDetail(Map<String, Object> map);

    // 테이블 PK조회 (Update처리용)
    List<Map<String, Object>> fwkColumnPk(String tableName);

    // 테이블 Insert
    boolean fwkViewTableInsert(Map<String, Object> tmpInsertMap);

    // 테이블 Update
    boolean fwkViewTableUpdate(Map<String, Object> tmpUpdateMap);

    // 테이블 Delete
    boolean fwkViewTableRemove(Map<String, Object> tmpRemoveMap);
    
    // 테이블 Row Count
    int fwkAllRow(Map<String, Object> allRowParam);

}