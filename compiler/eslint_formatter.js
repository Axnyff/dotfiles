const body = arg => {
  const [data] = arg;
  const { messages, filePath } = data;

  return messages
    .map(
      ({ line, column, message, source }) =>
        `${filePath}: line ${line}, col ${column}, ${message}`
    )
    .join("\n");
};

module.exports = body;
