![version](https://img.shields.io/badge/version-19%2B-5682DF)

# 4d-tips-view-pro-double-click
4D View Proエリアのダブルクリックイベントをカスタマイズする例題

#### 参考記事

* [endEdit Method](https://www.grapecity.com/spreadjs/docs/v14/online/SpreadJS~GC.Spread.Sheets.Worksheet~endEdit.html)
* [Edit Mode Always](https://www.grapecity.com/spreadjs/docs/v14/online/editmode.html)
* [Use Click Events](https://www.grapecity.com/spreadjs/docs/v14/online/sceventclick.html)

#### 前提

4D View Proエリアのフォームイベントは，SpreadJSの`bind()`で実装されています。

```
Components/4D ViewPro.4dbase/Resources/scripts/utils.js 
```

たとえば*On Double Clicked*イベントは，`CellDoubleClick`イベントにバインドされています。

```js
Utils.spread.bind(GC.Spread.Sheets.Events.CellDoubleClick, function (event, data) {
    if (data.sheetArea === GC.Spread.Sheets.SheetArea.viewport) {
        let obj = prepareEvent(data);
        makeRange(obj);
        delete obj.sheetArea;
        Utils.send4DEvent("OnDoubleClick", obj);
    }
});
```

このイベントはセル・ヘッダー・コーナー上のダブルクリック操作で発生します。このとき，アクティブセルがロックされておらず，編集が許可されていれば，`EditStarting`イベントも発生します。ただし，両イベントは順番に発生するわけではないようです。つまり，ダブルクリックイベントが完了した後に編集開始イベントが発生するという決まりはありません。したがって，ダブルクリックイベント単体を処理するためには，セルの編集を全面的に禁止する必要があります。その後，セルの編集を開始する場合，ロックを解除し，編集を開始し，編集の終了と同時に再びセルの編集を全面的に禁止することになります。

#### 解説

シート保護を有効にした上ですべてのセルを編集不可に設定します。

```4d
VP SET SHEET OPTIONS($event.objectName; New object("isProtected"; True))
VP SET DEFAULT STYLE($event.objectName; New object("locked"; True))
```

編集終了イベントでアクティブセルが再びロックされるよう，カスタムイベントをバインドします。

`Code`クラスのソースは[4d-tips-view-pro-to-html](https://github.com/4D-JP/4d-tips-view-pro-to-html)を参照

```4d
#DECLARE($name : Text)->$value : Variant

var $code : cs.Code

$code:=cs.Code.new($name)

$code.add("(function(){")

$code.add("    let spread = Utils.spread;")
$code.add("    let activeSheet = spread.getActiveSheet();")

$code.add("    let events = GC.Spread.Sheets.Events")

$code.add("    activeSheet.bind(events.EditEnded, function (sender, args) {")
$code.add("        $4d.vpEditEnded(sender, args, '"+$name+"', function(e){")
$code.add("        });")
$code.add("    });")

$code.add("}())")

$value:=$code.eval(Is text)
```

ダブルクリックイベントで一時的にアクティブセルの編集を許可します。

```4d
$activeCell:=VP Get active cell($event.objectName)
VP SET CELL STYLE($activeCell; New object("locked"; False))
VP FLUSH COMMANDS($event.objectName)
```

JavaScriptでアクティブシートを編集モードにします。

```js
#DECLARE($name : Text)->$value : Variant

var $code : cs.Code

$code:=cs.Code.new($name)

$code.add("(function(){")

$code.add("    let spread = Utils.spread;")
$code.add("    let activeSheet = spread.getActiveSheet();")
$code.add("    activeSheet.startEdit(false);")

$code.add("}())")

$value:=$code.eval(Is text)
```
