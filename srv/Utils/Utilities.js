const transformEmailItems = (items) =>
  items.flatMap(({ mailid, subject }) => {
    // extract local‐part of the email address
    const localPart = mailid.split("@")[0];

    // split the subject string on ';' (will yield one‐element array if no ';')
    return subject.split(";").map((token) => [
      { element: "isRead",        operand: "equals",   value: "unread" },
      { element: "hasAttachment", operand: "equals",   value: "true" },
      { element: "senderName",    operand: "contains", value: localPart },
      { element: "subject",       operand: "contains", value: token.trim() }
    ]);
  });

module.exports = {
      transformEmailItems
  }