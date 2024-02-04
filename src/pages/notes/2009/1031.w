@include u.i
%title AmaTunesツール

.revision
2009年10月31日作成
=AmaTunesツール

	1行に1つISBNを記述したファイルから、[AmaTunes|
	http://blogger.splhack.org/2007/10/amatunes.html]に
	取り込むためのプログラムです。

	これはずいぶん前に[Books for Mac OS X|
	http://journal.mycom.co.jp/news/2008/09/19/021/index.html]の
	データを移行させようとして作ったのですが、
	AmaTunes自体、数回しか使いませんでしたので、
	なんらかのバグが残っているのではないかと思います。

	!COCOA_APP_RESOURCES_DIR = File.dirname(File.expand_path(__FILE__))
	!resource_path = COCOA_APP_RESOURCES_DIR
	!
	!$LOAD_PATH.reject! { |d| d.index(File.dirname(COCOA_APP_RESOURCES_DIR))!=0 }
	!$LOAD_PATH << File.join(COCOA_APP_RESOURCES_DIR,"ThirdParty")
	!$LOAD_PATH << File.join(File.dirname(COCOA_APP_RESOURCES_DIR),"lib")
	!$LOAD_PATH << File.join(COCOA_APP_RESOURCES_DIR,"RubyGems","gems","rb-appscript-0.4.0","lib")
	!$LOAD_PATH << File.join(COCOA_APP_RESOURCES_DIR,"RubyGems","gems","hpricot-0.6","lib")
	!$LOAD_PATH << File.join(COCOA_APP_RESOURCES_DIR,"RubyGems","gems","hpricot-0.6","ext","hpricot_scan")
	!
	!$LOADED_FEATURES << "rubycocoa.bundle"
	!
	!ENV['GEM_HOME'] = ENV['GEM_PATH'] = File.join(COCOA_APP_RESOURCES_DIR,"RubyGems")
	!
	!#require 'rubygems'
	!#require 'osx/cocoa'
	!require 'appscript'
	!require 'open-uri'
	!require 'fileutils'
	!$KCODE='u'
	!
	!require resource_path + '/ecs.rb'
	!$faac_path = resource_path + "/../MacOS/lib"
	!
	!def conv_year(str)
	!	str =~ /^(\d\d\d\d).*/
	!	$1
	!end
	!
	!def conv_artwork(str)
	!	filename = "/tmp/amatunes.artwork"
	!	@tmpfiles.push filename
	!	f = File.open(filename, "wb")
	!	f.write open(str).read
	!	f.close
	!	filename
	!end
	!
	!class MyBarcodeScannerDelegate
	!	def initialize
	!		@barcodes = Hash.new
	!		@lastcode = nil
	!	end
	!	def gotBarcode(barcode)
	!		barcode = barcode.to_s
	!		barcode = '0' + barcode if barcode.size == 12
	!		sum = 0
	!		mod = 1
	!		barcode.reverse.each_byte do |c|
	!			n = c - '0'[0]
	!			sum += n * mod 
	!			if mod == 1
	!				mod = 3
	!			else
	!				mod = 1
	!			end
	!		end
	!		sum %= 10
	!		return unless sum == 0
	!		return if @lastcode == barcode
	!		@lastcode = barcode
	!		if @barcodes[barcode].nil?
	!			Amazon::Ecs.options = {
	!				:aWS_access_key_id => '1N37DT5CJCZQKPZR7BG2',
	!				:country => 'jp',
	!			}
	!			res = Amazon::Ecs.item_search(barcode, {:response_group => 'Medium'})
	!			item = res.first_item
	!			return if item.nil?
	!
	!			@tmpfiles = Array.new
	!			option = ""
	!			[
	!				["artist", "author"],
	!				["album", "title"],
	!				["title", "title"],
	!				["writer", "manufacturer"],
	!				["cover-art", "largeimage/url", :conv_artwork],
	!				["year", "publicationdate", :conv_year],
	!				["genre", "productgroup"],
	!			].each do |o|
	!				str = item.get(o[1]) 
	!				next if str.nil?
	!				option += ' --' + o[0] + ' "' +
	!					(o[2].nil? ? str : send(o[2], str)) + '"'
	!			end
	!			begin
	!				m4b = "/tmp/#{barcode}.m4b"
	!				@tmpfiles.push m4b
	!				system "#{$faac_path}/faac128 #{option} -o #{m4b} #{$faac_path}/base.wav"
	!
	!				app = Appscript.app('iTunes')
	!				app.activate
	!				app.open MacTypes::Alias.path(m4b)
	!				app.stop
	!
	!				#@tmpfiles.each {|file| FileUtils.rm file}
	!				@barcodes[barcode] = item
	!
	!				$snd.play
	!			rescue
	!			end
	!		end
	!	end
	!end
	!
	!while(s = gets)
	!	d = MyBarcodeScannerDelegate.new()
	!	d.gotBarcode(s.to_i)
	!end

	=遭遇したトラブル
		=require osx/cocoaが通らない
		使わない方向で逃げました。

		=ThirdParty/open-uri.rb:require stringioが通らない
		相対パスだと、reject!のマッチングで問題があったので、
		絶対パスに変換するよう修正して解決。

		=faacが落ちる
		AmaTunesに付属のfaacは、/opt/local/以下から
		ライブラリをロードしようとして落ちていました。
		そこで、faacをコンパイルして、そちらを使いました。

		.console
		!$ ./configure --disable-shared
		!$ make
		!$ mv frontend/faac $dir

@include nav.i
