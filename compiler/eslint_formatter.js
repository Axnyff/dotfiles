const body = arg => {
  const [data] = arg;
  const { messages, filePath } = data;

  const res = messages
    .map(
      ({ line, column, message, source }) =>
        `${filePath}: line ${line}, col ${column}, ${message}`
    )
    .join("\n");
  return res;
};

module.exports = body;
