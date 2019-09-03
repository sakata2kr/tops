package com.tops.mapper.urt;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.flow.BpGroupInfo;

@Mapper
public interface BpGroupInfoMapper
{
    // BP GROUP 정보 조회
    List<BpGroupInfo> selectBpGroupInfoList();

    // BP GROUP 정보 조회(단건)
    BpGroupInfo selectBpGroupInfo(@Param("bpGroupId") String bpGroupId);

    // BP GROUP 정보 등록
    int insertBpGroupInfo(@Param("bpGroupInfo") BpGroupInfo bpGroupInfo);

    // BP GROUP 정보 수정
    int updateBpGroupInfo(@Param("bpGroupInfo") BpGroupInfo bpGroupInfo);

    // BP GROUP 정보 삭제
    int deleteBpGroupInfo(@Param("bpGroupInfo") BpGroupInfo bpGroupInfo);
}
