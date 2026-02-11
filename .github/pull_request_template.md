## 📦 Impact on Versioning (CI Controlled)

This selection is used by CI to determine the version bump.

✔ Select **only ONE option**  
✔ If unsure — leave blank and CI will decide automatically

### Priority Order Used by CI
1️⃣ Checkbox selection below  
2️⃣ Conventional Commit detection (`feat:`, `fix:`, `feat!:` etc.)  
3️⃣ Default → **patch**

---

### Select ONE expected bump

- [ ] patch → bug fixes / small changes
- [ ] minor → new feature (`feat:`)
- [ ] major → breaking change (`feat!:` / `BREAKING CHANGE`)

⚠️ Selecting multiple options may cause CI validation failure  
⚠️ Leaving all blank will fallback to commit message detection
