import { ParserOptions } from "htmlparser2";
import { ReactElement } from "react";

export class Parser {
	constructor(options?: ParserOptions);

	parse(html: string): readonly ReactElement[];
}
