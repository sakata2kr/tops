package com.tops.model.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tops.model.operation.DashBoardInfo;
import com.tops.model.operation.EventMessage;
import com.tops.model.operation.ProcessInfoFlatData;
import com.tops.model.operation.ProcessInfoTreeNode;
import com.tops.model.operation.ProcessServerList;

/**
 * InMemoryRepository 데이터 구조체 정의
 */
public class InMemoryRepository
{
	// Tree 갱신 여부 확인을 위한 Flat List 저장 구조체
	public static List<ProcessInfoFlatData> processFlatDataList = new ArrayList<>();

    // Process 트리 정보
    public static Map<String, ProcessInfoTreeNode> processTreeDataMap = new HashMap<>();

    // Framework Process 정상 여부
    public static boolean fwkAllGreen = true;

	// 조회 대상 서버 정보 List
	public static List< ProcessServerList > processServerList = new ArrayList<>();

    // 이벤트 Alert 갱신용 Map
    public static EventMessage eventMessage = new EventMessage();

    // Dash Board 조회 처리를 위한 정보 저장 구조체
    public static List<DashBoardInfo> dashBoardInfo = new ArrayList<>();
}
