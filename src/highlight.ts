// @ts-ignore /lib/highlight hasn't type definitions.
import * as hljs from "highlight.js/lib/core";
// @ts-ignore /lib/languages/c hasn't type definitions.
import * as c from "highlight.js/lib/languages/c";

hljs.registerLanguage("c", c);
export default hljs;
