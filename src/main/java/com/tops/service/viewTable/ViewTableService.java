package com.tops.service.viewTable;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.fwk.FwkViewTableMapper;
import com.tops.mapper.urt.UrtViewTableMapper;
import com.tops.model.operation.ViewTableModel;
import com.tops.service.BaseService;

/**
 * 테이블 리스트 조회 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class ViewTableService extends BaseService
{
    @Autowired
    private UrtViewTableMapper urtViewTableMapper;

    @Autowired
    private FwkViewTableMapper fwkViewTableMapper;

    // Urt 테이블 리스트 조회
    public List<ViewTableModel> urtTableList()
    {
        return urtViewTableMapper.urtTableList();
    }

    // Urt 컬럼 리스트 조회
    public List<ViewTableModel> urtColumnList(Map<String, Object> urtParamMap)
    {
        return urtViewTableMapper.urtColumnList(urtParamMap);
    }

    // Urt 테이블 상세 조회
    public List<Map<String, String>> urtTableDetail(Map<String, Object> map)
    {
        return urtViewTableMapper.urtTableDetail(map);
    }

    // Urt 테이블 PK 조회 (Update처리용)
    public List<Map<String, Object>> urtColumnPk(String tableName)
    {
        return urtViewTableMapper.urtColumnPk(tableName);
    }

    // Urt 테이블 Insert
    public boolean urtViewTableInsert(Map<String, Object> tmpInsertMap)
    {
        return urtViewTableMapper.urtViewTableInsert(tmpInsertMap);
    }

    // Urt 테이블 Update
    public boolean urtViewTableUpdate(Map<String, Object> tmpUpdateMap) 
    {
        return urtViewTableMapper.urtViewTableUpdate(tmpUpdateMap);
    }

    //Urt 테이블 Delete
    public boolean urtViewTableRemove(Map<String, Object> tmpRemoveMap) 
    {
        return urtViewTableMapper.urtViewTableRemove(tmpRemoveMap);
    }

    //Urt 테이블 Row Count
	public int urtAllRow(Map<String, Object> allRowParam) 
	{
		return urtViewTableMapper.urtAllRow(allRowParam);
	}

    // Fwk 테이블 리스트 조회
    public List<ViewTableModel> fwkTableList()
    {
        return fwkViewTableMapper.fwkTableList();
    }

    // Fwk 컬럼 리스트 조회
    public List<ViewTableModel> fwkColumnList(Map<String, Object> tmpParamMap)
    {
        return fwkViewTableMapper.fwkColumnList(tmpParamMap);
    }

    // Fwk 테이블 상세 조회
    public List<Map<String, String>> fwkTableDetail(Map<String, Object> map)
    {
        return fwkViewTableMapper.fwkTableDetail(map);
    }

    // Fwk 테이블 PK 조회 (Update처리 용)
    public List<Map<String, Object>> fwkColumnPk(String tableName)
    {
        return fwkViewTableMapper.fwkColumnPk(tableName);
    }

    // Fwk 테이블 Insert
    public boolean fwkViewTableInsert(Map<String, Object> tmpInsertMap)
    {
        return fwkViewTableMapper.fwkViewTableInsert(tmpInsertMap);
    }
    
    // Fwk 테이블 Update
    public boolean fwkViewTableUpdate(Map<String, Object> tmpUpdateMap)
    {
        return fwkViewTableMapper.fwkViewTableUpdate(tmpUpdateMap);
    }

    // Fwk 테이블 Delete
    public boolean fwkViewTableRemove(Map<String, Object> tmpRemoveMap)
    {
        return fwkViewTableMapper.fwkViewTableRemove(tmpRemoveMap);
    }

    //Fwk 테이블 Row Count
	public int fwkAllRow(Map<String, Object> allRowParam) 
	{
		return fwkViewTableMapper.fwkAllRow(allRowParam);
	}
}