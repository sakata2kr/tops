package com.tops.common.ScheduledService;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StopWatch;

import com.tops.model.operation.ProcessInfoFlatData;
import com.tops.model.operation.ProcessInfoTreeNode;

/**
 * 온라인 프로세스 트리 Builder
 *
 * @author kujin.lee
 * @version 1.0.0
 */
public class FlatToTreeBuilder
{
    private static final Logger logger = LoggerFactory.getLogger(FlatToTreeBuilder.class);

    /**
     * 3가지 유형의 온라인 프로세스 트리(Group Type, System Type, Process Type)를 생성한다.
     *
     * @param onlineProcessFlatList
     * @return
     */
    public static Map<String, ProcessInfoTreeNode> buildTree(List<ProcessInfoFlatData> onlineProcessFlatList)
    {
        StopWatch stopWatch = new StopWatch("Build Tree Stopwatch");

        Map<String, ProcessInfoTreeNode> treeMap = new HashMap<String, ProcessInfoTreeNode>();

        // Build SwitchType Tree =============================================================
        stopWatch.start("Sort by SwitchTypeTreeComparator");
        Collections.sort(onlineProcessFlatList, ProcessInfoFlatData.GroupTypeComparator);
        stopWatch.stop();

        stopWatch.start("Build SwitchType Tree");
        treeMap.put("GROUP", FlatToTreeBuilder.buildGroupTypeTree(onlineProcessFlatList));
        stopWatch.stop();

        // Build Server Tree ================================================================
        stopWatch.start("Sort by ServerTreeComparator");
        Collections.sort(onlineProcessFlatList, ProcessInfoFlatData.ServerTypeComparator);
        stopWatch.stop();

        stopWatch.start("Build Server Tree");
        treeMap.put("SERVER", FlatToTreeBuilder.buildServerTypeTree(onlineProcessFlatList));
        stopWatch.stop();

        // Build Process Tree ===============================================================
        stopWatch.start("Sort by ProcessTreeComparator");
        Collections.sort(onlineProcessFlatList, ProcessInfoFlatData.ProcessTypeComparator);
        stopWatch.stop();

        stopWatch.start("Build Process Tree");
        treeMap.put("PROCESS", FlatToTreeBuilder.buildProcessTypeTree(onlineProcessFlatList));
        stopWatch.stop();

        logger.debug("\n{}", stopWatch.prettyPrint());

        return treeMap;
    }

    /**
     * Switch Type 유형의 온라인 프로세스 트리를 생성한다.
     *
     * @param onlineProcessFlatList
     * @return
     */
    public static ProcessInfoTreeNode buildGroupTypeTree(List<ProcessInfoFlatData> onlineProcessFlatList)
    {
        SortedMap<String, ProcessInfoTreeNode> lookup = new TreeMap<String, ProcessInfoTreeNode>();

        List<String> keys   = new ArrayList<String>();
        List<String> titles = new ArrayList<String>();
        List<String> types  = new ArrayList<String>();

        StringBuilder tmpStrBuilder = new StringBuilder();

        for (ProcessInfoFlatData dataInfo : onlineProcessFlatList)
        {
            // ArrayList 초기화
            keys.clear();
            titles.clear();
            types.clear();
            tmpStrBuilder.delete(0, tmpStrBuilder.length());

            keys.add(tmpStrBuilder.append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq1()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd1()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq2()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd2()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGroup_id_seq()),   3, '0')).append("|").append(dataInfo.getGroup_id()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getPsystem_id_seq()), 3, '0')).append("|").append(dataInfo.getPsystem_id())
            		              .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getSystem_id_seq()),  3, '0')).append("|").append(dataInfo.getSystem_id()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBp_group_seq()),   3, '0')).append("|").append(dataInfo.getBp_group()).toString());
            keys.add(tmpStrBuilder.append("|").append(dataInfo.getBp_id()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBm_id_seq()), 3, '0')).append("|").append(dataInfo.getBm_id()).toString());

            titles.add(dataInfo.getGrp_ctg_name1());
            titles.add(dataInfo.getGrp_ctg_name2());
            titles.add(dataInfo.getGroup_name() + " (" + dataInfo.getGroup_id() + ")");
            titles.add(dataInfo.getPsystem_name() + " (" + dataInfo.getSystem_name() + ")");
            titles.add(dataInfo.getBp_group());
            titles.add(dataInfo.getBp_name());
            titles.add(dataInfo.getBm_name() + " (T:" + dataInfo.getRunning_thread() + ")");

            types.add("GROUP_CTG1");
            types.add("GROUP_CTG2");
            types.add("GROUP");
            types.add("SERVER");
            types.add("BP_GROUP");
            types.add("BP");
            types.add("BM");

            lookup = FlatToTreeHelper.convertFlatToNested("GROUP", dataInfo, lookup, keys, titles, types);
        }

        return FlatToTreeHelper.buildRootTreeNode(lookup);
    }

    /**
     * Server 유형의 온라인 프로세스 트리를 생성한다.
     *
     * @param onlineProcessFlatList
     * @return
     */
    public static ProcessInfoTreeNode buildServerTypeTree(List<ProcessInfoFlatData> onlineProcessFlatList)
    {
        SortedMap<String, ProcessInfoTreeNode> lookup = new TreeMap<String, ProcessInfoTreeNode>();

        List<String> keys   = new ArrayList<String>();
        List<String> titles = new ArrayList<String>();
        List<String> types  = new ArrayList<String>();

        StringBuilder tmpStrBuilder = new StringBuilder();

        for (ProcessInfoFlatData dataInfo : onlineProcessFlatList)
        {
            // ArrayList 초기화
            keys.clear();
            titles.clear();
            types.clear();
            tmpStrBuilder.delete(0, tmpStrBuilder.length());

            keys.add(tmpStrBuilder.append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getPsystem_id_seq()), 3, '0')).append("|").append(dataInfo.getPsystem_id()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq1()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd1()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq2()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd2()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGroup_id_seq()),   3, '0')).append("|").append(dataInfo.getGroup_id()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getSystem_id_seq()),  3, '0')).append("|").append(dataInfo.getSystem_id())
            		              .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBp_group_seq()),   3, '0')).append("|").append(dataInfo.getBp_group()).toString());
            keys.add(tmpStrBuilder.append("|").append(dataInfo.getBp_id()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBm_id_seq()), 3, '0')).append("|").append(dataInfo.getBm_id()).toString());

            titles.add(dataInfo.getPsystem_name());
            titles.add(dataInfo.getGrp_ctg_name1());
            titles.add(dataInfo.getGrp_ctg_name2());
            titles.add(dataInfo.getGroup_name() + " (" + dataInfo.getGroup_id() + ")");
            titles.add(dataInfo.getBp_group() + " (" + dataInfo.getSystem_name() + ")");
            titles.add(dataInfo.getBp_name());
            titles.add(dataInfo.getBm_name() + " (T:" + dataInfo.getRunning_thread() + ")");

            types.add("SERVER");
            types.add("GROUP_CTG1");
            types.add("GROUP_CTG2");
            types.add("GROUP");
            types.add("BP_GROUP");
            types.add("BP");
            types.add("BM");

            lookup = FlatToTreeHelper.convertFlatToNested("SERVER", dataInfo, lookup, keys, titles, types);
        }

        return FlatToTreeHelper.buildRootTreeNode(lookup);
    }

    /**
     * Process 유형의 온라인 프로세스 트리를 생성한다.
     *
     * @param onlineProcessFlatList
     * @return
     */
    public static ProcessInfoTreeNode buildProcessTypeTree(List<ProcessInfoFlatData> onlineProcessFlatList)
    {
        SortedMap<String, ProcessInfoTreeNode> lookup = new TreeMap<String, ProcessInfoTreeNode>();

        List<String> keys   = new ArrayList<String>();
        List<String> titles = new ArrayList<String>();
        List<String> types  = new ArrayList<String>();

        StringBuilder tmpStrBuilder = new StringBuilder();

        for (ProcessInfoFlatData dataInfo : onlineProcessFlatList)
        {
            // ArrayList 초기화
            keys.clear();
            titles.clear();
            types.clear();
            tmpStrBuilder.delete(0, tmpStrBuilder.length());

            keys.add(tmpStrBuilder.append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getPsystem_id_seq()), 3, '0')).append("|").append(dataInfo.getPsystem_id()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getSystem_id_seq()),  3, '0')).append("|").append(dataInfo.getSystem_id())
		                          .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBp_group_seq()),   3, '0')).append("|").append(dataInfo.getBp_group()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq1()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd1()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq2()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd2()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGroup_id_seq()),   3, '0')).append("|").append(dataInfo.getGroup_id()).toString());
            keys.add(tmpStrBuilder.append("|").append(dataInfo.getBp_id()).toString());
            keys.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBm_id_seq()), 3, '0')).append("|").append(dataInfo.getBm_id()).toString());

            titles.add(dataInfo.getPsystem_name());
            titles.add(dataInfo.getBp_group() + " (" + dataInfo.getSystem_name() + ")");
            titles.add(dataInfo.getGrp_ctg_name1());
            titles.add(dataInfo.getGrp_ctg_name2());
            titles.add(dataInfo.getGroup_name() + " (" + dataInfo.getGroup_id() + ")");
            titles.add(dataInfo.getBp_name());
            titles.add(dataInfo.getBm_name() + " (T:" + dataInfo.getRunning_thread() + ")");

            types.add("SERVER");
            types.add("BP_GROUP");
            types.add("GROUP_CTG1");
            types.add("GROUP_CTG2");
            types.add("GROUP");
            types.add("BP");
            types.add("BM");

            lookup = FlatToTreeHelper.convertFlatToNested("PROCESS", dataInfo, lookup, keys, titles, types);
        }

        return FlatToTreeHelper.buildRootTreeNode(lookup);
    }

}
