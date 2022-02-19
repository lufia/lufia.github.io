const nextConfig = {
	async rewrites() {
		return [
			{
				source: "/:slug*.html",
				destination: "/:slug*",
			},
		];
	},
};

export default nextConfig;
