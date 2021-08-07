import type { AppProps } from "next/app";
import "../styles.css";
import hljs from "../highlight";

if(process.browser)
	hljs.initHighlightingOnLoad();

function App({ Component, pageProps }: AppProps) {
	return <Component {...pageProps} />;
}

export default App;
