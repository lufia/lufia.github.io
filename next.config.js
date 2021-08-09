// FIXME: update NextJS and remove this workaround.
// https://github.com/vercel/next.js/issues/12212

// FIXME: if we can use next 11.0.2 or later, it supports ESM.
const withTM = require("next-transpile-modules")([
	"react-children-utilities"
]);

module.exports = withTM({
	async rewrites() {
		return [
			{
				source: "/:slug*.html",
				destination: "/:slug*",
			},
		];
	},
});
