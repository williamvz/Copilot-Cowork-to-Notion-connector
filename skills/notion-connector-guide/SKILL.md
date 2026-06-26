---
name: notion-connector-guide
description: How to work reliably with Notion through the connected Notion workspace. Apply whenever the user wants to find, read, create, or update anything in Notion (pages, databases, projects, docs, comments, the content calendar, campaign briefs, meeting notes, wikis). Covers search-first discovery, reading full pages, querying databases, safe writes, and citing sources.
---

You can reach the user's Notion workspace through the connected Notion tools. Use this guide every time a request touches Notion so you act accurately and safely with their real data.

## Core workflow: find → read → act

1. **Find before you act.** Don't guess page or database IDs. Start by searching Notion for the relevant title, keyword, or person. Searching also tells you whether something already exists before you create a duplicate.
2. **Read the full thing.** Search results are summaries. Before answering questions about a page or editing it, fetch the full page/record so you have the real content, properties, and sub-pages.
3. **Then act** — answer, summarize, create, or update — and link back to what you used.

## Notion's structure (so you map requests correctly)

- **Pages** are documents. They can be standalone or live inside a database.
- **Databases** (sometimes surfaced as "data sources") are structured collections of pages with **properties** (columns) like Status, Owner, Due date, Channel, Stage. The content calendar, campaign tracker, and OKR tracker are almost always databases.
- When a user asks "what's due", "what's in progress", "who owns X", "show me everything tagged Y" — that's a **database query with filters/sorts**, not a free-text search. Query the database by its properties instead of reading pages one by one.
- **Comments** live on pages and blocks; use them for lightweight status notes and @mentions rather than editing body text.

## Reading and answering

- Prefer the workspace's own words. Quote or closely paraphrase what's actually on the page rather than inventing details.
- When you query a database, report the property values that matter to the request (e.g., Status, Owner, Due date) — not just the title.
- Always cite what you used: include the Notion page title and its link so the user can click through and verify.
- If you can't find something, say so and show the search terms you tried, rather than guessing.

## Writing safely (create / update / move / delete)

- **Confirm before any write.** Briefly state what you're about to change and where (which page or database, which properties) and get a go-ahead, unless the user has clearly already asked for that exact change.
- **Match existing conventions.** Reuse the database's existing property names and option values (Status, Stage, Channel, etc.) instead of inventing new ones. If a value doesn't exist yet, point that out instead of silently creating a near-duplicate.
- **Place new pages deliberately.** Ask where a new page should live (which parent page or database) if it isn't obvious from context.
- **Never delete or overwrite** existing content unless the user explicitly asks. Prefer adding a comment or appending over replacing.
- Make one clean change rather than many noisy edits.

## Permissions and scope

- You only see and change what the signed-in Notion account can access. If something seems missing, it may be a permissions issue — say that rather than assuming it doesn't exist.
- Treat Notion content as the source of truth for the team's plans. Don't paste sensitive workspace content into other tools without the user asking.

## When you're unsure

Ask a short clarifying question (which workspace area, which database, which page) instead of acting on a guess. A two-second question beats editing the wrong page.
