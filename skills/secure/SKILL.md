---
name: secure
description: "Security discipline. Load when a change touches authentication, authorization, user input, secrets, data access, file handling, or a network boundary. Covers treating security as part of working, never routing around a security control, distrusting everything that crosses a boundary, keeping secrets out of the repo, defaulting to least privilege, vetting dependencies before adding them, and escalating security decisions instead of defaulting them."
---

# Secure

Security skill for LLM coding agents. Load this when a change touches authentication, authorization, user input, secrets, data access, file handling, or a network boundary — which is more changes than it sounds like.

Where [`deliberate`](../deliberate/SKILL.md) keeps code honest, this skill keeps code *safe*. Counters the documented failure mode of AI-generated code: taking the path of least resistance, which is rarely the secure path — bypassed access controls, client-side-only auth, injectable queries, leaked secrets, and over-broad permissions.

---

## 1. Security Is Part of "Working"

**Code that works but is exploitable does not work.**

- The happy path proving out is not the bar. The bar includes: what can a hostile caller do with this?
- Security is not a later pass, a cleanup task, or someone else's audit. It ships with the change or the change isn't done.
- When you demo a feature, you demo the door. Ask who else can walk through it.

**Test:** Did I consider this change from the attacker's side, or only the user's?

---

## 2. Never Route Around a Security Control

**When a security mechanism blocks you, that is the mechanism working.**

The most dangerous shortcut an agent takes: the permission check fails, so reach for the key that bypasses it — the service-role token, the admin credential, the `sudo`, the disabled TLS check, the widened CORS policy.

- If row-level security blocks the query, fix the policy — don't switch to the role that ignores it.
- If auth middleware rejects the request, fix the auth flow — don't add the route to the exempt list.
- If a certificate fails validation, fix the certificate — don't set `verify=false`.

Each bypass "fixes" the task by deleting the protection. If a control genuinely seems wrong, say so and let the user decide.

**Test:** Does my fix satisfy the security control, or evade it?

---

## 3. Trust Nothing That Crosses a Boundary

**Input is hostile until validated — at the server, at the API, at the parser.**

- Validation and authorization live server-side. Client-side checks are UX, not security; anything enforced only in the browser is enforced nowhere.
- Queries are parameterized. String-built SQL, shell commands, and file paths from user input are injection, full stop.
- Output is encoded for its destination — HTML, attribute, URL, shell. XSS is the single most common flaw in generated code.
- File paths from users get canonicalized and checked against a root. Uploads get type- and size-checked.
- Deserialization of untrusted data uses safe loaders, never eval-equivalent ones.

**Test:** For each place data crosses into this code, what happens when the data is malicious?

---

## 4. Secrets Never Enter the Repo

**A credential in code, config, logs, or output is a leak — even in a private repo, even "temporarily."**

- Keys, tokens, passwords, and connection strings come from env vars or a secret store. Never literals.
- Don't print secrets in logs, error messages, debug output, or your own progress commentary.
- Don't copy a real credential into a test fixture or an example file. Placeholders only.
- Before committing, scan the diff for anything that looks like a credential. "I'll rotate it later" means it's already leaked.

**Test:** If this diff went public right now, would anything need rotating?

---

## 5. Least Privilege by Default

**The convenient permission is the insecure one. Scope everything down.**

- Tokens, roles, and service accounts get the narrowest scope that makes the feature work — not the broad one that makes the error go away.
- New endpoints default to authenticated. Public is an explicit, stated decision.
- Database users for an app don't own the schema. Cloud roles don't get `*` on resources or actions.
- If you can't name why a permission is needed, it isn't.

**Test:** Can I justify every permission this change grants, individually?

---

## 6. Vet Dependencies Before Adding Them

**A package name you're confident about may not exist — and an attacker may have registered it.**

Hallucinated package names are now a supply-chain attack vector (slopsquatting): attackers publish malware under the names models invent.

- Before adding a dependency, confirm it's the real one: registry page, repo, download count, maintenance activity, exact spelling.
- Prefer the platform's standard library and already-present dependencies over new ones (see [`deliberate`](../deliberate/SKILL.md) §4).
- Never hand-roll crypto, session management, or password hashing. Use the platform's standard, maintained mechanism.
- Pin versions. Review what a new dependency pulls in transitively.

**Test:** Did I verify this package exists and is the one I think it is, or did I trust my memory of its name?

---

## 7. Escalate Security Decisions — Don't Default Them

**When the spec is silent on security, the gap is a product decision, not yours to fill quietly.**

- Data retention, PII handling, encryption at rest, audit logging, session length, rate limits: if unspecified, ask — don't pick the permissive default because it's less code.
- Flag security-relevant omissions the way [`review`](../review/SKILL.md) hunts for what isn't there: the missing rate limit, the missing audit log, the unsanitized input the spec never mentioned.
- If you spot an existing vulnerability while working, report it — don't silently fix it (scope), and never ignore it.

**Test:** Did any security posture get decided in this change without anyone deciding it?

---

## These Guidelines Are Working If

- Security controls stop getting bypassed to make features work.
- Injection-shaped code (string-built queries, commands, paths) stops appearing in diffs.
- Secrets stop showing up in commits, logs, and fixtures.
- New permissions arrive with one-line justifications.
- Security gaps in specs get surfaced as questions, not filled with permissive defaults.

---

*Part of [Deliberate](https://github.com/angad-kandhari/deliberate). Load alongside [`deliberate`](../deliberate/SKILL.md); pairs with [`review`](../review/SKILL.md) (safety is a review layer) and [`verify`](../verify/SKILL.md) (exploitable isn't done).*
