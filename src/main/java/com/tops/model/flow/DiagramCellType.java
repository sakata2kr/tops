package com.tops.model.flow;

/**
 * Diagram Cell 유형 열거형 상수
 */
public enum DiagramCellType
{
	ENTITY("entity"),
	LINK("link");

	DiagramCellType(String cellType) {
		this.cellType = cellType;
	}

	// Diagram Cell 유형
	private final String cellType;

	// cellType 조회
	public String getCellType() {
		return cellType;
	}

	// Diagram Cell 유형에 해당하는 DiagramCellType enum Instance 반환
	public DiagramCellType getInstance(String cellType)
    {
		for (DiagramCellType diagramCellType : DiagramCellType.values())
		{
			if (diagramCellType.getCellType().equals(cellType))
			{
				return diagramCellType;
			}
		}

		throw new IllegalArgumentException("The DiagramCellType (\"" + cellType + "\") does not exist.");
	}
}