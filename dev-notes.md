# Dev Notes – DBMS Portfolio

These are personal notes written while completing the DBMS retos.
They focus on commands, pitfalls, and reminders rather than theory.

---

## General Setup

### Terminal
- macOS has a single terminal
- Same terminal is used for:
  - MySQL
  - PostgreSQL
  - R
  - Git
- Different tools ≠ different terminals

### MySQL
- Start MySQL shell:
  mysql -u root -p

- Run a SQL file:
  mysql -u root -p < schema.sql

- Common mistake:
  ERROR 1046 (3D000): No database selected
  → Fix with:
  USE database_name;

---

## MySQL Notes

### Storage Engine
- Use ENGINE=InnoDB for tables
- Needed for foreign keys and transactions

### Constraints
- PKs, FKs, UNIQUE, CHECK can be defined inline in CREATE TABLE
- PRIMARY KEY columns are implicitly NOT NULL

### GROUP BY
- Always group by all non-aggregated columns
- MySQL may allow looser syntax, but it’s not portable

---

## SQL Server Notes (Reto 3)

### Syntax differences
- AUTO_INCREMENT → IDENTITY(1,1)
- DATETIME → DATETIME2
- CURRENT_TIMESTAMP → SYSDATETIME()
- IFNULL → ISNULL
- No ENGINE clause

### GROUP BY
- SQL Server strictly enforces SQL standard
- All non-aggregated SELECT columns must be in GROUP BY

### Procedural SQL
- T-SQL supports variables and loops
- Example constructs:
  - DECLARE
  - SET
  - WHILE
  - PRINT

---

## Git Workflow

### Basic cycle
git status
git add file.sql
git commit -m "Meaningful message"
git push

### Mantra
nothing to commit, working tree clean

### .DS_Store
- macOS system file
- Never commit
- Add to .gitignore:
  .DS_Store

### .gitignore
- Must be named exactly ".gitignore"
- Needs to be committed

---

## ER Diagrams
- Use MySQL Workbench
- Database → Reverse Engineer
- Export as PNG
- Commit diagrams with schema changes

---

## Nano Editor Reminders
- Save: Ctrl + O → Enter
- Exit: Ctrl + X
- If stuck: check if nano or pico is running

---

## Personal Takeaways
- SQL dialects matter
- Portability matters
- Tooling knowledge ≠ theory knowledge
- Documentation and notes save time

---

## Git – File Management Commands

### Remove a file

- Remove a file from the project (and from git tracking):
  rm filename.sql

- If the file was already tracked and you want git to record the deletion:
  git rm filename.sql

- After removing:
  git commit -m "Remove unused file"

---

### Rename or move a file

- Rename a file (recommended way):
  git mv old_name.sql new_name.sql

- Move a file into a folder:
  git mv file.sql sql/file.sql

Why `git mv`:
- Git tracks the rename/move automatically
- Cleaner history than rm + add

---

### Undo common mistakes

- Discard local changes to a file:
  git restore filename.sql

- Unstage a file (keep changes):
  git restore --staged filename.sql

---

### Check differences before committing

- See what changed in a file:
  git diff filename.sql

- See all unstaged changes:
  git diff

---

### Inspect history

- View commit history (short):
  git log --oneline

- View detailed commit history:
  git log

---

## Panic Checklist (When Something Looks Wrong)

### 1. Stop typing
- Do not run random commands
- Read the error message fully
- Breathe

---

### 2. Where am I?
- Check current directory:
  pwd

- List files:
  ls

- Am I inside the project folder?

---

### 3. What tool am I in?
- Terminal prompt:
  - `$` → shell
  - `mysql>` → MySQL
- If stuck:
  exit;

---

### 4. Git: what is the state?
- Always run:
  git status

This answers:
- what changed
- what is staged
- what is untracked

---

### 5. Did I select a database?
Common error:
  ERROR 1046: No database selected

Fix:
  USE database_name;

---

### 6. Did I run the script in the correct engine?
- MySQL scripts:
  mysql -u root -p < file.sql

- SQL Server scripts:
  sqlcmd -i file.sql

If syntax looks “wrong”, I might be using the wrong engine.

---

### 7. Something looks deleted or broken?
- File deleted locally but not committed yet:
  git restore filename.sql

- File staged but shouldn’t be:
  git restore --staged filename.sql

---

### 8. Something weird appeared in the repo?
- macOS artifacts:
  .DS_Store

Fix:
- Add to .gitignore
- Do not commit

---

### 9. Check differences before panicking
- See what changed:
  git diff

- If it looks okay → commit
- If not → restore

---

### 10. Last resort
- Nothing is truly lost unless committed
- Git remembers more than I think
- Take a break if frustration rises

---

## Glossary of Errors I Hit (and What They Meant)

### ERROR 1046 (3D000): No database selected
**Meaning:**  
Connected to MySQL, but not using any database.

**Fix:**
```sql
USE database_name;
```

### ERROR 1050 (42S01): table already exists
**Meaning:**
Trying to create a table that already exists.

**Fix:**
```sql
CREATE TABLE IF NOT EXISTS table_name (...);
```

### ERROR 1007 (HY000): Can't create database; database exists
**Meaning:**
Trying to create a database that already exists.

***Fix:***
```sql
CREATE DATABASE IF NOT EXISTS database_name;
```
### ERROR 1064 (42000): SQL syntax error
**Meaning:**
Often caused by:
- using the wrong SQL dialect (MySQL vs SQL Server)
- missing commas or parentheses
- unsupported keywords

**Fix:**
- Which engine am I using?
- Am I running a SQL Server script in MySQL?

## Final Reminder

- Don’t throw the laptop across the room
- Take a break if frustration rises
- If stuck, re-read error messages slowly
