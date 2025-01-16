<!--#include file="external/base64.asp"-->
<!--#include file="external/aspJSON.asp"-->
<%
' The URL- and filename-safe Base64 encoding described in RFC 4648 [RFC4648], Section 5,
' with the (non URL-safe) '=' padding characters omitted, as permitted by Section 3.2.
' (See Appendix C of [JWS] for notes on implementing base64url encoding without padding.)
' http://tools.ietf.org/html/rfc4648
' http://tools.ietf.org/html/draft-ietf-jose-json-web-signature-10
Function SafeBase64Encode(sIn)
  sOut = Base64Encode(sIn)
  sOut = Base64ToSafeBase64(sOut)

  SafeBase64Encode = sOut
End Function

' Strips unsafe characters from a Base64 encoded string
Function Base64ToSafeBase64(sIn)
  sOut = Replace(sIn,"+","-")
  sOut = Replace(sOut,"/","_")
  sOut = Replace(sOut,"\r","")
  sOut = Replace(sOut,"\n","")
  sOut = Replace(sOut,"=","")

  Base64ToSafeBase64 = sOut
End Function

Function DictionaryToJSON(dict)
  Dim json, key, value
  json = "{"
  For Each key In dict.Keys
    If IsObject(dict(key)) Then
      ' If the value is a nested dictionary, recursively call the function
      json = json & """" & key & """: " & DictionaryToJSON(dict(key)) & ","
    ElseIf IsNumeric(dict(key)) Then
      ' If the dict(key) is numeric, add it without quotes
      json = json & """" & key & """: " & dict(key) & ","
    Else
      ' If the dict(key) is a string, add it with quotes
      json = json & """" & key & """: """ & dict(key) & ""","
    End If
  Next
  ' Remove the trailing comma and close the JSON object
  If Right(json, 1) = "," Then
    json = Left(json, Len(json) - 1)
  End If
  json = json & "}"
  DictionaryToJSON = json
End Function

' Converts an ASP dictionary to a JSON string
Function DictionaryToJSONString(dDictionary)
  Set oJSONpayload = New aspJSON

  
  Dim i, aKeys
  aKeys = dDictionary.keys
  
  For i = 0 to dDictionary.Count-1
    oJSONpayload.data (aKeys(i))= dDictionary(aKeys(i))
  Next

  DictionaryToJSONString = oJSONpayload.JSONoutput()
End Function

Function dtmAdjusted_date()
  Dim dtmDateValue, dtmAdjusted
  Dim objShell, lngBiasKey, lngBias, k

  dtmDateValue = Now()

  ' Obtain local Time Zone bias from machine registry.
  Set objShell = CreateObject("Wscript.Shell")
  lngBiasKey = objShell.RegRead("HKLM\System\CurrentControlSet\Control\" _
      & "TimeZoneInformation\ActiveTimeBias")
  If (UCase(TypeName(lngBiasKey)) = "LONG") Then
      lngBias = lngBiasKey
  ElseIf (UCase(TypeName(lngBiasKey)) = "VARIANT()") Then
      lngBias = 0
      For k = 0 To UBound(lngBiasKey)
          lngBias = lngBias + (lngBiasKey(k) * 256^k)
      Next
  End If

  ' Convert datetime value to UTC.
  dtmAdjusted = DateAdd("n", lngBias, dtmDateValue)
  dtmAdjusted_date = dtmAdjusted

End Function


' Returns the number of seconds since epoch
Function SecsSinceEpoch()
  SecsSinceEpoch = DateDiff("s", "01/01/1970 00:00:00", dtmAdjusted_date())
End Function

' Returns a random string to prevent replays
Function UniqueString()
  Set TypeLib = CreateObject("Scriptlet.TypeLib")
    UniqueString = Left(CStr(TypeLib.Guid), 38)
    Set TypeLib = Nothing
End Function


%>
