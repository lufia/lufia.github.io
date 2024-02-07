---
title: ArchLinuxのPythonでpkg_resourcesモジュールが見つからない
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2022年2月9日作成
=ArchLinuxのPythonでpkg_resourcesモジュールが見つからない

ArchLinuxで`awslogs`を実行したとき以下のエラーが発生した。

.console
!$ awslogs
!Traceback (most recent call last):
!  File "/usr/bin/awslogs", line 33, in <module>
!    sys.exit(load_entry_point('awslogs==0.14.0', 'console_scripts', 'awslogs')())
!  File "/usr/bin/awslogs", line 25, in importlib_load_entry_point
!    return next(matches).load()
!  File "/usr/lib/python3.10/importlib/metadata/__init__.py", line 162, in load
!    module = import_module(match.group('module'))
!  File "/usr/lib/python3.10/importlib/__init__.py", line 126, in import_module
!    return _bootstrap._gcd_import(name[level:], package, level)
!  File "<frozen importlib._bootstrap>", line 1050, in _gcd_import
!  File "<frozen importlib._bootstrap>", line 1027, in _find_and_load
!  File "<frozen importlib._bootstrap>", line 992, in _find_and_load_unlocked
!  File "<frozen importlib._bootstrap>", line 241, in _call_with_frames_removed
!  File "<frozen importlib._bootstrap>", line 1050, in _gcd_import
!  File "<frozen importlib._bootstrap>", line 1027, in _find_and_load
!  File "<frozen importlib._bootstrap>", line 1006, in _find_and_load_unlocked
!  File "<frozen importlib._bootstrap>", line 688, in _load_unlocked
!  File "<frozen importlib._bootstrap_external>", line 883, in exec_module
!  File "<frozen importlib._bootstrap>", line 241, in _call_with_frames_removed
!  File "/usr/lib/python3.10/site-packages/awslogs/__init__.py", line 1, in <module>
!    from ._version import __version__  # noqa
!  File "/usr/lib/python3.10/site-packages/awslogs/_version.py", line 1, in <module>
!    from pkg_resources import get_distribution
!ModuleNotFoundError: No module named 'pkg_resources'

どうやら`pkg_resources`は*python-setuptools*に含まれているようだけど、
これは*awslogs*パッケージの`makedepends`とされているので、
パッケージの掃除をしたときに消してしまったらしい。

なので解消するには、*python-setuptools*パッケージをインストールすればよい。

.console
!$ sudo pacman -S --asdeps python-setuptools
