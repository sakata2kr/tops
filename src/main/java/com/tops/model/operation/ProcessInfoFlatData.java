package com.tops.model.operation;

import java.util.Comparator;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("ProcessInfoFlatData")
public class ProcessInfoFlatData extends BaseObject implements Comparable<ProcessInfoFlatData>
{
    private String compare_key = "";

    private String grp_ctg_seq1;
    private String grp_ctg_cd1;
    private String grp_ctg_name1;
    private String grp_ctg_seq2;
    private String grp_ctg_cd2;
    private String grp_ctg_name2;
    private String group_id_seq;
    private String group_id;
    private String group_name;
    private String system_id_seq;
    private String system_id;
    private String system_name;
    private String psystem_id_seq;
    private String psystem_id;
    private String psystem_name;
    private String bp_group_seq;
    private String bp_group;
    private String bp_id;
    private String bp_name;
    private String bm_id_seq;
    private String bm_id;
    private String bm_name;
    private int    running_thread;
    private int    status_priority;
    private String status;

    public String getCompare_key()
    {
        return compare_key;
    }

    public void setCompare_key(String compare_key)
    {
        this.compare_key = compare_key;
    }

    public String getGrp_ctg_seq1()
    {
        return grp_ctg_seq1;
    }

    public void setGrp_ctg_seq1(String grp_ctg_seq1)
    {
        this.grp_ctg_seq1 = grp_ctg_seq1;
    }

    public String getGrp_ctg_cd1()
    {
        return grp_ctg_cd1;
    }

    public void setGrp_ctg_cd1(String grp_ctg_cd1)
    {
        this.grp_ctg_cd1 = grp_ctg_cd1;
    }

    public String getGrp_ctg_name1()
    {
        return grp_ctg_name1;
    }

    public void setGrp_ctg_name1(String grp_ctg_name1)
    {
        this.grp_ctg_name1 = grp_ctg_name1;
    }

    public String getGrp_ctg_seq2()
    {
        return grp_ctg_seq2;
    }

    public void setGrp_ctg_seq2(String grp_ctg_seq2)
    {
        this.grp_ctg_seq2 = grp_ctg_seq2;
    }

    public String getGrp_ctg_cd2()
    {
        return grp_ctg_cd2;
    }

    public void setGrp_ctg_cd2(String grp_ctg_cd2)
    {
        this.grp_ctg_cd2 = grp_ctg_cd2;
    }

    public String getGrp_ctg_name2()
    {
        return grp_ctg_name2;
    }

    public void setGrp_ctg_name2(String grp_ctg_name2)
    {
        this.grp_ctg_name2 = grp_ctg_name2;
    }

    public String getGroup_id_seq()
    {
        return group_id_seq;
    }

    public void setGroup_id_seq(String group_id_seq)
    {
        this.group_id_seq = group_id_seq;
    }

    public String getGroup_id()
    {
        return group_id;
    }

    public void setGroup_id(String group_id)
    {
        this.group_id = group_id;
    }

    public String getGroup_name()
    {
        return group_name;
    }

    public void setGroup_name(String group_name)
    {
        this.group_name = group_name;
    }

    public String getSystem_id_seq()
    {
        return system_id_seq;
    }

    public void setSystem_id_seq(String system_id_seq)
    {
        this.system_id_seq = system_id_seq;
    }

    public String getSystem_id()
    {
        return system_id;
    }

    public void setSystem_id(String system_id)
    {
        this.system_id = system_id;
    }

    public String getSystem_name()
    {
        return system_name;
    }

    public void setSystem_name(String system_name)
    {
        this.system_name = system_name;
    }

    public String getPsystem_id_seq()
    {
        return psystem_id_seq;
    }

    public void setPsystem_id_seq(String psystem_id_seq)
    {
        this.psystem_id_seq = psystem_id_seq;
    }

    public String getPsystem_id()
    {
        return psystem_id;
    }

    public void setPsystem_id(String psystem_id)
    {
        this.psystem_id = psystem_id;
    }

    public String getPsystem_name()
    {
        return psystem_name;
    }

    public void setPsystem_name(String psystem_name)
    {
        this.psystem_name = psystem_name;
    }

    public String getBp_group_seq()
    {
        return bp_group_seq;
    }

    public void setBp_group_seq(String bp_group_seq)
    {
        this.bp_group_seq = bp_group_seq;
    }

    public String getBp_group()
    {
        return bp_group;
    }

    public void setBp_group(String bp_group)
    {
        this.bp_group = bp_group;
    }

    public String getBp_id()
    {
        return bp_id;
    }

    public void setBp_id(String bp_id)
    {
        this.bp_id = bp_id;
    }

    public String getBp_name()
    {
        return bp_name;
    }

    public void setBp_name(String bp_name)
    {
        this.bp_name = bp_name;
    }

    public String getBm_id_seq()
    {
        return bm_id_seq;
    }

    public void setBm_id_seq(String bm_id_seq)
    {
        this.bm_id_seq = bm_id_seq;
    }

    public String getBm_id()
    {
        return bm_id;
    }

    public void setBm_id(String bm_id)
    {
        this.bm_id = bm_id;
    }

    public String getBm_name()
    {
        return bm_name;
    }

    public void setBm_name(String bm_name)
    {
        this.bm_name = bm_name;
    }

    public int getRunning_thread()
    {
        return running_thread;
    }

    public void setRunning_thread(int running_thread)
    {
        this.running_thread = running_thread;
    }

    public int getStatus_priority()
    {
        return status_priority;
    }

    public void setStatus_priority(int status_priority)
    {
        this.status_priority = status_priority;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    // Comparator
    @Override
    public int compareTo(ProcessInfoFlatData compareDataInfo)
    {
        return this.compare_key.compareTo(compareDataInfo.getCompare_key());
    }

    /** Switch Type으로 온라인 프로세스 현황 Tree 구성시 정렬 비교기 */
    public static Comparator<ProcessInfoFlatData> GroupTypeComparator = new Comparator<ProcessInfoFlatData>()
    {
        StringBuffer previousKey = new StringBuffer();
        StringBuffer currentKey  = new StringBuffer();

        public int compare(ProcessInfoFlatData previousOnlineProcess, ProcessInfoFlatData currentOnlineProcess)
        {
            // StringBuffer 초기화
            previousKey.delete(0, previousKey.length());
            currentKey.delete(0, currentKey.length());

            // StringBuffer append 처리
            previousKey.append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getGrp_ctg_seq1()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getGrp_ctg_cd1()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getGrp_ctg_seq2()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getGrp_ctg_cd2()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getGroup_id_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getGroup_id()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getPsystem_id_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getPsystem_id()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getSystem_id_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getSystem_id()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getBp_group_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getBp_group()))
                       .append(StringUtils.defaultString(previousOnlineProcess.getBp_id()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getBm_id_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getBm_id()))
                       ;

            currentKey.append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getGrp_ctg_seq1()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getGrp_ctg_cd1()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getGrp_ctg_seq2()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getGrp_ctg_cd2()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getGroup_id_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getGroup_id()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getPsystem_id_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getPsystem_id()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getSystem_id_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getSystem_id()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getBp_group_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getBp_group()))
                      .append(StringUtils.defaultString(currentOnlineProcess.getBp_id()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getBm_id_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getBm_id()))
                      ;

            // ascending order
            return previousKey.toString().compareTo(currentKey.toString());
        }
    };

    /** Server로 온라인 프로세스 현황 Tree 구성시 정렬 비교기 */
    public static Comparator<ProcessInfoFlatData> ServerTypeComparator = new Comparator<ProcessInfoFlatData>()
    {
        StringBuffer previousKey = new StringBuffer();
        StringBuffer currentKey  = new StringBuffer();

        public int compare(ProcessInfoFlatData previousOnlineProcess, ProcessInfoFlatData currentOnlineProcess)
        {
            // StringBuffer 초기화
            previousKey.delete(0, previousKey.length());
            currentKey.delete(0, currentKey.length());

            // StringBuffer append 처리
            previousKey.append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getPsystem_id_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getPsystem_id()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getGrp_ctg_seq1()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getGrp_ctg_cd1()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getGrp_ctg_seq2()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getGrp_ctg_cd2()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getGroup_id_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getGroup_id()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getSystem_id_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getSystem_id()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getBp_group_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getBp_group()))
                       .append(StringUtils.defaultString(previousOnlineProcess.getBp_id()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getBm_id_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getBm_id()))
                       ;

            currentKey.append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getPsystem_id_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getPsystem_id()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getGrp_ctg_seq1()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getGrp_ctg_cd1()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getGrp_ctg_seq2()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getGrp_ctg_cd2()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getGroup_id_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getGroup_id()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getSystem_id_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getSystem_id()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getBp_group_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getBp_group()))
                      .append(StringUtils.defaultString(currentOnlineProcess.getBp_id()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getBm_id_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getBm_id()))
                      ;

            // ascending order
            return previousKey.toString().compareTo(currentKey.toString());
        }
    };

    /** Process로 온라인 프로세스 현황 Tree 구성시 정렬 비교기 */
    public static Comparator<ProcessInfoFlatData> ProcessTypeComparator = new Comparator<ProcessInfoFlatData>()
    {
        StringBuffer previousKey = new StringBuffer();
        StringBuffer currentKey  = new StringBuffer();

        public int compare(ProcessInfoFlatData previousOnlineProcess, ProcessInfoFlatData currentOnlineProcess)
        {
            // StringBuffer 초기화
            previousKey.delete(0, previousKey.length());
            currentKey.delete(0, currentKey.length());

            // StringBuffer append 처리
            previousKey.append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getPsystem_id_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getPsystem_id()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getBp_group_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getBp_group()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getSystem_id_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getSystem_id()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getGrp_ctg_seq1()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getGrp_ctg_cd1()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getGrp_ctg_seq2()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getGrp_ctg_cd2()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getGroup_id_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getGroup_id()))
                       .append(StringUtils.defaultString(previousOnlineProcess.getBp_id()))
                       .append(StringUtils.leftPad(StringUtils.defaultString(previousOnlineProcess.getBm_id_seq()), 5, '0'))
                       .append(StringUtils.defaultString(previousOnlineProcess.getBm_id()))
                       ;


            currentKey.append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getPsystem_id_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getPsystem_id()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getBp_group_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getBp_group()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getSystem_id_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getSystem_id()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getGrp_ctg_seq1()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getGrp_ctg_cd1()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getGrp_ctg_seq2()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getGrp_ctg_cd2()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getGroup_id_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getGroup_id()))
                      .append(StringUtils.defaultString(currentOnlineProcess.getBp_id()))
                      .append(StringUtils.leftPad(StringUtils.defaultString(currentOnlineProcess.getBm_id_seq()), 5, '0'))
                      .append(StringUtils.defaultString(currentOnlineProcess.getBm_id()))
                      ;

            // ascending order
            return previousKey.toString().compareTo(currentKey.toString());
        }
    };
}