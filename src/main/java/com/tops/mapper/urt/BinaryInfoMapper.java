package com.tops.mapper.urt;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.flow.BinaryInfo;
import com.tops.model.flow.BinaryLocation;

@Mapper
public interface BinaryInfoMapper
{
	// BINARY 정보 조회 목록
    List<BinaryInfo> selectBinaryInfoList();
	
	// BINARY 정보 조회 목록(전체)
    List<BinaryInfo> selectBinaryInfoAllList();
	
	// BINARY 정보 조회
    BinaryInfo selectBinaryInfo(String binaryId);
	
	// BINARY Loc정보 조회 목록
    List<BinaryLocation> selectBinaryLocationInfoList(BinaryInfo binaryInfo);
	
	// BINARY정보 등록
    int insertBinaryInfo(@Param("binaryInfo") BinaryInfo binaryInfo);
	
	// BINARY Location정보 등록
    void insertBinaryLocationInfo(@Param("binaryLocationInfo") BinaryLocation binaryLocationInfo);
	
	// BINARY정보 수정
    int updateBinaryInfo(@Param("binaryInfo") BinaryInfo binaryInfo);
	
	// BINARY정보 삭제
    int deleteBinaryInfo(String binaryId);
	
	// BINARY Location정보 삭제
    void deleteBinaryLocationInfo(String binaryId);
}
