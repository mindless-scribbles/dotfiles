# GitHub Copilot Auth Fix for Neovim

## What broke and why

copilot.vim's `:Copilot setup` device flow consistently hangs in WSL2. Two compounding issues:

1. **npx download race**: On first auth attempt, nvim downloads `@github/copilot-language-server` via `npx`, which takes long enough that the device code (15-min window) expires before polling completes. After the download is cached, this is less likely to recur — but the flow can still hang for unknown reasons.

2. **Token specificity**: `~/.config/github-copilot/apps.json` must contain a token issued specifically by the **Copilot GitHub App** (`client_id: Iv1.b507a08c87ecfe98`). A `gh` CLI token — even with the `copilot` OAuth scope — is rejected by `api.github.com/copilot_internal/v2/token` with 404.

3. **Trailing space bug** (historical): At some point the language server wrote the token to `apps.json` with a trailing space, causing all token exchanges to fail silently.

## The fix: manual device flow from terminal

Run this whenever Copilot auth breaks on any machine:

```bash
# Step 1: request a device code
curl -s -X POST https://github.com/login/device/code \
  -H "Accept: application/json" \
  -d "client_id=Iv1.b507a08c87ecfe98&scope=read:user"
# Note the user_code from the response

# Step 2: go to https://github.com/login/device, enter the user_code, authorize

# Step 3: exchange for token (replace DEVICE_CODE with value from step 1)
RESPONSE=$(curl -s -X POST https://github.com/login/oauth/access_token \
  -H "Accept: application/json" \
  -d "client_id=Iv1.b507a08c87ecfe98&device_code=DEVICE_CODE&grant_type=urn:ietf:params:oauth:grant-type:device_code")

# Step 4: write to apps.json (replace YOUR_USERNAME)
echo "$RESPONSE" | python3 -c "
import json, sys
d = json.load(sys.stdin)
t = d.get('access_token', '').strip()
if not t: print('ERROR:', d); exit(1)
data = {'github.com:Iv1.b507a08c87ecfe98': {'user': 'YOUR_USERNAME', 'oauth_token': t, 'githubAppId': 'Iv1.b507a08c87ecfe98'}}
json.dump(data, open('/home/YOUR_USER/.config/github-copilot/apps.json', 'w'), indent=2)
print('Done, token length:', len(t))
"
```

Then open nvim and run `:Copilot status` to confirm.

## Should apps.json go in dotfiles?

**No — don't commit it.** The file contains a live OAuth token. If your dotfiles repo is public (or ever becomes public), the token would be exposed and GitHub would revoke it automatically, breaking Copilot on all machines simultaneously.

**Instead, add it to your dotfiles `.gitignore`:**

```
.config/github-copilot/apps.json
.config/github-copilot/hosts.json
```

**For new machines:** run the 4-step terminal flow above. It takes ~60 seconds and avoids the nvim auth hang entirely. Consider saving the script somewhere in your dotfiles (e.g., `~/.config/nvim/scripts/copilot-auth.sh`) as a helper.

## Token location

```
~/.config/github-copilot/apps.json
```

Token is valid until revoked at https://github.com/settings/applications — no expiry otherwise.
