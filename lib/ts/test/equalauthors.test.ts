import * as eqa from "../src/equalauthors";

function testAuthorStack(authors: string[], alpha: number, beta: number, fontFamily: string = "Times New Roman", fontSize: string = "16px", fontWeight: string = "normal") {
    const div = document.createElement("div");
    const stack_div = document.createElement("div");
    stack_div.style.fontFamily = fontFamily;
    stack_div.style.fontSize = fontSize;
    stack_div.style.fontWeight = fontWeight;
    const stats = eqa.equalizeAuthorsStack(authors, stack_div, alpha, beta);
    div.appendChild(stack_div);

    const beside_div = document.createElement("div");
    beside_div.style.fontFamily = fontFamily;
    beside_div.style.fontSize = fontSize;
    beside_div.style.fontWeight = fontWeight;
    eqa.equalizeAuthorsOnto(authors, beside_div, alpha, beta);
    div.appendChild(beside_div);

    document.body.appendChild(div);
    const stack_width = stack_div.getBoundingClientRect().width;
    const beside_width = beside_div.getBoundingClientRect().width;
    const stat_div = document.createElement("div");
    stat_div.innerText = `Stack width: ${stack_width}, Beside width: ${beside_width}; font: ${fontWeight} ${fontSize} ${fontFamily}, alpha: ${alpha}, beta: ${beta}`;
    document.body.appendChild(stat_div);
    // add table with author stats
    const table = document.createElement("table");
    const header = document.createElement("tr");
    header.innerHTML = "<th>Author</th><th>Natural Width</th><th>Width</th><th>Scale</th><th>Tracking</th>";
    table.appendChild(header);

    for (const stat of stats) {
        const row = document.createElement("tr");
        row.innerHTML = `<td>${stat.name}</td><td>${stat.natural_w.toFixed(2)}</td><td>${stat.w.toFixed(2)}</td><td>${stat.s.toFixed(3)}</td><td>${stat.t.toFixed(3)}</td>`;
        table.appendChild(row);
    }
    document.body.appendChild(table);
}


const authors = [
    "Peter Waldert",
    "Benedikt Joachim Kantz",
    "Thomas Köhler",
    "Erik D. Demaine",
    "Martin L. Demaine",
    "Y Wuuuuuuuuuu",
    "Donaudampfschiffskapitän",
    "Jesus Salvador Martinez Alcaide",
    "Yu Liu",];
testAuthorStack(authors, 1, 1);
testAuthorStack(authors.slice(0, 3), 1, 1);

testAuthorStack(authors, 1, 1, "Arial", "20px", "bold");
testAuthorStack(authors.slice(0, 3), 1, 1, "Arial", "20px", "bold");

