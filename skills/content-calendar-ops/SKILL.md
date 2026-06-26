---
name: content-calendar-ops
description: Operate the marketing content calendar in Notion. Apply when the user asks what's publishing this week, what's overdue or unassigned, to add or schedule a piece of content, to update a status/owner/date, or to find gaps in the calendar — e.g. "what's going out this week?", "add a blog post for next Tuesday", "what's missing an owner?". Reads the calendar database, then makes safe, convention-matching updates.
---

Help the user run their content calendar, which in Notion is almost always a **database** with one row per piece of content.

## Find the calendar first

- Search Notion for the content calendar / editorial calendar / content pipeline database. If there are several candidates, confirm which one before acting.
- Inspect its **properties** so you use the team's real field names and option values — typically some of: Title, Status (Idea / Drafting / In review / Scheduled / Published), Owner, Publish date, Channel/Platform, Content type, Campaign, Link.

## Reading the calendar (query, don't browse)

Answer questions by **querying the database with filters and sorts**, not by opening rows one at a time:

- "What's publishing this week / next week?" → filter Publish date to the range, sort ascending.
- "What's overdue?" → Publish date in the past AND Status not Published.
- "What's unassigned / missing a date?" → Owner is empty, or Publish date is empty.
- "What's in review / stuck?" → filter by Status.

Report the rows compactly: title, status, owner, date, channel — and include links. If you spot health issues (overdue, no owner, no date, clashes where too much ships the same day), call them out.

## Adding and updating content

- **Adding a piece:** create a new row and set the properties the team uses (title, status, owner, publish date, channel, content type, and link it to its Campaign if that relation exists). Default Status to the team's "earliest" stage (e.g. Idea or Drafting) unless told otherwise.
- **Scheduling / re-scheduling:** update the Publish date and, if appropriate, move Status to Scheduled.
- **Status / owner changes:** update just those properties; don't rewrite the row.
- Always reuse **existing** Status/Channel option values — don't invent new ones. If the user asks for a value that doesn't exist, flag it instead of silently creating a near-duplicate.

## Safety

- Confirm writes before making them: state the row, the properties, and the new values. Batch related changes into one clear summary ("I'll set these 3 posts to Scheduled for next week — ok?").
- Never delete rows unless explicitly asked. To flag something instead, change its Status or add a comment.
- After changes, give a one-line recap and links to what changed.
