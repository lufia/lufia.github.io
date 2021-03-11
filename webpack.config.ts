import path from "path";
import autoprefixer from "autoprefixer";
import nested from "postcss-nested";

export default {
	mode: "production",
	entry: "./src/index.ts",
	output: {
		path: path.resolve(process.cwd(), "lib"),
		publicPath: "/lib/",
		filename: "bundle.js"
	},
	module: {
		rules: [
			{
				test: /\.ts$/,
				loader: "ts-loader"
			},
			{
				test: /\.css$/,
				use: [
					"style-loader",
					"css-loader",
					{
						loader: "postcss-loader",
						options: {
							postcssOptions: {
								plugins: [
									autoprefixer,
									nested,
									// no @types
									require("postcss-mixins")
								]
							}
						}
					}
				]
			}
		]
	},
	resolve: {
		extensions: [".ts", ".js"]
	},
	devServer: {
		inline: true,
		contentBase: path.join(__dirname, "docs"),
		compress: true,
		port: 9000
	}
}
