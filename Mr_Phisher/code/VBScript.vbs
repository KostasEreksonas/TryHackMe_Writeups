Rem Attribute VBA_ModuleType=VBAModule
Option VBASupport 1

Sub Format()

Dim a()

Dim b As String

a = Array(102, 109, 99, 100, 127, 100, 53, 62, 105, 57, 61, 106, 62, 62, 55, 110, 113, 114, 118, 39, 36, 118, 47, 35, 32, 125, 34, 46, 46, 124, 43, 124, 25, 71, 26, 71, 21, 88)

For i = 0 To UBound(a)

b = b & Chr(a(i) Xor i)

Next

End Sub
