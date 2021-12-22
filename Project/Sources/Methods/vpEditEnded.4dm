//%attributes = {"invisible":true}
#DECLARE($sender : Object; $args : Object; $name : Text)->$status : Object

$activeCell:=VP Get active cell($name)
VP SET CELL STYLE($activeCell; New object:C1471("locked"; True:C214))