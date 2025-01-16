## Classic ASP JWT

A JWT implementation in Classic ASP, currently only supports `JWTEncode(dictionary, secret)`.

### Usage

```asp
<!--#include file="jwt.asp" -->
<%
Dim sKey, dAttributes, sToken

sKey = "Shared Secret"
Set dAttributes=Server.CreateObject("Scripting.Dictionary")

' The UniqueString and SecsSinceEpoch functions are provided by this implementation
dAttributes.Add "jti", UniqueString
dAttributes.Add "iat", SecsSinceEpoch
dAttributes.Add "name", "Roger"
dAttributes.Add "email", "roger@example.com"

' nested dictionary
set dNestedAttribute=Server.CreateObject("Scripting.Dictionary")
dNestedAttribute.Add "street", "21 2nd Street"
dNestedAttribute.Add "city", "New York"
dNestedAttribute.Add "state", "NY"
dNestedAttribute.Add "postalCode", "10221"
dAttributes.Add "address", dNestedAttribute

sToken = JWTEncode(dAttributes, sKey)
%>
```

### License

The depdendencies in the `external` folder are subject to their respective licenses as noted in the files. This license only pertains to the other files in this repository.

Copyright 2013 Zendesk

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
