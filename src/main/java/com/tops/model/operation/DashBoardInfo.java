package com.tops.model.operation;

import java.util.Comparator;

import org.apache.ibatis.type.Alias;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.tops.model.BaseObject;

@Alias("DashBoardInfo")
public class DashBoardInfo extends BaseObject implements Comparable<DashBoardInfo>
{
	// 정렬 처리를 위한 비교값
	@JsonInclude(JsonInclude.Include.NON_EMPTY)
	private String compare_key = "";

    private String comp_type;

    private String comp_id;
   
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String sub_comp_seq;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String sub_comp_id;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String sub_comp_name;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private int    stat_value;

    private String status;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String message;

    public String getCompare_key()
    {
        return compare_key;
    }

    public void setCompare_key(String compare_key)
    {
        this.compare_key = compare_key;
    }

    public String getComp_type()
    {
        return comp_type;
    }

    public void setComp_type(String comp_type)
    {
        this.comp_type = comp_type;
    }

    public String getComp_id()
    {
        return comp_id;
    }

    public void setComp_id(String comp_id)
    {
        this.comp_id = comp_id;
    }

    public String getSub_comp_seq()
    {
        return sub_comp_seq;
    }

    public void setSub_comp_seq(String sub_comp_seq)
    {
        this.sub_comp_seq = sub_comp_seq;
    }

    public String getSub_comp_id()
    {
        return sub_comp_id;
    }

    public void setSub_comp_id(String sub_comp_id)
    {
        this.sub_comp_id = sub_comp_id;
    }

    public String getSub_comp_name()
    {
        return sub_comp_name;
    }

    public void setSub_comp_name(String sub_comp_name)
    {
        this.sub_comp_name = sub_comp_name;
    }

    public int getStat_value()
    {
        return stat_value;
    }

    public void setStat_value(int stat_value)
    {
        this.stat_value = stat_value;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getMessage()
    {
        return message;
    }

    public void setMessage(String message)
    {
        this.message = message;
    }

    // Comparator
    @Override
    public int compareTo(DashBoardInfo compareDataInfo)
    {
        return this.compare_key.compareTo(compareDataInfo.getCompare_key());
    }

    /** Switch Type으로 온라인 프로세스 현황 Tree 구성시 정렬 비교기 */
    public static Comparator<DashBoardInfo> sortComparator = new Comparator<DashBoardInfo>()
    {
        StringBuffer previousKey = new StringBuffer();
        StringBuffer currentKey  = new StringBuffer();

        public int compare(DashBoardInfo prevInfo, DashBoardInfo currInfo)
        {
            // StringBuffer 초기화
            previousKey.delete(0, previousKey.length());
            currentKey.delete(0, currentKey.length());

            // StringBuffer append 처리
            previousKey.append(prevInfo.getComp_type())
                       .append(prevInfo.getComp_id())
                       .append(prevInfo.getSub_comp_seq())
                       .append(prevInfo.getSub_comp_id())
                       ;

            currentKey.append(currInfo.getComp_type())
                      .append(currInfo.getComp_id())
                      .append(currInfo.getSub_comp_seq())
                      .append(currInfo.getSub_comp_id())
                      ;

            // ascending order
            return previousKey.toString().compareTo(currentKey.toString());
        }
    };
}