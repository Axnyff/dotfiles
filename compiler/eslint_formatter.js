const body = (files) => {
  const { messages, filePath } = data;

  return files.flatMap(({ messages, filePath }) =>
    messages
      .map(
        ({ line, column, message, source }) =>
          `${filePath}: line ${line}, col ${column}, ${message}`
      )
      .join("\n")
  );
};

module.exports = body;
