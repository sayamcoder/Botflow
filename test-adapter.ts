import { SupabaseAdapter } from "@auth/supabase-adapter";
import dotenv from "dotenv";

dotenv.config({ path: ".env" });

async function run() {
  try {
    const adapter = SupabaseAdapter({
      url: process.env.NEXT_PUBLIC_SUPABASE_URL!,
      secret: process.env.SUPABASE_SERVICE_ROLE_KEY!,
    });
    
    console.log("Creating user...");
    const user = await adapter.createUser!({
      id: "test1234",
      name: "Test",
      email: "test2@example.com",
      emailVerified: null,
      image: "https://example.com/image.png",
    });
    
    console.log("Success! Created:", user);
    
  } catch (error) {
    console.error("ADAPTER ERROR:");
    console.error(error);
  }
}

run();
