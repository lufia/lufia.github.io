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
