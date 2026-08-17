import { cp, mkdir, readFile, rm, writeFile } from "node:fs/promises";
import { marked } from "marked";

const readmePath = new URL("../README.md", import.meta.url);
const templatePath = new URL("./template.html", import.meta.url);
const publicDirectory = new URL("./public/", import.meta.url);
const outputDirectory = new URL("../dist/", import.meta.url);

const escapeHtml = (value) =>
  value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");

const stripTags = (value) => value.replace(/<[^>]*>/g, "");

const slugify = (value) =>
  stripTags(value)
    .toLowerCase()
    .trim()
    .replace(/&amp;/g, "")
    .replace(/[^\p{L}\p{N}\s-]/gu, "")
    .replace(/\s+/g, "-")
    .replace(/-+/g, "-");

function addHeadingIds(html) {
  const usedSlugs = new Map();

  return html.replace(/<h([1-6])>([\s\S]*?)<\/h\1>/g, (heading, level, content) => {
    const baseSlug = slugify(content) || "section";
    const occurrence = usedSlugs.get(baseSlug) ?? 0;
    usedSlugs.set(baseSlug, occurrence + 1);
    const slug = occurrence === 0 ? baseSlug : `${baseSlug}-${occurrence}`;
    return `<h${level} id="${escapeHtml(slug)}">${content}</h${level}>`;
  });
}

function improveGeneratedMarkup(html) {
  return addHeadingIds(html)
    .replaceAll("<table>", '<div class="table-wrapper"><table>')
    .replaceAll("</table>", "</table></div>")
    .replace(
      /<a href="(https?:\/\/[^\"]+)">/g,
      '<a href="$1" target="_blank" rel="noopener noreferrer">',
    );
}

const readme = await readFile(readmePath, "utf8");
const template = await readFile(templatePath, "utf8");
const version = readme.match(/Specification Version\s+([0-9]+(?:\.[0-9]+)*)/i)?.[1] ?? "draft";
const renderedMarkdown = marked.parse(readme, {
  gfm: true,
  breaks: false,
});
const content = improveGeneratedMarkup(renderedMarkdown);

const siteUrl = (process.env.SITE_URL ?? "https://shishir-dey.github.io/DatasheetXML/").replace(
  /\/?$/,
  "/",
);
const repositoryUrl = process.env.REPOSITORY_URL ?? "https://github.com/shishir-dey/DatasheetXML";

const replacements = {
  "{{CONTENT}}": content,
  "{{SITE_URL}}": escapeHtml(siteUrl),
  "{{REPOSITORY_URL}}": escapeHtml(repositoryUrl),
  "{{SPEC_VERSION}}": escapeHtml(version),
};

let page = template;
for (const [placeholder, value] of Object.entries(replacements)) {
  page = page.replaceAll(placeholder, value);
}

const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>${escapeHtml(siteUrl)}</loc>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
</urlset>
`;

const robots = `User-agent: *
Allow: /
Sitemap: ${siteUrl}sitemap.xml
`;

await rm(outputDirectory, { recursive: true, force: true });
await mkdir(outputDirectory, { recursive: true });
await cp(publicDirectory, outputDirectory, { recursive: true });
await Promise.all([
  writeFile(new URL("index.html", outputDirectory), page),
  writeFile(new URL("sitemap.xml", outputDirectory), sitemap),
  writeFile(new URL("robots.txt", outputDirectory), robots),
  writeFile(new URL(".nojekyll", outputDirectory), ""),
]);

console.log(`Built DatasheetXML ${version} documentation at dist/index.html`);
