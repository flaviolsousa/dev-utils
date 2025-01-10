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

MyMenu := Menu()
MyMenu.Add("To Upper Case", ToUpperCaseMenuHandler)
MyMenu.Add("To Lower Case", ToLowerCaseMenuHandler)
MyMenu.Add()
MyMenu.Add("To camelCase", ToCamelCaseMenuHandler)
MyMenu.Add("To PascalCase", ToPascalCaseMenuHandler)
MyMenu.Add("To snake_case", ToSnakeCaseMenuHandler)
MyMenu.Add("To kebab-case", ToKebabCaseMenuHandler)
MyMenu.Add("To Title Case", ToTitleCaseMenuHandler)
MyMenu.Add("To Sentence case", ToSentenceCaseMenuHandler)
MyMenu.Add("To dot.case", ToDotCaseMenuHandler)
MyMenu.Add()
MyMenu.Add("To NumbersOnly", ToNumbersOnlyMenuHandler)
MyMenu.Add("To UniqueLines", ToUniqueLinesMenuHandler)
MyMenu.Add("To AscendingLines", ToAscendingLinesMenuHandler)
MyMenu.Add("To DescendingLines", ToDescendingLinesMenuHandler)
MyMenu.Add()
MyMenu.Add("To ListNumber", ToListNumberMenuHandler)
MyMenu.Add("To ListVarchar", ToListVarcharMenuHandler)

#f:: MyMenu.Show()