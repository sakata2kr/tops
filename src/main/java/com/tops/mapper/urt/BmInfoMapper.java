package com.tops.mapper.urt;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.flow.BmInfo;

@Mapper
public interface BmInfoMapper
{
    // BM 정보 조회(단건)
    BmInfo selectBmInfo(@Param("bmInfo") BmInfo bmInfo);

    // BM 정보 등록
    int insertBmInfo(@Param("bmInfo") BmInfo bmInfo);

    // BM 정보 수정
    int updateBmInfo(@Param("bmInfo") BmInfo bmInfo);

    // BM 정보 삭제
    int deleteBmInfo(@Param("bmInfo") BmInfo bmInfo);
}
