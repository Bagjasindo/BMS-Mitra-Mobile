import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

Deno.serve(async (req: Request) => {
  try {
    const url = new URL(req.url);
    const token = url.searchParams.get("token") || "";
    if (!/^[a-f0-9]{64}$/i.test(token)) {
      return new Response("Link backup tidak valid.", { status: 400 });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceRole = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, serviceRole, {
      auth: { persistSession: false, autoRefreshToken: false }
    });

    const { data, error } = await supabase.rpc("bms_backup_download_payload", { p_token: token });
    if (error) throw error;
    const row = Array.isArray(data) ? data[0] : null;
    if (!row) return new Response("Link backup sudah kedaluwarsa atau tidak ditemukan.", { status: 404 });

    const fileName = "BMS_BACKUP_" + row.backup_date + ".json";
    const body = JSON.stringify({
      metadata: {
        app: "BMS Mobile",
        backup_date: row.backup_date,
        checksum_sha256: row.checksum,
        expires_at: row.expires_at
      },
      data: row.payload
    }, null, 2);

    return new Response(body, {
      status: 200,
      headers: {
        "content-type": "application/json; charset=utf-8",
        "content-disposition": 'attachment; filename="' + fileName + '"',
        "cache-control": "no-store"
      }
    });
  } catch (e) {
    return new Response("Gagal menyiapkan backup.", { status: 500 });
  }
});
