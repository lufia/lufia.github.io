---
title: Firefox AutoConfig
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2021年11月14日作成
=Firefox AutoConfig

	Firefoxにはユーザーが任意のコードを実行できるAutoConfigという仕様があります。

	=AutoConfigを有効にする
	AutoConfigはFirefoxをインストールしたディレクトリ(ArchLinuxの場合は*/usr/lib/firefox*)以下の*defaults/pref/autoconifg.js*に

	.js
	!pref("general.config.filename", "autoconfig.cfg");

	という設定を入れておくと、*autoconfig.cfg*に書いた任意のJavaScriptを
	起動時に実行できるというものです。
	相対パスの場合、Firefoxをインストールしたディレクトリからのパスとして扱われます。

	*[Customizing Firefox Using AutoConfig|
	https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig]

	=キーボードショートカットがどのように実装されているか
	Firefoxの外観、タブなどはXHTMLファイルで定義されています。
	具体的には*browser.xhtml*というファイルですが、
	これは*omni.ja*にまとめられているので展開してみましょう。

	.console
	!$ cp /usr/lib/firefox/browser/omni.ja .
	!$ unzip omni.ja
	!$ vi chrome/browser/content/browser/browser.xhtml

	ファイルの中には、各種ショートカットキーや履歴バーの開閉処理などが定義されています。
	以下の定義は履歴サイドバーをトグルするショートカットです。

	.html
	!<key id="key_gotoHistory"
	!     data-l10n-id="history-sidebar-shortcut"
	!     modifiers="accel"
	!     oncommand="SidebarUI.toggle('viewHistorySidebar');"/>

	`modifier="accel"`は、*about:config*で

	!ui.key.accelKey=17(Ctrl)

	に設定されたキー(デフォルトではCtrl)を押した状態を表現します。

	似たようなキーとして

	!ui.key.menuAccessKey=18(Alt)
	!ui.key.menuAccessKeyFocuses=true
	!ui.key.generalAccessKey=-1
	!ui.key.chromeAccessKey=4(Alt)
	!ui.key.contentAccessKey=5(Shift+Alt)

	などが定義されていますが、これらはそれぞれ

	:ui.key.menuAccessKey
	-Firefoxのメニューを選択するときのキーコード
	:ui.key.menuAccessKeyFocuses
	-menuAccessKey単体でメニューを開いたままにするかどうか
	:[ui.key.generalAccessKey|http://kb.mozillazine.org/Ui.key.generalAccessKey]
	-accesskey要素にアクセスするときのキー
	-値が`-1`の場合は以下の2つが有効になる
	:[ui.key.chromeAccessKey|http://kb.mozillazine.org/Ui.key.chromeAccess]
	-Chrome(Firefoxのコンテンツ表示部分以外を指す)のaccesskey要素にアクセスするときのキー
	:[ui.key.contentAccessKey|http://kb.mozillazine.org/Ui.key.contentAccess]
	-Contentのaccesskey要素にアクセスするときのキー

	の目的で利用されるもので、どれも0を設定するとキーが無効になります。

	*[XULがWeb Componentsになったね|
	https://cat-in-136.github.io/2020/02/xul-has-been-ported-to-web-components.html]

	=Ctrl+Hを無効にする

	Ctrl+Hをバックスペースとして使っている癖で、履歴サイドバーが開閉してしまって
	不愉快だったので無効にしようと試みた記録です。結局は

	.console
	!$ gsettings set org.gnome.desktop.interface gtk-key-theme Emacs

	が正解だったのですが、一応メモとして残しておきます。

	まずは*/usr/lib/firefox/defaults/pref/autoconifg.js*でAutoConfigを有効にします。
	ここで*sandbox_enabled*を`false`にしておかないと動作しないので注意です。

	.js
	!pref("general.config.filename", "autoconfig.cfg");
	!pref("general.config.vendor", "autoconfig");
	!pref("general.config.obscure_value", 0);
	!pref("general.config.sandbox_enabled", false);

	次に*general.config.filename*で指定したファイルを作成します。
	最初の1行目はコメントが必須です。

	.js
	!// disable ugly shortcut keys
	!try {
	!  let { classes, interfaces, manager } = Components;
	!  const { Services } = Components.utils.import('resource://gre/modules/Services.jsm');
	!  function ConfigJS() {
	!    Services.obs.addObserver(this, 'chrome-document-global-created', false);
	!  };
	!  ConfigJS.prototype = {
	!    observe: function(subject) {
	!      subject.addEventListener('DOMContentLoaded', this, { once: true });
	!    },
	!    handleEvent: function(e) {
	!      let document = e.originalTarget;
	!      let window = document.defaultView;
	!      let location = window.location;
	!      if(/^(chrome:(?!\/\/(global\/content\/commonDialog|browser\/content\/webext-panels)\.x?html)|about:(?!blank))/i.test(location.href)) {
	!        if(window._gBrowser){
	!          let ctlh = window.document.getElementById('key_gotoHistory');
	!          ctlh.remove();
	!        }
	!      }
	!    }
	!  };
	!  if(!Services.appinfo.inSafeMode)
	!    new ConfigJS();
	!}catch(e){
	!  displayError(e);
	!}

	これでFirefoxを再起動すれば、Ctrl+Hを押してもサイドバーは開閉しなくなります。
