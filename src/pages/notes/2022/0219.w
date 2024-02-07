---
title: Windowsに移植されたplan9port
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2022年2月19日作成
=Windowsに移植されたplan9port

Windows用にplan9portを移植しているプロジェクトがいくつかある。

:[pf9|https://github.com/knieriem/pf9]
-A port of some libraries and programs from Plan9 from User Space to Win32
:[ansic|https://github.com/caerwynj/ansic]
-ANSI C tools derived from UNIX, Plan9, and Inferno OS for compilation with MinGW on Windows OS
:[pm9|https://github.com/kaveman-/9pm]
-archived sources of a Windows port of some of the plan9 utilities as found on the Bell Labs server

手元では試したことがないので正確なところは分からないが、
更新停止していたり、ビルドがエラーになるなど、どれも問題を持っているようなので、
WSL2またはMSYS2(MinGW)などでplan9portそのものをビルドすると良いかもしれない。
