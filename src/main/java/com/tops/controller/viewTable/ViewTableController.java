package com.tops.controller.viewTable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tops.controller.BaseController;
import com.tops.model.operation.ViewTableModel;
import com.tops.service.viewTable.ViewTableService;


@Controller
@RequestMapping("/viewTable")
public class ViewTableController extends BaseController
{
    @Autowired
    private ViewTableService viewTableService;

    /**
     * 테이블 리스트 조회
     */
    @RequestMapping(value = "/viewTableList")
    public ModelAndView viewTableList(HttpServletRequest request) throws Exception
    {
        ModelAndView mv = new ModelAndView();
        List<ViewTableModel> urtTableList = viewTableService.urtTableList();
        List<ViewTableModel> fwkTableList = viewTableService.fwkTableList();
        
        mv.addObject("pageID", request.getParameter("pageID"));
        mv.addObject("urtTableList", urtTableList);
        mv.addObject("fwkTableList", fwkTableList);
        mv.setViewName("viewTable/viewTableList");

        return mv;
    }

    @RequestMapping(value = "/viewTableDetail", method = RequestMethod.GET)
    public String viewTableDetail(
    		@RequestParam("tableName") String tableName,
    		@RequestParam("ownerId") String ownerId,
    		@RequestParam("db") String db, 
    		@RequestParam("startRow") int startRow, 
    		@RequestParam("endRow") int endRow, 
    		@RequestParam("pageID") String pageID, 
    		ModelMap model) throws Exception
    {
        List<ViewTableModel> tmpColumnList   = new ArrayList<>();
        Map<String, Object> tmpColumnListMap = new HashMap<>();
        List<Map<String, String>> tmpTableDetail = new ArrayList<>();
        Map<String, Object> tmpParamMap = new HashMap<>();
        
        if(startRow == 0 && endRow == 0 ) {
        	startRow = 1;
        	endRow = 100;
        }
        
        
        // DB 조회 대상에 따라
        switch(db)
        {
            case "urt" :
            	tmpParamMap.put("tableName", tableName);
            	tmpParamMap.put("ownerId", ownerId);
                tmpColumnList = viewTableService.urtColumnList(tmpParamMap);
                tmpColumnListMap.put("urtColumnList", tmpColumnList);
                tmpColumnListMap.put("tableName", tableName);
                tmpColumnListMap.put("ownerId", ownerId);
                tmpColumnListMap.put("startRow", startRow);
                tmpColumnListMap.put("endRow", endRow);
                tmpTableDetail = viewTableService.urtTableDetail(tmpColumnListMap);

                break;

            case "fwk" :
            	tmpParamMap.put("tableName", tableName);
            	tmpParamMap.put("ownerId", ownerId);
                tmpColumnList = viewTableService.fwkColumnList(tmpParamMap);
                tmpColumnListMap.put("fwkColumnList", tmpColumnList);
                tmpColumnListMap.put("tableName", tableName);	
                tmpColumnListMap.put("ownerId", ownerId);
                tmpColumnListMap.put("startRow", startRow);
                tmpColumnListMap.put("endRow", endRow);
                
                tmpTableDetail = viewTableService.fwkTableDetail(tmpColumnListMap);
                
                break;

            default :
                break;
        }

        model.addAttribute("tableDetail", tmpTableDetail);
        model.addAttribute("tableName", tableName);
        model.addAttribute("ownerId", ownerId);
        model.addAttribute("db", db);
        model.addAttribute("pageID", pageID);

        return "viewTable/viewTableDetail";
    }


    /**
     * 테이블 상세 조회
     */
    @RequestMapping(value = "/viewTableInfo" , method = RequestMethod.POST)
    public @ResponseBody ModelAndView viewTableInfo(HttpServletRequest request, @RequestBody ViewTableModel viewTable) throws Exception
    {
        List<ViewTableModel> tmpColumnList   = new ArrayList<>();
        Map<String, Object> tmpColumnListMap = new HashMap<>();
        List<Map<String, String>> tmpTableDetail = new ArrayList<>();
        Map<String, Object> allRowParam = new HashMap<>();
        Map<String, Object> tmpParamMap = new HashMap<>();
        
        
        if(viewTable.getStartRow() == 0 && viewTable.getEndRow() == 0 ) {
        	viewTable.setStartRow(1);
        	viewTable.setEndRow(100);
        }
        allRowParam.put("tableName", viewTable.getTableName());
        
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView()) ;
        // DB 조회 대상에 따라
        switch(viewTable.getDb())
        {
            case "urt" :
            	tmpParamMap.put("tableName", viewTable.getTableName());
            	tmpParamMap.put("ownerId", viewTable.getOwnerId());
            	viewTable.setAllRow(viewTableService.urtAllRow(allRowParam));
                tmpColumnList = viewTableService.urtColumnList(tmpParamMap);
                tmpColumnListMap.put("urtColumnList", tmpColumnList);
                tmpColumnListMap.put("tableName", viewTable.getTableName());
                tmpColumnListMap.put("startRow", viewTable.getStartRow());
                tmpColumnListMap.put("endRow", viewTable.getEndRow());
                tmpTableDetail = viewTableService.urtTableDetail(tmpColumnListMap);
                break;

            case "fwk" :
            	tmpParamMap.put("tableName", viewTable.getTableName());
            	tmpParamMap.put("ownerId", viewTable.getOwnerId());
            	viewTable.setAllRow(viewTableService.fwkAllRow(allRowParam));
                tmpColumnList = viewTableService.fwkColumnList(tmpParamMap);
                tmpColumnListMap.put("fwkColumnList", tmpColumnList);
                tmpColumnListMap.put("tableName", viewTable.getTableName());
                tmpColumnListMap.put("startRow", viewTable.getStartRow());
                tmpColumnListMap.put("endRow", viewTable.getEndRow());

                tmpTableDetail = viewTableService.fwkTableDetail(tmpColumnListMap);
                break;

            default :
                break;
        }
        
        mv.addObject("grid", tmpTableDetail);
        mv.addObject("columnList", tmpColumnList);
        mv.addObject("columnListSize", tmpColumnList.size());
        mv.addObject("total", (viewTable.getAllRow()/100)+1);
        return mv;
    }


    /**
     * 테이블 입력
     */
    @RequestMapping(value = "/viewTableInsert" , method = RequestMethod.POST)
    public @ResponseBody ModelAndView viewTableInsert(HttpServletRequest request, @RequestBody ViewTableModel viewTable) throws Exception 
    {
        List<ViewTableModel> tmpColumnList = new ArrayList<>();
        Map<String, Object> tmpInsertData = new HashMap<>();
        Map<String, Object> tmpInsertDataMap = new HashMap<>();
        Map<String, Object> tmpInsertMap = new HashMap<>();
        Map<String, Object> tmpParamMap = new HashMap<>();
        boolean isSuccess = false;
			
        String updateJsonData = viewTable.getUpdateJsonData();

        updateJsonData = updateJsonData.replaceAll("\\[", "");
        updateJsonData = updateJsonData.replaceAll("\\]", "");

        ObjectMapper mapper = new ObjectMapper();
        tmpInsertData = mapper.readValue(updateJsonData, new TypeReference<Map<String, Object>>(){});
        tmpInsertData.remove("id");
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView()) ;
        
        tmpParamMap.put("tableName", viewTable.getTableName());
    	tmpParamMap.put("ownerId", viewTable.getOwnerId());
    	
        try {
        // DB 조회 대상에 따라
        switch(viewTable.getDb())
        {
            case "urt" :
            	tmpColumnList = viewTableService.urtColumnList(tmpParamMap);
                for(int i = 0; i <= tmpColumnList.size() - 1; i++)
                {
                    if(tmpColumnList.get(i).getDataType().equals("NUMBER"))
                    {
                        tmpInsertDataMap.put(tmpColumnList.get(i).getColumnName(), tmpInsertData.get(tmpColumnList.get(i).getColumnName()));
                    }
                    else if(tmpColumnList.get(i).getDataType().equals("DATE"))
                    {
                        tmpInsertDataMap.put(tmpColumnList.get(i).getColumnName(), "to_char('sysdate', 'YYYYMMDDHH24MISS' )");
                    }
                    else
                    {
                        tmpInsertDataMap.put(tmpColumnList.get(i).getColumnName(), "'"+tmpInsertData.get(tmpColumnList.get(i).getColumnName())+"'");
                    }
                }
                
                tmpInsertMap.put("tableName", viewTable.getTableName());
                tmpInsertMap.put("urtInsertDataMap", tmpInsertDataMap);
                isSuccess = viewTableService.urtViewTableInsert(tmpInsertMap);
                
                break;

            case "fwk" :
            	
                tmpColumnList = viewTableService.fwkColumnList(tmpParamMap);

                for(int i = 0; i <= tmpColumnList.size() - 1; i++)
                {
                    if(tmpColumnList.get(i).getDataType().equals("NUMBER"))
                    {
                        tmpInsertDataMap.put(tmpColumnList.get(i).getColumnName(), tmpInsertData.get(tmpColumnList.get(i).getColumnName()));
                    }
                    else if(tmpColumnList.get(i).getDataType().equals("DATE"))
                    {
                        tmpInsertDataMap.put(tmpColumnList.get(i).getColumnName(), "to_char('sysdate', 'YYYYMMDDHH24MISS' )");
                    }
                    else
                    {
                        tmpInsertDataMap.put(tmpColumnList.get(i).getColumnName(), "'"+tmpInsertData.get(tmpColumnList.get(i).getColumnName())+"'");
                    }
                }

                tmpInsertMap.put("tableName", viewTable.getTableName());
                tmpInsertMap.put("fwkInsertDataMap", tmpInsertDataMap);
                isSuccess = viewTableService.fwkViewTableInsert(tmpInsertMap);

            default :
                break;
        } //switch
        mv.addObject("result", isSuccess);
        
        } //try 
        catch (Exception e) {
        	String errorMsg = e.getMessage();
        	mv.addObject("result", isSuccess);
        	mv.addObject("errorMsg", errorMsg);
        }

        return mv;
    }

    /**
     * 테이블 수정
     */
    @RequestMapping(value = "/viewTableUpdate" , method = RequestMethod.POST)
    public @ResponseBody ModelAndView viewTableUpdate(HttpServletRequest request, @RequestBody ViewTableModel viewTable) throws Exception
    {
        List<ViewTableModel> tmpColumnList = new ArrayList<>();
        List<Map<String, Object>> tmpColumnPk = new ArrayList<>();
        Map<String, Object> tmpUpdateDataMap = new HashMap<>();
        Map<String, Object> tmpUpdateData = new HashMap<>();
        Map<String, Object> tmpBeforeData = new HashMap<>();
        Map<String, Object> tmpUpdateMap = new HashMap<>();
        Map<String, Object> tmpPkMap = new HashMap<>();
        Map<String, Object> tmpParamMap = new HashMap<>();

        boolean isSuccess = false;

        String beforeJsonData = viewTable.getBeforeJsonData();
        String updateJsonData = viewTable.getUpdateJsonData();

        beforeJsonData = beforeJsonData.replaceAll("\\[", "");
        beforeJsonData = beforeJsonData.replaceAll("\\]", "");
        
        updateJsonData = updateJsonData.replaceAll("\\[", "");
        updateJsonData = updateJsonData.replaceAll("\\]", "");

        ObjectMapper mapper = new ObjectMapper();
        tmpUpdateData = mapper.readValue(updateJsonData, new TypeReference<Map<String, Object>>(){});
        tmpUpdateData.remove("id");
        
        tmpBeforeData = mapper.readValue(beforeJsonData, new TypeReference<Map<String, Object>>(){});
        tmpBeforeData.remove("id");
        
        tmpParamMap.put("tableName", viewTable.getTableName());
    	tmpParamMap.put("ownerId", viewTable.getOwnerId());
       
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView()) ;
        try {
        	
        // DB 조회 대상에 따라
        switch(viewTable.getDb())
        {
            case "urt" :
                tmpColumnPk = viewTableService.urtColumnPk(viewTable.getTableName());
                tmpColumnList = viewTableService.urtColumnList(tmpParamMap);

                for(int i = 0; i <= tmpColumnList.size() - 1; i++)
                {
                    if(tmpColumnList.get(i).getDataType().equals("NUMBER"))
                    {
                        tmpUpdateDataMap.put(tmpColumnList.get(i).getColumnName(), tmpUpdateData.get(tmpColumnList.get(i).getColumnName()));
                    }
                    else if(tmpColumnList.get(i).getDataType().equals("DATE"))
                    {
                        tmpUpdateDataMap.put(tmpColumnList.get(i).getColumnName(), "to_char('sysdate', 'YYYYMMDDHH24MISS' )");
                    }
                    else
                    {
                        tmpUpdateDataMap.put(tmpColumnList.get(i).getColumnName(), "'"+tmpUpdateData.get(tmpColumnList.get(i).getColumnName())+"'");
                    }
                }
                
                for(int i = 0; i <= tmpColumnList.size() - 1; i++)
                {
                    if(tmpColumnPk.get(i).get("COLUMNPK").toString().equals(tmpColumnList.get(i).getColumnName()))
                    {
                        if(tmpColumnList.get(i).getColumnName().equals("NUMBER"))
                        {
                            tmpPkMap.put(tmpColumnPk.get(i).get("COLUMNPK").toString() , tmpBeforeData.get(tmpColumnPk.get(i).get("COLUMNPK")));
                        }
                        else
                        {
                            tmpPkMap.put(tmpColumnPk.get(i).get("COLUMNPK").toString() , "'"+tmpBeforeData.get(tmpColumnPk.get(i).get("COLUMNPK"))+"'");
                        }

                    }
                }
                tmpUpdateMap.put("tableName", viewTable.getTableName());
                tmpUpdateMap.put("urtUpdateDataMap", tmpUpdateDataMap);
                tmpUpdateMap.put("urtPkMap", tmpPkMap);

                isSuccess = viewTableService.urtViewTableUpdate(tmpUpdateMap);
                break;
                
            case "fwk" :

                tmpColumnPk = viewTableService.fwkColumnPk(viewTable.getTableName());
                tmpColumnList = viewTableService.fwkColumnList(tmpParamMap);

                for(int i = 0; i <= tmpColumnList.size() - 1; i++)
                {
                    if(tmpColumnList.get(i).getDataType().equals("NUMBER"))
                    {
                        tmpUpdateDataMap.put(tmpColumnList.get(i).getColumnName(), tmpUpdateData.get(tmpColumnList.get(i).getColumnName()));
                    }
                    else if(tmpColumnList.get(i).getDataType().equals("DATE"))
                    {
                        tmpUpdateDataMap.put(tmpColumnList.get(i).getColumnName(), "to_char('sysdate', 'YYYYMMDDHH24MISS' )");
                    }
                    else
                    {
                        tmpUpdateDataMap.put(tmpColumnList.get(i).getColumnName(), "'"+tmpUpdateData.get(tmpColumnList.get(i).getColumnName())+"'");
                    }
                }
                for(int i = 0; i <= tmpColumnList.size() - 1; i++)
                {
                    if(tmpColumnPk.get(i).get("COLUMNPK").toString().equals(tmpColumnList.get(i).getColumnName()))
                    {
                        if(tmpColumnList.get(i).getColumnName().equals("NUMBER"))
                        {
                            tmpPkMap.put(tmpColumnPk.get(i).get("COLUMNPK").toString() , tmpBeforeData.get(tmpColumnPk.get(i).get("COLUMNPK")));
                        }
                        else
                        {
                            tmpPkMap.put(tmpColumnPk.get(i).get("COLUMNPK").toString() , "'"+tmpBeforeData.get(tmpColumnPk.get(i).get("COLUMNPK"))+"'");
                        }

                    }
                }

                tmpUpdateMap.put("tableName", viewTable.getTableName());
                tmpUpdateMap.put("fwkUpdateDataMap", tmpUpdateDataMap);
                tmpUpdateMap.put("fwkPkMap", tmpPkMap);

                isSuccess = viewTableService.fwkViewTableUpdate(tmpUpdateMap);

            default :
                break;
        }
        mv.addObject("result", isSuccess);
        
        } //try 
        catch (Exception e) {
        	String errorMsg = e.getMessage();
        	mv.addObject("result", isSuccess);
        	mv.addObject("errorMsg", errorMsg);
        }

        mv.addObject("result", isSuccess);

        return mv;
    }


    /**
     * 테이블 삭제
     */
    @RequestMapping(value = "/viewTableRemove" , method = RequestMethod.POST)
    public @ResponseBody ModelAndView viewTableRemove(HttpServletRequest request, @RequestBody ViewTableModel viewTable) throws Exception
    {
        List<ViewTableModel> tmpColumnList = new ArrayList<>();
        Map<String, Object> tmpRemoveData = new HashMap<>();
        Map<String, Object> tmpRemoveDataMap = new HashMap<>();
        Map<String, Object> tmpRemoveMap = new HashMap<>();
        Map<String, Object> tmpParamMap = new HashMap<>();

        boolean isSuccess = false;

        String jsonData = viewTable.getJsonData();

        jsonData = jsonData.replaceAll("\\[", "");
        jsonData = jsonData.replaceAll("\\]", "");

        ObjectMapper mapper = new ObjectMapper();
        tmpRemoveData = mapper.readValue(jsonData, new TypeReference<Map<String, Object>>(){});
        tmpRemoveData.remove("id");

        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView()) ;
        
        tmpParamMap.put("tableName", viewTable.getTableName());
    	tmpParamMap.put("ownerId", viewTable.getOwnerId());

        // DB 조회 대상에 따라
        switch(viewTable.getDb())
        {
            case "urt" :

            	tmpColumnList = viewTableService.urtColumnList(tmpParamMap);

            	for(int i = 0; i <= tmpColumnList.size() - 1; i++)
                {
                    if(tmpColumnList.get(i).getDataType().equals("NUMBER"))
                    {
                        tmpRemoveDataMap.put(tmpColumnList.get(i).getColumnName(), tmpRemoveData.get(tmpColumnList.get(i).getColumnName()));
                    }
                    else if(tmpColumnList.get(i).getDataType().equals("DATE"))
                    {
                        tmpRemoveDataMap.put(tmpColumnList.get(i).getColumnName(), "to_char('sysdate', 'YYYYMMDDHH24MISS' )");
                    }
                    else
                    {
                        tmpRemoveDataMap.put(tmpColumnList.get(i).getColumnName(), "'"+tmpRemoveData.get(tmpColumnList.get(i).getColumnName())+"'");
                    }
                }

                tmpRemoveMap.put("tableName", viewTable.getTableName());
                tmpRemoveMap.put("urtRemoveDataMap", tmpRemoveDataMap);

                isSuccess = viewTableService.urtViewTableRemove(tmpRemoveMap);

                break;

            case "fwk" :

                tmpColumnList = viewTableService.fwkColumnList(tmpParamMap);

                for(int i = 0; i <= tmpColumnList.size() - 1; i++)
                {
                    if(tmpColumnList.get(i).getDataType().equals("NUMBER"))
                    {
                        tmpRemoveDataMap.put(tmpColumnList.get(i).getColumnName(), tmpRemoveData.get(tmpColumnList.get(i).getColumnName()));
                    }
                    else if(tmpColumnList.get(i).getDataType().equals("DATE"))
                    {
                        tmpRemoveDataMap.put(tmpColumnList.get(i).getColumnName(), "to_char('sysdate', 'YYYYMMDDHH24MISS' )");
                    }
                    else
                    {
                        tmpRemoveDataMap.put(tmpColumnList.get(i).getColumnName(), "'"+tmpRemoveData.get(tmpColumnList.get(i).getColumnName())+"'");
                    }
                }

                tmpRemoveMap.put("tableName", viewTable.getTableName());
                tmpRemoveMap.put("fwkRemoveDataMap", tmpRemoveDataMap);

                isSuccess = viewTableService.fwkViewTableRemove(tmpRemoveMap);

            default :
                break;
        }

//      mv.addObject("grid", tmpTableDetail);
        mv.addObject("result", isSuccess);

        return mv;
    }
}