import * as path from "path";

export default {
	mode: "development",
	entry: "./src/index.ts",
	output: {
		path: path.resolve(process.cwd(), "lib"),
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
					"postcss-loader"
				]
			}
		]
	},
	resolve: {
		extensions: [".ts", ".js"]
	}
}
