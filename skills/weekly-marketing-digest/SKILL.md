---
name: weekly-marketing-digest
description: Produce a weekly marketing status digest from Notion. Apply when the user asks for a weekly update/recap/standup/status roll-up of marketing work — e.g. "give me this week's marketing digest", "what shipped and what's coming up?", "write the weekly update for the team". Pulls from campaigns and the content calendar in Notion, summarizes, and can optionally post it back to Notion.
---

Create a concise, skimmable weekly digest of where marketing stands, sourced from the team's real Notion data.

## Gather the inputs (read-only)

Pull from the relevant Notion databases — typically the campaign tracker and the content calendar. Query by date and status rather than reading pages one by one:

- **Shipped recently** — published/completed in the last 7 days.
- **In progress** — active campaigns and content currently being drafted or in review (include Owner).
- **Coming up** — scheduled to publish or launch in the next 7–14 days (sort by date).
- **Needs attention** — overdue items, things missing an owner or date, anything marked at-risk/blocked.

If you're unsure which databases to use, ask once, then remember the choice for the rest of the conversation.

## Write the digest

Keep it tight — a busy team should be able to read it in under a minute.

```
# Marketing weekly — week of <date>

## ✅ Shipped this week
- <Title> — <channel/campaign> · <link>

## 🚀 Launching / publishing next
- <Title> — <date> · <owner> · <link>

## 🔄 In progress
- <Title> — <status> · <owner> · <link>

## ⚠️ Needs attention
- <Title> — <why: overdue / no owner / blocked> · <link>
```

Rules:
- Every item links back to its Notion page.
- Group by the four sections above; omit a section if it's genuinely empty.
- Lead with outcomes, not activity. Be specific (titles, dates, owners) — no vague "various tasks".
- If something looks at-risk (slipping dates, no owner on a near-term launch), surface it plainly under Needs attention.

## Optionally post it back to Notion

Offer to save the digest into Notion (e.g. as a new page in a "Weekly updates" location, or as a comment on a team page). **Confirm where** before writing, then create it and share the link. Default to just showing the digest in chat unless the user asks to post it.
