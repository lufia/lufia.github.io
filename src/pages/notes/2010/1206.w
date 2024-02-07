---
title: SproutCoreのGUIデザイン
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2011年2月26日更新
=SproutCoreのGUIデザイン

	=アプリケーションタイトルの変更

	main.jsなどから、document.titleに設定します。

	.js
	!document.title = 'blog'.loc()

	=ビューの作成

	プロジェクトディレクトリに移動して、以下を実行すると、
	views/以下にそのファイルが作成されます。

	.console
	!$ sc-gen view Blog.CategoryView

	でもだいたいmain_page.jsで事足りますので、
	あまり使う機会はないかも。

		=参考

		*[Creating a Simple Custom View|
		http://frozencanuck.wordpress.com/2009/08/16/creating-a-simple-custom-view-in-sproutcore-part2/]

	=ボタン

	.js
	!postView: SC.ButtonView.design({
	!	title: 'post',
	!	isEnabled: YES,
	!	isDefault: YES
	!	target: 'Blog.articleController',
	!	action: 'createArticle'
	!})

	ボタンを押したときに、
	Blog.articleController.createArticle()を実行します。
	アイコンボタンを作る場合はtitleをnullにして、
	iconプロパティに特定の名前を設定します。

	isDefaultをYESにすると、Enterキーを押したときに
	実行されるボタンになります。

	=リスト

	\<SourceListViewとListViewの違い|1206.jpg>

	.js
	!categoriesView: SC.ScrollView.design({
	!	contentView: SC.SourceListView.design({
	!		exampleView: Blog.CategoryView
	!	})
	!})
	!articlesView: SC.ScrollView.design({
	!	contentView: SC.ListView.design({
	!	})
	!})

	上記画像の左側がSourceListViewで、右が普通のListViewです。

	2行で表示する、とか、そういうCSSで対応できないような範囲で
	個々の見た目を変えたければ、SC.ListItemViewを拡張した型を作って、
	SC.ListView#exampleViewに設定します。

		=参考

		*[Creating a Simple Custom List View|
		http://frozencanuck.wordpress.com/2009/09/06/creating-a-simple-custom-list-item-view-part-1/]

	=ドロップダウンメニュー

	.js
	!selectionView: SC.SelectButtonView.design({
	!	title: 'title',
	!	objects: [
	!		{ name: 'PC等', value: 'pc' },
	!		{ name: 'Web製作', value: 'web' }
	!	],
	!	value: 'pc',
	!	theme: 'square',
	!	nameKey: 'name',
	!	valueKey: 'value'
	!})

	nameKeyを省略したときは、objects[[i]].toString()の値を使います。
	同様に、valueKeyを省略したときは、objects[[i]]を使います。

	valueの値がobjectsに含まれていない場合、
	titleの値がボタンのタイトルに使われます。
	このとき、valueの比較は===演算子により行われますので注意です。

	.note
	{
		調べると、SC.SelectViewがSC.SelectButtonViewに代わるようです。
		ですが使ってみると、ドロップダウンから選択すると、
		parentMenuがnullまたはundefinedだというエラーで停止します。
		SproutCoreのメーリングリストで2010年2月頃に[話題に挙がり|
		http://markmail.org/thread/cydb4g23lc35rltx]、
		修正もされているような記述がありましたが、
		SproutCoreの1.4.5でもまだバグが残っている状態です。
	}

	=タブ

	nowShowingをnullにすると、どのタブも選択されていない状態になります。

	.js
	!middle: SC.View.design({
	!	layout: { top: 75, bottom: 115, left: 0, right: 0 },
	!	childViews: 'tab'.w(),
	!
	!	tab: SC.TabView.design({
	!		nowShowing: 'Blog.publicPage.mainView',
	!		items: [
	!			{	title: 'public'.loc(),
	!				value: 'Blog.publicPage.mainView'
	!			},
	!			{	title: 'acquisition'.loc(),
	!				value: 'Blog.privatePage.mainView'
	!			}
	!		],
	!		itemTitleKey: 'title',
	!		itemValueKey: 'value'
	!	})
	!})

	ここで、valueのパスはSC.Pageの名前で、
	それはふつうに書いてもいいですし、sc-genを使ってもいいです。

	.console
	!$ sc-gen design Blog.publicPage

	=並び替え

	まずはSC.Query等のクエリで対応するのが正解かなあと思いますが、
	使えない場合は、SC.ArrayController#orderByが便利かもしれません。

	.js
	!Blog.articlesController = SC.ArrayController.create({
	!	orderBy: 'createdDate DESC, ...'
	!})

	=テーブル

		使う前に、Buildfileへsproutcore/tableを追加しておきます。

		.js
		!required => [:sproutcore, 'sproutcore/table']

		.note
		テーブルもスクロールさせる場合は、
		ListViewと同じようにScrollViewに含めるといいです。

		=フォーマット

		TableViewでフォーマットするには、
		TableColumnのオプションにformatterを渡します。
		これが関数なら、その戻り値をテーブルデータに表示します。
		以下はSC.DateTimeを表示する場合。一部抜粋。

		.js
		!tableView: SC.TableView.design({
		!	columns: [
		!		SC.TableColumn.create({
		!			label: 'created date',
		!			key: 'createdDate',
		!			formatter: function(d){
		!				return d.toFormattedString('%Y/%m/%d')
		!			}
		!		}),
		!		...
		!	],
		!	contentBinding: 'Blog.articlesController.arrangedObjects',
		!	selectionBinding: 'Blog.articlesController.selection',
		!	selectOnMouseDown: YES,
		!	exampleView: SC.TableRowView
		!})

	=多言語対応

	ビューとはちょっと違うかもしれませんが、まあ見た目なので。
	まず言語ファイルを作成するには、以下のようにします。

	.console
	!$ sc-gen language Blog Japanese

	sc-genのヘルプでは、

	.console
	!# エラーが出るよ
	!$ sc-gen language Language

	となっていますが、実際は違うので注意です。いちおう[Wiki|
	http://wiki.sproutcore.com/w/page/12413070/Todos%2008-Localizing]
	では修正されているみたいですが。。

	あとは生成した言語ファイルを修正して、String#locを呼び出すだけです。
	個人的によく使うのは、

	.js
	!'%Y-%m-%d': '%Y/%m/%d'

	と定義しておいて、'%Y-%m-%d'.loc()とか。
	置換パラメータを持っている場合は、

	.js
	!'post failed[code=%@]': '書き込みに失敗しました[コード=%@]'

	で、locに引数を渡します。

	.js
	!throw 'post failed[code=%@]'.loc(statusCode)

	こうしておくと、未対応の言語でも最低限の表示ができますので。

	=ドラッグアンドドロップ(並び替え)

	コントローラと連携して対応するっぽいです。
	まず、コントローラをSC.CollectionViewDelegateで拡張します。

	.js
	!Blog.articlesController = SC.ArrayController.create(
	!	SC.CollectionViewDelegate, {
	!	...
	!})

	次に、View側でcanReorderContentとisEditableをYESに設定します。
	一部抜粋。

	.js
	!articlesView: SC.ScrollView.design({
	!	contentView: SC.ListView.design({
	!		contentBinding: 'Blog.articlesController.arrangedObjects',
	!		selectionBinding: 'Blog.articlesController.selection',
	!		canReorderContent: YES,
	!		isEditable: YES
	!	})
	!})

	こうすると、該当するビュー内で、ドラッグアンドドロップを使った
	並び替えができるようになります。あとは必要に応じて、
	以下の関数を実装すれば終わりです。

	:collectionViewDragDataTypes(view)
	-ドラッグ開始時に実行される
	:collectionViewDragDataForType(view, drag, dataType)
	-上記が成功したとき
	:collectionViewPerformDragOperation(view, drag, op, i, p)
	-ドロップ時に発生

		=参考ページ

		*[Custom ListView with Reordering|
		http://www.veebsbraindump.com/2010/11/sproutcore-tutorial-custom-listview-with-reordering/]

	=ドラッグアンドドロップ(他のリストへドロップ)

	並び替えとは少し違う形になります。

		=ドラッグ対象側のリスト

		.js
		!contentView: SC.ListView.design({
		!	dragDataTypes: [Blog.Article]
		!})

		=ドロップされる側のリスト

		.js
		!contentView: SC.ListView.design({
		!	isDropTarget: YES,
		!	computeDragOperation: function(drag, e){
		!		return SC.DRAG_ANY
		!	},
		!	acceptDragOperation: function(drag, op){
		!		...
		!	}
		!})

	ドロップしたときの動作は、acceptDragOperationに記述します。

	=ドラッグアンドドロップ(他リスト中のアイテムへドロップ)

	ドロップ先となるアイテムのビューをsc-genで新しく作り、
	それをSC.ListItemViewで拡張したものに置き換えます。
	で、他のリストへドロップする場合と同じように、
	作成したリストへプロパティを追加すればいいです。
	以下ではdragEnteredとdragExitedも実装していますが、
	これはあってもなくてもいいです。
	また、performDragOperationでは、thisはドロップ先のアイテムです。

	.js
	!Blog.CategoryView = SC.ListItemView.extend({
	!	isDropTarget: YES,
	!	computeDragOperations: function(drag, e){
	!		return SC.DRAG_ANY
	!	},
	!	acceptDragOperation: function(drag, op){
	!		var ctlr = drag.get('source')
	!		var article = ctlr.get('selection').firstObject()
	!		article.set('category', this.get('content'))
	!		return YES
	!	},
	!	dragEntered: function(drag, e){
	!		this.$().addClass('drop-target')
	!	},
	!	dragExited: function(drag, e){
	!		this.$().removeClass('drop-target')
	!	}
	!});

	最後に、上記で作成したビューを
	ドロップ先のSC.ListView#exampleViewに設定します。

	.js
	!categoriesView: SC.ScrollView.design({
	!	contentView: SC.SourceListView.design({
	!		exampleView: Blog.CategoryView
	!	})
	!})

	=Validator

	詳しく調べていないのでざっくりと。
	validatorはSC.Validatorを拡張して作ります。
	sc-genを使えないので、自分で作らなければいけません。
	とりあえず、main_page.jsの先頭に書くようにしています。

	.js
	!Blog.dateTimeValidator = SC.Validator.extend({
	!	...
	!})

	:validate(form, field): bool
	-変更時に実行される
	-変更時とはchange, submit, partialのこと; partial?
	-違反している場合はfalseを返すように作る
	:validateError(form, field)
	-validate()がfalseの時
	:fieldValueForObject(obj, form, field)
	:objectForFieldValue(value, form, field)
	-いろいろ
	-イメージ的にはkeydownイベントで発生してるっぽい

	ビューへ適用するには、validatorに設定します。

	.js
	!createdDateView: SC.LabelView.design({
	!	validator: Blog.dateTimeValidator.create({...})
	!})

	メールアドレスやクレジットカードなど、一般的なものは
	SC.Validator以下に最初から用意されています。

	*[SC.Validator.Email|
	http://docs.sproutcore.com/symbols/SC.Validator.Email.html]
	*[SC.Validator.Date|
	http://docs.sproutcore.com/symbols/SC.Validator.Date.html]

	=observes式

	ほぼメモ。あとで清書。

	:observes('a')のような名前だけ
	-自分自身のaプロパティが変更されたら通知
	:observes('.a')またはobserves('this.a')
	-同上
	:observes('a.b.c')
	-グローバル変数aのプロパティbから、cが変更されたら通知
	:observes('**a.b')
	-自分自身の、aまたはa.bのどちらかが変更されたら通知
	-おそらく**で開始した場合のみ自分自身を起点とする
	:observes('a.b**c.d')
	-グローバル変数aのプロパティbを起点として、cかc.dに変更があれば通知

	こんなのも書けるっぽい。

	.js
	!function(){}.observes('this')

	=トラブルシューティング

		=selectObjectしても関連データが更新されていない

		SC.ArrayController#selectObjectの直後、
		関連するSC.Bindingが更新されるわけではないようです。

		.js
		!Blog.articleController = SC.ObjectController.create({
		!	contentBinding: SC.Binding
		!		.single('Blog.articlesController.selection')
		!})

		ここで、

		.js
		!Blog.articlesController.selectObject(article)
		!var p = Blog.articleController.get('content')

		pの値は直前に選んでいた記事か、
		選んでいなければnullが設定されます。
		正しく動かすには、invoke系関数を使います。

		.js
		!Blog.articlesController.selectObject(article)
		!Blog.articlesController.invokeLater(function(){
		!	var p = Blog.articleController.get('content')
		!})

		または、自分でSC.RunLoop.beginとSC.RunLoop.endを
		呼び出して処理してもいいのかも。

		=追加や削除してもリストに反映されない

		リレーションを張った状態で、
		多側の内容をコントローラに設定、
		それをリストにバインドしていると、
		ビューの更新がされません。具体的に書くと、

		.js
		!contentBinding: SC.Binding
		!	.single('Blog.categoriesController.selection')
		!	.transform(function(value, binding){
		!		return value ? value.get('articles') : null
		!	})

		ここで、contentはSC.ManyArray型になります。
		この場合は変更が通知されません。
		ちなみに、ビューが更新されないだけで、
		内部のデータは変更されています。

		次に、

		.js
		!contentBinding: SC.Binding
		!	.single('Blog.categoriesController.selection')
		!	.transform(function(value, binding){
		!		var q = SC.Query.local(Blog.Article, 'category = {target}', {
		!			target: value
		!		})
		!		return Blog.store.find(q)
		!	})

		この場合は、contentがSC.RecordArray型になり、
		変更を反映するようになります。

		=変更していないけど変更したことにしたい

		.js
		!obj.propertyDidChange('name')

		enumerableContentDidChangeも気になります。

		=SC.DropTargetがundefined

		SC.DropTargetを拡張してドラッグアンドドロップを実装していると、
		sc-serverで動かすぶんには普通に動くのですが、
		sc-buildして展開した際に、

		>Uncaught SC.Object.extend expects a non-null value.
		>Did you forget to 'sc_require' something?
		>Or were you passing a Protocol to extend() as if it were a mixin?

		というエラーが出るみたいです。
		あきらめてisDropTarget版を作り直してください。

		=SC.SelectButtonViewの表示がvalueの値にならない

		SC.SelectButtonViewの比較は===演算子なので、
		オブジェクトのアドレスが異なれば違うものとして扱われます。

		.js
		!SC.SelectButtonView.design({
		!	objectsBinding: 'Blog.categoriesController.arrangedObjects',
		!	valueBinding: 'Blog.articleController.category',
		!	theme: 'square'
		!})

		これで通常は、valueの値にあわせて切り替わりますが、
		SC.NestedStoreが関係する場合は混乱するかもしれません。
		というのも、オリジナルのオブジェクトとNestedStoreから再取得した
		オブジェクトは異なるアドレスを持つので、
		同じ値は無いというように扱われてしまうのですね。

		なので、割と適当な回避策として、objectsのほうもNestedStoreから
		再取得したものでバインドしてあげると期待通りに動きます。一部抜粋。

		.js
		!SC.SelectButtonView.design({
		!	objectsBinding: 'Blog.altCategoriesController.arrangedObjects'
		!	valueBinding: 'Blog.articleController.category'
		!})

		呼び出す場所では以下のように。

		.js
		!var nstore = Blog.store.chain()
		!var q = SC.Query.local('Blog.Category')
		!Blog.altCategoriesController.set('content', nstore.find(q))
		!Blog.articleController.set('content', nstore.find(article))

		=SC.Validator.Numberのバグ

		Validator.Numberはplacesで小数点以下の桁数を指定できます。

		!validator: SC.Validator.Number.extend({ places: 1 })

		ですが、2011年2月時点でバグがあり、文字が一切入力できません。
		仕方がないのでバグの部分だけを置き換えたものを作ります。

		.js
		!Vacations.DaysValidator = SC.Validator.Number.extend({
		!
		!	places: 1,
		!
		!	objectForFieldValue: function(value, form, field){
		!		switch(SC.typeOf(value)){
		!		case SC.T_STRING:
		!			value = SC.uniJapaneseConvert(value)
		!			value = value.replace(/,/g, '')
		!			if(value.length === 0 || value.match(/^-$/))
		!				value = null
		!			else if(this.get('places') > 0)
		!				value = parseFloat(value)
		!			else
		!				value = parseInt(value, 0)
		!			if(isNaN(value))
		!				value = ''
		!			return value
		!		case SC.T_NULL:
		!		case SC.T_UNDEFINED:
		!		default:
		!			return null
		!		}
		!	},
		!
		!	validateKeyDown: function(form, field, charStr){
		!		var text = field.$input().val()
		!		if(!text)
		!			text = ''
		!		text += charStr
		!		var pass = charStr.length === 0 || charStr === '-' || charStr === '.'
		!		if(this.get('places') === 0){
		!			if(pass)
		!				return true
		!			else{
		!				var a = text.match(/^[\-{0,1}]?[0-9,\0]*/)
		!				return a && a[0] === text
		!			}
		!		}else{
		!			if(pass)
		!				return true
		!			else{
		!				var a = text.match(/^[\-{0,1}]?[0-9,\0]*\.?[0-9\0]+/)
		!				return a && a[0] === text
		!			}
		!		}
		!	}
		!}

		で、これをvalidatorに設定するとうまく動きます。

.aside
{
	*[SproutCoreのモデル定義|1203.w]
}
