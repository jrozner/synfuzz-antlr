grammar antlr4;

root:
	GRAMMAR_SYM (UPPER_ID | LOWER_ID) SEMI (
		parser_rule
		| lexer_rule
		| fragment_rule
	)* EOF;

parser_name: LOWER_ID;

parser_rule: parser_name COLON parser_body? SEMI;

parser_body:
	(
		(
			lexer_name
			| parser_name
			| STRING_LITERAL
			| LEFT_PAREN parser_body RIGHT_PAREN
		) (PLUS | STAR | QUESTION_MARK)*
	)+ label? (PIPE parser_body label?)*;

label: HASH (UPPER_ID | LOWER_ID);

lexer_name: UPPER_ID;

lexer_rule: lexer_name COLON lexer_body lexer_command? SEMI;

lexer_body:
	(
		TILDE? (
			lexer_name
			| STRING_LITERAL
			| STRING_LITERAL DOT_RANGE STRING_LITERAL
			| LEFT_PAREN lexer_body RIGHT_PAREN
			| DOT
			| CHARACTER_CLASS
		) (PLUS | STAR | QUESTION_MARK)*
	)+ (PIPE lexer_body)*;

lexer_command: ARROW commands (COMMA commands)*;

commands:
	SKIP_SYM
	| MORE_SYM
	| POPMODE_SYM
	| (MODE_SYM | PUSHMODE_SYM | TYPE_SYM | CHANNEL) LEFT_PAREN (
		UPPER_ID
		| LOWER_ID
	) RIGHT_PAREN;

fragment_name: UPPER_ID;

fragment_rule: FRAGMENT_SYM fragment_name COLON lexer_body SEMI;

SEMI: ';';
PLUS: '+';
STAR: '*';
COLON: ':';
HASH: '#';
PIPE: '|';
COMMA: ',';
LEFT_PAREN: '(';
RIGHT_PAREN: ')';
QUESTION_MARK: '?';
ARROW: '->';
TILDE: '~';
HYPHEN: '-';
DOT_RANGE: '..';
DOT: '.';
IMPORT_SYM: 'import';
FRAGMENT_SYM: 'fragment';
LEXER_SYM: 'lexer';
PARSER_SYM: 'parser';
GRAMMAR_SYM: 'grammar';
RETURNS_SYM: 'returns';
LOCALS_SYM: 'locals';
THROWS_SYM: 'throws';
CATCH_SYM: 'catch';
FINALLY_SYM: 'finally';
MODE_SYM: 'mode';
OPTIONS_SYM: 'options';
TOKENS_SYM: 'tokens';
SKIP_SYM: 'skip';
MORE_SYM: 'more';
POPMODE_SYM: 'popmode';
PUSHMODE_SYM: 'pushMode';
TYPE_SYM: 'type';
CHANNEL: 'channel';

MULTILINE_COMMENT: '/*' .*? '*/' -> skip;
SINGLELINE_COMMENT: '//' ~[\r\n]* -> skip;

CHARACTER_CLASS: '[' ('\\]' | ~']')* ']';

STRING_LITERAL: '\'' ('\\\'' | ~['])* '\'';

LOWER_ID: [a-z][a-zA-Z0-9_]*;
UPPER_ID: [A-Z][a-zA-Z0-9_]*;

WS: [ \r\n\t] -> skip;
