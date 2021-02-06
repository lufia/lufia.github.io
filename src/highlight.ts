// @ts-ignore /lib/highlight hasn't type definitions.
import hljs from "highlight.js/lib/core";
// @ts-ignore
import awk from "highlight.js/lib/languages/awk";
// @ts-ignore
import bash from "highlight.js/lib/languages/bash";
// @ts-ignore
import c from "highlight.js/lib/languages/c";
// @ts-ignore
import diff from "highlight.js/lib/languages/diff";
// @ts-ignore
import ini from "highlight.js/lib/languages/ini";
// @ts-ignore
import shell from "highlight.js/lib/languages/shell";

hljs.registerLanguage("awk", awk);
hljs.registerLanguage("bash", bash);
hljs.registerLanguage("sh", bash);
hljs.registerLanguage("c", c);
hljs.registerLanguage("diff", diff);
hljs.registerLanguage("ini", ini);
hljs.registerLanguage("console", shell);
hljs.registerLanguage("sh-session", shell);
export default hljs;
