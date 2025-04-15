; AutoHotkey2

Copy()
{
  A_Clipboard := ""
  Sleep 100
  Send "^c"
  ClipWait
}

Paste()
{
  Sleep 100
  Send "^v"
}

RunWaitOne(command) {
  shell := ComObject("WScript.Shell")
  exec := shell.Exec(A_ComSpec " /C " command)
  return exec.StdOut.ReadAll()
}

IsProcessRunning(ProcessName) {
  OutputVar := RunWaitOne("tasklist | find /I `"" ProcessName "`"")
  return InStr(OutputVar, ProcessName)
}

#t:: WinSetAlwaysOnTop -1, "A"

#+f::
{
  Copy()
  url := "https://www.google.com/search?q=" . A_Clipboard
  run(url)
  Paste()
}

ToUpperCaseMenuHandler(Item, *)
{
  Copy()
  text := StrUpper(A_Clipboard)
  A_Clipboard := text
  Paste()
}

ToLowerCaseMenuHandler(Item, *)
{
  Copy()
  text := StrLower(A_Clipboard)
  A_Clipboard := text
  Paste()
}

ToListNumberMenuHandler(Item, *)
{
  Copy()
  text := StrReplace(A_Clipboard, "`r`n", ", ")
  text := StrReplace(text, "`n", ", ")
  A_Clipboard := text
  Paste()
}

ToListVarcharMenuHandler(Item, *)
{
  Copy()
  text := StrReplace(A_Clipboard, "`r`n", "', '")
  text := StrReplace(text, "`n", "', '")
  text := "'" . text . "'"
  A_Clipboard := text
  Paste()
}

ToList999NumberMenuHandler(Item, *)
{
  Copy()
  text := A_Clipboard
  text := StrReplace(text, "`r`n", "`n")
  items := StrSplit(text, "`n")

  result := ""
  block := ""
  count := 0
  for index, item in items
  {
    if (block = "")
      block := item
    else
      block .= ", " . item

    count++
    if (count = 999)
    {
      if (result != "")
        result .= "`n"
      result .= block
      block := ""
      count := 0
    }
  }
  if (block != "")
  {
    if (result != "")
      result .= "`n"
    result .= block
  }

  A_Clipboard := result
  Paste()
}

ToList999VarcharMenuHandler(Item, *)
{
  Copy()
  text := A_Clipboard
  text := StrReplace(text, "`r`n", "`n")
  items := StrSplit(text, "`n")

  result := ""
  block := ""
  count := 0
  for index, item in items
  {
    if (block = "")
      block := item
    else
      block .= "', '" . item

    count++
    if (count = 999)
    {
      if (result != "")
        result .= "`n"
      result .= "'" . block . "'"
      block := ""
      count := 0
    }
  }
  if (block != "")
  {
    if (result != "")
      result .= "`n"
    result .= "'" . block . "'"
  }

  A_Clipboard := result
  Paste()
}

ToSnakeCaseMenuHandler(Item, *)
{
  Copy()
  text := RegExReplace(A_Clipboard, "[^a-zA-Z0-9`r`n]", "_")
  text := RegExReplace(text, "([a-z0-9])([A-Z])", "$1_$2")
  text := RegExReplace(text, "_+_", "_")
  text := RegExReplace(text, "^_+|_+$", "")
  A_Clipboard := text
  Paste()
}

ToCamelCaseMenuHandler(Item, *)
{
  Copy()
  text := RegExReplace(A_Clipboard, "[^a-zA-Z0-9`r`n]", "_")
  text := RegExReplace(text, "([a-z0-9])([A-Z])", "$1_$2")
  text := StrLower(text)
  words := StrSplit(text, ["_", A_Space, A_Tab])
  if (words.Length > 0) {
    text := words[1]
    Loop words.Length - 1
    {
      index := A_Index + 1
      text .= StrUpper(SubStr(words[index], 1, 1)) . SubStr(words[index], 2)
    }
  }
  A_Clipboard := text
  Paste()
}

ToPascalCaseMenuHandler(Item, *)
{
  Copy()
  text := RegExReplace(A_Clipboard, "[^a-zA-Z0-9`r`n]", "_")
  text := RegExReplace(text, "([a-z0-9])([A-Z])", "$1_$2")
  text := StrLower(text)
  words := StrSplit(text, ["_", A_Space, A_Tab])
  if (words.Length > 0) {
    text := words[1]
    Loop words.Length - 1
    {
      index := A_Index + 1
      text .= StrUpper(SubStr(words[index], 1, 1)) . SubStr(words[index], 2)
    }
  }
  text := RegExReplace(text, "\b(\w)", "$U1")
  A_Clipboard := text
  Paste()
}

ToNumbersOnlyMenuHandler(Item, *)
{
  Copy()
  text := RegExReplace(A_Clipboard, "[^0-9`r`n]")
  A_Clipboard := text
  Paste()
}

ToKebabCaseMenuHandler(Item, *)
{
  Copy()
  ; Convert clipboard text to kebab-case
  text := StrLower(A_Clipboard)
  text := RegExReplace(text, "[^a-zA-Z0-9`r`n]+", "-") ; Replace spaces with hyphens
  text := RegExReplace(text, "[^a-zA-Z0-9\-]", "") ; Remove non-alphanumeric characters except hyphens
  A_Clipboard := text
  Paste()
}

ToTitleCaseMenuHandler(Item, *)
{
  Copy()
  ; Convert clipboard text to Title Case
  text := StrLower(A_Clipboard)
  text := RegExReplace(text, "\b(\w)", "$U1") ; Capitalize first letter of each word
  A_Clipboard := text
  Paste()
}

ToSentenceCaseMenuHandler(Item, *)
{
  Copy()
  ; Convert clipboard text to Sentence case
  text := StrLower(A_Clipboard)
  text := RegExReplace(text, "[^a-zA-Z0-9`r`n]+", " ")
  text := RegExReplace(text, "^\s*\w", "$U0") ; Capitalize the first character of the first word
  A_Clipboard := text
  Paste()
}

ToDotCaseMenuHandler(Item, *)
{
  Copy()
  ; Convert clipboard text to dot.case
  text := StrLower(A_Clipboard)
  text := RegExReplace(text, "[^a-zA-Z0-9`r`n]+", ".") ; Replace spaces with dots
  ; text := RegExReplace(text, "[^a-zA-Z0-9\.]", "") ; Remove non-alphanumeric characters except dots
  A_Clipboard := text
  Paste()
}

ToUniqueLinesMenuHandler(Item, *)
{
  Copy()
  lines := StrSplit(A_Clipboard, "`n", "`r")
  uniqueLines := Map()
  for line in lines
  {
    line := Trim(line)
    if (line != "")
      uniqueLines[line] := true
  }
  A_Clipboard := ""
  for line in uniqueLines
  {
    A_Clipboard .= line "`r`n"
  }
  A_Clipboard := Trim(A_Clipboard, "`r`n")
  Paste()
}

ToCountDuplicateLinesMenuHandler(Item, *)
{
  Copy()
  lines := StrSplit(A_Clipboard, "`n", "`r")
  lineCounts := Map()

  for line in lines
  {
    line := Trim(line)
    if (line != "")
    {
      if lineCounts.Has(line)
        lineCounts[line] += 1
      else
        lineCounts[line] := 1
    }
  }

  A_Clipboard := ""
  for line, count in lineCounts
  {
    if (count > 1)
      A_Clipboard .= count " => " line "`r`n"
  }

  A_Clipboard := Trim(A_Clipboard, "`r`n")
  Paste()
}

ToAscendingLinesMenuHandler(Item, *)
{
  Copy()
  A_Clipboard := Sort(A_Clipboard)
  Paste()
}

ToDescendingLinesMenuHandler(Item, *)
{
  Copy()
  A_Clipboard := Sort(A_Clipboard, "R")
  Paste()
}

ToBase64EncodeMenuHandler(Item, *)
{
  Copy()
  text := A_Clipboard
  text := StrReplace(text, "`r`n", "`n")
  items := StrSplit(text, "`n")

  result := ""
  for index, item in items
  {
    if (item = "") {
      result .= "`n"
      continue
    }
    ; Encode item as UTF-8
    buf := Buffer(StrPut(item, "UTF-8"))
    StrPut(item, buf, "UTF-8")
    ; Prepare output buffer for base64
    DllCall("Crypt32.dll\CryptBinaryToString"
      , "Ptr", buf.Ptr
      , "UInt", buf.Size
      , "UInt", 0x1 ; CRYPT_STRING_BASE64
      , "Ptr", 0
      , "UInt*", &outLen := 0)
    outBuf := Buffer(outLen << 1, 0)
    DllCall("Crypt32.dll\CryptBinaryToString"
      , "Ptr", buf.Ptr
      , "UInt", buf.Size
      , "UInt", 0x1
      , "Ptr", outBuf.Ptr
      , "UInt*", outLen)
    base64 := StrReplace(StrGet(outBuf), "`r`n", "")
    result .= base64 . "`n"
  }
  ; Remove trailing newline if present
  if (SubStr(result, -1) = "`n")
    result := SubStr(result, 1, -1)
  A_Clipboard := result
  Paste()
}

ToBase64DecodeMenuHandler(Item, *)
{
  Copy()
  text := A_Clipboard
  text := StrReplace(text, "`r`n", "`n")
  items := StrSplit(text, "`n")

  result := ""
  for index, item in items
  {
    if (item = "") {
      result .= "`n"
      continue
    }
    ; Descobrir tamanho do buffer decodificado
    DllCall("Crypt32.dll\CryptStringToBinary"
      , "Str", item
      , "UInt", 0
      , "UInt", 0x1 ; CRYPT_STRING_BASE64
      , "Ptr", 0
      , "UInt*", &binLen := 0
      , "Ptr", 0
      , "Ptr", 0)
    if (binLen = 0) {
      result .= "`n"
      continue
    }
    binBuf := Buffer(binLen, 0)
    DllCall("Crypt32.dll\CryptStringToBinary"
      , "Str", item
      , "UInt", 0
      , "UInt", 0x1
      , "Ptr", binBuf.Ptr
      , "UInt*", binLen
      , "Ptr", 0
      , "Ptr", 0)
    ; Converter binário para string UTF-8
    decoded := StrGet(binBuf, "UTF-8")
    result .= decoded . "`n"
  }
  ; Remove trailing newline if present
  if (SubStr(result, -1) = "`n")
    result := SubStr(result, 1, -1)
  A_Clipboard := result
  Paste()
}

MyMenu := Menu()
CaseMenu := Menu()
CaseMenu.Add("To Upper Case", ToUpperCaseMenuHandler)
CaseMenu.Add("To Lower Case", ToLowerCaseMenuHandler)
CaseMenu.Add()
CaseMenu.Add("To camelCase", ToCamelCaseMenuHandler)
CaseMenu.Add("To PascalCase", ToPascalCaseMenuHandler)
CaseMenu.Add("To snake_case", ToSnakeCaseMenuHandler)
CaseMenu.Add("To kebab-case", ToKebabCaseMenuHandler)
CaseMenu.Add("To Title Case", ToTitleCaseMenuHandler)
CaseMenu.Add("To Sentence case", ToSentenceCaseMenuHandler)
CaseMenu.Add("To dot.case", ToDotCaseMenuHandler)
MyMenu.Add("Case", CaseMenu)
MyMenu.Add()
MyMenu.Add("To Numbers Only", ToNumbersOnlyMenuHandler)
MyMenu.Add("To Unique Lines", ToUniqueLinesMenuHandler)
MyMenu.Add("To Count Duplicate Lines", ToCountDuplicateLinesMenuHandler)
SortMenu := Menu()
SortMenu.Add("Ascending", ToAscendingLinesMenuHandler)
SortMenu.Add("Descending", ToDescendingLinesMenuHandler)
MyMenu.Add("Sort Lines", SortMenu)
CreateListMenu := Menu()
CreateListMenu.Add("To ListNumber", ToListNumberMenuHandler)
CreateListMenu.Add("To ListVarchar", ToListVarcharMenuHandler)
CreateListMenu.Add("To List999Number", ToList999NumberMenuHandler)
CreateListMenu.Add("To List999Varchar", ToList999VarcharMenuHandler)
MyMenu.Add("Create List", CreateListMenu)
Base64Menu := Menu()
Base64Menu.Add("Encode", ToBase64EncodeMenuHandler)
Base64Menu.Add("Decode", ToBase64DecodeMenuHandler)
MyMenu.Add("Base64", Base64Menu)

#f:: MyMenu.Show()
