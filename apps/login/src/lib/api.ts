import { newSystemToken } from "@zitadel/client/node";

export async function systemAPIToken() {
  const privateKey = process.env.SYSTEM_USER_PRIVATE_KEY;
  const audience = process.env.AUDIENCE;
  const userID = process.env.SYSTEM_USER_ID;
  
  if (!privateKey) {
    throw new Error("SYSTEM_USER_PRIVATE_KEY environment variable is not set");
  }
  
  if (!audience) {
    throw new Error("AUDIENCE environment variable is not set");
  }
  
  if (!userID) {
    throw new Error("SYSTEM_USER_ID environment variable is not set");
  }

  const token = {
    audience,
    userID,
    token: Buffer.from(privateKey, "base64").toString("utf-8"),
  };

  return newSystemToken({
    audience: token.audience,
    subject: token.userID,
    key: token.token,
  });
}
