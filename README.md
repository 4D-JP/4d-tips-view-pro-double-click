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

このイベントはセル・ヘッダー・コーナー上のダブルクリック操作で発生します。このとき，アクティブセルがロックされておらず，編集が許可されていれば，`EditStarting`イベントも発生します。ただし，両イベントは順番に発生するわけではないようです。つまり，ダブルクリックイベントが完了した後に編集開始イベントが発生するという決まりはありません。
