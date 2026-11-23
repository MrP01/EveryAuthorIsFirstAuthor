// Adapted from Source - https://stackoverflow.com/a/21015393
// Posted by Domi, modified by community. See post 'Timeline' for change history
// Retrieved 2026-11-23, License - CC BY-SA 4.0

/**
  * Uses canvas.measureText to compute and return the width of the given text of given font in pixels.
  * 
  * @param {String} text The text to be rendered.
  * @param {String} font The css font descriptor that text is to be rendered with (e.g. "bold 14px verdana").
  * 
  * @see https://stackoverflow.com/questions/118241/calculate-text-width-with-javascript/21015393#21015393
  */

let canvasCache: HTMLCanvasElement | null = null;
export function getTextWidth(text: string, font: string): number {
    // re-use canvas object for better performance
    const canvas = canvasCache || (canvasCache = document.createElement("canvas"));
    const context = canvas.getContext("2d");
    if (!context) {
        throw new Error("Failed to get 2D context from canvas");
    }
    context.font = font;
    const metrics = context.measureText(text);
    return metrics.width;
}

export function getCssStyle(element: Element, prop: string): string {
    return window.getComputedStyle(element, null).getPropertyValue(prop);
}

export function getElementFont(el = document.body) {
    const fontWeight = getCssStyle(el, 'font-weight') || 'normal';
    const fontSize = getCssStyle(el, 'font-size') || '16px';
    const fontFamily = getCssStyle(el, 'font-family') || 'Times New Roman';
    return {
        fontWeight,
        fontSize,
        fontFamily
    };
}
export function getElementFontString(el = document.body): string {
    const { fontWeight, fontSize, fontFamily } = getElementFont(el);
    return `${fontWeight} ${fontSize} ${fontFamily}`;
}
