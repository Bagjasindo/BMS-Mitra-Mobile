import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2.57.4";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS"
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405, headers: { ...corsHeaders, "Content-Type": "application/json" } });

  try {
    const authHeader = req.headers.get("Authorization") || "";
    if (!authHeader.startsWith("Bearer ")) throw new Error("Sesi login tidak ditemukan");

    const url = Deno.env.get("SUPABASE_URL")!;
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY") || JSON.parse(Deno.env.get("SUPABASE_PUBLISHABLE_KEYS") || "{}")["default"];
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || JSON.parse(Deno.env.get("SUPABASE_SECRET_KEYS") || "{}")["default"];
    if (!anonKey || !serviceKey) throw new Error("Konfigurasi server tidak lengkap");

    const userClient = createClient(url, anonKey, { global: { headers: { Authorization: authHeader } } });
    const token = authHeader.slice(7);
    const { data: userData, error: userError } = await userClient.auth.getUser(token);
    if (userError || !userData.user) throw new Error("Sesi tidak valid");

    const { data: caller, error: callerError } = await userClient
      .from("profiles")
      .select("role,active")
      .eq("user_id", userData.user.id)
      .single();
    if (callerError || !caller || caller.role !== "ADMIN" || !caller.active) throw new Error("Akses hanya untuk Administrator");

    const body = await req.json();
    const name = String(body?.name || "").trim();
    const email = String(body?.email || "").trim().toLowerCase();
    const role = String(body?.role || "").trim();
    const password = String(body?.password || "");
    const roles = ["ADMIN","LOGISTIK","PPL","MARKETING","KEUANGAN","OWNER"];

    if (!name || !email || !role || !password) throw new Error("Nama, email, role, dan password wajib diisi");
    if (!roles.includes(role)) throw new Error("Role tidak valid");
    if (password.length < 8) throw new Error("Password minimal 8 karakter");

    const admin = createClient(url, serviceKey, { auth: { autoRefreshToken: false, persistSession: false } });
    const { data: created, error: createError } = await admin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { full_name: name }
    });
    if (createError || !created.user) throw new Error(createError?.message || "Gagal membuat akun");

    const { error: profileError } = await admin.from("profiles").insert({
      user_id: created.user.id,
      full_name: name,
      role,
      active: true
    });

    if (profileError) {
      await admin.auth.admin.deleteUser(created.user.id);
      throw new Error(profileError.message);
    }

    return new Response(JSON.stringify({ ok: true, user_id: created.user.id, email }), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" }
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: e instanceof Error ? e.message : String(e) }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" }
    });
  }
});
