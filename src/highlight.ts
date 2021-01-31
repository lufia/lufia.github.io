// @ts-ignore /lib/highlight hasn't type definitions.
import hljs from "highlight.js/lib/core";
// @ts-ignore /lib/languages/c hasn't type definitions.
import c from "highlight.js/lib/languages/c";

hljs.registerLanguage("c", c);
export default hljs;
