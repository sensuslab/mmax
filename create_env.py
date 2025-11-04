#!/usr/bin/env python3
"""
Helper script to create backend/.env file with your API keys.
This script will create the .env file in the backend directory.
"""
import os
import base64
import secrets

def generate_encryption_key():
    """Generate a secure base64-encoded encryption key."""
    key_bytes = secrets.token_bytes(32)
    return base64.b64encode(key_bytes).decode("utf-8")

def create_env_file():
    """Create the backend/.env file with provided credentials."""
    
    env_content = """# Environment Mode
# Valid values: local, staging, production
ENV_MODE=local

##### DATABASE (REQUIRED)
SUPABASE_URL=https://db.rtwcwwfpwahnpdeggoku.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0d2N3d2Zwd2FobnBkZWdnb2t1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIxMzMwODYsImV4cCI6MjA3NzcwOTA4Nn0.6y7Xuh2mESxbEFoQOjNOrLf0Fa3bRsmKbSxltC848w0
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0d2N3d2Zwd2FobnBkZWdnb2t1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MjEzMzA4NiwiZXhwIjoyMDc3NzA5MDg2fQ.x2NQvkNroeuU0T9A_Ln434sgZA0ORsX2Dc8d0SG-fJY

##### REDIS
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_SSL=false

##### LLM PROVIDERS (At least one is functionally REQUIRED)
ANTHROPIC_API_KEY=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
OPENAI_API_KEY=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
GROQ_API_KEY=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
OPENROUTER_API_KEY=
GEMINI_API_KEY=
XAI_API_KEY=

# AWS Bedrock (only if using Bedrock)
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION_NAME=

# OpenAI-compatible
OPENAI_COMPATIBLE_API_KEY=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
OPENAI_COMPATIBLE_API_BASE=https://api.minimax.io/v1

##### DATA / SEARCH (REQUIRED)
RAPID_API_KEY=
TAVILY_API_KEY=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

##### WEB SCRAPE (REQUIRED)
FIRECRAWL_API_KEY=fc-c5f457889c97477eb1f076ff3324a32f
FIRECRAWL_URL=

##### AGENT SANDBOX (REQUIRED to use Daytona sandbox)
DAYTONA_API_KEY=dtn_f371edf670d005ae2e9b6a1df7e578aefa2cfa95115951dee067136c25584aba
DAYTONA_SERVER_URL=https://app.daytona.io/api
DAYTONA_TARGET=us

##### SECURITY & WEBHOOKS (Recommended)
MCP_CREDENTIAL_ENCRYPTION_KEY=
TRIGGER_WEBHOOK_SECRET=

##### OBSERVABILITY (Optional)
LANGFUSE_PUBLIC_KEY=
LANGFUSE_SECRET_KEY=
LANGFUSE_HOST=https://cloud.langfuse.com

##### BILLING (Optional;)
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
STRIPE_DEFAULT_PLAN_ID=
STRIPE_DEFAULT_TRIAL_DAYS=14

##### ADMIN
KORTIX_ADMIN_API_KEY=

##### INTEGRATIONS
COMPOSIO_API_KEY=7b8e1b260503d0a731bc02d3b111a62d866226b4bdf72cc50b08fc23d961a91d
COMPOSIO_WEBHOOK_SECRET=7b8e1b260503d0a731bc02d3b111a62d866226b4bdf72cc50b08fc23d961a91d
COMPOSIO_API_BASE=https://backend.composio.dev

##### MISC
MORPH_API_KEY=sk-mA5AUCyDF93Cupvf1a3yolXTMM9vXYL-u5V_wmSdyFWcwJTq
OPENAI_COMPATIBLE_MODEL=MiniMax-M2
EXA_API_KEY=2ff31e79-8271-4592-9693-2d461e1bfd46

##### QSTASH (Note: May not be actively used - Supabase Cron replaced QStash scheduling)
QSTASH_URL=https://qstash.upstash.io
QSTASH_TOKEN=eyJVc2VySUQiOiJjMmU2YmQwNC0xZDQ2LTQ0ZmMtOWU0NS04OTdiZjk5MzY1MTAiLCJQYXNzd29yZCI6IjY5ZTZjN2M3MWE3ZjRlN2FhZmQ5YTI0YjMwMjUwZDUyIn0=
QSTASH_CURRENT_SIGNING_KEY=sig_5pkp7Waza3G9vQgpNngADqskoSTi
QSTASH_NEXT_SIGNING_KEY=sig_6it374tEvKXgHoCpTcEF4xg74Ywz

# Additional required keys
ENCRYPTION_KEY={encryption_key}
NEXT_PUBLIC_URL=http://localhost:3000
"""
    
    # Generate encryption key
    encryption_key = generate_encryption_key()
    
    # Replace placeholder with actual encryption key
    env_content = env_content.format(encryption_key=encryption_key)
    
    # Ensure backend directory exists
    backend_dir = "backend"
    if not os.path.exists(backend_dir):
        print(f"❌ Error: {backend_dir} directory not found. Run this from the project root.")
        return False
    
    # Write .env file
    env_file = os.path.join(backend_dir, ".env")
    
    # Check if file already exists
    if os.path.exists(env_file):
        response = input(f"⚠️  {env_file} already exists. Overwrite? (y/N): ").strip().lower()
        if response != 'y':
            print("Aborted. Existing file preserved.")
            return False
    
    try:
        with open(env_file, 'w') as f:
            f.write(env_content)
        print(f"✅ Successfully created {env_file}")
        print(f"✅ Generated encryption key: {encryption_key[:20]}...")
        print(f"\n📝 Next steps:")
        print(f"   1. Review {env_file} and add any missing values")
        print(f"   2. Set up frontend/.env.local (see SETUP_GUIDE.md)")
        print(f"   3. Run: python start.py")
        return True
    except Exception as e:
        print(f"❌ Error creating {env_file}: {e}")
        return False

if __name__ == "__main__":
    print("🔧 Creating backend/.env file with your API keys...")
    create_env_file()

