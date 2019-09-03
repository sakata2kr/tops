package com.tops.common.ScheduledService;

import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import org.apache.commons.lang3.StringUtils;

import com.tops.model.operation.ProcessInfoFlatData;
import com.tops.model.operation.ProcessInfoTreeNode;

public class FlatToTreeHelper
{
    /**
     * 온라인 프로세스 정보를 중첩 구조로 변경하여 반환한다.
     *
     * <pre>
     * before :
     *  | A | B | C |
     *
     * after :
     *  [ keA : A{ title : titleA, children : [ B{ title : titleA, children : [ C{ title : titleA, children : [  ] } ] } ] } ]
     *  [ keB : B{ title : titleA, children : [ C{ title : titleA, children : [  ] } ] } ]
     *  [ keC : C{ title : titleA, children : [  ] } ]
     * </pre>
     *
     * @param treeType
     * @param flat
     * @param nested
     * @param keys
     * @param titles
     * @param types
     * @return
     */
    public static SortedMap<String, ProcessInfoTreeNode> convertFlatToNested( String treeType
                                                                              , ProcessInfoFlatData flat
                                                                              , SortedMap<String, ProcessInfoTreeNode> nested
                                                                              , List<String> keys
                                                                              , List<String> titles
                                                                              , List<String> types
                                                                              )
    {
        if (keys.isEmpty() || titles.isEmpty() || types.isEmpty())     throw new IllegalArgumentException("The keys, titles, types are required.");

        if (titles.size() < keys.size() || types.size() < keys.size()) throw new IllegalArgumentException("The length of titles and types must not be less than keys.");

        if (nested == null) nested = new TreeMap<String, ProcessInfoTreeNode>();

        String key  = "";
        String type = "";
        int depth   = 0;

        String parentKey = ProcessInfoTreeNode.ROOT_KEY;      // 최상위 Node 의 Key 값은 ROOT로 정의
        ProcessInfoTreeNode parentTreeNode = null;

        ProcessInfoTreeNode treeNode = new ProcessInfoTreeNode();

        for (int i = 0; i < keys.size(); i++)
        {
            // 넘어온 keys 값이 NODATA인 경우를 제외
            if (!keys.get(i).contains("NODATA"))
            {
                key   = keys.get(i);
                type  = types.get(i);
                depth = i + 1;

                treeNode = new ProcessInfoTreeNode();

                // 공통 입력 정보를 생성
                treeNode.setDepth(depth);
                treeNode.setKey(key);
                treeNode.setParent_key(parentKey);
                treeNode.setTitle(titles.get(i));
                treeNode.setType(type);
                treeNode.setStatus_priority(flat.getStatus_priority());
                treeNode.setStatus(flat.getStatus());

                // 유형별 입력 정보를 생성
                switch (treeType)
                {
                    case "GROUP" :
                        switch (depth)
                        {
                            case 7 :
                                treeNode.setBm_id(flat.getBm_id());

                            case 6 :
                                treeNode.setBp_id(flat.getBp_id());

                            case 5 :
                                treeNode.setLsystem_id(flat.getSystem_id());
                                treeNode.setBp_group(flat.getBp_group());

                            case 4 :
                                treeNode.setPsystem_id(flat.getPsystem_id());

                            case 3 :
                                treeNode.setGroup_id(flat.getGroup_id());

                            case 2 :
                                treeNode.setGrp_ctg_cd2(flat.getGrp_ctg_cd2());

                            case 1 :
                                treeNode.setGrp_ctg_cd1(flat.getGrp_ctg_cd1());

                            default :
                                break;
                        }
                        break;

                    case "SERVER" :
                        switch (depth)
                        {
                            case 7 :
                                treeNode.setBm_id(flat.getBm_id());

                            case 6 :
                                treeNode.setBp_id(flat.getBp_id());

                            case 5 :
                                treeNode.setLsystem_id(flat.getSystem_id());
                                treeNode.setBp_group(flat.getBp_group());

                            case 4 :
                                treeNode.setGroup_id(flat.getGroup_id());

                            case 3 :
                                treeNode.setGrp_ctg_cd2(flat.getGrp_ctg_cd2());

                            case 2 :
                                treeNode.setGrp_ctg_cd1(flat.getGrp_ctg_cd1());

                            case 1 :
                                treeNode.setPsystem_id(flat.getPsystem_id());

                            default :
                                break;
                        }
                        break;

                    case "PROCESS" :
                        switch (depth)
                        {
                            case 7 :
                                treeNode.setBm_id(flat.getBm_id());

                            case 6 :
                                treeNode.setBp_id(flat.getBp_id());

                            case 5 :
                                treeNode.setGroup_id(flat.getGroup_id());

                            case 4 :
                                treeNode.setGrp_ctg_cd2(flat.getGrp_ctg_cd2());

                            case 3 :
                                treeNode.setGrp_ctg_cd1(flat.getGrp_ctg_cd1());

                            case 2 :
                                treeNode.setLsystem_id(flat.getSystem_id());
                                treeNode.setBp_group(flat.getBp_group());

                            case 1 :
                                treeNode.setPsystem_id(flat.getPsystem_id());

                            default :
                                break;
                        }
                        break;

                    default :
                        break;
                }

                treeNode.setParent(parentTreeNode);

                if (nested.containsKey(key) == false)
                {
                    nested.put(key, treeNode);
                }

                if (nested.containsKey(parentKey))
                {
                    nested.get(parentKey).addChild(treeNode);
                }

                parentKey = key;
                parentTreeNode = treeNode;
            }
        }

        // 최종 변경 Node에 대한 정보를 다시 ROOT위로 올려준다.
        while (ProcessInfoTreeNode.ROOT_KEY.equals(parentKey) == false)
        {
            nested.get(parentKey).updateChild(treeNode);

            treeNode = nested.get(parentKey);
            parentKey = treeNode.getParent_key();
        }

        return nested;
    }

    /**
     * 루트 노드를 생성하고, 1 depth 트리 노드들을 추출하여 자식 노드 리스트 추가하여 반환한다.
     *
     * @param lookup
     * @return
     */
    public static ProcessInfoTreeNode buildRootTreeNode(SortedMap<String, ProcessInfoTreeNode> lookup)
    {
        ProcessInfoTreeNode rootTreeNode = new ProcessInfoTreeNode();
        rootTreeNode.setKey(ProcessInfoTreeNode.ROOT_KEY);
        rootTreeNode.setType(ProcessInfoTreeNode.ROOT_KEY);
        rootTreeNode.setDepth(ProcessInfoTreeNode.ROOT_DEPTH);

        for (Map.Entry<String, ProcessInfoTreeNode> entry : lookup.entrySet())
        {
            if (ProcessInfoTreeNode.ROOT_KEY.equals(entry.getValue().getParent_key()))
            {
                rootTreeNode.addChild(entry.getValue());
            }
        }

        return rootTreeNode;
    }

    /**
     * 온라인 프로세스 트리 노드 리스트에서 노드 키에 해당하는 트리 노드를 추출한다.
     *
     * @param treeNodeList 온라인 프로세스 트리 노드 리스트
     * @param nodeKey 추출할 트리 노드의 키
     * @return
     */
    public static ProcessInfoTreeNode extractTreeNode(List<ProcessInfoTreeNode> treeNodeList, String nodeKey)
    {
        if (StringUtils.isBlank(nodeKey)) return null;

        ProcessInfoTreeNode extractedTreeNode = null;

        if (treeNodeList != null && treeNodeList.size() > 0)
        {
            for (ProcessInfoTreeNode treeNode : treeNodeList)
            {
                if (treeNode.getKey().equals(nodeKey))
                {
                    extractedTreeNode = treeNode;
                    break;
                }
            }
        }

        return extractedTreeNode;
    }

    /**
     * 변경된 온라인 프로세스 정보로 TreeNodeLookup(트리 노드를 찾기 위한 Map)를 갱신한다.
     *
     * @param rootTreeNode
     * @param keys
     * @param changedData
     * @param treeNodeLookup
     * @return
     */
    public static SortedMap<String, ProcessInfoTreeNode> updateTreeNodeLookup( ProcessInfoTreeNode rootTreeNode
                                                                               , List<String> keys
                                                                               , ProcessInfoFlatData changedData
                                                                               , SortedMap<String, ProcessInfoTreeNode> treeNodeLookup
                                                                               )
    {
        if (rootTreeNode == null)
        {
            return treeNodeLookup;
        }

        if (treeNodeLookup.containsKey(rootTreeNode.getKey()) == false)
        {
            treeNodeLookup.put(rootTreeNode.getKey(), rootTreeNode);
        }

        String key = "";
        ProcessInfoTreeNode treeNode = rootTreeNode;

        // BM 노드까지 찾는다.
        for (int i = 0; i < keys.size(); i++)
        {
            key = keys.get(i);

            treeNode = FlatToTreeHelper.extractTreeNode(treeNode.getChildren(), key);

            if (treeNode == null)
            {
                break;
            }

            treeNodeLookup.put(treeNode.getKey(), treeNode);
        }

        // changedData에 해당하는 BM 노드가 없으면 treeNode가 null이다.
        if (treeNode != null)
        {
            ProcessInfoTreeNode currentTreeNode = treeNodeLookup.get(treeNode.getKey());
            String parentKey = currentTreeNode.getParent_key();

            // BM 갱신
            if (treeNode.getType().equals("BM"))
            {
                currentTreeNode.setTitle(changedData.getBm_name() + " (T:" + changedData.getRunning_thread() + ")");
                currentTreeNode.setStatus_priority(changedData.getStatus_priority());
                currentTreeNode.setStatus(changedData.getStatus());
            }

            while (ProcessInfoTreeNode.ROOT_KEY.equals(parentKey) == false)
            {
                treeNodeLookup.get(parentKey).updateChild(currentTreeNode);

                currentTreeNode = treeNodeLookup.get(parentKey);
                parentKey = currentTreeNode.getParent_key();
            }
        }

        return treeNodeLookup;
    }
}