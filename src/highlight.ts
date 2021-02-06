// @ts-ignore /lib/highlight hasn't type definitions.
import hljs from "highlight.js/lib/core";
// @ts-ignore
import awk from "highlight.js/lib/languages/awk";
// @ts-ignore
import bash from "highlight.js/lib/languages/bash";
// @ts-ignore
import c from "highlight.js/lib/languages/c";
// @ts-ignore
import csharp from "highlight.js/lib/languages/csharp";
// @ts-ignore
import diff from "highlight.js/lib/languages/diff";
// @ts-ignore
import http from "highlight.js/lib/languages/http";
// @ts-ignore
import go from "highlight.js/lib/languages/go";
// @ts-ignore
import ini from "highlight.js/lib/languages/ini";
// @ts-ignore
import javascript from "highlight.js/lib/languages/javascript";
// @ts-ignore
import json from "highlight.js/lib/languages/json";
// @ts-ignore
import makefile from "highlight.js/lib/languages/makefile";
// @ts-ignore
import shell from "highlight.js/lib/languages/shell";
// @ts-ignore
import typescript from "highlight.js/lib/languages/typescript";
// @ts-ignore
import xml from "highlight.js/lib/languages/xml";
// @ts-ignore
import yaml from "highlight.js/lib/languages/yaml";

hljs.registerLanguage("awk", awk);
hljs.registerLanguage("bash", bash);
hljs.registerLanguage("sh", bash);
hljs.registerLanguage("c", c);
hljs.registerLanguage("cs", csharp);
hljs.registerLanguage("diff", diff);
hljs.registerLanguage("go", go);
hljs.registerLanguage("http", http);
hljs.registerLanguage("ini", ini);
hljs.registerLanguage("js", javascript);
hljs.registerLanguage("json", json);
hljs.registerLanguage("ts", typescript);
hljs.registerLanguage("makefile", makefile);
hljs.registerLanguage("console", shell);
hljs.registerLanguage("sh-session", shell);
hljs.registerLanguage("xml", xml);
hljs.registerLanguage("yaml", yaml);
export default hljs;
