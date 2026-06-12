# ♟️ Chess Game — Project Roadmap (Flutter)

A Jira-style backlog for building a cross-platform chess game in **Flutter / Dart**, primarily targeting **iOS** with **web** as a second target (Android comes largely for free from the same codebase). Built as a portfolio / learning project.

---

## 📋 Context — read this first

**Stack:** Flutter (UI) · Dart (engine *and* UI) · `dart test` for engine validation.
**Targets:** iOS first → web second → Android (~free from the same codebase).
**Architecture rule:** the chess engine is a **pure-Dart core with zero `package:flutter` imports**, fully unit-testable from the console. The Flutter layer only renders engine state and forwards moves back. This separation is the project's portability insurance — the UI gets rebuilt per platform anyway, so the engine is the part that actually travels.

**🎓 Working style (this is a learning project — important for any AI assisting):**
- Proceed **one epic / rung at a time**; each rung must run and be verified before starting the next.
- **Teach, don't dump.** Explain the concept and the approach first, then let me attempt the code. Review and guide rather than generating whole files unprompted.
- Keep the engine completely free of UI concerns at all times.
- When in doubt, prefer a question over assuming.

**Legend** — `pt` = relative effort (Fibonacci) · 🔴 hard / conceptual hump · 🟡 fiddly · 🟢 straightforward · 🎓 = key concept to learn

---

## `CHESS-1` — EPIC: Project Setup & Architecture 🟢
> Scaffold the Flutter project and lock in the engine/UI split before writing any logic.

- [ ] `CHESS-1.1` `flutter create` the app; enable the iOS + web targets · **1 pt**
- [ ] `CHESS-1.2` Isolate the engine as a pure-Dart layer (a `lib/engine/` folder, or a standalone Dart package for stricter separation) — no Flutter imports · **2 pt**
- [ ] `CHESS-1.3` Set up the `test/` folder; confirm `dart test` runs against the engine · **1 pt**
- [ ] `CHESS-1.4` 🎓 Decide a state-management approach for later (research Provider / Riverpod / Bloc; `ChangeNotifier` is the simplest start) · **1 pt**

**✅ Done when:** the app builds on both iOS and web, and a dummy engine test passes with zero Flutter imports in the engine.

---

## `CHESS-2` — EPIC: Core Engine — Board & Pieces 🟢
> *(Rung 1)* The Dart data model only. No moves yet.

- [ ] `CHESS-2.1` Enums for `PieceColor` and `PieceType` · **1 pt**
- [ ] `CHESS-2.2` `Piece`, `Square`, and `Position` types · **2 pt**
- [ ] `CHESS-2.3` Build the standard starting `Position` · **1 pt**
- [ ] `CHESS-2.4` Console board printer (`toString`) · **2 pt**

**✅ Done when:** printing the start position matches a real chessboard.

---

## `CHESS-3` — EPIC: Core Engine — Move Generation 🟡
> *(Rungs 2–3)* Pseudo-legal moves, one piece type at a time. Verify each by hand before the next.

- [ ] `CHESS-3.1` Rook (sliding rays, stop at blockers) · **3 pt**
- [ ] `CHESS-3.2` Bishop (diagonal rays) · **2 pt**
- [ ] `CHESS-3.3` Queen (reuse rook + bishop) · **1 pt**
- [ ] `CHESS-3.4` Knight (fixed L-offsets) · **2 pt**
- [ ] `CHESS-3.5` King (one square, any direction) · **2 pt**
- [ ] `CHESS-3.6` 🟡 Pawn (push, double-step, diagonal capture) · **5 pt**

**✅ Done when:** each piece's move list is correct on empty and blocked boards.

---

## `CHESS-4` — EPIC: Core Engine — Legality & Special Rules 🔴
> *(Rungs 4–6)* The conceptual hump. Make moves mutate state, then filter out illegal ones.

- [ ] `CHESS-4.1` Apply a move (update board, capture, flip turn) · **3 pt**
- [ ] `CHESS-4.2` 🔴 `isSquareAttacked(by:)` helper · **5 pt**
- [ ] `CHESS-4.3` 🔴 Filter moves that leave your own king in check · **5 pt**
- [ ] `CHESS-4.4` Castling (incl. the pass-through-check rule) · **5 pt**
- [ ] `CHESS-4.5` En passant · **3 pt**
- [ ] `CHESS-4.6` Pawn promotion · **3 pt**

**✅ Done when:** illegal moves are rejected and all three special moves work.

---

## `CHESS-5` — EPIC: Core Engine — Endgame Detection 🟡
> *(Rung 7)* When and how the game ends.

- [ ] `CHESS-5.1` Checkmate (no legal moves + in check) · **2 pt**
- [ ] `CHESS-5.2` Stalemate (no legal moves + not in check) · **2 pt**
- [ ] `CHESS-5.3` Draws: 50-move, threefold repetition, insufficient material · **5 pt**

**✅ Done when:** the engine reports the correct terminal state for known mate/draw positions.

---

## `CHESS-6` — EPIC: Engine Validation (Perft) 🔴
> *(Rung 8)* Prove correctness with numbers before trusting the engine.

- [ ] `CHESS-6.1` Recursive `perft(depth)` move counter · **3 pt**
- [ ] `CHESS-6.2` Assert against published counts (20 / 400 / 8902 / 197281) via `dart test` · **2 pt**
- [ ] `CHESS-6.3` Run perft from "tricky" test positions (e.g. Kiwipete) · **3 pt**

**✅ Done when:** all perft counts match exactly. The engine is now verified.

---
## ──────────── ⚙️ ENGINE DONE (verified, headless) · 🎨 UI BEGINS ────────────
*Everything above is a fully-validated chess engine runnable from the console. A **playable game** (the MVP) arrives at the end of `CHESS-8`.*
---

## `CHESS-7` — EPIC: UI — Board & Rendering 🟢
> *(Rung 9)* Put a board on screen with Flutter widgets.

- [ ] `CHESS-7.1` 8×8 board via `GridView` or `CustomPaint`, with alternating square colors · **3 pt**
- [ ] `CHESS-7.2` Render pieces — Unicode glyphs (`Text`), image assets, or SVG (`flutter_svg`). *(Note: SF Symbols are iOS-only and don't exist in Flutter.)* · **2 pt**
- [ ] `CHESS-7.3` 🎓 Bridge engine ↔ UI via your chosen state management · **3 pt**

**✅ Done when:** the current `Position` renders correctly on **both iOS and web**.

---

## `CHESS-8` — EPIC: UI — Interaction & Game Flow 🟡
> Tap (or drag) to move, with feedback.

- [ ] `CHESS-8.1` Tap a piece → highlight its legal moves (`GestureDetector` / `InkWell`) · **3 pt**
- [ ] `CHESS-8.2` Tap a destination → commit the move · **2 pt**
- [ ] `CHESS-8.3` 🎓 Move animations (`AnimatedPositioned` / implicit animations) · **2 pt**
- [ ] `CHESS-8.4` Promotion picker (`showDialog` / `showModalBottomSheet`) · **3 pt**
- [ ] `CHESS-8.5` Game-over overlay · **2 pt**
- [ ] `CHESS-8.6` *(Optional)* Drag-and-drop pieces (`Draggable` / `DragTarget`) · **3 pt**

**✅ Done when:** a full game is playable by tapping on iOS and web. **← MVP reached here.**

---

## `CHESS-9` — EPIC: UI — Surrounding Features 🟢
> Quality-of-life additions that make it portfolio-ready.

- [ ] `CHESS-9.1` Turn indicator + captured-pieces tray · **2 pt**
- [ ] `CHESS-9.2` Move list in algebraic notation (`ListView`) · **3 pt**
- [ ] `CHESS-9.3` Undo / redo · **3 pt**
- [ ] `CHESS-9.4` New game / reset · **1 pt**
- [ ] `CHESS-9.5` 🎓 Responsive layout for phone vs. wide web screen (`LayoutBuilder` / `MediaQuery`) · **3 pt**

---

## `CHESS-10` — EPIC: [STRETCH] AI Opponent 🔴
> A computer to play against. Pick one path.

- [ ] `CHESS-10.1` Material + position evaluation function (pure Dart) · **5 pt**
- [ ] `CHESS-10.2` 🔴 Minimax with alpha-beta pruning (pure Dart) · **8 pt**
- [ ] `CHESS-10.3` 🎓 Run the search in a Dart **isolate** (`compute`) so the UI doesn't freeze · **3 pt**
- [ ] `CHESS-10.4` Selectable difficulty (search depth) · **3 pt**
- [ ] `CHESS-10.5` 🎓 *Alt path:* wrap Stockfish — native via `dart:ffi`, but **web needs the Stockfish WASM/JS build** (FFI doesn't run on web) · **8 pt**

---

## `CHESS-11` — EPIC: [STRETCH] Multiplayer & Persistence 🟡
> Save games and play others.

- [ ] `CHESS-11.1` FEN import/export (single position) · **3 pt**
- [ ] `CHESS-11.2` PGN import/export (full game) · **5 pt**
- [ ] `CHESS-11.3` Local pass-and-play polish · **2 pt**
- [ ] `CHESS-11.4` 🎓 Online multiplayer — GameKit is iOS-only, so for cross-platform use a backend (Firebase / WebSocket / Supabase) instead · **13 pt**
- [ ] `CHESS-11.5` Local persistence (`shared_preferences` or a local file) · **3 pt**

---

### Suggested order
`CHESS-1` → `2` → `3` → `4` → `5` → `6` → **⚙️ verified engine** → `7` → `8` → **🎯 MVP: playable game** → `9` → **🏆 portfolio-ready** → `10` / `11` in either order.
