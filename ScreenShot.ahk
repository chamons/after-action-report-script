#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

InputBox, folder, Name of Folder, What do you want to name the run as?

FileCreateDir, %folder%

#Include GDIP_All.ahk

pToken := Gdip_Startup()


+F3::
    output := A_ScriptDir . "\" . folder

    ; Find image filename
    offset = 0
    Loop
    {
        candidate := output . "\" . offset . ".png"
        IfNotExist, %candidate%
            break
        offset += 1
    }

    ; Take a Screenshot
    snap := Gdip_BitmapFromScreen()
    
    image_path := output . "\" . offset . ".png"
    text_path  := output . "\" . offset . ".txt"

    Gdip_SaveBitmapToFile(snap, image_path)
    Gdip_DisposeImage(snap)

    ; Get text modal
    Gui, Add, Text,, What is going on here?:
    Gui, Add, Edit, w600 h400 vinput
    Gui, Add, Button, gokay_pressed, &Okay
    Gui, Add, Button, cancel X+8 YP+0, &Cancel
    Gui, Show, Center autosize, Screenshot Story
    return


okay_pressed:
  Gui Submit
  Gui Destroy
  FileAppend, %input%, %text_path%
  Return

GuiClose:
GuiEscape:
ButtonCancel:
  Gui, Destroy
  return