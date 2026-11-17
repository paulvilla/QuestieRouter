# QuestieRouter Nav: notice

This folder is a modified copy of **Polestar_Nav** from Polestar (https://github.com/fitzforge/polestar),
GPL-3.0-or-later, whose walking router started from **Shortest Path Forever** v1.16.0 by **Cillian Berragan**
(https://github.com/cjber/shortest-path-forever, GPL-3.0-or-later). See LICENSE and CREDITS.md in this folder
(or in QuestieRouter_Nav) for the original copyright and licence notices, which are kept unchanged in every file.

Changes made for QuestieRouter on 2026-11-17 (tools/nav_import.py in QuestieRouter's repository):

- Renamed the addon folder and TOC (Polestar_Nav -> QuestieRouter_Nav) and its dependency (Polestar -> QuestieRouter).
- Renamed the globals so the copy never collides with an installed Polestar: PolestarPathData ->
  QuestieRouterPathData, PolestarNavChokepoints -> QuestieRouterNavChokepoints, Polestar_NavEngine ->
  QuestieRouter_NavEngine; the map parts point to QuestieRouter_Nav_EK / QuestieRouter_Nav_Kalimdor.
- No other change to the router or the maps.

Thank you, Cillian Berragan and the Polestar authors.
