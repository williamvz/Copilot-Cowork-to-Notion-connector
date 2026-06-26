# Notion Connector for Microsoft 365 Copilot Cowork

Talk to your **Notion** workspace from **Microsoft 365 Copilot Cowork**.

This repo is a ready-to-build Cowork **plugin package**. It registers Notion's
official hosted **MCP server** as a Cowork **connector**, so Copilot can search,
read, create, and update Notion pages, databases, and comments on your behalf —
using *your* Notion permissions. It also ships four marketing-focused **Agent
Skills** so Cowork knows how to do useful work in Notion out of the box.

> Built for a marketing team that plans everything in Notion: draft campaign
> briefs, triage the content calendar, and generate a weekly digest — without
> leaving Copilot.

---

## How it works

```
You ──▶ Copilot Cowork ──▶ "Notion" connector ──▶ Notion hosted MCP server ──▶ your Notion workspace
                              (this plugin)         https://mcp.notion.com/mcp        (OAuth, your permissions)
```

- Cowork plugins can declare an **`agentConnectors`** entry that points at a
  remote **MCP server**. Cowork talks to that server using the Model Context
  Protocol and exposes its tools to Copilot.
- Notion runs a **hosted MCP server** at `https://mcp.notion.com/mcp`. It speaks
  OAuth 2.0 and supports **Dynamic Client Registration (DCR)**.
- Because Notion's server supports DCR, this plugin's connector lists **only the
  server URL — no auth config**. Cowork automatically creates an OAuth client and
  walks you through Notion sign-in the first time you use it. **No servers to
  host, no secrets to manage.**

That's the big reason this uses the **MCP server** rather than the raw Notion
REST API — see [Why MCP instead of the Notion API](#why-mcp-instead-of-the-notion-api).

---

## What's in the package

| File | Purpose |
|------|---------|
| `manifest.json` | The Cowork/Teams app manifest. Declares the **Notion MCP connector** and the **skills**. |
| `skills/notion-connector-guide/` | Teaches Cowork to use Notion reliably: search → read → act, query databases, write safely, cite sources. |
| `skills/marketing-campaign-brief/` | Turn notes into a structured campaign brief page in Notion. |
| `skills/content-calendar-ops/` | Query and update the content calendar database (what's due, gaps, scheduling). |
| `skills/weekly-marketing-digest/` | Generate a weekly marketing status digest from Notion (and optionally post it back). |
| `color.png`, `outline.png` | Plugin icons. |
| `scripts/build.sh` | Validates everything and produces `dist/notion-cowork-connector.zip`. |

The connector is the part that makes the Notion *connection*. The skills are
optional but recommended — they're prompt-only and make Copilot good at Notion
immediately. Remove any you don't want by deleting its folder and its entry in
`manifest.json` → `agentSkills`.

---

## Prerequisites

1. **Copilot Cowork access.** Cowork is a Microsoft 365 Copilot capability
   currently delivered through the **Microsoft Copilot Frontier** program. Your
   tenant must be enrolled in Frontier (and you must have a Copilot license)
   before custom Cowork plugins will load. If you're not sure, check with your
   M365 admin.
2. **Permission to upload a custom app.** Either you're an admin, or your tenant
   allows users to upload custom apps. (See deployment options below.)
3. **A Notion account** with access to the workspace/content you want Copilot to
   reach. The connector acts as *you* — it can only see what you can see.

---

## Customize before you ship

Open `manifest.json` and update these — they currently hold placeholders:

- `developer.name`, `developer.websiteUrl`, `developer.privacyUrl`,
  `developer.termsOfUseUrl` — your org's real values. Teams/Cowork validation
  requires these to be real, reachable HTTPS URLs.
- `packageName` — a reverse-domain id for your org, e.g.
  `com.yourcompany.copilotcowork.notion`.
- `id` — a unique GUID for the app. A fresh one is already filled in; if you fork
  this for multiple variants, generate a new GUID per variant
  (`python3 -c "import uuid;print(uuid.uuid4())"`).
- `name` / `description` — tweak wording to taste.
- `color.png` / `outline.png` — swap in your own branding if you like
  (`color.png` = 192×192, `outline.png` = 32×32 transparent).

Everything else (the connector URL and skills) works as-is.

---

## Build

```bash
./scripts/build.sh
```

This validates `manifest.json` and the skill files, then writes
`dist/notion-cowork-connector.zip` with `manifest.json` at the **root** of the
zip (a hard requirement). That zip is what you deploy.

---

## Deploy

Pick the path that matches your access. **All three require Frontier-enabled
Cowork.**

### Option A — Roll out to your org or a group (admin)

Best for deploying to the marketing team.

1. Go to the **Microsoft 365 admin center → Integrated apps / Manage apps**.
2. **Upload custom app** and select `dist/notion-cowork-connector.zip`.
3. Assign it to the right users/groups and complete the deployment.

### Option B — Sideload it yourself (no org-wide rollout)

Good for testing or single-user installs. Requires that your tenant allows
custom app upload.

1. In **Teams → Apps → Manage your apps → Upload a customized app**, choose
   `dist/notion-cowork-connector.zip`.
2. Open Copilot Cowork; the **Notion** plugin (and its skills) will be available.

### Option C — Skills only, via OneDrive (no admin, no connector)

If you can't upload a custom app, you can still use the **skills** (but **not**
the Notion connector): copy the `skills/` folder into your OneDrive at
`Documents/Cowork/skills/`. Cowork auto-discovers custom skills there (up to 50
per user). Note: without the plugin wrapper there's **no Notion connection** —
this only gives Copilot the marketing know-how, not access to your workspace. Use
Option A or B to get the actual connector.

---

## Connect Notion (first run)

The first time Copilot uses a Notion tool, Cowork starts the OAuth flow:

1. You'll be prompted to **sign in to Notion** and **authorize** the connection.
2. Notion lets you choose which workspace and which pages/databases to share.
3. After that, Copilot can use Notion on your behalf. Notion access tokens are
   short-lived and refreshed automatically; you may be asked to re-authorize
   periodically (Notion expires refresh tokens after ~180 days, or 30 days of
   inactivity).

You can revoke access anytime from **Notion → Settings → Connections**.

---

## Try it

Once connected, ask Cowork things like:

- "Search my Notion for the Q3 launch plan and summarize the current status."
- "What content is publishing this week according to our content calendar?"
- "Draft a campaign brief in Notion for our spring webinar series."
- "Which calendar items are missing an owner or a publish date?"
- "Write this week's marketing digest from Notion and post it to our Weekly Updates page."

---

## Authentication options

This plugin uses **DCR** (the simplest, recommended path for Notion). For
reference, Cowork connectors support three modes via the connector's
`toolSource.remoteMcpServer.authorization`:

| Mode | When to use | Config |
|------|-------------|--------|
| **Dynamic Client Registration (DCR)** ✅ *(used here)* | The MCP server supports DCR (Notion does). | **Omit** `authorization` entirely. Cowork auto-creates the OAuth client. |
| **OAuthPluginVault** | You must use a pre-registered OAuth client. | `"authorization": { "type": "OAuthPluginVault", "referenceId": "<vault-ref>" }` |
| **ApiKeyPluginVault** | The server authenticates with a static API key. | `"authorization": { "type": "ApiKeyPluginVault", "referenceId": "<vault-ref>" }` |

For Notion, **DCR is the intended path** — leave `authorization` out, as this
manifest does. Only switch to OAuthPluginVault if your tenant requires a
pre-registered client (see Microsoft's "Configure authentication for MCP and API
plugins" guidance), and never commit client secrets to this repo.

---

## Troubleshooting & known issues

- **Plugin doesn't appear / won't load.** Confirm the tenant is enrolled in the
  **Copilot Frontier** program and you have a Copilot license. Cowork custom
  plugins are gated behind it.
- **"Upload a custom app" is greyed out.** Your tenant blocks custom app upload.
  An admin must enable it (or use Option A to deploy centrally).
- **Connector added but you never get a "Connect"/sign-in prompt, and Notion is
  never contacted.** This has been reported with DCR connectors in current Cowork
  preview builds. Things to try: remove and re-add the plugin; confirm the
  manifest version is one your tenant accepts (see next item); as a fallback,
  switch the endpoint to Notion's SSE URL `https://mcp.notion.com/sse`; or, if
  your org mandates it, register a client and use `OAuthPluginVault`.
- **Sign-in succeeds but tool calls fail in chat.** Also reported in preview.
  Re-authorize from scratch, and double-check the `mcpServerUrl` is exactly
  `https://mcp.notion.com/mcp`. If it persists, try the `/sse` endpoint.
- **Manifest version rejected on upload.** This manifest targets the
  `devPreview` schema, which is what currently-shipping Cowork skill plugins use.
  If your tenant's validator requires a pinned version instead, change **both**
  fields to match, e.g.:
  ```json
  "$schema": "https://developer.microsoft.com/json-schemas/teams/v1.27/MicrosoftTeams.schema.json",
  "manifestVersion": "1.27"
  ```
  (`agentConnectors` is supported from the 1.27 schema onward.) Keep the two
  fields' versions consistent.
- **A skill isn't triggering.** Cowork decides when to apply a skill from its
  frontmatter `description`. Make the description explicitly mention the kinds of
  requests it should handle. Re-deploy after editing.

---

## Why MCP instead of the Notion API

You asked for "either Notion's MCP server or their API." MCP wins here:

| | **Notion MCP server** (this plugin) | **Raw Notion REST API** |
|---|---|---|
| Infra to host | **None** — Notion hosts the server | You host an MCP server or API-plugin backend |
| Auth | **DCR OAuth, handled by Cowork** | You build/operate an OAuth app + token storage |
| Tool surface | Curated Notion tools, **auto-discovered** | You hand-write an OpenAPI spec for each endpoint |
| Maintenance | Notion updates the server | You patch your spec/backend as the API changes |
| Secrets in this repo | **None** | Client secret / integration token to manage |

The API route is viable if you need custom server-side logic, but it means
standing up and securing your own service. For "let Copilot talk to Notion,"
the hosted MCP server is dramatically less work and has no moving parts to keep
running. If you later want the API route, the cleanest shape is still to wrap it
in your own MCP server and point `mcpServerUrl` at it — the manifest wouldn't
change much.

---

## Security & privacy notes

- The connector acts **as the signed-in Notion user** — it can't see or change
  anything that user can't.
- OAuth tokens are managed by Cowork/Notion; **no secrets are stored in this
  repo**. `.gitignore` excludes `.env*` and build output. Never commit a client
  secret or integration token.
- Notion content flows from Notion → Cowork to answer your prompts. Treat it like
  any other Copilot data path and follow your org's data-handling policies.
- Review and revoke access anytime in **Notion → Settings → Connections**.

---

## Repo layout

```
.
├── manifest.json                         # Cowork/Teams manifest (connector + skills)
├── color.png  outline.png                # Icons
├── skills/
│   ├── notion-connector-guide/SKILL.md
│   ├── marketing-campaign-brief/SKILL.md
│   ├── content-calendar-ops/SKILL.md
│   └── weekly-marketing-digest/SKILL.md
├── scripts/
│   └── build.sh                          # -> dist/notion-cowork-connector.zip
└── dist/                                 # build output (gitignored)
```

---

## References

- [Build plugins for Copilot Cowork — Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-365/copilot/cowork/cowork-plugin-development)
- [Use plugins with Copilot Cowork — Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-365/copilot/cowork/cowork-plugins)
- [Manage plugins for Copilot Cowork — Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-365/copilot/cowork/cowork-manage-plugins)
- [Register MCP servers as agent connectors for Microsoft 365 — Microsoft Learn](https://learn.microsoft.com/en-us/microsoftteams/platform/m365-apps/agent-connectors)
- [Notion's hosted MCP server: an inside look — Notion](https://www.notion.com/blog/notions-hosted-mcp-server-an-inside-look)
- [Integrating your own MCP client — Notion Docs](https://developers.notion.com/guides/mcp/build-mcp-client)
- [Microsoft Copilot Frontier program](https://adoption.microsoft.com/en-us/copilot/frontier-program/)
