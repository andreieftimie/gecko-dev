; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this file,
; You can obtain one at http://mozilla.org/MPL/2.0/.
;
; Author(s):        Cosmin Malutan <cosmin.malutan@softvision.ro>
;                   Andrei Eftimie <andrei.eftimie@softvision.ro>
; AutoIt Version:   3.3.10.2

; This variable stands for setting the default application
Global $setDefault = False
; Number times we click "down" until we successfully
; set our default, it will increment with each failure
Global $l = 0
Global $httpsIndex
Global $httpsElement
; Is name of application which we will set as default.
Global $default
Global $error = False

; If there are two parameter given then one is the target
; default application and one the file where we save the
; name of the current default if $setDefault is False we
; will read the value from the file otherwise we will
; assign the value of $setDefault
If $cmdline[0] = 2 Then
  $setDefault = $cmdline[1]
  $fileLocation = $cmdline[2]
ElseIf $cmdline[0] = 1 Then
  $fileLocation = $cmdline[1]
Else
  Exit(1)
EndIf

; Open the "Set Associations" under the control panel
Run("control /name Microsoft.DefaultPrograms /page pageFileAssoc")

; Wait for Control Panel and then focus it
Local $hControlPanel = WinWait("[TITLE:Set Associations; CLASS:CabinetWClass]")
WinActivate($hControlPanel)

; If we don't have $setDefault argument then we should fallback
; on restoring the previous default
If $setDefault Then
  $default = GetTextValue("HTTPS")
  $file = FileOpen($fileLocation, 2)
  FileWrite($file, $default)
  FileClose($file)
  $default = $setDefault
Else
  $default = FileRead($fileLocation)
  If $default = "" Then
    $error = True
    CleanUp()
  EndIf
EndIf

; Keep trying to set the default until the $httpElemet will have
; the value of the $default
While Not (GetTextValue("HTTPS") = $default)
  ; He re we increment the length so we take the next option next time
  If $l >= 4 Then ; After four tries we exit the loop
    $error = True
    ExitLoop
  EndIf

  $httpsIndex = WaitForElement("HTTPS")
  $httpsElement = ControlListView($hControlPanel, "", "SysListView321", "Select", $httpsIndex)
  ControlFocus($hControlPanel, "", $httpsElement)
  ControlClick($hControlPanel, "", "[CLASS:Button; INSTANCE:1]")

  Sleep(1000)
  Local $i = 0
  While $i < $l
    Send("{DOWN}")
    Sleep(500)
    $i = $i + 1
  WEnd
  Send("{ENTER}")

  $l = $l + 1
WEnd

CleanUp()


Func WaitForElement($aElement)
  Local $returnValue = -1
  Local $counter = 0
  Do
    ControlGetHandle($hControlPanel, "", "SysListView321")
    $counter += 1
    If $counter = 10 Then
      $counter = 0
      ExitLoop
    EndIf

    If @error = 1 Then
      Sleep(5000)
    EndIf
  Until @error <> 1
  $counter = 0
  Do
    Sleep(2500)
    $returnValue = ControlListView($hControlPanel, "", "SysListView321", "FindItem", $aElement)
    $counter += 1
    If $counter = 10 Then
      $counter = 0
      ExitLoop
    EndIf

  Until @error <> 1 And $returnValue <> -1

  Return $returnValue
EndFunc

Func GetTextValue($aElement)
  Return ControlListView($hControlPanel, "", "SysListView321", "GetText", WaitForElement($aElement), 2)
EndFunc

Func Cleanup()
  ; Close the Control Panel
  WinClose($hControlPanel)

  If $error == True Then
    Exit(1)
 Else

  EndIf
EndFunc
