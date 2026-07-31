# Installing and logging in

This is the part everyone gets stuck on, so we do it live and we do it first.

**Which agent should you use?**

- **You already have a ChatGPT account** (Plus, Pro, or Team): use **Codex**. It signs in with
  the account you already have, so there is nothing to provision.
- **Anything else**: use **Claude Code**. Tian's course workspace has an API key waiting for
  you, and the cost is covered.

To be straight with you about support: **I can help you with Claude Code.** That is what I run
daily and what everything in this repo was built with. Codex is a genuinely good tool and the
install is below, but if it misbehaves in the room I will be guessing alongside you.

---

## Install

Both are one `npm` command. In a Codespace terminal, or your own:

```bash
npm install -g @anthropic-ai/claude-code
```

```bash
npm install -g @openai/codex
```

Or install both at once:

```bash
bash scripts/setup-agents.sh
```

Check they landed:

```bash
claude --version && codex --version
```

---

## Log in

### Codex, if you have a ChatGPT account

```bash
codex
```

It prompts you to sign in on first run. In a Codespace there is no local browser, so it prints
a URL: open it in a normal tab, approve, and come back to the terminal. That is the whole
process, and your own subscription pays for it.

### Claude Code, the normal path

Tian's course workspace issues you an API key (Settings → API keys at
[platform.claude.com](https://platform.claude.com), **shown only once**, so save it somewhere).
Hand it to Claude Code as an environment variable:

```bash
export ANTHROPIC_API_KEY='sk-ant-...'
```

```bash
claude
```

To keep it across new terminals and Codespace restarts:

```bash
echo "export ANTHROPIC_API_KEY='sk-ant-...'" >> ~/.bashrc
```

That is it. In principle every one of you already has this key and never needs the next
section.

### Claude Code, if the key does not work

Things go wrong in rooms. If your workspace key is missing, expired, or rejected, there is a
shared class token in this repo, encrypted, that I unlock with a passcode I will say out loud:

```bash
source scripts/claude-login.sh
```

Type the passcode when prompted. Then:

```bash
claude --dangerously-skip-permissions
```

Three things worth knowing about that:

- **`source`, not `bash`.** Running it as `bash scripts/claude-login.sh` puts the variable in a
  subshell that exits immediately, and nothing sticks.
- **Once per Codespace.** The script also appends the token to your `~/.bashrc`, so new
  terminals and a restart stay logged in. Rebuild the container from scratch and you run it
  again.
- **Use the terminal, not the VS Code Claude panel.** In a Codespace the panel starts before
  you unlock and cannot see the token, so it will show you a login screen and try to send you
  into your own account.

The `--dangerously-skip-permissions` flag lets the agent read, edit, and run commands without
stopping to confirm each one. I use it in demos deliberately, so you see what an agent actually
does when it is not being interrupted. It is fine here because a Codespace is a disposable
container. **Do not make a habit of it on your own machine.**

---

## Instructor notes: creating and rotating the shared token

Only relevant if you are reusing this repo for your own teaching.

```bash
claude setup-token
```

That mints a long-lived OAuth token, valid about a year, and prints it once. Re-running it
invalidates the previous one, which is also how you revoke.

```bash
scripts/secret-encrypt.sh CLAUDE_CODE_OAUTH_TOKEN
```

Paste the token at the hidden prompt, then type your passcode twice. It writes
`secrets/CLAUDE_CODE_OAUTH_TOKEN.enc` and nothing else. The script never prints the secret,
never writes plaintext to disk, and never puts the secret or the passcode on a command line
where `ps` could see it. Commit only the `.enc`.

**The passcode is the entire security model, so pick it accordingly.** The ciphertext sits in a
public repo where anyone can attack it offline at their leisure. AES-256 with PBKDF2 at 600k
iterations makes a strong passphrase hopeless to brute force and does nothing whatsoever for a
weak one. **Four or five random words**: easy to say to a room, far out of reach. Never the
course name, the venue, or the year.

Two habits that go with this:

- **Never let the plaintext token touch anything but that hidden prompt.** Not a chat window,
  not a notebook cell, not a commit message. If it lands somewhere it should not, mint a fresh
  one immediately, which invalidates the leaked one.
- **Revoke after the session.** Re-run `claude setup-token` the same day. Anything students
  kept stops working, and the encrypted blob in the public repo becomes worthless.

**Encryption details:** AES-256-CBC, PBKDF2-SHA256, 600,000 iterations, random salt, base64
armored. See [`secrets/README.md`](../secrets/README.md).

---

## If nothing works

You are not blocked. Every notebook in this repo is committed **with its outputs**, so the
figures, tables and results are all readable on GitHub without running a single cell. Read
along and come find me afterward.
