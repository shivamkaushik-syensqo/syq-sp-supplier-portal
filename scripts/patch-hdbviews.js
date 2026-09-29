/**
 * patch-hdbviews.js
 *
 * Post-processes CDS-generated hdbview files to wrap all identifiers in
 * double-quotes. This is required because the RT_SUP_* replication tables
 * inherit case-sensitive quoted column names (e.g. "BusinessPartner") from
 * the ABAP remote source via:
 *   CREATE COLUMN TABLE RT_SUP_X LIKE VT_SUP_X WITH NO DATA
 * HANA stores those columns as quoted identifiers. CDS generates unquoted
 * SQL which HANA uppercases, causing "invalid column name" errors.
 */

const fs = require('fs');
const path = require('path');

const genDir = path.join(__dirname, '..', 'gen', 'db', 'src', 'gen');

if (!fs.existsSync(genDir)) {
  console.error(`[patch-hdbviews] Directory not found: ${genDir}`);
  process.exit(1);
}

const files = fs.readdirSync(genDir).filter(f => f.endsWith('.hdbview'));

if (files.length === 0) {
  console.warn('[patch-hdbviews] No .hdbview files found – nothing to patch.');
  process.exit(0);
}

let patched = 0;

for (const file of files) {
  const filePath = path.join(genDir, file);
  const original = fs.readFileSync(filePath, 'utf8');

  // Quote every word-boundary identifier token.
  // Strategy: tokenise the SQL and quote bare identifiers (words that are not
  // SQL keywords and not already quoted).
  const SQL_KEYWORDS = new Set([
    'SELECT', 'FROM', 'AS', 'WHERE', 'JOIN', 'LEFT', 'RIGHT', 'INNER',
    'OUTER', 'ON', 'AND', 'OR', 'NOT', 'NULL', 'IS', 'IN', 'LIKE',
    'ORDER', 'BY', 'GROUP', 'HAVING', 'DISTINCT', 'UNION', 'ALL',
    'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'VIEW', 'TABLE', 'WITH',
    'CASE', 'WHEN', 'THEN', 'ELSE', 'END', 'CAST', 'AS', 'TOP', 'LIMIT',
    'OFFSET', 'BETWEEN', 'EXISTS', 'ASC', 'DESC'
  ]);

  // Replace:  VIEW Name AS  →  VIEW "Name" AS
  //           alias.Column  →  "alias"."Column"
  //           FROM table AS alias  →  FROM "table" AS "alias"
  // We do a targeted replacement that handles the patterns CDS actually emits.

  let sql = original;

  // 1. Quote the VIEW name:  VIEW Foo_Bar AS  →  VIEW "Foo_Bar" AS
  sql = sql.replace(/^VIEW\s+([A-Za-z_][A-Za-z0-9_]*)\s+AS\b/m,
    (_, name) => `VIEW "${name}" AS`);

  // 2. Quote alias.column references:  Alias_0.ColumnName  →  "Alias_0"."ColumnName"
  sql = sql.replace(/\b([A-Za-z_][A-Za-z0-9_]*)\.([A-Za-z_][A-Za-z0-9_]*)\b/g,
    (match, tbl, col) => {
      // Skip if already quoted (won't happen here but be safe)
      return `"${tbl}"."${col}"`;
    });

  // 3. Quote FROM table AS alias and remap CDS namespace-prefixed names to
  //    actual HANA synonym names.
  //    CDS generates  FROM sup_Bidder AS Bidder_0  (or already quoted)
  //    but the synonym is  SUP_BIDDER.
  sql = sql.replace(/\bFROM\s+"?(sup_[A-Za-z0-9_]+)"?\s+AS\s+"?([A-Za-z_][A-Za-z0-9_]*)"?/g,
    (_, tbl, alias) => {
      const synonymName = tbl.replace(/^sup_/, 'SUP_').toUpperCase();
      return `FROM "${synonymName}" AS "${alias}"`;
    });

  if (sql !== original) {
    fs.writeFileSync(filePath, sql, 'utf8');
    console.log(`[patch-hdbviews] Patched: ${file}`);
    patched++;
  } else {
    console.log(`[patch-hdbviews] Already quoted (skipped): ${file}`);
  }
}

console.log(`[patch-hdbviews] Done. ${patched}/${files.length} file(s) patched.`);
