module.exports = ([result]) => {
	return result.warnings.map( warning => `${result.source} ${warning.line}:${warning.column} ${warning.text}`).join('\n');
}
