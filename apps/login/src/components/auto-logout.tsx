"use client";

import { clearSession } from "@/lib/server/session";
import { useRouter } from "next/navigation";
import { useEffect } from "react";
import { Translated } from "@/components/translated";

type Props = {
  sessionId: string;
  postLogoutRedirectUri?: string;
  organization?: string;
};

export function AutoLogout({ sessionId, postLogoutRedirectUri, organization }: Props) {
    const router = useRouter();
    
    useEffect(() => {
        async function performAutoLogout() {
            try {
                await clearSession({ sessionId });

                if (postLogoutRedirectUri) {
                router.push(postLogoutRedirectUri);
                } else {
                const params = new URLSearchParams();
                if (organization) {
                    params.set("organization", organization);
                }
                router.push("/logout/done?" + params.toString());
                }
            } catch (error) {
                console.error("Auto-logout failed:", error);
                // Reload to show session selection UI on error
                router.refresh();
            }
        }

        performAutoLogout();
    }, [sessionId, postLogoutRedirectUri, organization]);

    return (
        <div className="flex flex-col items-center justify-center space-y-4">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
                <p className="text-sm text-muted-foreground">
                    <Translated i18nKey="autoLoggingOut" namespace="logout" />
                </p>
        </div>
    );
}
