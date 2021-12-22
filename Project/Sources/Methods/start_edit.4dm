//%attributes = {"invisible":true}
#DECLARE($name : Text)->$value : Variant

var $code : cs:C1710.Code

$code:=cs:C1710.Code.new($name)

$code.add("(function(){")

$code.add("    let spread = Utils.spread;")
$code.add("    let activeSheet = spread.getActiveSheet();")
$code.add("    activeSheet.startEdit(false);")

$code.add("}())")

$value:=$code.eval(Is text:K8:3)