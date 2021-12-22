$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		
		
	: ($event.code=On VP Ready:K2:59)
		
/*
シート保護を有効に
セルはデフォルトでロック（編集不可）
*/
		
		VP SET SHEET OPTIONS($event.objectName; New object:C1471("isProtected"; True:C214))
		VP SET DEFAULT STYLE($event.objectName; New object:C1471("locked"; True:C214))
		
/*
		
編集終了イベントで再びロックする
		
*/
		
		custom_event($event.objectName)
		
	: ($event.code=On Double Clicked:K2:5)
		
		CONFIRM:C162("編集する？"; "はい"; "いいえ")
		
		If (OK=1)
			
/*
			
一時的にロックを解除する
			
*/
			
			$activeCell:=VP Get active cell($event.objectName)
			VP SET CELL STYLE($activeCell; New object:C1471("locked"; False:C215))
			
/*
			
設定の変更を反映させる
			
*/
			
			VP FLUSH COMMANDS($event.objectName)
			
/*
			
JavaScriptでアクティブシートを編集モードに
			
*/
			
			start_edit($event.objectName)
			
		End if 
		
End case 