package com.tops.model.common;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

/**
 * 검색 파라미터를 다루기 위한 Model class
 */
@Alias("SearchParam")
public class SearchParam extends BaseObject
{
    private String searchOption; // 검색 옵션
    private String searchWord;   // 검색 키워드
    private String sortType;     // 정렬 구분
    private String sortBy;       // 정렬 기준

    public String getSearchOption()
    {
        return searchOption;
    }

    public void setSearchOption(String searchOption)
    {
        this.searchOption = searchOption;
    }

    public String getSearchWord()
    {
        return searchWord;
    }

    public void setSearchWord(String searchWord)
    {
        this.searchWord = searchWord;
    }

    public String getSortType()
    {
        return sortType;
    }

    public void setSortType(String sortType)
    {
        this.sortType = sortType;
    }

    public String getSortBy()
    {
        return sortBy;
    }

    public void setSortBy(String sortBy)
    {
        this.sortBy = sortBy;
    }
}