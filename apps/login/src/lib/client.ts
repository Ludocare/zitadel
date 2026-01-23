import { completeAuthFlow } from "./server/auth-flow";

type FinishFlowCommand =
  | {
      sessionId: string;
      requestId: string;
    }
  | { loginName: string };

/**
 * Check if a URL is cross-origin relative to the current page
 * @param url - The URL to check
 * @returns true if the URL is cross-origin, false otherwise
 */
export function isCrossOrigin(url: string): boolean {
  try {
    const targetUrl = new URL(url, window.location.origin);
    return targetUrl.origin !== window.location.origin;
  } catch (e) {
    // If URL parsing fails, assume it's a relative URL (same-origin)
    return false;
  }
}

function goToSignedInPage(
  props:
    | { sessionId: string; organization?: string; requestId?: string }
    | { organization?: string; loginName: string; requestId?: string },
) {
  const params = new URLSearchParams({});

  if ("loginName" in props && props.loginName) {
    params.append("loginName", props.loginName);
  }

  if ("sessionId" in props && props.sessionId) {
    params.append("sessionId", props.sessionId);
  }

  if (props.organization) {
    params.append("organization", props.organization);
  }

  // required to show conditional UI for device flow
  if (props.requestId) {
    params.append("requestId", props.requestId);
  }

  return `/signedin?` + params;
}

/**
 * Complete authentication flow or get next URL for navigation
 * - For OIDC/SAML flows with sessionId+requestId: completes flow directly via server action
 * - For device flows: returns URL to signed-in page
 * - For other cases: returns default redirect or fallback URL
 */
export async function completeFlowOrGetUrl(
  command: FinishFlowCommand & { organization?: string },
  defaultRedirectUri?: string,
): Promise<{ redirect: string } | { error: string }> {
  
  // Complete OIDC/SAML flows directly with server action
  if (
    "sessionId" in command &&
    "requestId" in command &&
    (command.requestId.startsWith("saml_") || command.requestId.startsWith("oidc_"))
  ) {
    
    // This completes the flow and returns a redirect URL or error
    const result = await completeAuthFlow({
      sessionId: command.sessionId,
      requestId: command.requestId,
    });
    
    return result;
  }

  
  // For all other cases, return URL for navigation
  const url = await getNextUrl(command, defaultRedirectUri);
  
  const result = { redirect: url };
  
  return result;
}

/**
 * for client: redirects user back to device flow completion, default redirect, or success page
 * Note: OIDC/SAML flows now use completeAuthFlowAction() instead of URL navigation
 * @param command
 * @returns
 */
export async function getNextUrl(
  command: FinishFlowCommand & { organization?: string },
  defaultRedirectUri?: string,
): Promise<string> {
  

  // finish Device Authorization Flow
  if (
    "requestId" in command &&
    command.requestId.startsWith("device_") &&
    ("loginName" in command || "sessionId" in command)
  ) {
    const result = goToSignedInPage({
      ...command,
      organization: command.organization,
    });
    
    return result;
  }

  // OIDC/SAML flows are now handled by completeAuthFlowAction() server action
  // This function only handles device flows and fallback navigation

  if (defaultRedirectUri) {
    
    return defaultRedirectUri;
  }

  const result = goToSignedInPage(command);
  
  return result;
}
