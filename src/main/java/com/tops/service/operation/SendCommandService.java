package com.tops.service.operation;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.model.common.InMemoryRepository;
import com.tops.model.operation.ProcessInfoFlatData;
import com.tops.model.operation.ProcessInfoTreeNode;
import com.tops.model.user.UserInfo;
import com.tops.service.BaseService;

@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class SendCommandService extends BaseService
{
	public static String fwkServer1Name;
    public static String fwkServer1Host;
    public static int    fwkServer1Port;

	public static String fwkServer2Name;
    public static String fwkServer2Host;
    public static int    fwkServer2Port;

    @Value("${fwkServer1.name}")
    public void setPriName(String fwkServer1Name)
    {
        SendCommandService.fwkServer1Name = fwkServer1Name;
    }

    @Value("${fwkServer1.host}")
    public void setfwkServer1Host(String fwkServer1Host)
    {
        SendCommandService.fwkServer1Host = fwkServer1Host;
    }

    @Value("${fwkServer1.port}")
    public void setfwkServer1Port(int fwkServer1Port)
    {
        SendCommandService.fwkServer1Port = fwkServer1Port;
    }

    @Value("${fwkServer2.name}")
    public void setfwkServer2Name(String fwkServer2Name)
    {
        SendCommandService.fwkServer2Name = fwkServer2Name;
    }

    @Value("${fwkServer2.host}")
    public void setfwkServer2Host(String fwkServer2Host)
    {
        SendCommandService.fwkServer2Host = fwkServer2Host;
    }

    @Value("${fwkServer2.port}")
    public void setfwkServer2Port(int fwkServer2Port)
    {
        SendCommandService.fwkServer2Port = fwkServer2Port;
    }

    private Socket socket;

    private DataInputStream  inputStream;
    private DataOutputStream outputStream;

    // 전문 생성
    public boolean requestProcessCommand (UserInfo userInfo, String viewType, String nodeKey, String nodeType, String cmdCode, String cmdInfo, String cmdInfoSub) throws Exception
    {
        StringBuilder tmpStringBuilder = new StringBuilder();
        List<String> ifTmpBodyList = new ArrayList<String>();

        // Framework Reload 처리용 전문
        if ( nodeType.equals("FWK") )
        {
            tmpStringBuilder.append("RE_START").append("\0").append("ALL_FWKS").append("\0").append("\0").append("\0").append("\0");
            ifTmpBodyList.add(tmpStringBuilder.toString());    // 전문 처리 내역 적재
        }
        else
        {
            List<ProcessInfoTreeNode> cmdTreeNodeList = new ArrayList<ProcessInfoTreeNode>();
            ProcessInfoTreeNode cmdTreeNode;
            boolean doubleDiffCheck = false;

            for ( ProcessInfoFlatData dataInfo : InMemoryRepository.processFlatDataList )
            {
                tmpStringBuilder.delete(0, tmpStringBuilder.length());
                cmdTreeNode = new ProcessInfoTreeNode();

                switch (viewType)
                {
                    case "GROUP" :
                        tmpStringBuilder.append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq1()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd1())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq2()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd2())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGroup_id_seq()),   3, '0')).append("|").append(dataInfo.getGroup_id())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getPsystem_id_seq()), 3, '0')).append("|").append(dataInfo.getPsystem_id())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getSystem_id_seq()),  3, '0')).append("|").append(dataInfo.getSystem_id())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBp_group_seq()),   3, '0')).append("|").append(dataInfo.getBp_group())
                            .append("|").append(dataInfo.getBp_id())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBm_id_seq()), 3, '0')).append("|").append(dataInfo.getBm_id())
                            ;
                        break;

                    case "SERVER" :
                        tmpStringBuilder.append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getPsystem_id_seq()), 3, '0')).append("|").append(dataInfo.getPsystem_id())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq1()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd1())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq2()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd2())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGroup_id_seq()),   3, '0')).append("|").append(dataInfo.getGroup_id())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getSystem_id_seq()),  3, '0')).append("|").append(dataInfo.getSystem_id())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBp_group_seq()),   3, '0')).append("|").append(dataInfo.getBp_group())
                            .append("|").append(dataInfo.getBp_id())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBm_id_seq()), 3, '0')).append("|").append(dataInfo.getBm_id())
                            ;
                        break;

                    case "PROCESS" :
                        tmpStringBuilder.append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getPsystem_id_seq()), 3, '0')).append("|").append(dataInfo.getPsystem_id())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getSystem_id_seq()),  3, '0')).append("|").append(dataInfo.getSystem_id())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBp_group_seq()),   3, '0')).append("|").append(dataInfo.getBp_group())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq1()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd1())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq2()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd2())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGroup_id_seq()),   3, '0')).append("|").append(dataInfo.getGroup_id())
                            .append("|").append(dataInfo.getBp_id())
                            .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBm_id_seq()), 3, '0')).append("|").append(dataInfo.getBm_id())
                            ;
                        break;

                    default :
                        break;
                }

                // key 값을 기준으로 하위 항목 중 key를 가지고 있는 대상에 대해 추출 후 전문 생성
                if ( tmpStringBuilder.toString().indexOf(nodeKey) == 0 )
                {
                    doubleDiffCheck = true;

                    // 최상위 처리 정보를 기준으로 하위 전문 처리 관련 데이터 생성
                    switch (nodeType)
                    {
                        case "SERVER" :     // SERVER 지정인 경우
                            cmdTreeNode.setPsystem_id(dataInfo.getPsystem_id());
                            cmdTreeNode.setLsystem_id(dataInfo.getSystem_id());

                            /* SERVER 지정인 경우라도 GROUP 기준으로 split 하여 전문 생성
                            // Tree 유형이 GROUP인 경우는 GROUP 정보도 포함
                            if ( viewType.equals("GROUP") && ( cmdTreeNode.getGroup_id() == null || !cmdTreeNode.getGroup_id().equals(dataInfo.getGroup_id()) ) )
                            */
                            {
                                cmdTreeNode.setGroup_id(dataInfo.getGroup_id());
                            }

                            // 저장된 Node List 중 기존 정보와 다른 내용이 있는지 한번 더 확인
                            for (ProcessInfoTreeNode tmpTreeNodeIter : cmdTreeNodeList)
                            {
                                if ( tmpTreeNodeIter.equals(cmdTreeNode) )
                                {
                                    doubleDiffCheck = false; // 기존 add된 정보가 존재하므로 skip
                                    break;
                                }
                            }
                            break;

                        case "GROUP_CTG1" : // GROUP 분류1 지정인 경우
                        case "GROUP_CTG2" : // GROUP 분류2 지정인 경우
                        case "GROUP" :      // GROUP 지정인 경우
                            cmdTreeNode.setPsystem_id(dataInfo.getPsystem_id());
                            cmdTreeNode.setLsystem_id(dataInfo.getSystem_id());
                            cmdTreeNode.setGroup_id(dataInfo.getGroup_id());

                            // Tree 유형이 PROCESS인 경우는 BP정보까지 포함
                            if (viewType.equals("PROCESS")  && ( cmdTreeNode.getBp_id() == null || !cmdTreeNode.getBp_id().equals(dataInfo.getBp_id()) ) )
                            {
                                cmdTreeNode.setBp_id(dataInfo.getBp_id());
                            }

                            // 저장된 Node List 중 기존 정보와 다른 내용이 있는지 한번 더 확인
                            for (ProcessInfoTreeNode tmpTreeNodeIter : cmdTreeNodeList)
                            {
                                if ( tmpTreeNodeIter.equals(cmdTreeNode) )
                                {
                                    doubleDiffCheck = false; // 기존 add된 정보가 존재하므로 skip
                                    break;
                                }
                            }
                            break;

                        case "BP_GROUP" : // BP_GROUP 분류 지정인 경우
                        case "BP" :       // BP 분류 지정인 경우
                            cmdTreeNode.setPsystem_id(dataInfo.getPsystem_id());
                            cmdTreeNode.setLsystem_id(dataInfo.getSystem_id());
                            cmdTreeNode.setGroup_id(dataInfo.getGroup_id());
                            cmdTreeNode.setBp_id(dataInfo.getBp_id());

                            // 저장된 Node List 중 기존 정보와 다른 내용이 있는지 한번 더 확인
                            for (ProcessInfoTreeNode tmpTreeNodeIter : cmdTreeNodeList)
                            {
                                if ( tmpTreeNodeIter.equals(cmdTreeNode) )
                                {
                                    doubleDiffCheck = false; // 기존 add된 정보가 존재하므로 skip
                                    break;
                                }
                            }
                            break;

                        case "BM" : // BM 분류 지정인 경우
                            // BM은 최하단이고 중복 처리건이 미존재하므로 조회값으로 바로 세팅
                            cmdTreeNode.setPsystem_id(dataInfo.getPsystem_id());
                            cmdTreeNode.setLsystem_id(dataInfo.getSystem_id());
                            cmdTreeNode.setGroup_id(dataInfo.getGroup_id());
                            cmdTreeNode.setBp_id(dataInfo.getBp_id());
                            cmdTreeNode.setBm_id(dataInfo.getBm_id());
                            break;

                        default : // Node Type 값이 잘 못 들어온 경우
                            doubleDiffCheck = false;
                            break;
                    }

                    if (doubleDiffCheck)
                    {
                        cmdTreeNodeList.add(cmdTreeNode);
                    }
                }
            }

            // 2. 전문 요청 코드 생성
            for ( ProcessInfoTreeNode jsonIter : cmdTreeNodeList )
            {
                tmpStringBuilder.delete(0, tmpStringBuilder.length());

                switch (cmdCode)
                {
                    case "BP01" :   // BP 중지/기동 전문 처리 시
                        if (jsonIter.getLsystem_id() != null && jsonIter.getPsystem_id() != null && jsonIter.getGroup_id() != null && jsonIter.getBp_id() != null)
                        {
                            tmpStringBuilder.append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getLsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getPsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getGroup_id()),   7, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getBp_id()),      7, "\0"))
                                            .append(StringUtils.defaultString(cmdInfo)).append("\0")
                                            .append("U").append("\0")           // U. GUI
                                            .append(StringUtils.rightPad(StringUtils.defaultString(userInfo.getUser_id()),   31, "\0"))
                                            .append("R").append("\0")
                                            .append(StringUtils.rightPad(StringUtils.defaultString(userInfo.getIpAddr()),    16, "\0"))
                                            ;
                        }
                        break;

                    case "BG01" :   // GROUP 중지/기동 전문 처리 시
                        // GROUP 정보가 존재하는 경우 GROUP Flag로 처리
                        if (jsonIter.getLsystem_id() != null && jsonIter.getPsystem_id() != null && jsonIter.getGroup_id() != null)
                        {
                            tmpStringBuilder.append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getLsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getPsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getGroup_id()),   7, "\0"))
                                            .append("G").append("\0")           // G. GROUP S. SYSTEM
                                            .append(StringUtils.defaultString(cmdInfo)).append("\0")
                                            .append("U").append("\0")           // U. GUI
                                            .append(StringUtils.rightPad(StringUtils.defaultString(userInfo.getUser_id()),   31, "\0"))
                                            .append("R").append("\0")
                                            .append(StringUtils.rightPad(StringUtils.defaultString(userInfo.getIpAddr()),    16, "\0"))
                                            ;
                        }
                        // GROUP 정보가 존재하지 않는 경우 SYSTEM Flag로 처리
                        else if (jsonIter.getLsystem_id() != null && jsonIter.getPsystem_id() != null)
                        {
                            tmpStringBuilder.append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getLsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getPsystem_id()), 9, "\0"))
                                            .append("000000").append("\0")
                                            .append("S").append("\0")           // G. GROUP S. SYSTEM
                                            .append(StringUtils.defaultString(cmdInfo)).append("\0")
                                            .append("U").append("\0")           // U. GUI
                                            .append(StringUtils.rightPad(StringUtils.defaultString(userInfo.getUser_id()),   31, "\0"))
                                            .append("R").append("\0")
                                            .append(StringUtils.rightPad(StringUtils.defaultString(userInfo.getIpAddr()),    16, "\0"))
                                            ;

                        }
                        break;

                    case "TH01" : // BM Thread 추가/삭제 전문 처리 시
                        if (jsonIter.getLsystem_id() != null && jsonIter.getPsystem_id() != null && jsonIter.getGroup_id() != null && jsonIter.getBp_id() != null && jsonIter.getBm_id() != null)
                        {
                            tmpStringBuilder.append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getLsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getPsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getGroup_id()),   7, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getBp_id()),      7, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getBm_id()),      7, "\0"))
                                            .append("B").append("\0")           // B. COMMAND RANGE : BP
                                            .append(StringUtils.defaultString(cmdInfo)).append("\0")
                                            .append("U").append("\0")           // U. GUI
                                            .append(StringUtils.rightPad(StringUtils.defaultString(userInfo.getUser_id()),   31, "\0"))
                                            .append("R").append("\0")
                                            .append(StringUtils.rightPad(StringUtils.defaultString(userInfo.getIpAddr()),    16, "\0"))
                                            ;
                        }
                        break;

                    case "BP05" : // GROUP 수동 Take-Over 처리 시
                        if (jsonIter.getLsystem_id() != null && jsonIter.getPsystem_id() != null && jsonIter.getGroup_id() != null)
                        {
                            tmpStringBuilder.append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getLsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getGroup_id()),   7, "\0"))
                                            .append(StringUtils.defaultString(cmdInfo)).append("\0")
                                            .append("M").append("\0")           // D. DB만 갱신 M. DB 갱신 및 GROUP 이전
                                            .append("U").append("\0")           // U. GUI
                                            .append(StringUtils.rightPad(StringUtils.defaultString(userInfo.getUser_id()),   31, "\0"))
                                            .append("R").append("\0")
                                            .append(StringUtils.rightPad(StringUtils.defaultString(userInfo.getIpAddr()),    16, "\0"))
                                            ;
                        }
                        break;

                    case "BS05" : // GROUP 자동 Take-Over 처리 시
                        if (jsonIter.getPsystem_id() != null)
                        {
                            tmpStringBuilder.append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getPsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(""), 9, "\0")) // 자동 Take-Over 시 target system_id는 미반영
                                            .append(StringUtils.defaultString(cmdInfo)).append("\0")
                                            .append("U").append("\0")           // U. GUI
                                            .append(StringUtils.rightPad(StringUtils.defaultString(userInfo.getUser_id()), 31, "\0")).append("\0")
                                            .append("R").append("\0")
                                            .append(StringUtils.rightPad(StringUtils.defaultString(userInfo.getIpAddr()),  16, "\0")).append("\0")
                                            ;
                        }
                        break;

                    case "BP07" : // BP 사용 / 미사용 처리 시
                        // BP 지정인 경우
                        if (jsonIter.getLsystem_id() != null && jsonIter.getGroup_id() != null && jsonIter.getBp_id() != null)
                        {
                            tmpStringBuilder.append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getLsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getGroup_id()),   7, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getBp_id()),      7, "\0"))
                                            .append(StringUtils.defaultString(cmdInfo)).append("\0")
                                            .append(StringUtils.defaultString(cmdInfoSub)).append("\0")
                                            .append("A").append("\0")
                                            ;
                        }
                        // GROUP 지정인 경우
                        else if(jsonIter.getLsystem_id() != null && jsonIter.getGroup_id() != null )
                        {
                            tmpStringBuilder.append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getLsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getGroup_id()),   7, "\0"))
                                            .append("000000").append("\0")
                                            .append(StringUtils.defaultString(cmdInfo)).append("\0")
                                            .append(StringUtils.defaultString(cmdInfoSub)).append("\0")
                                            .append("A").append("\0")
                                            ;
                        }
                        break;

                    case "BP14" : // BP Hold 처리 시 (2017.04.13 추가)
                        if (jsonIter.getLsystem_id() != null && jsonIter.getPsystem_id() != null && jsonIter.getGroup_id() != null && jsonIter.getBp_id() != null)
                        {
                            tmpStringBuilder.append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getLsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getGroup_id()),   7, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getBp_id()),      7, "\0"))
                                            .append(StringUtils.defaultString(cmdInfo)).append("\0")
                                            ;
                        }
                        break;

                    case "LO02" : // 로그 레벨 변경 처리 시 (2017.04.19 추가)
                        if (jsonIter.getLsystem_id() != null && jsonIter.getPsystem_id() != null && jsonIter.getGroup_id() != null && jsonIter.getBp_id() != null)
                        {
                            tmpStringBuilder.append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getLsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getPsystem_id()), 9, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getGroup_id()),   7, "\0"))
                                            .append(StringUtils.rightPad(StringUtils.defaultString(jsonIter.getBp_id()),      7, "\0"))
                                            .append("000000").append("\0")  // BM_ID : 고정값 (로그레벨은 현재 BP단위로 적용됨)
                                            .append("1").append("\0")       // INSTANCE_ID : 고정값
                                            .append(StringUtils.defaultString(cmdInfo)).append("\0")
                                            ;

                             // 로그이벤트(에러) 생성 요청 전문은 cmdInfo 값을 기준으로 하되, cmdInfo가 3보다 큰경우는 무조건 2로 고정
                             try
                             {
                                 if (Integer.valueOf(cmdInfo) >= 3)
                                 {
                                     tmpStringBuilder.append("2").append("\0");
                                 }
                                 else
                                 {
                                     tmpStringBuilder.append(cmdInfo).append("\0");
                                 }
                             }
                             catch (Exception e)
                             {
                                 logger.error("{} 로그이벤트 전문 처리 오류 : {} {}", cmdCode, cmdInfo, e.getMessage());

                                 // 전문 송신 결과 Alarm 처리
                                 return false;
                             }
                        }
                        break;

                    default :
                        break;
                }

                ifTmpBodyList.add(tmpStringBuilder.toString());    // 전문 처리 내역 적재
            }
        }

        try
        {
            // Socket connect
            String fwkSystemId = connect();

            for ( String ifTmpBodyString : ifTmpBodyList )
            {
                // 전문 전송
                tmpStringBuilder = makeHeaderInfo(cmdCode, ifTmpBodyString, fwkSystemId);

                sendCommandMessage(tmpStringBuilder);
                logger.warn("{} 전문 송신 {}", cmdCode, tmpStringBuilder);
            }

            // 수신전문이 별도로 없으므로 전문 송신 후 1초정도 waiting 처리
            Thread.sleep(1000);

            // 전문 송신 결과 Alarm 처리
            return true;
        }
        catch ( Exception e )
        {
            logger.error("{} 전문 데이터 연동 오류 :{}", cmdCode, e.getMessage());

            return false;
        }
        finally
        {
            disconnect();
        }
    }

    public String connect() throws Exception
    {
        try
        {
            logger.info("Connect : {} {}", fwkServer1Host, fwkServer1Port);
            socket = new Socket(fwkServer1Host, fwkServer1Port);

            socket.setSoTimeout(10 * 1000);    //socket 연동 시 10초 이내로 응답이 없는 경우 disconnect 처리
            inputStream  = new DataInputStream(socket.getInputStream());
            outputStream = new DataOutputStream(socket.getOutputStream());

            return fwkServer1Name;
        }
        catch (Exception pex)
        {
            logger.warn("{} {} 소켓 연동 오류 발생 : {}", fwkServer1Host, fwkServer1Port, pex.getMessage());

            try
            {
                logger.info("Connect : {} {}", fwkServer2Host, fwkServer2Port);
                socket = new Socket(fwkServer2Host, fwkServer2Port);

                socket.setSoTimeout(10 * 1000);    //socket 연동 시 10초 이내로 응답이 없는 경우 disconnect 처리
                inputStream  = new DataInputStream(socket.getInputStream());
                outputStream = new DataOutputStream(socket.getOutputStream());

                return fwkServer2Name;
            }
            catch (Exception bex)
            {
                logger.error("{} {} 소켓 연동 오류 발생 : {}", fwkServer2Host, fwkServer2Port, bex.getMessage());
                throw bex;
            }
        }
    }

    public void disconnect() throws IOException
    {
        try
        {
            // 전문 송신 완료 처리
            outputStream.flush();

            // 소켓 연동 해제 처리
            if (inputStream  != null)    inputStream.close();
            if (outputStream != null)    outputStream.close();
            if (socket       != null)    socket.close();
        }
        catch (IOException ex)
        {
            logger.error("소켓 연동해제 오류 발생 : " + ex.getMessage());
            throw ex;
        }
        finally
        {
            inputStream  = null;
            outputStream = null;
            socket       = null;
        }
    }

    // 전송 전문을 생성한다.
    public StringBuilder makeHeaderInfo(String cmdCode, String ifBody, String fwkSystemId)
    {
        StringBuilder ifHeaderInfo = new StringBuilder();
        String timestamp = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date()) + "000";

        ifHeaderInfo.append("UI").append("\0")                                                         // 소속코드
                    .append(cmdCode).append("\0")                                                      // 거래분류코드
                    .append("S").append("\0")                                                          // 거래유형정보 (S:요청 R:응답 P:Push E:실패)
                    .append(String.format("%08d",  ifBody.getBytes().length)).append("\0")             // 데이터 길이 (헤더 제외)
                    .append(UUID.randomUUID().toString().replace("-", "").toUpperCase()).append("\0")  // UUID
                    .append("0000").append("\0")                                                       // 거래분류 상세 코드 (GUI는 0000)
                    .append(timestamp.substring(0, 8)).append("\0")                                    // 일자
                    .append(timestamp.substring(8, 20)).append("\0")                                   // 시간
                    .append("GUISYSID").append("\0")                                                   // GUI PSYSTEM_ID
                    .append("GUISYSID").append("\0")                                                   // GUI LSYSTEM_ID
                    .append("000000").append("\0")                                                     // GUI GROUP_ID
                    .append("GUI___").append("\0")                                                     // GUI BP_ID
                    .append("000000").append("\0")                                                     // GUI BM_ID
                    .append(fwkSystemId).append("\0")                                                  // Framework PSYSTEM_ID
                    .append(fwkSystemId).append("\0")                                                  // Framework LSYSTEM_ID
                    .append("000000").append("\0")                                                     // Framework GROUP_ID
                    ;

        // BP07, TH01, TH02 전문의 경우 Process Manager 정보를 입력
        switch (cmdCode)
        {
            // FWK RELOAD 인 경우 MASTER로 처리
            case "FB01":
                ifHeaderInfo.append("MASTER").append("\0");      // Framework BPID
                break;

            case "BG01":
            case "BP01":
            case "BP07":
            case "BP14":
            case "TH01":
            case "TH02":
                ifHeaderInfo.append("PRCMGR").append("\0");      // Framework BPID
                break;

            case "FL01":
            case "FL02":
            case "FL03":
            case "FL04":
            case "FI01":
            case "FI02":
            case "FI03":
            case "FI04":
                ifHeaderInfo.append("FLWMGR").append("\0");       // Framework BPID
                break;

            // 그 외의 경우 HA Manager 정보를 입력
            default:
                ifHeaderInfo.append("HA_MGR").append("\0");       // Framework BPID

                break;
        }

        ifHeaderInfo.append("000000").append("\0");               // Framework BM_ID
        ifHeaderInfo.append(ifBody);

        return ifHeaderInfo;
    }

    // 전문을 송신한다.
    public void sendCommandMessage (StringBuilder ifHeaderInfo) throws IOException
    {
        logger.info("전송 전문 : {}", ifHeaderInfo.toString());

        try
        {
            if ( ifHeaderInfo.length() > 0 )
            {
                outputStream.write(ifHeaderInfo.toString().getBytes());
            }
        }
        catch (Exception e)
        {
            logger.error("전문 전송 오류 발생 : " + ifHeaderInfo.toString());
            throw new IOException("전문 전송 중 오류가 발생하였습니다.");
        }
    }
}