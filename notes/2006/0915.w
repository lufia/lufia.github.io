@include u.i
%title Syleraの設定ファイルを移行する

=Syleraの設定ファイルを移行する
.revision
2006年9月15日作成

アップグレードではなく、別のPC(ユーザ)に設定ファイルをコピーする場合。
C:\Documents and Settings\ユーザ名\Application Data\sylera(以下$syroot)を
単純にコピーすると起動しなくなります。
原因はたぶん以下のどれかまたは全部。

*$syroot\registry.datが違う
*$syroot\Profiles\default\*ID*.sltのIDが違う

とりあえずは、$syroot\Profiles\default\(UID1).slt\に含まれるファイルを
新しいPCの$syroot\Profiles\default\(UID2).slt\にコピーすれば動きます。
移行する前にいちどSyleraを立ち上げておかないと、
新しい環境の(UID2).sltが見つからないかもしれません。
非常にめんどくさい。

@include nav.i
