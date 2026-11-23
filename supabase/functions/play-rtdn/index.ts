// supabase functions deploy play-rtdn --no-verify-jwt
import { createClient } from "npm:@supabase/supabase-js@2";
import { createRemoteJWKSet, jwtVerify } from "npm:jose@5";

const googleKeys = createRemoteJWKSet(
  new URL("https://www.googleapis.com/oauth2/v3/certs"),
);

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });

// Pub/Sub signs every push with the service account chosen on the subscription.
async function isFromPubSub(req: Request): Promise<boolean> {
  const token = (req.headers.get("Authorization") ?? "").replace("Bearer ", "");
  if (!token) return false;
  try {
    const { payload } = await jwtVerify(token, googleKeys, {
      issuer: ["https://accounts.google.com", "accounts.google.com"],
      audience: Deno.env.get("PUBSUB_AUDIENCE")!,
    });
    return (
      payload.email === Deno.env.get("PUBSUB_SERVICE_ACCOUNT") &&
      payload.email_verified === true
    );
  } catch {
    return false;
  }
}

Deno.serve(async (req) => {
  if (!(await isFromPubSub(req))) return json({ error: "unauthorized" }, 401);

  // Pub/Sub wraps the Google Play notification: { message: { data: <base64 json> } }
  const body = await req.json().catch(() => null);
  const data = body?.message?.data;
  if (!data) return json({ ok: true });

  let note;
  try {
    note = JSON.parse(atob(data));
  } catch {
    return json({ ok: true }); // unreadable, retrying will not help
  }

  // Test notifications, other apps and other event types are acknowledged and ignored.
  const voided = note.voidedPurchaseNotification;
  if (note.packageName !== Deno.env.get("PLAY_PACKAGE_NAME") || !voided) {
    return json({ ok: true });
  }
  if (voided.productType !== 1) return json({ ok: true }); // 1 = one-time product

  const admin = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // verify-purchase saves the purchase under the order id (or the token when there is no order id).
  for (const ref of [voided.orderId, voided.purchaseToken]) {
    if (!ref) continue;
    const { error } = await admin.rpc("refund_purchase", {
      p_source: "google",
      p_store_ref: ref,
    });
    if (error) {
      console.error("refund_purchase", error.message);
      return json({ error: error.message }, 500); // Pub/Sub retries
    }
  }

  return json({ ok: true });
});
