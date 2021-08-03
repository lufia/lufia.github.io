// FIXME: update NextJS and remove this workaround.
// https://github.com/vercel/next.js/issues/12212
module.exports = {
	async rewrites() {
		return [
			{
				source: "/:slug*.html",
				destination: "/:slug*",
			},
		];
	},
};
