package com.tops.model.operation;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.tops.model.BaseObject;

/**
 * Online Process 트리 노드
 */
public class ProcessInfoTreeNode extends BaseObject
{
    public static final String ROOT_KEY   = "ROOT"; /** Root 노드의 키   */
    public static final int    ROOT_DEPTH = 0;      /** Root 노드의 깊이 */

    private int    depth;
    private String key;
    private String parent_key;
    private String title;
    private String type;
    private int    status_priority;
    private String status;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String grp_ctg_cd1;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String grp_ctg_cd2;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String group_id;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String lsystem_id;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String psystem_id;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String bp_group;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String bp_id;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String bm_id;

    /** 부모 노드 */
    @JsonBackReference
    private ProcessInfoTreeNode parent;

    /** 자식 노드 리스트 */
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private List<ProcessInfoTreeNode> children;

    public int getDepth ()
    {
        return depth;
    }

    public void setDepth (int depth)
    {
        this.depth = depth;
    }

    public String getKey ()
    {
        return key;
    }

    public void setKey (String key)
    {
        this.key = key;
    }

    public String getParent_key ()
    {
        return parent_key;
    }

    public void setParent_key (String parent_key)
    {
        this.parent_key = parent_key;
    }

    public String getTitle ()
    {
        return title;
    }

    public void setTitle (String title)
    {
        this.title = title;
    }

    public String getType ()
    {
        return type;
    }

    public void setType (String type)
    {
        this.type = type;
    }

    public int getStatus_priority ()
    {
        return status_priority;
    }

    public void setStatus_priority (int status_priority)
    {
        this.status_priority = status_priority;
    }

    public String getStatus ()
    {
        return status;
    }

    public void setStatus (String status)
    {
        this.status = status;
    }

    public String getGrp_ctg_cd1()
    {
        return grp_ctg_cd1;
    }

    public void setGrp_ctg_cd1(String grp_ctg_cd1)
    {
        this.grp_ctg_cd1 = grp_ctg_cd1;
    }

    public String getGrp_ctg_cd2()
    {
        return grp_ctg_cd2;
    }

    public void setGrp_ctg_cd2(String grp_ctg_cd2)
    {
        this.grp_ctg_cd2 = grp_ctg_cd2;
    }

    public String getGroup_id ()
    {
        return group_id;
    }

    public void setGroup_id (String group_id)
    {
        this.group_id = group_id;
    }

    public String getLsystem_id ()
    {
        return lsystem_id;
    }

    public void setLsystem_id (String lsystem_id)
    {
        this.lsystem_id = lsystem_id;
    }

    public String getPsystem_id ()
    {
        return psystem_id;
    }

    public void setPsystem_id (String psystem_id)
    {
        this.psystem_id = psystem_id;
    }

    public String getBp_group ()
    {
        return bp_group;
    }

    public void setBp_group (String bp_group)
    {
        this.bp_group = bp_group;
    }

    public String getBp_id ()
    {
        return bp_id;
    }

    public void setBp_id (String bp_id)
    {
        this.bp_id = bp_id;
    }

    public String getBm_id ()
    {
        return bm_id;
    }

    public void setBm_id (String bm_id)
    {
        this.bm_id = bm_id;
    }

    public ProcessInfoTreeNode getParent()
    {
        return parent;
    }

    public void setParent(ProcessInfoTreeNode parent)
    {
        this.parent = parent;
    }

    public List<ProcessInfoTreeNode> getChildren()
    {
        return children;
    }

    public void setChildren(List<ProcessInfoTreeNode> children)
    {
        this.children = children;
    }

    /**
     * 하위 Node를 추가
     */
    public void addChild(ProcessInfoTreeNode node)
    {
        if ( node == null ) return;

        if ( this.children == null )
        {
            this.children = new ArrayList<ProcessInfoTreeNode>();
        }

        int    priority = 0;  // 상태코드 우선순위
        String status   = ""; // 상태코드

        boolean notExists = true; // 해당 Node의 하위 Node 존재 여부

        for ( ProcessInfoTreeNode treeNode : this.children )
        {
            // 최우선 순위 상태를 찾는다.
            if ( treeNode.getStatus_priority() >= priority )
            {
            	priority = treeNode.getStatus_priority();
                status = treeNode.getStatus();
            }

            // 하위 Node 정보의 Key값이 조회 대상 Node의 Key값과 동일한 경우
            if ( treeNode.getKey().equals(node.getKey()) )
            {
                notExists = false;
            }
        }

         // 하위 Node 정보가 존재하는 경우
        if ( notExists )
        {
            // 하위 Node 추가
            this.children.add(node);

            // 가장 PRIORITY가 낮은 값(최우선 순위)를 찾아 매핑
            if ( node.getStatus_priority() >= priority )
            {
            	priority = node.getStatus_priority();
                status = node.getStatus();
            }
        }

        // 자식 노드 중 우선순위가 가장 높은 것의 '상태 코드'로 설정한다.
        this.status_priority = priority;
        this.status = status;
    }

    /**
     * 하위 Node 정보를 갱신
     *
     */
    public void updateChild(ProcessInfoTreeNode node)
    {
        if ( node == null || this.children == null ) return;

        int    priority = 0;  // 상태코드 우선순위
        String status   = ""; // 상태코드

        for ( ProcessInfoTreeNode treeNode : this.children )
        {
            // Key가 일치하는 하위 Node 정보 갱신
            if ( treeNode.getKey().equals(node.getKey()) )
            {
                treeNode.setTitle(node.getTitle());
                treeNode.setStatus_priority(node.getStatus_priority());
                treeNode.setStatus(node.getStatus());
            }

            // 가장 PRIORITY가 낮은 값(최우선 순위)를 찾아 매핑
            if ( treeNode.getStatus_priority() >= priority )
            {
            	priority = treeNode.getStatus_priority();
                status = treeNode.getStatus();
            }
        }

        // 하위 Node의 상태값 중 가장 높은 값으로 상위 Node를 갱신
        this.status_priority = priority;
        this.status = status;
    }
}