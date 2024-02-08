---
title: Arch Linuxで最新のAWS CLI v2をインストールする
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2022年6月13日作成
=Arch Linuxで最新のAWS CLI v2をインストールする

AWS CloudWatchのログをみるとき、今まではAURの*awslogs*を使っていたけど、
6/10頃から`pacman -Syu`したときに以下のエラーで失敗するようになった。

.console
!$ sudo pacman -Syu
!:: Synchronizing package databases...
!core is up to date
!extra is up to date
!community is up to date
!:: Starting full system upgrade...
!resolving dependencies...
!looking for conflicting packages...
!error: failed to prepare transaction (could not satisfy dependencies)
!:: installing python-jmespath (1.0.0-1) breaks dependency 'python-jmespath<1.0.0' required by awslogs

AWS CLI v2にある`aws logs tail`コマンドで*awslogs*相当のことが行えるらしいが、
Arch LinuxのCommunityパッケージにある*aws-cli*はv1で、
AURにある*aws-cli-v2*はバージョンが古く、どちらも要件を満たせない。

*[aws-cli|https://www.archlinux.jp/packages/community/any/aws-cli/]
*[aws-cli-v2|https://aur.archlinux.org/packages/aws-cli-v2]

次に、[AWS CLI v2をpipからインストールしてみた|
https://dev.classmethod.jp/articles/install-aws-cli-v2-from-sourcecode/]を参考に`pip`で試すと、
2022年時点では*botocore*の*v2*ブランチに動きがなく、
Cのソースファイルをビルドするところでエラーになったので諦めた。

仕方がないのでバイナリパッケージを入れる。

.console
!# 古いコマンドは消しておく
!$ sudo pacman -Rs awslogs aws-cli
!
!$ curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
!$ unzip awscliv2.zip
!$ ./aws/install -i ~/pkg/aws -b ~/bin

これで、Arch Linuxの標準では*~/.local/bin*に`aws`コマンドがインストールされる。
アップデートする場合は、新しいインストーラをダウンロードして`install -u`するといいらしい。

これを調べている時に知ったけど、今は`python -mpip`とするらしい。
また、GitHubのURLを渡すと直接インストールできる。

.console
!$ python -m pip install git+https://github.com/aws/aws-cli.git@v2
!
!# アーカイブの場合はこれ
!$ python -m pip install https://github.com/aws/aws-cli/archive/v2.tar.gz
