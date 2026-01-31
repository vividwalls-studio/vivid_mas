#!/bin/bash

# Quick Build MCP Servers Script
# Focuses on newly created servers only

echo "🚀 Quick Build for New MCP Servers"
echo "=========================================="

# Base path
MCP_AGENTS_PATH="/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/agents"

# List of newly created servers that need building
NEW_SERVERS=(
    # Sales agents
    "sale-sdir-ecto-r-prompts"
    "sale-sdir-ecto-r-resource"
    "hosp-ital-itys-ales-prompts"
    "hosp-ital-itys-ales-resource"
    "corp-orat-esal-es-prompts"
    "corp-orat-esal-es-resource"
    "heal-thca-resa-les-prompts"
    "heal-thca-resa-les-resource"
    "resi-dent-ials-ales-prompts"
    "resi-dent-ials-ales-resource"
    "educ-atio-nals-ales-prompts"
    "educ-atio-nals-ales-resource"
    "gove-rnme-ntsa-les-prompts"
    "gove-rnme-ntsa-les-resource"
    "reta-ilsa-les-prompts"
    "reta-ilsa-les-resource"
    "real-esta-tesa-les-prompts"
    "real-esta-tesa-les-resource"
    "lead-gene-rati-on-prompts"
    "lead-gene-rati-on-resource"
    "part-ners-hipd-evel-opme-nt-prompts"
    "part-ners-hipd-evel-opme-nt-resource"
    "acco-untm-anag-emen-t-prompts"
    "acco-untm-anag-emen-t-resource"
    "sale-sana-lyti-cs-prompts"
    "sale-sana-lyti-cs-resource"
    
    # Social media agents
    "pint-eres-t-prompts"
    "pint-eres-t-resource"
    "twit-ter-prompts"
    "twit-ter-resource"
    "link-edin-prompts"
    "link-edin-resource"
    "tikt-ok-prompts"
    "tikt-ok-resource"
    "yout-ube-prompts"
    "yout-ube-resource"
    
    # Marketing agents
    "emai-lmar-keti-ng-prompts"
    "emai-lmar-keti-ng-resource"
    "news-lett-er-prompts"
    "news-lett-er-resource"
    "copy-writ-er-prompts"
    "copy-writ-er-resource"
    "copy-edit-or-prompts"
    "copy-edit-or-resource"
    "keyw-ord-prompts"
    "keyw-ord-resource"
    
    # Finance agents
    "acco-unti-ng-prompts"
    "acco-unti-ng-resource"
    "budg-etin-g-prompts"
    "budg-etin-g-resource"
    "fina-ncia-lpla-nnin-g-prompts"
    "fina-ncia-lpla-nnin-g-resource"
    
    # Customer Experience agents
    "cust-omer-serv-ice-prompts"
    "cust-omer-serv-ice-resource"
    "cust-omer-feed-back-prompts"
    "cust-omer-feed-back-resource"
    "cust-omer-succ-ess-prompts"
    "cust-omer-succ-ess-resource"
    "supp-ortt-icke-t-prompts"
    "supp-ortt-icke-t-resource"
    "live-chat-prompts"
    "live-chat-resource"
    
    # Operations agents
    "inve-ntor-yman-agem-ent-prompts"
    "inve-ntor-yman-agem-ent-resource"
    "supp-lych-ain-prompts"
    "supp-lych-ain-resource"
    "qual-ityc-ontr-ol-prompts"
    "qual-ityc-ontr-ol-resource"
    "logi-stic-s-prompts"
    "logi-stic-s-resource"
    "vend-orma-nage-ment-prompts"
    "vend-orma-nage-ment-resource"
    
    # Product agents
    "prod-uctr-esea-rch-prompts"
    "prod-uctr-esea-rch-resource"
    "prod-uctd-evel-opme-nt-prompts"
    "prod-uctd-evel-opme-nt-resource"
    "prod-ucta-naly-tics-prompts"
    "prod-ucta-naly-tics-resource"
    "cata-logm-anag-emen-t-prompts"
    "cata-logm-anag-emen-t-resource"
    
    # Analytics Director
    "anal-ytic-sdir-ecto-r-prompts"
    "anal-ytic-sdir-ecto-r-resource"
)

# Track statistics
TOTAL=0
SUCCESS=0
FAILED=0

echo "📦 Processing ${#NEW_SERVERS[@]} new MCP servers..."
echo ""

for server in "${NEW_SERVERS[@]}"; do
    server_path="$MCP_AGENTS_PATH/$server"
    
    if [ -d "$server_path" ]; then
        echo -n "  • $server: "
        TOTAL=$((TOTAL + 1))
        
        cd "$server_path"
        
        # Check if package.json exists
        if [ ! -f "package.json" ]; then
            echo "❌ No package.json"
            FAILED=$((FAILED + 1))
            continue
        fi
        
        # Quick install and build
        if npm install --silent > /dev/null 2>&1; then
            if [ -f "tsconfig.json" ]; then
                if npm run build > /dev/null 2>&1; then
                    echo "✅ Built"
                    SUCCESS=$((SUCCESS + 1))
                else
                    echo "⚠️ Build failed"
                    FAILED=$((FAILED + 1))
                fi
            else
                echo "✅ Installed (no TS)"
                SUCCESS=$((SUCCESS + 1))
            fi
        else
            echo "❌ Install failed"
            FAILED=$((FAILED + 1))
        fi
    fi
done

# Summary
echo ""
echo "=========================================="
echo "✅ BUILD SUMMARY"
echo "=========================================="
echo "  • Total processed: $TOTAL"
echo "  • Successful: $SUCCESS"
echo "  • Failed: $FAILED"
echo ""

if [ $SUCCESS -gt 0 ]; then
    echo "🎉 Successfully built $SUCCESS MCP servers!"
fi

if [ $FAILED -gt 0 ]; then
    echo "⚠️ Note: $FAILED servers need attention"
    echo "  This is likely due to missing package.json files"
    echo "  in the generated directories."
fi

echo ""
echo "🎯 Next: Create n8n workflows for agents"

exit 0