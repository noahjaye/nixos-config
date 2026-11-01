function focusQuadrant(right, bottom) {
    const active = workspace.activeWindow;
    const output = active ? active.output : workspace.activeScreen;
    const area = output.geometry;
    const px = right  ? area.x + area.width  : area.x;
    const py = bottom ? area.y + area.height : area.y;

    let best = null;
    let bestPrimary = Infinity;
    let bestSecondary = Infinity;

    for (const w of workspace.windowList()) {
        if (!w.normalWindow || w.output !== output) continue;
        if (!w.onAllDesktops &&
            w.desktops.indexOf(workspace.currentDesktop) === -1) continue;

        const g = w.frameGeometry;

        const dx = Math.max(g.x - px, 0, px - (g.x + g.width));
        const dy = Math.max(g.y - py, 0, py - (g.y + g.height));
        const primary = dx * dx + dy * dy;
        const wx = right  ? g.x + g.width  : g.x;
        const wy = bottom ? g.y + g.height : g.y;
        const secondary = (wx - px) ** 2 + (wy - py) ** 2;

        if (primary < bestPrimary ||
            (primary === bestPrimary && secondary < bestSecondary)) {
            best = w;
        bestPrimary = primary;
        bestSecondary = secondary;
            }
    }

    if (best) workspace.activeWindow = best;
}

registerShortcut("Focus Top Left Pane", "Focus Top Left Pane", "",
                 () => focusQuadrant(false, false));
registerShortcut("Focus Top Right Pane", "Focus Top Right Pane", "",
                 () => focusQuadrant(true, false));
registerShortcut("Focus Bottom Left Pane", "Focus Bottom Left Pane", "",
                 () => focusQuadrant(false, true));
registerShortcut("Focus Bottom Right Pane", "Focus Bottom Right Pane", "",
                 () => focusQuadrant(true, true));
