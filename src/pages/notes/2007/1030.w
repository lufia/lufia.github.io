---
title: Sylera APIで新しくタブを開く
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2007年10月30日作成
=Sylera APIで新しくタブを開く

.js
!var url = "...";
!var m = Components.interfaces.nsISyleraAPI;
!var srv = Components.classes["@mozilla.org/sylera-api;1"].getService(m);
!var fd = srv.insertView(url, m.ViewTypeGecko, -1, -1);
!srv.selectView(-1, fd);
