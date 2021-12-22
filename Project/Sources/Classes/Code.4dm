Class constructor($name : Text; $lines : Collection)
	
	If ($lines=Null:C1517)
		$lines:=New collection:C1472
	End if 
	
	This:C1470.name:=$name
	This:C1470.lines:=$lines
	
Function add($line : Text)->$this : Object
	
	This:C1470.lines.push(String:C10($line))
	
	$this:=This:C1470
	
Function code()->$code : Text
	
	$code:=This:C1470.lines.join("\r"; ck ignore null or empty:K85:5)
	
Function clear()->$this : Object
	
	This:C1470.lines:=New collection:C1472
	
	$this:=This:C1470
	
Function eval($type : Integer)->$value : Variant
	
	$value:=WA Evaluate JavaScript:C1029(*; This:C1470.name; This:C1470.code(); $type)
	