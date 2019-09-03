package com.tops.mapper.urt;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.tops.model.operation.ViewTableModel;

@Mapper
public interface UrtViewTableMapper
{
    // 테이블 리스트 조회
    List<ViewTableModel> urtTableList();

    // 컬럼 리스트 조회
    List<ViewTableModel> urtColumnList(Map<String, Object> urtParamMap);

    // 테이블 상세 조회
    List<Map<String, String>> urtTableDetail(Map<String, Object> map);

    // 테이블 PK 조회
    List<Map<String, Object>> urtColumnPk(String tableName);

    // 테이블 Insert
    boolean urtViewTableInsert(Map<String, Object> tmpInsertMap);

    // 테이블 Update
    boolean urtViewTableUpdate(Map<String, Object> tmpUpdateMap);

    // 테이블 Delete
    boolean urtViewTableRemove(Map<String, Object> tmpRemoveMap);
    
    // 테이블 Row Count
    int urtAllRow(Map<String, Object> allRowParam);

}
