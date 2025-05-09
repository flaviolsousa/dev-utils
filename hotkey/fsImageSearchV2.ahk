;e := vPosX := vPosY := 0
;fsImageSearch(A_ScriptDir . "\imagemProcurada.png", &e, &vPosX, &vPosY, 500)
;fsImageSearch(A_ScriptDir . "\imagemProcurada.png", &e, &vPosX, &vPosY, 500, 5)
;fsImageSearch(A_ScriptDir . "\imagemProcurada.png", &e, &vPosX, &vPosY, 500, 5, true, true)

global tooltipFsImageSearchAtivado := 1
; CoordMode "Pixel"

fsImageSearch(pathImagem, &status, &posX := 0, &posY := 0, searchInterval := 100, maxSearchCount := -1, errorIfNotFound := true, searchSequencial := false, X1 := 0, Y1 := 0, X2 := A_ScreenWidth, Y2 := A_ScreenHeight) {
	if X2 = -1
		X2 := A_ScreenWidth
	if Y2 = -1
		Y2 := A_ScreenHeight
	
	searchCount := 0
	imgFound := false
	while not imgFound and searchCount != maxSearchCount {
		if not searchSequencial {
			if tooltipFsImageSearchAtivado = 1
				ToolTip("Searching image: " pathImagem)
			statusSearch := ImageSearch(&posX, &posY, X1, Y1, X2, Y2, pathImagem)
			if (statusSearch)
				imgFound := true
		} else {
			vIndex := 1
			nextFile := RegExReplace(pathImagem, "(.*)\.(\w\w\w\w?)", "$1" vIndex ".$2")
			Loop {
				if tooltipFsImageSearchAtivado = 1
					ToolTip("Searching image: " nextFile)
				statusSearch := ImageSearch(&posX, &posY, X1, Y1, X2, Y2, nextFile)
				if (statusSearch)
					imgFound := true
				vIndex := vIndex + 1
				nextFile := RegExReplace(pathImagem, "(.*)\.(\w\w\w\w?)", "$1" vIndex ".$2")
			} Until imgFound or not FileExist(nextFile)
		}
		if not imgFound {
			searchCount := searchCount + 1
			if tooltipFsImageSearchAtivado = 1
				ToolTip("Not found. Wait for new search (" searchCount " | " maxSearchCount ")")
			Sleep(searchInterval)			
		}
	}
	
	if tooltipFsImageSearchAtivado = 1
		ToolTip("")
	
	status := imgFound

	if errorIfNotFound and not imgFound and not posX {
		msgErro := "Image not found: " pathImagem
		MsgBox(msgErro)
		throw Error("Image not found!")
	}
}
