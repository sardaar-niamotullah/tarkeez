import { createClient } from "npm:@supabase/supabase-js@2";
import { SignJWT, importPKCS8 } from "npm:jose@5";

const MONTHS: Record<string, number> = {
  tarkeez_premium_1m: 1,
  tarkeez_premium_3m: 3,
  tarkeez_premium_6m: 6,
  tarkeez_premium_1y: 12,
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });

// Signs in to Google as the service account and returns an access token.
async function googleAccessToken(): Promise<string> {
  const key = JSON.parse(Deno.env.get("GOOGLE_SERVICE_ACCOUNT_JSON")!);
  const now = Math.floor(Date.now() / 1000);
  const assertion = await new SignJWT({
    scope: "https://www.googleapis.com/auth/androidpublisher",
  })
    .setProtectedHeader({ alg: "RS256", typ: "JWT" })
    .setIssuer(key.client_email)
    .setSubject(key.client_email)
    .setAudience("https://oauth2.googleapis.com/token")
    .setIssuedAt(now)
    .setExpirationTime(now + 3600)
    .sign(await importPKCS8(key.private_key, "RS256"));

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion,
    }),
  });
  if (!res.ok) throw new Error(`google token: ${await res.text()}`);
  return (await res.json()).access_token;
}

Deno.serve(async (req) => {
  const admin = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // 1. Who is calling? The user's login token comes with the request.
  const jwt = (req.headers.get("Authorization") ?? "").replace("Bearer ", "");
  const {
    data: { user },
  } = await admin.auth.getUser(jwt);
  if (!user) return json({ error: "not signed in" }, 401);

  // 2. What are they claiming to have bought?
  const { product_id, purchase_token, amount, currency } = await req.json();
  const months = MONTHS[product_id];
  if (!months || !purchase_token) return json({ error: "bad request" }, 400);

  // 3. Ask Google if the token is a real, paid purchase of that product.
  const pkg = Deno.env.get("PLAY_PACKAGE_NAME")!;
  const res = await fetch(
    `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${pkg}/purchases/productsv2/tokens/${encodeURIComponent(purchase_token)}`,
    { headers: { Authorization: `Bearer ${await googleAccessToken()}` } },
  );
  if (!res.ok) {
    console.error("google rejected", res.status, await res.text());
    return json({ error: "google rejected the token" }, 400);
  }
  const purchase = await res.json();
  const paid = purchase.purchaseStateContext?.purchaseState === "PURCHASED";
  const item = purchase.productLineItem?.find(
    (i: { productId: string }) => i.productId === product_id,
  );
  if (!paid || !item) return json({ error: "not a paid purchase" }, 400);

  // 4. Save it and extend premium. A repeated call is ignored by grant_purchase.
  const { data, error } = await admin.rpc("grant_purchase", {
    p_user: user.id,
    p_source: "google",
    p_store_ref: purchase.orderId ?? purchase_token,
    p_amount: Number(amount) || 0,
    p_currency:
      String(currency ?? "")
        .slice(0, 3)
        .toUpperCase() || "USD",
    p_months: months,
    p_paid_at: purchase.purchaseCompletionTime ?? new Date().toISOString(),
  });
  if (error) {
    console.error("grant_purchase", error.message);
    return json({ error: error.message }, 409);
  }

  return json({ premium_until: data });
});
